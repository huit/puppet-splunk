require 'spec_helper'

describe 'splunk::service', :type => :class do
  describe "Splunk service sub class" do
    it { should create_class('splunk::service')}
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }

      it {
        should create_class('splunk::service')
        should contain_service('splunk')
      }
    end

  end
end
