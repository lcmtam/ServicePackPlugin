# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

ENV['RACK_ENV'] ||= :production

Bundler.require(:default, ENV['RACK_ENV']) if defined?(Bundler)
require 'bundler/setup'

# lib_path = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(acklib_path)

require 'api/v1/base.rb'

run API::V1::Base.new

run Rails.application
