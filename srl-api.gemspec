Gem::Specification.new do |s|
  s.name = 'srl-api'
  s.version = File.read('lib/srl.rb')[/RELEASE += +([\"\'])([\d][\w\.]+)\1/, 2]
  s.platform = Gem::Platform::RUBY
  s.homepage = 'https://github.com/bedmonds/srl-api/'
  s.author = "Brian 'Artea' Edmonds"
  s.email = ["brian@bedmonds.net"]
  s.summary = 'Ruby Client for the SpeedRunsLive.com API'
  s.description = <<-EOF
Library to query the SpeedRunsLive.com API and deal with the results
in plain old Ruby.
EOF
  s.license = "MIT"

  s.files = `git ls-files -- lib/*`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  s.bindir = 'bin'

  s.require_path = 'lib'

  s.extra_rdoc_files = %w(README.md)
  s.rdoc_options.concat ["--main", "README.md"]

  if File.exist?("UPGRADING")
    s.post_install_message = File.read("UPGRADING")
  end

  s.required_ruby_version = '>= 2.3.0'

  s.add_development_dependency = 'minitest'
  s.add_development_dependency = 'rake'
  s.add_development_dependency = 'simplecov'
end
