module Fastlane
  class FastFile
    def ovo_import_full_repo_from_git(**options)
      config = FastlaneCore::Configuration.create(
        Actions::OvoImportFullRepoFromGitAction.available_options,
        options
      )

      fastfile_path = Helper::OvoImportFullRepoFromGitHelper.checkout_repo(
        url: config[:url],
        path: config[:path],
        branch: config[:branch],
        version: config[:version],
        cache_path: config[:cache_path],
        depth: config[:depth],
        submodules: config[:submodules],
        clean: config[:clean]
      )
      
      import(fastfile_path)
    end
  end
end
