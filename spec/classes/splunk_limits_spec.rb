require 'spec_helper'

describe 'splunk::limits', :type => :class do
  describe "Splunk limits sub class" do
    let(:node) { 'testhost.example.com' }
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { {
        :path       => '/opt/splunk/etc/system/local',
        :limit_hash => { "search" => {
                        "maxKBps" => "10240",
                        } }
      } }

      it { should create_class('splunk::limits') }
      it { 
        should contain_file('/opt/splunk/etc/system/local/limits.conf').with(
          'ensure'  => 'file',
          'owner'   => 'splunk',
          'group'   => 'splunk',
          'mode'    => '0644'
        )
      }
      it { should contain_file('/opt/splunk/etc/system/local/limits.conf').with_content(/[search]/) }
      it { should contain_file('/opt/splunk/etc/system/local/limits.conf').with_content(/maxKBps = 10240/) }
    end
  end
end
