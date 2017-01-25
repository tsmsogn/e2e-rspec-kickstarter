require 'e2e_rspec_kickstarter/generator'
require 'e2e_rspec_kickstarter/version'

#
# E2eRSpecKickstarter Facade
#
module E2eRSpecKickstarter

  def self.write_spec(url, output = './spec/features/pages_spec.rb', force_write = false, dry_run = false)
    generator = E2eRSpecKickstarter::Generator.new
    generator.write_spec(url, output, force_write, dry_run)
  end

end

