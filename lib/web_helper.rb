require 'app_helper'
require 'rack/utils'

module AppHelper::WebHelper
  include Rack::Utils
  def h(args)
    escape_html(args)
  end

  def blank_splat_params?(splat)
    splat.size == 1 && splat.first == ""
  end

  def breadcrumbs(entry)
    partial_crumbs = File.expand_path(entry).split('/') - root_path.split('/')
    partial_crumbs.unshift(root_name)
  end

  def breadcrumb_url_map(crumbs)
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

  def url_for(requested_path, entry)
    File.join("", requested_path, entry)
  end

  def icon_for(entry_type)
    directory_icon = "folder.png"
    file_icon = "page_white_text.png"
    return directory_icon if entry_type == 'directory'
    return file_icon if entry_type == 'file'
    return file_icon if entry_type != 'directory'
  end
end
