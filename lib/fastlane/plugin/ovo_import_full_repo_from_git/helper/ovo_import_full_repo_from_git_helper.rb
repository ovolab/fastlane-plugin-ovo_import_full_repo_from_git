require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class OvoImportFullRepoFromGitHelper
      def self.checkout_repo(url:, path:, branch:, version:, cache_path:, depth:, submodules:, clean:)
        FastlaneCore::UI.user_error!("Please pass a url") if url.to_s.strip.empty?
        FastlaneCore::UI.user_error!("Please pass a path") if path.to_s.strip.empty?

        depth = depth.to_i
        depth = 1 if depth <= 0

        repo_name = url.split("/").last.to_s.gsub(/\.git\z/, "")
        folder_name = "#{repo_name}.git"

        clone_folder = resolve_clone_folder(folder_name, cache_path, clean)

        if Dir.exist?(File.join(clone_folder, ".git"))
          FastlaneCore::UI.message("Using cached repo at #{clone_folder}")
        else
          FastlaneCore::UI.message("Cloning remote git repo...")

          FileUtils.mkdir_p(File.dirname(clone_folder))

          clone_cmd = build_clone_command(
            url: url,
            clone_folder: clone_folder,
            depth: depth,
            branch: (version ? nil : branch)
          )
          Fastlane::Actions.sh(clone_cmd)
        end

        ref =
          if version
            resolve_tag_from_version!(clone_folder, version)
          else
            branch.to_s.strip.empty? ? "HEAD" : branch.to_s.strip
          end

        # FULL checkout
        Fastlane::Actions.sh(%(cd "#{clone_folder}" && git -c advice.detachedHead=false checkout #{sanitize_ref(ref)}))

        if submodules
          Fastlane::Actions.sh(%(cd "#{clone_folder}" && git submodule update --init --recursive))
        end

        fastfile_path = File.join(clone_folder, path)
        FastlaneCore::UI.user_error!("Could not find Fastfile at path '#{fastfile_path}'") unless File.exist?(fastfile_path)

        fastfile_path
      end

      def self.resolve_clone_folder(folder_name, cache_path, clean)
        if cache_path.to_s.strip.empty?
          tmp_path = Dir.mktmpdir("fl_clone")
          File.join(tmp_path, folder_name)
        else
          expanded = File.expand_path(cache_path.to_s)
          FileUtils.rm_rf(expanded) if clean && Dir.exist?(expanded)
          FileUtils.mkdir_p(expanded)
          File.join(expanded, folder_name)
        end
      end

      def self.build_clone_command(url:, clone_folder:, depth:, branch:)
        branch_option = ""
        b = branch.to_s.strip
        branch_option = %(--branch #{sanitize_ref(b)}) unless b.empty? || b == "HEAD"
        %(git clone "#{url}" "#{clone_folder}" --no-checkout --depth #{depth} #{branch_option}).strip
      end

      def self.resolve_tag_from_version!(clone_folder, version)
        Fastlane::Actions.sh(%(cd "#{clone_folder}" && git fetch --all --tags -q))
        tags_raw = Fastlane::Actions.sh(%(cd "#{clone_folder}" && git tag -l), log: false).to_s
        tags = tags_raw.lines.map(&:strip).reject(&:empty?)

        req = build_requirement(version)

        candidates = tags.filter_map do |t|
          clean = t.start_with?("v") ? t[1..] : t
          next unless clean.match?(/^\d+\.\d+\.\d+$/)
          v = Gem::Version.new(clean)
          next unless req.satisfied_by?(v)
          [v, t]
        end

        FastlaneCore::UI.user_error!("No git tag satisfies version requirement: #{version.inspect}") if candidates.empty?

        selected = candidates.max_by { |(v, _t)| v }[1]
        FastlaneCore::UI.message("Selected tag: #{selected}")
        selected
      end

      def self.build_requirement(version)
        if version.is_a?(Array)
          Gem::Requirement.new(version)
        else
          s = version.to_s.strip
          parts = s.split(",").map(&:strip).reject(&:empty?)
          Gem::Requirement.new(parts.empty? ? s : parts)
        end
      end

      def self.sanitize_ref(ref)
        # keep it simple: allow common ref chars only
        ref.to_s.gsub(/[^A-Za-z0-9_\-\.\/]/, "")
      end
    end
  end
end
