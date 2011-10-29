require 'app_helper'

class NoPresentWorkingDirectoryError < Exception; end

module AppHelper::FileHelper
  attr_accessor :pwd
  attr_accessor :root, :root_path, :root_name
  
  def basename(path)
    File.basename(path)
  end

  def directory_listing(dir)
    self.pwd = File.expand_path(dir)
    Dir.entries(pwd) - %w[. ..]
  rescue Errno::ENOENT => e
    raise ArgumentError.new("Must supply a valid path argument")
  end

  def entry_info_map(entry)
    raise NoPresentWorkingDirectoryError if pwd.nil?
    [entry, File.ftype(File.expand_path(File.join(pwd, entry)))]
  rescue Errno::ENOENT => e
    raise ArgumentError.new("Must supply a valid directory entry")
  end

  def listing_info_map(listing)
    listing.map do |entry|
      entry_info_map(entry)
    end
  end

   def age(entry)
    File.mtime(File.expand_path(File.join(pwd, entry))).strftime("%D %T %z")
  end

  def size(entry)
    entry_path = File.expand_path(File.join(pwd, entry))
    if File.file?(entry_path)
      File.size(entry_path)
    else
      '--'
    end
  end
end
