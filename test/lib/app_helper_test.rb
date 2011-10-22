require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'app_helper'

class AppHelperTest < Test::Unit::TestCase
  setup do
    @tester = Object.new
    @tester.extend(AppHelper)
  end

  describe 'root accessor' do
    should 'be available' do
      assert @tester.respond_to?(:root)
      assert @tester.respond_to?(:root=)
    end

    should 'raise error if environment variable is not set' do
      ENV['DIRSERVER_ROOT'] = nil
      assert_raises(DirserverRootNotSetError) { @tester.root }
    end

    should 'be set via environment variable' do
      ENV['DIRSERVER_ROOT'] = '.'
      assert_equal ENV['DIRSERVER_ROOT'], @tester.root
    end
  end

  describe 'root_path accessor' do
    should 'be available' do
      assert @tester.respond_to?(:root_path)
      assert @tester.respond_to?(:root_path=)
    end

    should 'return the fully expanded path' do
      ENV['DIRSERVER_ROOT'] = '.'
      assert_equal File.expand_path(ENV['DIRSERVER_ROOT']), @tester.root_path
    end
  end

  describe 'root_name accessor' do
    should 'be available' do
      assert @tester.respond_to?(:root_name)
      assert @tester.respond_to?(:root_name=)
    end

    should 'return the root directory name' do
      ENV['DIRSERVER_ROOT'] = '.'
      assert_equal File.basename(File.expand_path(ENV['DIRSERVER_ROOT'])), @tester.root_name
    end
  end
end
