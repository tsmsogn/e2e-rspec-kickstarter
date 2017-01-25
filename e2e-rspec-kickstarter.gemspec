lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'e2e_rspec_kickstarter/version'

Gem::Specification.new do |gem|
  gem.name          = "e2e-rspec-kickstarter"
  gem.version       = E2eRSpecKickstarter::VERSION
  gem.authors       = ["tsmsogn"]
  gem.email         = ["tsmsogn@gmail.com"]
  gem.licenses      = ["MIT"]
  gem.description   = %q{e2e-rspec-kickstarter generates tests against remote server with RSpec and Capybara.}
  gem.summary       = %q{e2e-rspec-kickstarter generates tests against remote server with RSpec and Capybara.}
  gem.homepage      = "https://github.com/tsmsogn/e2e-rspec-kickstarter"
  gem.files         = Dir["{bin,lib}/**/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
