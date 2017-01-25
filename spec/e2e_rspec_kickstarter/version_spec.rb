require 'spec_helper'
require 'e2e_rspec_kickstarter/version'

describe E2eRSpecKickstarter do

  describe E2eRSpecKickstarter::VERSION do
    it 'exists' do
      expect(E2eRSpecKickstarter::VERSION).not_to be_nil
    end
  end

end
