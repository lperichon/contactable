# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{contactable}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luis Perichon"]
  s.date = %q{2009-11-05}
  s.description = %q{Adds contact information to an active record model}
  s.email = %q{info@luisperichon.com.ar}
  s.extra_rdoc_files = ["README.rdoc", "lib/contactable.rb"]
  s.files = ["README.rdoc", "Rakefile", "lib/contactable.rb", "Manifest", "contactable.gemspec"]
  s.homepage = %q{http://github.com/lperichon/contactable}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Contactable", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{contactable}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Adds contact information to an active record model}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
