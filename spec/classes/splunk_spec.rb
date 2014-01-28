require 'spec_helper'

describe 'splunk', :type => :class do
  describe "on RedHat platform" do
    let(:facts) { { :osfamily => 'RedHat' } }

    describe "Splunk class with no parameters, basic test" do
      let(:params) { { } }
        it {
          should compile
          should create_class('splunk')
          should contain_class('splunk::outputs')
          should contain_class('splunk::config::mgmt_port')
          should contain_package('splunkforwarder')
	  should contain_service('splunk').with(
            'ensure' => 'running',
            'enable' => 'true'
          )
        }
    end
    describe "With type param set to 'lwf'" do
      let(:params) { { :type => 'lwf' } }
        it {
          should compile
          should create_class('splunk')
          should contain_class('splunk::outputs')
          should contain_class('splunk::config::mgmt_port')
          should contain_class('splunk::config::lwf')
          should contain_class('splunk::config::remove_uf')
          should contain_package('splunk')
	  should contain_service('splunk').with(
            'ensure' => 'running',
            'enable' => 'true'
          )
        }
    end
  end
end
