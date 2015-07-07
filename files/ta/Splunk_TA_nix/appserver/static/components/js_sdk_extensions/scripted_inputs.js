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
    // JS SDK Extension: Scripted Inputs
    
    var Paths = {
        scriptedInputs: 'data/inputs/script'
    };
    
    root.ScriptedInput = root.Entity.extend({
        path: function() {
            // Approximate path - accepts reads only
            // ex: data/inputs/script/%2FApplications%2Fsplunk_622light_unix%2Fetc%2Fapps%2FSplunk_TA_nix%2Fbin%2Fcpu.sh
            return Paths.monitorInputs + "/" + encodeURIComponent(this.name);
        },
        
        init: function(service, name, namespace) {
            this.name = name;
            this._super(service, this.path(), namespace);
        },
        
        _load: function(properties) {
            this._super(properties);
            
            // HACK: Patch path to be canonical version to enable updates
            // 
            // Canonical path - accepts reads and updates
            // ex: data/inputs/script/.%252Fbin%252Fcpu.sh
            if (this.state().id) {
                this.qualifiedPath = this.state().id.match(/\/servicesNS\/.*$/)[0];
            }
        }
    });
    
    root.ScriptedInputs = root.Collection.extend({
        path: function() {
            return Paths.scriptedInputs;
        },
        
        instantiateEntity: function(props) {
            var entityNamespace = utils_namespaceFromProperties(props);
            return new root.ScriptedInput(this.service, props.name, entityNamespace);
        },
        
        init: function(service, namespace) {
            this._super(service, this.path(), namespace);
        }
    });
    
    // -------------------------------------------------------------------------
    
    return root;
});