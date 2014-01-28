require 'spec_helper'

describe 'splunk::config::license', :type => :class do
  describe "Splunk license sub class" do
    it { should create_class('splunk::config::license')}
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }

        describe "Without Any params" do
          it { should create_class('splunk::config::license') }
        end

        describe "With server Param set to 'self'" do
          let(:params) { { :server => 'self' } }
          it {
            should create_class('splunk::config::license')
            should contain_ini_setting('Configure Splunk License')
          }
        end

        describe "With server Param set to 'splunklicense.example.com" do
          let(:params) { { :server => 'splunklicense.example.com' } }
          it {
            should create_class('splunk::config::license')
            should contain_ini_setting('Configure Splunk License')
          }
        end
    end
  end
end
