require 'fileutils'
require 'nokogiri'
require 'open-uri'
require 'rdoc'
require 'e2e_rspec_kickstarter'
require 'e2e_rspec_kickstarter/erb_factory'
require 'e2e_rspec_kickstarter/erb_templates'
require 'typhoeus'

#
# RSpec Code Generator
#
module E2eRSpecKickstarter
  class Generator
    include E2eRSpecKickstarter::ERBTemplates

    attr_accessor :test_template, :scenario_template, :spec_template

    def initialize(test_template = nil, scenario_template = nil, spec_template = nil)
      @test_template = test_template
      @scenario_template = scenario_template
      @spec_template = spec_template
    end

    def raw_html(url)
      request = Typhoeus::Request.new(url, followlocation: true)
      request.on_complete do |response|
        if response.success?
          return response.body
        else
          raise "HTTP request to #{url} failed"
        end
      end
      request.run
    end

    #
    # Writes new spec or appends to the existing spec.
    #
    def write_spec(url, output = './spec/features/pages_spec.rb', force_write = false, dry_run = false)
      if force_write && File.exist?(output)
        append_to_existing_spec(url, output, dry_run)
      else
        create_new_spec(url, output, dry_run)
      end
    end

    #
    # Creates new spec.
    #
    # rubocop:disable Metrics/AbcSize
    def create_new_spec(url, output, dry_run)
      html_doc = Nokogiri::HTML(raw_html(url))

      erb = E2eRSpecKickstarter::ERBFactory.new(@spec_template).get_instance_for_new_spec
      code = erb.result(binding)

      if dry_run
        puts "----- #{output} -----"
        puts code
      else
        if File.exist?(output)
          puts "#{output} already exists."
        else
          FileUtils.mkdir_p(File.dirname(output))
          File.open(output, 'w') { |f| f.write(code) }
          puts "#{output} created."
        end
      end
    end

    # rubocop:enable Metrics/AbcSize

    #
    # Appends new tests to the existing spec.
    #
    # rubocop:disable Metrics/AbcSize
    def append_to_existing_spec(url, output, dry_run)
      html_doc = Nokogiri::HTML(raw_html(url))

      erb = E2eRSpecKickstarter::ERBFactory.new(@scenario_template).get_instance_for_appending
      additional_spec = erb.result(binding)

      existing_spec = File.read(output)
      lines = existing_spec.split("\n")

      last_end_not_found = true
      code = lines.reverse!.each_with_index { |line, i|
        if last_end_not_found && line =~ /end/
          last_end_not_found = false
          lines.insert(i + 1, additional_spec)
        end
      }.reverse.join("\n") + "\n"

      if dry_run
        puts "----- #{output} -----"
        puts code
      else
        File.open(output, 'w') { |f| f.write(code) }
      end
      puts "#{output} modified."
    end
  end
end

