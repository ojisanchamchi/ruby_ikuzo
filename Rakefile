require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  warn "RSpec not available; `rake spec` will be skipped." if $stdout.tty?
end
