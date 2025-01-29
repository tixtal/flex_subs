# frozen_string_literal: true

require_relative 'lib/flex_subs/version'

Gem::Specification.new do |spec|
  spec.name = 'flex_subs'
  spec.version = FlexSubs::VERSION
  spec.authors = ['ilhampasya']
  spec.email = ['ilham@tixtal.com']

  spec.summary = 'Flex Subscription'
  spec.description = 'Flex Subscription'
  spec.homepage = 'https://github.com/tixtal/subscription'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.4'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage + '/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'rails', '>= 8.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
