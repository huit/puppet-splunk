require 'spec_helper'

describe 'splunk::inputs', :type => :class do
  describe "Splunk inputs sub class" do
    let(:node) { 'testhost.example.com' }
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { {
        :path       => '/opt/splunk/etc/system/local',
        :input_hash => { "monitor:///var/log/nagios/service-perfdata" => {
                        "sourcetype" => "nagiosserviceperf",
                        "index"      => "nagios",
                        "disabled"   => "False"} }
      } }

      it { should create_class('splunk::inputs') }
      it { 
        should contain_file('/opt/splunk/etc/system/local/inputs.conf').with(
          'ensure'  => 'file',
          'owner'   => 'splunk',
          'group'   => 'splunk',
          'mode'    => '0644'
        )
      }
      it { should contain_file('/opt/splunk/etc/system/local/inputs.conf').with_content(/host = testhost.example.com/) }
      it { should contain_file('/opt/splunk/etc/system/local/inputs.conf').with_content(/[monitor:\/\/\/var\/log\/nagios\/service-perfdata]/) }
      it { should contain_file('/opt/splunk/etc/system/local/inputs.conf').with_content(/disabled = False/) }
      it { should contain_file('/opt/splunk/etc/system/local/inputs.conf').with_content(/index = nagios/) }
      it { should contain_file('/opt/splunk/etc/system/local/inputs.conf').with_content(/sourcetype = nagiosserviceperf/) }
    end
  end
end
