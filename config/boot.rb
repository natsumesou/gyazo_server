# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# Enable devel logging
#
# Padrino::Logger::Config[:development] = { :log_level => :devel, :stream => :stdout }
# Padrino::Logger.log_static = true
#

Padrino::Logger::Config[:production] = { :log_level => :warn, :stream => :to_file }
Padrino::Logger::Config[:development] = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:test] = { :log_level => :debug, :stream => :stdout }

##
# Add your before load hooks here
#
Padrino.before_load do
  module NyazoEnv; end
  unless NyazoEnv.const_defined?('app'.classify, false)
    data = YAML.load_file(Padrino.root("config/app.yml"))[PADRINO_ENV].symbolize_keys
    NyazoEnv.const_set('app'.classify, data)
  end
end

##
# Add your after load hooks here
#
Padrino.after_load do
end

Padrino.load!
