require 'spec_helper'
require 'e2e_rspec_kickstarter/generator'
require 'typhoeus'

describe E2eRSpecKickstarter::Generator do

  let(:generator) { E2eRSpecKickstarter::Generator.new }
  let(:url) { 'http://example.com/' }
  let(:output) { './tmp/pages_spec.rb' }

  before do
    response = Typhoeus::Response.new(code: 200, body: '<html><head><title>Example Domain</title></head></html>')
    Typhoeus.stub(url).and_return(response)
  end

  describe '#new' do

    it 'works without params' do
      result = E2eRSpecKickstarter::Generator.new
      expect(result).not_to be_nil
    end

    it 'works with params' do
      test_template = ''
      scenario_template = ''
      spec_template = ''

      result = E2eRSpecKickstarter::Generator.new(test_template, scenario_template, spec_template)
      expect(result).not_to be_nil
    end
  end

  describe '#raw_html' do

    it 'raises error with invalid url' do
      expect { generator.raw_html('') }.to raise_error
    end

    it 'works with valid url' do
      expect(generator.raw_html(url)).to match 'Example Domain'
    end
  end

  describe '#write_spec' do

    it 'just works' do
      FileUtils.rm_rf('spec/features') if File.exist?('spec/features')

      generator.write_spec(url)

      code = <<CODE
require 'spec_helper'
require 'capybara/rspec'

describe 'pages', type: :feature do
  before do
    Capybara.current_driver = :selenium
    Capybara.run_server = false
  end

  describe 'http://example.com/' do
    before { visit 'http://example.com/' }

    it { expect(page.title).to eq('Example Domain') }
  end

end
CODE

      expect(File.read('spec/features/pages_spec.rb')).to eq(code)
    end

    it 'works with -o option' do
      FileUtils.rm_rf('tmp') if File.exist?('tmp')

      generator.write_spec(url, output)

      expect(File.exist?('tmp/pages_spec.rb')).to be true
    end

    it 'works with -f option' do
      FileUtils.rm_rf('tmp') if File.exist?('tmp')

      code1 = <<CODE
require 'spec_helper'

describe 'pages', type: :feature do

  describe 'https://rubygems.org' do
    before { visit 'https://rubygems.org' }

    skip { expect(page.title).to eq('RubyGems.org | your community gem host') }
  end

end
CODE

      FileUtils.mkdir_p(File.dirname(output))
      File.open(output, 'w') { |f| f.write(code1) }

      code2 = <<CODE
require 'spec_helper'

describe 'pages', type: :feature do

  describe 'https://rubygems.org' do
    before { visit 'https://rubygems.org' }

    skip { expect(page.title).to eq('RubyGems.org | your community gem host') }
  end

  describe 'http://example.com/' do
    before { visit 'http://example.com/' }

    it { expect(page.title).to eq('Example Domain') }
  end

end
CODE

      generator.write_spec(url, output, true)

      expect(File.read(output)).to eq(code2)
    end

    it 'works with -n option' do
      FileUtils.rm_rf('tmp') if File.exist?('tmp')

      code1 = <<CODE
require 'spec_helper'

describe 'pages', type: :feature do

  describe 'https://rubygems.org' do
    before { visit 'https://rubygems.org' }

    skip { expect(page.title).to eq('RubyGems.org | your community gem host') }
  end

end
CODE

      FileUtils.mkdir_p(File.dirname(output))
      File.open(output, 'w') { |f| f.write(code1) }

      generator.write_spec(url, output, true, true)

      expect(File.read(output)).to eq(code1)
    end

    it 'creates new spec with custom template' do
      FileUtils.rm_rf('tmp') if File.exist?('tmp')

      test_template = File.read('samples/test_template.erb')
      scenario_template = File.read('samples/scenario_template.erb')
      spec_template = File.read('samples/spec_template.erb')

      generator = E2eRSpecKickstarter::Generator.new(test_template, scenario_template, spec_template)
      generator.write_spec(url, output)

      expect(File.read(output)).to match(/Test template example/)
      expect(File.read(output)).to match(/Scenario template example/)
      expect(File.read(output)).to match(/Spec template example/)
    end
  end

end
