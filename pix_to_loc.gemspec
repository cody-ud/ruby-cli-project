Gem::Specification.new do |s|
  s.name        = 'pix_to_loc'
  s.version     = '0.1.0'
  s.date        = '2016-04-08'
  s.summary     = 'Inhale images, exhale coordinates.'
  s.description = 'Convert coordinates from image files to lat long decimals and output the results in a table as a csv or html file.'
  s.files       = Dir.glob('{lib,views}/**/*')
  s.executables << 'pix_to_loc'
  s.add_runtime_dependency 'exif', '~> 2.2.4'
  s.add_runtime_dependency 'csv', '~> 3.3.0'
  s.add_runtime_dependency 'erb', '~> 4.0.4'
  s.add_runtime_dependency 'thor', '~> 1.3.1'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  s.authors     = ['C']
end