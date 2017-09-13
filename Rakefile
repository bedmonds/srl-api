desc 'Run the whole test suite'
task :default => :test do
  sh 'ruby -Ilib ./test/run.rb'
end

desc 'Make an archive as .tar.gz'
task :dist => %w[chmod ChangeLog rdoc] do
  sh "git archive --format=tar --prefix=#{release}/ HEAD^{tree} >#{release}.tar"
  sh "pax -waf #{release}.tar -s ':^:#{release}/:' SPEC ChangeLog doc srl-api.gemspec"
  sh "gzip -f -9 #{release}.tar"
end

desc 'Make binaries executable'
task :chmod do
  Dir["bin/*"].each { |binary| File.chmod(0755, binary) }
end

desc "Install gem dependencies"
task :deps do
  require 'rubygems'
  spec = Gem::Specification.load('srl-api.gemspec')
  spec.dependencies.each do |dep|
    reqs = dep.requirements_list
    reqs = (["-v"] * reqs.size).zip(reqs).flatten
    # Use system over sh, because we want to ignore errors!
    system Gem.ruby, "-S", "gem", "install", '--conservative', dep.name, *reqs
  end
end

desc 'Generate a ChangeLog'
task :changelog => %w[ChangeLog]

file '.git/index'
file 'ChangeLog' => '.git/index' do
  File.open('ChangeLog', 'w') { |out|
    log = `git log -z`
    log.force_encoding(Encoding::BINARY)
    log.split("\0").map { |chunk|
      author = chunk[/Author: (.*)/, 1].strip
      date = chunk[/Date: (.*)/, 1].strip
      desc, detail = $'.strip.split("\n", 2)
      detail ||= ""
      detail = detail.gsub(/.*darcs-hash:.*/, '')
      detail.rstrip!
      out.puts "#{date}  #{author}"
      out.puts "  * #{desc.strip}"
      out.puts detail  unless detail.empty?
      out.puts
    }
  }
end

task :doc => :rdoc
desc 'Generate RDoc documentation'
task :rdoc => %w[ChangeLog] do
  cmd = %w(rdoc --line-numbers --main README.md
           --title 'SRL\ Ruby\ Client\ Documentation' --charset utf-8 -U -o doc)

  files = `git ls-files -z lib/`.split("\x0")
  files += %w(README.md ChangeLog)

  sh [cmd, files].join(' ')
end

task :gem do
  sh "gem build srl-api.gemspec"
end

def release
  @version ||=
    File.read('lib/srl-api.rb')[/RELEASE += +([\"\'])([\d][\w\.]+)\1/, 2]

  "srl-api-#{@version}"
end


# = Thanks
# Some of these were inspired (or straight out lifted) from Rack's own
# Rakefile
#
# https://github.com/rack/rack/blob/master/Rakefile
