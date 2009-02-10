Gem::Specification.new do |spec|
  spec.name = 'microgem'
  spec.version = '0.2.0'
  
  spec.author = 'Eloy Duran'
  spec.email = 'eloy.de.enige@gmail.com'
  
  spec.description = spec.summary = %{
    MicroGem provides a simple naive replacement for the `gem install' command
    in the form of the `µgem' or `mgem' commandline utility.
  }
  
  spec.executables << 'µgem'
  spec.executables << 'mgem'
  spec.files = Dir['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*']
  
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w{ README.rdoc LICENSE TODO }
  spec.rdoc_options << '--charset=utf-8' << '--main' << 'README.rdoc'
end