
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rggen/basic_output_components/version'

Gem::Specification.new do |spec|
  spec.name = 'rggen-basic-output-components'
  spec.version = RgGen::BasicOutputComponents::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['taichi730@gmail.com']

  spec.summary = "rggen-basic-output-components-#{RgGen::BasicOutputComponents::VERSION}"
  spec.description = 'Correction of basic output components.'
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.homepage = 'https://github.com/rggen/rggen-basic-output-components'
  spec.license = 'MIT'

  spec.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency "bundler"
end
