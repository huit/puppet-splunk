require 'find'
Facter.add(:splunk_version) do
  confine :kernel => :linux
  setcode do
    command = ''
    path = ['/opt/splunk','/opt/splunkforwarder']
    path.each do |directory|
      Find.find(directory) do |file|
        command << file if !File::directory?(file) and File.executable?(file) and file =~ /.*\/splunk$/
      end
    end
    if command != ''
      version = Facter::Util::Resolution.exec("#{command} version")
    elsif command == ''
      version = Facter::Util::Resolution.exec('splunk version')
    end
    if version
      version.match(/\d+\.\d+\.\d+/).to_s
    else
      nil
    end
  end
end
