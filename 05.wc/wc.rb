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

def wc(files, options)
  total_lines = 0
  total_words = 0
  total_bytes = 0

  files.each do |file|
    contents = File.read(file)
    lines = count_lines(contents)
    words = count_words(contents)
    bytes = count_bytes(contents)
    puts format_output(file, lines, words, bytes, options)
    total_lines += lines
    total_words += words
    total_bytes += bytes
  end

  puts format_output('total', total_lines, total_words, total_bytes, options) if files.length > 1
end

options = { lines: false, words: false, bytes: false }

opt = OptionParser.new

opt.on('-l') do
  options[:lines] = true
end

opt.on('-w') do
  options[:words] = true
end

opt.on('-c') do
  options[:bytes] = true
end

opt.parse!(ARGV)

if ARGV.empty?
  contents = $stdin.read
  lines = count_lines(contents)
  words = count_words(contents)
  bytes = count_bytes(contents)
  puts format_output(nil, lines, words, bytes, options)
else
  wc(ARGV, options)
end
