require 'spec_helper'

describe 'splunk', :type => :class do

  describe "Splunk class with no parameters, basic test" do
    let(:params) { { } }
    
      it {
        should contain_package('splunkforwarder')
	should contain_service('splunk')
      }
  end
end
