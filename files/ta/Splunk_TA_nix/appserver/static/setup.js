require([
    'splunkjs/ready!',
    'splunkjs/mvc/simplexml/ready!',
    'underscore',
    'jquery',
    '../app/Splunk_TA_nix/components/js_sdk_extensions/scripted_inputs',
    '../app/Splunk_TA_nix/components/js_sdk_extensions/monitor_inputs'
], function(
    mvc,
    ignored,
    _,
    $,
    sdkx_scripted_inputs,
    sdkx_monitor_inputs
) {
    var ScriptedInput = sdkx_scripted_inputs.ScriptedInput;
    var ScriptedInputs = sdkx_scripted_inputs.ScriptedInputs;
    var MonitorInput = sdkx_monitor_inputs.MonitorInput;
    var MonitorInputs = sdkx_monitor_inputs.MonitorInputs;
    
    var service = mvc.createService();
    
    // -------------------------------------------------------------------------
    // Prerequisite Checks
    
    // Error if running on unrecognized unix
    // 
    // JIRA: Workaround lack of API to build URLs that are agnostic
    //       to the root endpoint location and locale. (SPL-91659)
    var PATH_TO_ROOT = '../../..';
    $.ajax({
        type: 'GET',
        url: PATH_TO_ROOT + '/en-US/custom/Splunk_TA_nix/setup/is_unix'
    }).always(function(data, responseStatus) {
        if (responseStatus === 'success') {
            var isRecognizedUnix = data;
            if (!isRecognizedUnix) {
                $('#not-unix-error').show();
                $('#save-btn').addClass('disabled');
            }
        } else {
            console.error('Problem checking whether splunkweb is running on Unix.');
        }
    });
    
    // -------------------------------------------------------------------------
    // Populate Tables
    
    var INPUT_ROW_TEMPLATE = _.template(
        '<tr class="input" data-fullname="<%- fullname %>">\n' +
        '    <td><%- name %></td>\n' +
        '    <td><input class="enable-btn"  type="radio" name="<%- name %>" <% if (enabled)  { %>checked="checked"<% } %> /></td>\n' +
        '    <td><input class="disable-btn" type="radio" name="<%- name %>" <% if (!enabled) { %>checked="checked"<% } %> /></td>\n' +
        '<% if (interval != -1) { %>\n' +
        '    <td><input class="interval-field" type="text" value="<%- interval %>" /></td>\n' +
        '<% } %>\n' +
        '</tr>\n');
    
    // Populate monitor input table
    var monitorInputs = {};
    new MonitorInputs(
        service,
        { owner: '-', app: 'Splunk_TA_nix', sharing: 'app' }
    ).fetch(function(err, inputs) {
        var inputsList = _.filter(inputs.list(), function(input) {
            return input.namespace.app === 'Splunk_TA_nix';
        });
        
        _.each(inputsList, function(input) {
            $('#monitor-input-table').append($(INPUT_ROW_TEMPLATE({
                fullname: input.name,
                name: input.name,
                enabled: !input.properties().disabled,
                interval: -1
            })));
            monitorInputs[input.name] = input;
        });
    });
    
    // Populate scripted input table
    var scriptedInputs = {};
    new ScriptedInputs(
        service,
        { owner: '-', app: 'Splunk_TA_nix', sharing: 'app' }
    ).fetch(function(err, inputs) {
        var inputsList = _.filter(inputs.list(), function(input) {
            return input.namespace.app === 'Splunk_TA_nix';
        });
        
        _.each(inputsList, function(input) {
            $('#scripted-input-table').append($(INPUT_ROW_TEMPLATE({
                fullname: input.name,
                name: input.name.substring(input.name.lastIndexOf('/') + 1),
                enabled: !input.properties().disabled,
                interval: input.properties().interval
            })));
            scriptedInputs[input.name] = input;
        });
    });
    
    // -------------------------------------------------------------------------
    // Buttons
    
    // Enable All button
    $('.enable-all-btn').click(function(e) {
        var table = $(e.target).closest('.input-table');
        $('.input .enable-btn', table).prop('checked', true);
    });
    
    // Disable All button
    $('.disable-all-btn').click(function(e) {
        var table = $(e.target).closest('.input-table');
        $('.input .disable-btn', table).prop('checked', true);
    });
    
    // Save button
    $('#save-btn').click(function() {
        if ($('#save-btn').hasClass('disabled')) {
            return;
        }
        
        var savesPending = 0;
        var saveErrors = [];
        
        // Save monitor inputs
        _.each($('#monitor-input-table .input'), function(inputElem) {
            var fullname = $(inputElem).data('fullname');
            var enabled = $('.enable-btn', inputElem).prop('checked');
            
            var input = monitorInputs[fullname];
            
            savesPending++;
            input.update({
                'disabled': !enabled
            }, saveDone);
        });
        
        // Save scripted inputs
        _.each($('#scripted-input-table .input'), function(inputElem) {
            var fullname = $(inputElem).data('fullname');
            var enabled = $('.enable-btn', inputElem).prop('checked');
            var interval = $('.interval-field', inputElem).val();
            
            var input = scriptedInputs[fullname];
            
            savesPending++;
            input.update({
                'disabled': !enabled,
                'interval': interval
            }, saveDone);
        });
        
        // After saves are complete...
        function saveDone(err, entity) {
            if (err) {
                saveErrors.push(err);
            }
            
            savesPending--;
            if (savesPending > 0) {
                return;
            }
            
            if (saveErrors.length === 0) {
                // Save successful. Provide feedback in form of page reload.
                window.location.reload();
            } else {
                // Save failed.
                $('#generic-save-error').show();
                
                // (Allow Support to debug if necessary.)
                console.log('Errors while saving inputs:');
                console.log(saveErrors);
            }
        }
    });
});
