require 'spec_helper_acceptance'

describe 'splunk::service class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  describe 'adding dependencies in between the base class and service class' do
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'splunk':
        package_provider => 'rpm',
        package_source => 'http://download.splunk.com/releases/6.1.3/universalforwarder/linux/splunkforwarder-6.1.3-220630-linux-2.6-x86_64.rpm',
      }
      file { '/tmp/test':
        require => Class['splunk'],
        notify  => Class['splunk::service'],
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end
end
