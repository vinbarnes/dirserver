require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'web_helper'

class WebHelperTest < Test::Unit::TestCase
  setup do
    @tester = Object.new
    @tester.extend(AppHelper, AppHelper::WebHelper)
  end

  describe 'sanitize method' do
    should 'be available' do
      assert @tester.respond_to?(:h)
    end
  end

  describe '#blank_splat_params?' do
    should 'accept a splat argument' do
      assert_nothing_raised { @tester.blank_splat_params?('')}
    end

    should 'raise error if no splat argument given' do
      assert_raises(ArgumentError) { @tester.blank_splat_params?() }
    end

    should 'return true if splat param has one member and is empty string' do
      assert @tester.blank_splat_params?([''])
    end

    should 'return false if splat param has one member and is not empty string' do
      assert_equal false, @tester.blank_splat_params?(['tango'])
    end
  end

  describe '#breadcrumbs' do
    setup do
      ENV['DIRSERVER_ROOT'] = 'test_root'
    end

    should 'accept a entry argument' do
      assert_nothing_raised { @tester.breadcrumbs('tusk')}
    end

    should 'raise error if no entry argument given' do
      assert_raises(ArgumentError) { @tester.breadcrumbs() }
    end

    should 'return breadcrumbs' do
      assert_equal ['test_root', 'tusk'], @tester.breadcrumbs('tusk')
    end
  end

  describe '#breadcrumb_url_map' do
    setup do
      ENV['DIRSERVER_ROOT'] = 'test_root'
    end

    should 'accept a crumb list argument' do
      assert_nothing_raised { @tester.breadcrumb_url_map(['test_root', 'tusk']) }
    end

    should 'raise error if no crumb list argument given' do
      assert_raises(ArgumentError) { @tester.breadcrumb_url_map() }
    end

    should 'return breadcrumb url map' do
      assert_equal [['test_root', '/test_root'],['tusk', '/test_root/tusk']], @tester.breadcrumb_url_map(['test_root', 'tusk'])
    end
  end

  describe '#equal_breadcrumbs?' do
    should 'accept two crumb arguments' do
      assert_nothing_raised { @tester.equal_breadcrumbs?('crumb1', 'crumb2') }
    end

    should 'raise error if only one crumb argument given' do
      assert_raises(ArgumentError) { @tester.equal_breadcrumbs?('crumb1') }
    end

    should 'raise error if no crumb arguments given' do
      assert_raises(ArgumentError) { @tester.equal_breadcrumbs?() }
    end

    should 'return true if both crumb arguments are equal' do
      crumb1 = crumb2 = 'crumb'
      assert @tester.equal_breadcrumbs?(crumb1, crumb1)
    end

    should 'return false if crumbs arguments are not equal' do
      assert_equal false, @tester.equal_breadcrumbs?('crumb1', 'crumb2')
    end
  end

  describe '#last_breadcrumb?' do
    setup do
      @crumb_list = ['test_root', 'tusk', 'tail']
      @last_crumb = @crumb_list.last
      @first_crumb = @crumb_list.first
    end

    should 'accept crumb list and crumb arguments' do
      assert_nothing_raised { @tester.last_breadcrumb?(@crumb_list, @last_crumb) }
    end

    should 'raise error if only crumb list argument given' do
      assert_raises(ArgumentError) { @tester.last_breadcrumb?(@crumb_list) }
    end

    should 'raise error if only crumb argument given' do
      assert_raises(ArgumentError) { @tester.last_breadcrumb?(@last_crumb) }
    end

    should 'raise error if no arguments given' do
      assert_raises(ArgumentError) { @tester.last_breadcrumb?() }
    end

    should 'return true if crumb is the last entry in crumb list' do
      assert @tester.last_breadcrumb?(@crumb_list, @last_crumb)
    end

    should 'return false if crumb is not the last entry in crumb list' do
      assert_equal false, @tester.last_breadcrumb?(@crumb_list, @first_crumb)
    end
  end

  describe '#build_requested_path' do
    setup do
      ENV['DIRSERVER_ROOT'] = 'test_root'
    end

    should 'accept splat param argument' do
      assert_nothing_raised { @tester.build_requested_path('/test_root/tusk') }
    end

    should 'raise error if not splat param argument given' do
      assert_raises(ArgumentError) { @tester.build_requested_path() }
    end

    should 'return requested path from splat param' do
      expected_path = @tester.root_path + '/tusk'
      assert_equal expected_path, @tester.build_requested_path('/test_root/tusk')
    end
  end

  describe '#build_url' do
    setup do
      @requested_path = '/test_root/tusk'
    end

    should 'accept requested path and entry arguments' do
      assert_nothing_raised { @tester.build_url(@requested_path, 'tail') }
    end

    should 'raise error if only requested path given' do
      assert_raises(ArgumentError) { @tester.build_url(@requested_path) }
    end

    should 'raise error if only requested entry given' do
      assert_raises(ArgumentError) { @tester.build_url('dsb.mp3') }
    end

    should 'return relative path' do
      assert_equal File.join(@requested_path, 'dsb.mp3'), @tester.build_url(@requested_path, 'dsb.mp3')
    end
  end

  describe '#icon_for' do
    setup do
      @file_icon = "page_white_text.png"
      @directory_icon = "folder.png"
    end

    should 'accept entry argument' do
      assert_nothing_raised { @tester.icon_for('file') }
    end

    should 'raise error if entry argument not given' do
      assert_raises(ArgumentError) { @tester.icon_for() }
    end

    should 'return file icon if entry is a file' do
      assert_equal @file_icon, @tester.icon_for('file')
    end

    should 'return directory icon if entry is a directory' do
      assert_equal @directory_icon, @tester.icon_for('directory')
    end

    should 'return file icon if entry is neither file nor directory' do
      assert_equal @file_icon, @tester.icon_for('link')
    end

  end
end
