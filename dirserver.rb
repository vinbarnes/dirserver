require 'sinatra'

get '/*' do
  @requested_entry = params[:splat]
  @requested_entry_path = build_requested_path(@requested_entry)
  @breadcrumbs = breadcrumbs(@requested_entry_path)
  @listing = listing_info(directory_listing(@requested_entry_path)) if File.directory?(@requested_entry_path)

  if blank_splat_params?(@requested_entry)
    redirect to(url_for(root_name))
  else
    erb :index
  end
end

helpers do
  attr_accessor :root, :root_path, :root_name
  
  include Rack::Utils
  alias_method :h, :escape_html

  def root
    @root ||= ENV['DIRSERVER_ROOT']
  end
  
  def root_path
    @root_path ||= File.expand_path(root)
  end

  def root_name
    @root_name ||= root_path.split('/').last
  end

  def directory_listing(dir)
    Dir.entries(dir) - %w[. ..]
  end

  def listing_info(listing)
    listing.map do |entry|
      [entry, File.directory?(entry)]
    end
  end

  def blank_splat_params?(splat)
    splat.size == 1 && splat.first == ""
  end

  def breadcrumbs(entry)
    partial_crumbs = File.expand_path(entry).split('/') - root_path.split('/')
    partial_crumbs.unshift(root_name)
  end

  def add_urls_to_breadcrumbs(crumbs)
    previous = ''
    crumbs.map do |crumb|
      url = File.join(previous, crumb)
      previous = url
      [crumb, url]
    end
  end

  def last_breadcrumb?(crumbs, crumb)
    equal_breadcrumbs?(crumbs.last, crumb)
  end

  def equal_breadcrumbs?(crumb1, crumb2)
    crumb1.object_id == crumb2.object_id
  end

  def build_requested_path(splat)
    File.join(File.dirname(root_path), splat)
  end

  def url_for(entry)
    File.join("", @requested_entry, entry)
  end

  def icon_for(is_directory)
    folder = "folder.png"
    file = "page_white_text.png"
    (is_directory and folder) || file
  end
end
