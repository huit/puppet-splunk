require 'spec_helper'

describe 'splunk::outputs', :type => :class do
  describe "Splunk outputs private sub class" do
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { {
        :indexandforward => 'False',
        :port            => '50514',
        :path            => '/opt/splunk/etc/system/local',
        :output_hash     => { },
        :target_group    => { "example1" => "server1.example.com" }
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
    end
  end
end
