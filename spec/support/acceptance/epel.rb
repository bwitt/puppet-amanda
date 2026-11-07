# frozen_string_literal: true

# amanda is only packaged in EPEL on EL9
RSpec.configure do |c|
  c.before :suite do
    hosts.each do |host|
      next unless fact_on(host, 'os.family') == 'RedHat' && fact_on(host, 'os.release.major') == '9'

      host.install_package((fact_on(host, 'os.name') == 'OracleLinux') ? 'oracle-epel-release-el9' : 'epel-release')
    end
  end
end
