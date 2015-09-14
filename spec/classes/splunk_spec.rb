require 'spec_helper'

describe 'splunk', :type => :class do
  describe "on RedHat platform" do
    let(:facts) { { :osfamily => 'RedHat' } }
    shared_examples "splunk_general" do
      it {
        should compile
        should create_class('splunk')
        should contain_class('splunk::outputs')
        should contain_class('splunk::config::mgmt_port')
        should contain_service('splunk').with(
          'ensure' => 'running',
          'enable' => 'true'
        )
      }
    end
    shared_examples "forwarder_general" do
      include_examples "splunk_general" do
        it {
          should contain_package('splunkforwarder')
          should contain_file('/opt/splunkforwarder/etc/passwd').with(
            'replace' => 'no'
          )
        }
      end
    end
    describe "Splunk class with no parameters, basic test" do
      include_examples "forwarder_general" do
        let(:params) { { } }
        it {
          should contain_file('/opt/splunkforwarder/etc/system/local/outputs.conf')
        }
      end
    end
    describe "With type param set to 'lwf'" do
      include_examples "splunk_general" do
        let(:params) { { :type => 'lwf' } }
        it {
          should contain_class('splunk::config::lwf')
          should contain_class('splunk::config::remove_uf')
          should contain_package('splunk')
          should contain_file('/opt/splunk/etc/passwd').with(
            'replace' => 'no'
          )
        }
      end
    end
    describe "With configure_outputs set to false" do
      include_examples "forwarder_general" do
        let(:params) { { :configure_outputs => false } }
        it {
          should_not contain_file('/opt/splunkforwarder/etc/system/local/outputs.conf')
        }
      end
    end
    describe "With replace_passwd set to yes" do
      include_examples "splunk_general" do
        let(:params) { { :replace_passwd => 'yes' } }
        it {
          should contain_package('splunkforwarder')
          should contain_file('/opt/splunkforwarder/etc/passwd').with(
            'replace' => 'yes'
          )
        }
      end
    end
  end
end
