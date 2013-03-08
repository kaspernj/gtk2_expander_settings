# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "gtk2_expander_settings"
  gem.homepage = "http://github.com/kaspernj/gtk2_expander_settings"
  gem.license = "MIT"
  gem.summary = %Q{A library for remembering expander-settings using a database for the gtk2-extension in Ruby.}
  gem.description = %Q{A library for remembering expander-settings using a database for the gtk2-extension in Ruby.}
  gem.email = "k@spernj.org"
  gem.authors = ["Kasper Johansen"]
  # dependencies defined in Gemfile
  
  #Conditional dependencies (make them work with installed dist packages and dont comile).
  deps = [:gtk2]
  
  deps.each do |dep|
    dep = {:require => dep, :gem => dep} if !dep.is_a?(Hash)
    
    begin
      require dep[:require].to_s
      puts "Skipping '#{dep[:gem]}' - already installed."
    rescue Gem::LoadError, LoadError
      gem.add_dependency dep[:gem]
    end
  end
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gtk2_expander_settings #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
