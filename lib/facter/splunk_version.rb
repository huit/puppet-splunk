require 'find'
Facter.add(:splunk_version, :timeout => 10) do
  confine :kernel => :linux
  setcode do
    command = ''
    path = ['/opt/splunk/bin','/opt/splunkforwarder/bin']
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
      version.match(/[\d+\.]+\s/).to_s
    else
      nil
    end
  end
end
