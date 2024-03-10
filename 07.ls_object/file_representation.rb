# frozen_string_literal: true

class FileRepresentation
  FILE_TYPE_CHARACTERS = {
    '10': '-',
    '04': 'd',
    '12': 'l',
    '02': 'c',
    '06': 'b',
    '01': 'p',
    '14': 's'
  }.freeze

  PERMISSIONS = {
    '0': '---',
    '1': '--x',
    '2': '-w-',
    '3': '-wx',
    '4': 'r--',
    '5': 'r-x',
    '6': 'rw-',
    '7': 'rwx'
  }.freeze

  attr_reader :name

  def initialize(file_name)
    @name = file_name
    @stat = File.stat(file_name)
  end

  def long_format
    mode = format_mode(@stat.mode.to_s(8))
    link_count = @stat.nlink
    owner_name = Etc.getpwuid(@stat.uid).name
    group_name = Etc.getgrgid(@stat.gid).name
    size = @stat.size
    mtime = @stat.mtime.strftime('%-m %e %H:%M')
    "#{mode} #{link_count} #{owner_name} #{group_name.rjust(5)} #{size.to_s.rjust(4)} #{mtime} #{@name}"
  end

  private

  def format_mode(mode)
    mode_str = mode.rjust(6, '0')
    type_code = mode_str[0..1]
    file_types = FILE_TYPE_CHARACTERS[type_code.to_sym] || '-'
    user_permissions, group_permissions, other_permissions = mode_str[3..5].chars.map { |char| PERMISSIONS[char.to_sym] }
    "#{file_types}#{user_permissions}#{group_permissions}#{other_permissions}"
  end
end
