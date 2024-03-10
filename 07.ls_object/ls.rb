# frozen_string_literal: true

require 'optparse'
require_relative 'directory'
require_relative 'formatter'

options = { include_hidden: false, reverse: false, long_format: false }
opt = OptionParser.new

opt.on('-a') { options[:include_hidden] = true }
opt.on('-r') { options[:reverse] = true }
opt.on('-l') { options[:long_format] = true }

opt.parse!(ARGV)

directory = Directory.new(options)
Formatter.format_files(directory, long_format: options[:long_format])
