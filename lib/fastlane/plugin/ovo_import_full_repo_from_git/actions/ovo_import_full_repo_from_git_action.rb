require 'fastlane/action'
require_relative '../helper/ovo_import_full_repo_from_git_helper'

module Fastlane
  module Actions
    class OvoImportFullRepoFromGitAction < Action
      def self.run(params)
        url          = params[:url]
        path         = params[:path]
        branch       = params[:branch]
        version      = params[:version]
        cache_path   = params[:cache_path]
        depth        = params[:depth]
        submodules   = params[:submodules]
        clean        = params[:clean]

        # Delegate all logic to the helper
        Helper::OvoImportFullRepoFromGitHelper.checkout_repo(
          url: url,
          path: path,
          branch: branch,
          version: version,
          cache_path: cache_path,
          depth: depth,
          submodules: submodules,
          clean: clean
        )
      end

      def self.authors
        ["Christian Borsato"]
      end

      def self.description
        "Clone a full git repository and import a Fastfile from it"
      end

      def self.details
        "A fastlane plugin that imports shared Fastfiles from a remote git repository by cloning and checking out the full repository first, then importing the selected Fastfile path. It supports selecting a specific branch or tag, as well as SemVer-based version constraints to automatically pick the latest compatible release tag. This is useful when the imported Fastfile relies on additional files in the repository (e.g., Ruby helpers, config files, scripts) that must be present on disk at runtime."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :url,
            env_name: "OVO_IMPORT_FULL_REPO_URL",
            description: "Git repository URL",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :path,
            env_name: "OVO_IMPORT_FULL_REPO_PATH",
            description: "Path to Fastfile inside the repository",
            optional: true,
            type: String,
            default_value: "fastlane/Fastfile"
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            env_name: "OVO_IMPORT_FULL_REPO_BRANCH",
            description: "Branch/ref to checkout (ignored when version is set)",
            optional: true,
            type: String,
            default_value: "HEAD"
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "OVO_IMPORT_FULL_REPO_VERSION",
            description: "Tag/version requirement (e.g. '~> 3.0.0' or ['>= 3.0.0', '< 4.0.0'])",
            optional: true,
            type: Object
          ),
          FastlaneCore::ConfigItem.new(
            key: :cache_path,
            env_name: "OVO_IMPORT_FULL_REPO_CACHE_PATH",
            description: "Optional cache directory to clone into",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :depth,
            env_name: "OVO_IMPORT_FULL_REPO_DEPTH",
            description: "Git clone depth (default: 1)",
            optional: true,
            type: Integer,
            default_value: 1
          ),
          FastlaneCore::ConfigItem.new(
            key: :submodules,
            env_name: "OVO_IMPORT_FULL_REPO_SUBMODULES",
            description: "If true, also initializes and updates git submodules",
            optional: true,
            is_string: false,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :clean,
            env_name: "OVO_IMPORT_FULL_REPO_CLEAN",
            description: "If true and cache_path is set, clears the cache folder before cloning",
            optional: true,
            is_string: false,
            default_value: false
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
