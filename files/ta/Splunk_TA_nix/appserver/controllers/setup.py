import json
import sys

import cherrypy
import splunk
import splunk.appserver.mrsparkle.controllers as controllers
from splunk.appserver.mrsparkle.lib.decorators import expose_page


# JIRA: Must use private API (splunkweb controllers) for server-side
#       endpoint due to lack of public API. (SPL-90798)
class SetupService(controllers.BaseController):
    @expose_page(must_login=True, methods=['GET'])
    def is_unix(self, **kwargs):
        """
        Returns whether current OS is a recognized Unix.
        """
        
        is_recognized_unix = not sys.platform.startswith('win')
        
        cherrypy.response.headers['Content-Type'] = 'text/json'
        return json.dumps(is_recognized_unix)
