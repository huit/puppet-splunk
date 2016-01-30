require 'spec_helper'

describe 'splunk::outputs', :type => :class do
  describe "outputs with indexandforward true" do
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { {
        :configure_outputs => true,
        :indexandforward   => true,
        :port              => '50514',
        :path              => '/opt/splunk/etc/system/local',
        :output_hash       => { },
        :target_group      => { "example1" => "server1.example.com" }
      } }

      it { should create_class('splunk::outputs') }
      it { 
        should contain_file('/opt/splunk/etc/system/local/outputs.conf').with(
          'ensure'  => 'file',
          'owner'   => 'splunk',
          'group'   => 'splunk',
          'mode'    => '0644',
          'backup'  => 'true'
        )
      }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/[tcpout]/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/defaultGroup = example1/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/disabled = false/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/tcpout:example1/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/server = server1.example.com:50514/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/indexAndForward = True/) }
    end
    describe "with multiple servers in target group" do
      let(:params) { {
        :configure_outputs => true,
        :indexandforward   => true,
        :port              => '50514',
        :path              => '/opt/splunk/etc/system/local',
        :output_hash       => { },
        :target_group      => { "example1" => ["server1.example.com","server2.example.com"] }
      } }

      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/[tcpout]/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/defaultGroup = example1/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/disabled = false/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/tcpout:example1/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/server = server1.example.com:50514,server2.example.com:50514/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/indexAndForward = True/) }
    end
    describe "with an Array of server in target group" do
      let(:params) { {
        :configure_outputs => true,
        :indexandforward   => true,
        :port              => '50514',
        :path              => '/opt/splunk/etc/system/local',
        :output_hash       => { },
        :target_group      => { "example1" => ["server1.example.com"] }
      } }

      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/[tcpout]/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/defaultGroup = example1/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/disabled = false/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/tcpout:example1/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/server = server1.example.com:50514/) }
      it { should contain_file('/opt/splunk/etc/system/local/outputs.conf').with_content(/indexAndForward = True/) }
    end
  end
end
