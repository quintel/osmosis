require "bundler/gem_tasks"

# Documentation --------------------------------------------------------------

begin
  require 'yard'
  require 'yard-tomdoc'
  YARD::Rake::YardocTask.new do |doc|
    doc.options << '--no-highlight'
  end
rescue LoadError
  desc 'yard task requires that the yard gem is installed'
  task :yard do
    abort 'YARD is not available. In order to run yard, you must: gem ' \
          'install yard'
  end
end

# Console --------------------------------------------------------------------

namespace :console do
  task :run do
    command = system("which pry > /dev/null 2>&1") ? 'pry' : 'irb'
    exec "#{ command } -I./lib -r./lib/osmosis.rb"
  end
end

desc 'Open a pry or irb session preloaded with Osmosis'
task console: ['console:run']
