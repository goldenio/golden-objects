require_relative 'lib/golden/objects/version'

Gem::Specification.new do |spec|
  spec.name          = 'golden-objects'
  spec.version       = Golden::Objects::VERSION
  spec.authors       = ['Tse-Ching Ho']
  spec.email         = ['tsechingho@gmail.com']

  spec.summary       = %q{Provide ruby classes and modules help you build business logics as ruby components.}
  spec.description   = %q{Let's compose business logics as ruby components to improve efficiency of maintenance.}
  spec.homepage      = 'https://github.com/goldenio/golden-objects'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata['allowed_push_host'] = 'https://github.com'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/goldenio/golden-objects.git'
  spec.metadata['changelog_uri'] = 'https://github.com/goldenio/golden-objects/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.2'
end
