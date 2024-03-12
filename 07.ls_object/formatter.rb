# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_representation'

class Formatter
  MAX_COLUMNS = 3
  def self.format_files(directory, long_format: false)
    if long_format
      puts "total #{directory.total_blocks}"
      directory.files.each { |file| puts file.long_format }
    else
      max_length = directory.files.map { |file| file.name.length }.max
      files_in_columns = directory.files.map { |file| file.name.ljust(max_length) }
                                  .each_slice((directory.files.size / MAX_COLUMNS.to_f).ceil).to_a

      files_in_columns.first.zip(*files_in_columns[1..]).each do |row|
        puts row.join('  ')
      end
    end
  end
end
