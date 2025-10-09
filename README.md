# ikuzo 行くぞ (いくぞ)

[![Gem Version](https://badge.fury.io/rb/ikuzo.svg)](https://badge.fury.io/rb/ikuzo)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/ojisanchamchi)

Ikuzo is a Ruby gem that generates short, motivational commit messages for developers. Use it as a CLI tool or as a library inside your scripts when you need an instant morale boost.

I built it after one too many blank stares at my terminal, trying to squeeze yet another branch name into a Conventional Commit subject. Life is short, take time to code, so I'd rather spend the focus on shipping than negotiating with commit lint rules. With Ikuzo, I can fire off a compliant, upbeat message in seconds and get back to building.

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

Outputs vary because messages are chosen at random. Ikuzo commits automatically; add `--no-commit` if you only want to print the message.

Commit with a random message (default: feat):
```
$ ikuzo
git commit -m "feat: main linted the vibes not the code"
[main abc1234] feat: main linted the vibes not the code
 1 file changed, 1 insertion(+)
```

Print a random message from a specific category without committing:
```
$ ikuzo funny --no-commit
This commit was pair-programmed with caffeine.
```

Commit with a random message explicitly (also default behavior):
```
$ ikuzo commit
git commit -m "It compiled on my machine, scout's honor."
[main abc1234] It compiled on my machine, scout's honor.
 1 file changed, 1 insertion(+)
```

Skip committing and just print the message:
```
$ ikuzo --no-commit
feat: main linted the vibes not the code
```

Specify a category explicitly and commit:
```
$ ikuzo --category dev
git commit -m "Logs cleaned, metrics gleam."
[main ghi9012] Logs cleaned, metrics gleam.
 1 file changed, 1 insertion(+)
```

Generate a Conventional Commit message from the current branch (omit `--no-commit` to auto commit):
```
$ ikuzo feat --no-commit
feat: main no rubber duck was harmed in this fix
```

Pick any Conventional Commit type that you need:
```
$ ikuzo fix
git commit -m "fix: main stack trace more like snack trace"
[main jkl3456] fix: main stack trace more like snack trace
 1 file changed, 1 insertion(+)
```

Supported types align with the Conventional Commits 1.0.0 spec: build, ci, chore, docs, feat, fix, perf, refactor, revert, style, and test.

List available categories:
```
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
```
$ ikuzo --version
1.0.0
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
