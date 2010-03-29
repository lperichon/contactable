require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('contactable', '1.0.1') do |p|
  p.description     = "Adds contact information to an active record model"
  p.url             = "http://github.com/lperichon/contactable"
  p.author          = "Luis Perichon"
  p.email           = "info@luisperichon.com.ar"
  p.ignore_pattern  = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }