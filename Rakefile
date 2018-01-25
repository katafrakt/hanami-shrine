require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :spec do
  task :all do
    require 'dotenv'
    Dotenv.load!
    require_relative 'spec/database_helper'

    %w(sqlite postgres mysql).each do |adapter|
      ENV['DB_ADAPTER'] = adapter
      ENV['DB_URL'] = DatabaseHelper.db_url
      p ENV.keys
      puts '########################'
      puts "# Running for: #{adapter}"
      puts "########################\n\n"
      Rake::Task['spec'].invoke
      Rake::Task['spec'].reenable
    end
  end
end
