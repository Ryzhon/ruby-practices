# frozen_string_literal: true

class Directory
  attr_reader :files

  def initialize(options)
    flags = options[:include_hidden] ? File::FNM_DOTMATCH : 0
    @files = Dir.glob('*', flags).map { |file_name| FileRepresentation.new(file_name) }
    @files.reverse! if options[:reverse]
  end

  def total_blocks
    @files.sum { |file| File.stat(file.path).blocks }
  end
end
