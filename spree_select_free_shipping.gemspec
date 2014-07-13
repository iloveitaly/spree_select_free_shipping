# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_select_free_shipping'
  s.version     = '1.2.0'
  s.summary     = 'Free shipping as a selection in spree commerce'

  s.author    = 'Michael Bianco'
  s.email     = 'mike@cliffsidemedia.com'
  s.homepage  = 'http://github.com/iloveitaly/spree_select_free_shipping'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.1'

  s.add_development_dependency 'rspec-rails', '2.12.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'capybara', '1.1'
  s.add_development_dependency 'factory_girl_rails', '1.7.0'
end
