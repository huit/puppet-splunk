require 'spec_helper'

describe ' splunk::config::license', :type => :class do
  describe "Splunk license sub class" do
    it { should create_class('splunk::config::license')}
    describe "on RedHat platform" do
      let(:facts) { { :osfamily => 'RedHat' } }
        describe "Without Any params" do
          it { should compile }
        end
    end
  end
end
