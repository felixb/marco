require File.expand_path('../lib/marco/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'marco'
  s.version = Marco::VERSION
  s.licenses = ['MIT']
  s.summary = 'Create JIRA tickets based on JIRA tickets'
  s.description = 'Parse all JIRA tickets of a project and generate new tickets with markov chains.'
  s.authors = ['Felix Bechstein']
  s.email = 'f@ub0r.de'
  s.homepage = 'https://github.com/felixb/marco'

  s.files = `git ls-files`.split($\)
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w{lib}

  s.add_dependency 'jira-ruby'
  s.add_dependency 'logger'
  s.add_dependency 'marky_markov'
  s.add_dependency 'thor'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
