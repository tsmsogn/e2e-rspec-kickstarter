require 'erb'
require 'e2e_rspec_kickstarter'

#
# ERB templates
#
module E2eRSpecKickstarter
  module ERBTemplates

    BASIC_TEST_PART_TEMPLATE = <<SPEC
    it { expect(page.title).to eq('<%= html_doc.title %>') }
SPEC

    BASIC_SCENARIO_PART_TEMPLATE = <<SPEC
  describe '<%= url %>' do
    before { visit '<%= url %>' }

<%= ERB.new(BASIC_TEST_PART_TEMPLATE, nil, '-', 'test').result(binding) -%>
  end
SPEC

    BASIC_NEW_SPEC_TEMPLATE = <<SPEC
require 'spec_helper'

describe 'pages', type: :feature do

<%= ERB.new(BASIC_SCENARIO_PART_TEMPLATE, nil, '-', 'scenario').result(binding) -%>

end
SPEC

  end
end
