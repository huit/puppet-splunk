define([
    'splunkjs/ready!',   // for splunkjs global
    './common'
], function(
    mvc,
    sdkx_common)
{
    var root = {
        Entity: splunkjs.Service.Entity,
        Collection: splunkjs.Service.Collection
    };
    
    var utils_namespaceFromProperties = sdkx_common.utils_namespaceFromProperties;
    
    // -------------------------------------------------------------------------
    // JS SDK Extension: Monitor Inputs
    
    var Paths = {
        monitorInputs:  'data/inputs/monitor'
    };
    
    root.MonitorInput = root.Entity.extend({
        path: function() {
            return Paths.monitorInputs + "/" + encodeURIComponent(this.name);
        },
        
        init: function(service, name, namespace) {
            this.name = name;
            this._super(service, this.path(), namespace);
        }
    });
    
    root.MonitorInputs = root.Collection.extend({
        path: function() {
            return Paths.monitorInputs;
        },
        
        instantiateEntity: function(props) {
            var entityNamespace = utils_namespaceFromProperties(props);
            return new root.MonitorInput(this.service, props.name, entityNamespace);
        },
        
        init: function(service, namespace) {
            this._super(service, this.path(), namespace);
        }
    });
    
    // -------------------------------------------------------------------------
    
    return root;
});