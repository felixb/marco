require 'rubygems'
require 'bundler/setup'
require 'jira'
require 'logger'
require 'marky_markov'
require 'yaml'

module Marco

  require_relative '../lib/marco/version'
  require_relative '../lib/marco/base'
  require_relative '../lib/marco/knowledge_base'
  require_relative '../lib/marco/issue_fetcher'
  require_relative '../lib/marco/issue_writer'

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  attr_writer :logger
  module_function :logger, :logger=
end
