lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'e_invoice/version'

Gem::Specification.new do |spec|
  spec.name = 'e_invoice'
  spec.version = EInvoice::VERSION
  spec.authors = ['Artur Beljajev', 'Maciej Szlosarczyk', 'Sergei Tsõganov']
  spec.email = ['artur.beljajev@internet.ee', 'maciej.szlosarczyk@internet.ee', 'sergei.tsoganov@internet.ee']
  spec.summary = 'Ruby API for generating and delivering Estonian e-invoices'
  spec.homepage = 'https://github.com/internetee/e_invoice'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'builder', '~> 3.2'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'savon'
  spec.add_development_dependency 'bundler', '>= 2.2.10'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'bundle-audit'
  spec.add_development_dependency 'brakeman'
end
