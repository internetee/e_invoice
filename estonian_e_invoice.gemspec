lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'estonian_e_invoice/version'

Gem::Specification.new do |spec|
  spec.name = 'estonian_e_invoice'
  spec.version = EstonianEInvoice::VERSION
  spec.author = 'Estonian Internet Foundation'
  spec.email = 'info@internet.ee'
  spec.summary = 'Ruby API for generating Estonian e-invoices'
  spec.homepage = 'https://github.com/internetee/estonian_e_invoice'
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
  spec.add_runtime_dependency 'nokogiri' # Required by "Omniva" provider
  spec.add_runtime_dependency 'money'
  spec.add_runtime_dependency 'savon' # Required by "Omniva" provider
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'simplecov'
end