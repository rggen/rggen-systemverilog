# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in rggen-basic-output-components.gemspec
gemspec

['rggen-core'].each do |rggen_library|
  library_path = File.expand_path("../#{rggen_library}", __dir__)
  if Dir.exist?(library_path) && !ENV['USE_GITHUB_REPOSITORY']
    gem rggen_library, path: library_path
  else
    gem rggen_library, git: "https://github.com/rggen/#{rggen_library}.git"
  end
end

group :develop do
  gem 'rake'
  gem 'rspec', '>= 3.3'
  gem 'codecov', require: false
  gem 'rubocop', '>= 0.48.0', require: false
end
