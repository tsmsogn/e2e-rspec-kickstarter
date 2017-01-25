require 'erb'
require 'e2e_rspec_kickstarter'
require 'e2e_rspec_kickstarter/erb_templates'

#
# ERB instance provider
#
module E2eRSpecKickstarter
  class ERBFactory

    def initialize(custom_template)
      @custom_template = custom_template
    end

    #
    # Returns ERB instance for creating new spec
    #
    def get_instance_for_new_spec
      template = get_erb_template(@custom_template, true)
      ERB.new(template, nil, '-', '_new_spec_code')
    end

    #
    # Returns ERB instance for appeding lacking tests
    #
    def get_instance_for_appending
      template = get_erb_template(@custom_template, false)
      ERB.new(template, nil, '-', '_additional_spec_code')
    end

    private

    #
    # Returns ERB template
    #
    def get_erb_template(custom_template, is_full)
      if custom_template
        custom_template
      else
        get_basic_template(is_full)
      end
    end

    def get_basic_template(is_full)
      if is_full
        E2eRSpecKickstarter::ERBTemplates::BASIC_NEW_SPEC_TEMPLATE
      else
        E2eRSpecKickstarter::ERBTemplates::BASIC_SCENARIO_PART_TEMPLATE
      end
    end

  end
end
