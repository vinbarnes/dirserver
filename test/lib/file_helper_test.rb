require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'file_helper'

class FileHelperTest < Test::Unit::TestCase
  setup do
    @tester = Object.new
    @tester.extend(AppHelper, AppHelper::FileHelper)
    @test_dir = File.expand_path(File.dirname(__FILE__) + '/..')
  end

  describe '@pwd' do
    should 'be available' do
      assert @tester.respond_to?(:pwd)
      assert @tester.respond_to?(:pwd=)
    end
  end

  describe '#directory_listing' do
    should 'accept a path argument' do
      assert_nothing_raised { @tester.directory_listing(@test_dir) }
    end

    should 'raise error if argument given is not a valid path' do
      assert_raises(ArgumentError) { @tester.directory_listing('does-not-exist') }
    end

    should 'raise error if argument not given' do
      assert_raises(ArgumentError) { @tester.directory_listing() }
    end

    should 'return directory contents' do
      assert_equal %w[contest.rb lib test_helper.rb], @tester.directory_listing(@test_dir)
    end

    should 'never include . and .. in listing' do
      # let's make sure the listing actually has the entries in question
      assert_equal true, Dir.entries(@test_dir).include?('.')
      assert_equal true, Dir.entries(@test_dir).include?('..')

      assert_equal false, @tester.directory_listing(@test_dir).include?('.')
      assert_equal false, @tester.directory_listing(@test_dir).include?('..')
    end
  end

  describe '#entry_info_map' do
    setup do
      @file_entry = 'test_helper.rb'
      @directory_entry = 'lib'
      @tester.pwd = @test_dir # fake out a call to #directory_listing
    end

    should 'raise error if pwd is not set' do
      @tester.pwd = nil
      assert_raises(NoPresentWorkingDirectoryError) do
        @tester.entry_info_map(@file_entry)
      end
    end

    should 'accept an entry argument' do
      assert_nothing_raised { @tester.entry_info_map(@file_entry) }
    end

    should 'raise error if argument given is not a valid entry' do
      assert_raises(ArgumentError) { @tester.entry_info_map('does-not-exist') }
    end

    should 'raise error if argument not given' do
      assert_raises(ArgumentError) { @tester.entry_info_map() }
    end

    should 'return entry info map' do
      assert_equal [@file_entry, 'file'], @tester.entry_info_map(@file_entry)
      assert_equal [@directory_entry, 'directory'], @tester.entry_info_map(@directory_entry)
    end
  end

  describe '#listing_info_map' do
    setup do
      @listing = @tester.directory_listing(@test_dir)
    end

    should 'accept a listing argument' do
      assert_nothing_raised { @tester.listing_info_map(@listing) }
    end

    should 'raise error if no listing given' do
      assert_raises(ArgumentError) { @tester.listing_info_map() }
    end

    should 'return listing info map' do
      assert_equal [['contest.rb', 'file'], ['lib', 'directory'], ['test_helper.rb', 'file']], @tester.listing_info_map(@listing)
    end

    should 'return empty listing if empty listing argument given' do
      assert_equal [], @tester.listing_info_map([])
    end
  end

  describe '#age' do
    setup do
      @file_entry = 'test_helper.rb'
      @directory_entry = 'lib'
      @tester.pwd = @test_dir # fake out a call to #directory_listing
    end

    should 'accept a entry argument' do
      assert_nothing_raised { @tester.age(@file_entry)}
    end

    should 'raise error if no entry argument given' do
      assert_raises(ArgumentError) { @tester.age() }
    end

    should 'return age of entry' do
      # TODO figure out easy way to test this. Tempfile?
    end
  end

  describe '#size' do
    setup do
      @file_entry = 'test_helper.rb'
      @directory_entry = 'lib'
      @tester.pwd = @test_dir # fake out a call to #directory_listing
    end

    should 'accept a entry argument' do
      assert_nothing_raised { @tester.size(@file_entry)}
    end

    should 'raise error if no entry argument given' do
      assert_raises(ArgumentError) { @tester.size() }
    end

    should 'return size for a file' do
      assert @tester.size(@file_entry).kind_of?(Fixnum)
    end

    should 'not return size for a directory' do
      assert_equal '--', @tester.size(@directory_entry)
    end
  end
end
