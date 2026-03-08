lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/ovo_import_full_repo_from_git/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-ovo_import_full_repo_from_git'
  spec.version       = Fastlane::OvoImportFullRepoFromGit::VERSION
  spec.author        = 'Christian Borsato'
  spec.email         = 'christian@ovolab.com'

  spec.summary       = 'Clone a full git repository and import a Fastfile from it (supports branch/tag/SemVer constraints)'
  spec.homepage      = "https://github.com/ovolab/fastlane-plugin-ovo_import_full_repo_from_git"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 3.0'
end
