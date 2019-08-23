lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_codebreaker_amidasd/version'

Gem::Specification.new do |spec|
  spec.name          = 'gem_codebreaker_amidasd'
  spec.version       = GemCodebreakerAmidasd::VERSION
  spec.authors       = ['Amidasd']
  spec.email         = ['amidasd@gmail.com']

  spec.summary       = 'Codebreaker game'
  spec.description   = 'My first ruby gem Codebreaker'
  spec.homepage      = 'https://github.com/Amidasd/gem_codebreaker_amidasd'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.5'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'fasterer', '~> 0.5.1'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.69.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end
