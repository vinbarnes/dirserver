$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))

require 'sinatra'
require 'app_helper'
require 'file_helper'
require 'web_helper'

helpers do
  include AppHelper, AppHelper::FileHelper, AppHelper::WebHelper

  # candy method for getting file entry URLs
  def url_for(entry)
    build_url(@requested_entry, entry)
  end
end

get '/*' do
  @requested_entry = params[:splat]
  @requested_entry_path = build_requested_path(@requested_entry)
  @breadcrumbs = breadcrumbs(@requested_entry_path)
  @listing = listing_info_map(directory_listing(@requested_entry_path)) if File.directory?(@requested_entry_path)

  if blank_splat_params?(@requested_entry)
    redirect to(url_for(root_name))
  else
    erb :index
  end
end
