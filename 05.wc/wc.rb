# frozen_string_literal: true

require 'optparse'

def count_lines(contents)
  contents.count("\n")
end

def count_words(contents)
  contents.split(/\s+/).size
end

def count_bytes(contents)
  contents.bytesize
end

def format_output(filename, lines, words, bytes, options)
  output = []
  if options.values.none?
    output << lines.to_s.rjust(8)
    output << words.to_s.rjust(8)
    output << bytes.to_s.rjust(8)
  else
    output << lines.to_s.rjust(8) if options[:lines]
    output << words.to_s.rjust(8) if options[:words]
    output << bytes.to_s.rjust(8) if options[:bytes]
  end
  output << filename
  output.join(' ')
end

def wc(inputs, options)
  total_lines = 0
  total_words = 0
  total_bytes = 0

  inputs.each do |input|
    content = input.respond_to?(:read) ? input.read : File.read(input)
    lines = count_lines(content)
    words = count_words(content)
    bytes = count_bytes(content)
    file_label = input.respond_to?(:read) ? '' : input
    puts format_output(file_label, lines, words, bytes, options)
    total_lines += lines
    total_words += words
    total_bytes += bytes
  end

  return unless inputs.length > 1

  puts format_output('total', total_lines, total_words, total_bytes, options)
end

options = { lines: false, words: false, bytes: false }

opt = OptionParser.new

opt.on('-l') { options[:lines] = true }

opt.on('-w') { options[:words] = true }

opt.on('-c') { options[:bytes] = true }

opt.parse!(ARGV)

inputs = ARGV.empty? ? [$stdin] : ARGV
wc(inputs, options)
