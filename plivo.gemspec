Gem::Specification.new do |s|
  s.name = 'plivo'
  s.version = '0.3.19'
  s.author = 'Plivo Inc'
  s.email = 'support@plivo.com'
  s.homepage = 'http://www.plivo.com'
  s.license = 'MIT'
  s.description = 'A Ruby gem for interacting with the Plivo Cloud Platform'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A Ruby gem for communicating with the Plivo Cloud Platform'
  s.files = Dir['lib/*']
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md']
  s.add_dependency('builder', '>= 2.1.2')
  s.add_dependency('rest-client', '~> 2.0')
  s.add_dependency('json', '~> 1.6', '>= 1.6.6')
  s.add_dependency('htmlentities', '~> 4.3', '>= 4.3.1')
  s.extensions = 'ext/mkrf_conf.rb'
  s.bindir = 'bin'
end
