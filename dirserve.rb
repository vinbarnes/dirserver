require 'sinatra'

get '/*' do
  @requested_entry = params[:splat]
  @requested_entry_path = build_requested_path(@requested_entry)
  @breadcrumbs = breadcrumbs(@requested_entry_path)
  @listing = listing_info(directory_listing(@requested_entry_path)) if File.directory?(@requested_entry_path)

  erb :index
end

helpers do
  attr_accessor :root, :root_path, :root_name
  
  include Rack::Utils
  alias_method :h, :escape_html

  def root
    @root ||= ENV['DIRSERVE_ROOT']
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

  def breadcrumbs(entry)
    partial_crumbs = File.expand_path(entry).split('/') - root_path.split('/')
    partial_crumbs.unshift(root_name)
  end

  def last_breadcrumb?(crumb)
    equal_breadcrumbs?(@breadcrumbs.last, crumb)
  end

  def equal_breadcrumbs?(crumb1, crumb2)
    crumb1.object_id == crumb2.object_id
  end

  def build_requested_path(splat)
    File.join(root_path, splat)
  end

  def url_for(entry)
    File.join("", @requested_entry, entry)
  end
end
