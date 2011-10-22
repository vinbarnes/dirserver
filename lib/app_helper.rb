class DirserverRootNotSetError < Exception; end

module AppHelper
  attr_accessor :root, :root_path, :root_name

  def root
    raise DirserverRootNotSetError unless ENV['DIRSERVER_ROOT']
    @root ||= ENV['DIRSERVER_ROOT']
  end
  
  def root_path
    @root_path ||= File.expand_path(root)
  end

  def root_name
    @root_name ||= File.basename(root_path)
  end

end
