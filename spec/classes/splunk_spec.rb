require 'spec_helper'

describe 'splunk', :type => :class do

  describe "Splunk class with no parameters, basic test" do
    let(:params) { { } }
    
      it { should create_class('splunk') }
  end
end
