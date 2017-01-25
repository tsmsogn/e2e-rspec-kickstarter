require 'spec_helper'
require 'e2e_rspec_kickstarter'

describe E2eRSpecKickstarter do

  let(:url) { 'http://example.com/' }
  let(:output) { './tmp/pages_spec.rb' }

  describe '#write_spec' do
    it 'works' do
      FileUtils.rm_rf('tmp') if File.exist?('tmp')

      E2eRSpecKickstarter.write_spec(url, output)

      expect(File.exist?('tmp/pages_spec.rb')).to be true
    end
  end

end
