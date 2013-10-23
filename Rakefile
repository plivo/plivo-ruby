require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |s|
  s.name = "plivo"
  s.version = "0.3.0"
  s.author = "Plivo Inc"
  s.email = "support@plivo.com"
  s.homepage = "http://www.plivo.com"
  s.description = "A Ruby gem for interacting with the Plivo Cloud Platform"
  s.platform = Gem::Platform::RUBY
  s.summary = "A Ruby gem for communicating with the Plivo Cloud Platform"
  s.files = FileList["{lib}/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/response_spec.rb"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md"]
  s.add_dependency("builder", ">= 2.1.2")
  s.add_dependency("rest-client", ">= 1.6.7")
  s.add_dependency("json", ">= 1.6.6")
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :build => "pkg/#{spec.name}-#{spec.version}.gem" do
    puts "generated latest version"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
