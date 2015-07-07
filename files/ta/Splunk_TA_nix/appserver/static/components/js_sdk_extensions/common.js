define([], function() {
    var utils_namespaceFromProperties = function(props) {
        return {
            owner: props.acl.owner,
            app: props.acl.app,
            sharing: props.acl.sharing
        };
    };
    
    return {
        utils_namespaceFromProperties: utils_namespaceFromProperties
    };
});