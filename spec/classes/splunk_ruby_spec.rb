require 'spec_helper'

describe 'splunk::ruby', :type => :class do

  describe "on RedHat platform" do
    let(:facts) { { :osfamily => 'RedHat' } }

    describe "Splunk class with no parameters, basic test" do
      let(:params) { { } }
      it {
        should create_class('splunk::ruby')
      }
    end
  end

  describe "on unsupported platform" do
    let(:facts) { { :osfamily => 'SuperFoonly' } }

    it {
      expect { should raise_error(Puppet::Error, /only suports Debian, RedHat, and Suse/) }
    }
  end

end
