# Ikuzo

Ikuzo is a Ruby gem that generates short, motivational commit messages for developers. Use it as a CLI tool or as a library inside your scripts when you need an instant morale boost.

## Installation

```bash
gem install ikuzo
```

If you are developing locally:

```bash
bundle install
```

## Usage

### CLI

Outputs vary because messages are chosen at random.

Print a random message (default: feat):

$ ikuzo
feat: main linted the vibes not the code
```

Print a random message from a specific category:

$ ikuzo funny
This commit was pair-programmed with caffeine.
```

Commit with a random message (requires staged changes in Git):

$ ikuzo commit
git commit -m "It compiled on my machine, scout's honor."
[main abc1234] It compiled on my machine, scout's honor.
 1 file changed, 1 insertion(+)
```

Or use the long option:

$ ikuzo --commit
git commit -m "Stack trace? More like snack trace."
[main def5678] Stack trace? More like snack trace.
 1 file changed, 1 insertion(+)
```

Specify a category explicitly:

$ ikuzo --category dev
Logs cleaned, metrics gleam.
```

Generate a Conventional Commit message from the current branch:

$ ikuzo feat
feat: main no rubber duck was harmed in this fix
```

Pick any Conventional Commit type that you need:

$ ikuzo fix
fix: main stack trace more like snack trace
```

Supported types align with the Conventional Commits 1.0.0 spec: build, ci, chore, docs, feat, fix, perf, refactor, revert, style, and test.

List available categories:

$ ikuzo --list-categories
Available categories:
  - general
  - funny
  - motivation
  - dev
  - build - Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
  - ci - Changes to CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
  - chore - Changes which don't affect source code or tests e.g. build process, auxiliary tools, libraries
  - docs - Documentation only changes
  - feat
  - fix
  - perf
  - refactor
  - revert
  - style
  - test
```

Show the installed version:

$ ikuzo --version
0.1.0
```

Each Conventional Commit category builds a `<type>: ...` message from your current Git branch, appends a cleaned-up motivational quip, and falls back to a default subject if the branch cannot be detected.

### Library

```ruby
require "ikuzo"

message = Ikuzo.random
# Defaults to the feat category
puts message
```

## Development

After checking out the repo, run `bundle install` to install dependencies. You can run `bundle exec rake release` to build and release the gem.

## License

MIT License © 2025 Dang Quang Minh
