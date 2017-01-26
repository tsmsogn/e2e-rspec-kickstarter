# e2e-rspec-kickstarter

e2e-rspec-kickstarter generates tests against remote server with RSpec and Capybara.

[![Build Status](https://travis-ci.org/tsmsogn/e2e-rspec-kickstarter.png)](https://travis-ci.org/tsmsogn/e2e-rspec-kickstarter)
[![Coverage Status](https://coveralls.io/repos/tsmsogn/e2e-rspec-kickstarter/badge.png)](https://coveralls.io/r/tsmsogn/e2e-rspec-kickstarter)
[![Code Climate](https://codeclimate.com/github/tsmsogn/e2e-rspec-kickstarter.png)](https://codeclimate.com/github/tsmsogn/e2e-rspec-kickstarter)

## Usage

    e2e-rspec-kickstarter http://example.com/

## Options

```
$ e2e-rspec-kickstarter -h
Usage: e2e-rspec-kickstarter [options]
    -f, --force                      Create if absent or append to the existing spec
    -n, --dry-run                    Dry run mode (shows generated code to console)
    -o, --output VAL                 Output file (default: ./spec/features/pages_spec.rb)
        --test-template VAL          Test template path
        --scenario-template VAL      Scenario template path
        --spec-template VAL          Spec template path
    -v, --version                    Print version
```

## Output example

```sh
$ e2e-rspec-kickstarter http://example.com/
./spec/features/pages_spec.rb created.
```

`/spec/features/pages_spec.rb` will be created as follows.

```ruby
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
```

## Customizable code template

Try the template_samples.

```
ruby -Ilib ./bin/e2e-rspec-kickstarter http://example.com --test-template=samples/test_template.erb --scenario-template=samples/scenario_template.erb --spec-template=samples/spec_template.erb -n
```

## License

Copyright (c) 2013 - Kazuhiro Sera

MIT License

https://github.com/seratch/rspec-kickstarter/blob/master/LICENSE.txt

