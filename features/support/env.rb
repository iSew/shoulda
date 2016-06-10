require 'aruba/cucumber'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..')).freeze
APP_NAME     = 'testapp'.freeze

Before do
  @aruba_timeout_seconds = 15

  if ENV['DEBUG']
    @puts = true
    @announce_stdout = true
    @announce_stderr = true
    @announce_cmd = true
    @announce_dir = true
    @announce_env = true
  end
end

module AppendHelpers
  def append_to(path, contents)
    cd('.') do
      File.open(path, "a") do |file|
        file.puts
        file.puts contents
      end
    end
  end

  def append_to_gemfile(contents)
    append_to('Gemfile', contents)
  end
end

module MinitestHelpers
  def minitest_identifier
    if rails_gte_4_1?
      :minitest_5
    else
      :minitest_4
    end
  end
end

module RailsHelpers
  def rails_version
    Gem::Version.new(Bundler.definition.specs['rails'][0].version)
  end

  def rails_gte_4_1?
    Gem::Requirement.new(">= 4.1").satisfied_by?(rails_version)
  end
end

World(AppendHelpers)
World(MinitestHelpers)
World(RailsHelpers)
