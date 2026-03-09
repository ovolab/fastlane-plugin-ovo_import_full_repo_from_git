# Ovo Import Full Repo From Git Plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-ovo_import_full_repo_from_git)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-ovo_import_full_repo_from_git`, add it to your project by running:

```bash
fastlane add_plugin ovo_import_full_repo_from_git
```

## About Ovo Import Full Repo From Git

Clone a remote git repository (full checkout) and import a Fastfile from it.

This is useful when the imported Fastfile relies on additional repository files (Ruby modules, configs, scripts, etc.) that must be present on disk when Fastlane evaluates the imported Fastfile.

## Available Actions

### ovo_import_full_repo_from_git

This action clones (or reuses) the repository and checks out the selected ref, then returns the absolute path of the Fastfile inside the checked out repository.

> Note: to actually import lanes from the checked out Fastfile, use the DSL method `ovo_import_full_repo_from_git(...)` (see examples below). The action is mostly useful for debugging and for verifying the checkout/ref resolution.

#### Parameters

- `url` (required): Git repository URL
- `path` (optional, default: `fastlane/Fastfile`): Path to the Fastfile inside the repository
- `branch` (optional, default: `HEAD`): Branch/ref to checkout (ignored when `version` is set)
- `version` (optional): Tag/version requirement (e.g. `~> 3.0.0` or `['>= 3.0.0', '< 4.0.0']`)
- `cache_path` (optional): Cache directory used to persist the clone between runs
- `depth` (optional, default: `1`): Git clone depth
- `submodules` (optional, default: `false`): If `true`, initializes and updates git submodules
- `clean` (optional, default: `false`): If `true` and `cache_path` is set, clears the cache folder before cloning

## Usage (Fastfile DSL)

To import lanes correctly, call `ovo_import_full_repo_from_git(...)` at the top level of your `Fastfile` (before defining lanes), similarly to `import_from_git`.

### Import from a branch

```ruby
# Fastfile (top-level)

ovo_import_full_repo_from_git(
  url: "https://gitlab.com/your-org/your-repo.git",
  branch: "feature/refactor",
  path: "fastlane/Fastfile"
)
```

### Import latest compatible tag (SemVer range)

```ruby
# Fastfile (top-level)

ovo_import_full_repo_from_git(
  url: "https://gitlab.com/your-org/your-repo.git",
  version: [">= 3.0.0", "< 4.0.0"],
  path: "fastlane/Fastfile"
)
```

### Optional: use a cache directory

```ruby
# Fastfile (top-level)

ovo_import_full_repo_from_git(
  url: "https://gitlab.com/your-org/your-repo.git",
  version: [">= 3.0.0", "< 4.0.0"],
  cache_path: "./.fastlane-cache/shared-fastfile",
)
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use

```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).