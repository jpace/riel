require 'rubygems'
require 'fileutils'
require './lib/riel'
require 'rake/testtask'
require 'rubygems/package_task'

task :default => :test

Rake::TestTask.new("test") do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end

spec = Gem::Specification.new do |s| 
  s.name = "riel"
  s.version = "1.1.8"
  s.author = "Jeff Pace"
  s.email = "jpace@incava.org"
  s.homepage = "http://www.incava.org/projects/riel"
  s.platform = Gem::Platform::RUBY
  s.summary = "Extensions to core Ruby code."
  s.description = "This library extends the core Ruby libraries."
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end
 
Gem::PackageTask.new(spec) do |pkg| 
  pkg.need_zip = true 
  pkg.need_tar_gz = true 
end 
