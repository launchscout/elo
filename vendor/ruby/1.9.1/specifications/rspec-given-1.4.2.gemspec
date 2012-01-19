# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rspec-given"
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jim Weirich"]
  s.date = "2011-11-22"
  s.description = "Given is an RSpec extension that allows explicit definition of the\npre and post-conditions for code under test.\n"
  s.email = "jim.weirich@gmail.com"
  s.homepage = "http://github.com/jimweirich/rspec-given"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.md", "--title", "RSpec Given Extensions"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "given"
  s.rubygems_version = "1.8.10"
  s.summary = "Given/When/Then Specification Extensions for RSpec."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, ["> 1.2.8"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["> 2.4.2"])
    else
      s.add_dependency(%q<rspec>, ["> 1.2.8"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["> 2.4.2"])
    end
  else
    s.add_dependency(%q<rspec>, ["> 1.2.8"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["> 2.4.2"])
  end
end
