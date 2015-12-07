require 'spec_helper'

describe Settings do
  # place your tests here


  before do

    SettingsRepository.clear

    @settings = SettingsRepository.create Settings.new( owner: 'Jason Foo-Bar' )

  end

  describe 'initialization' do

    it 'works' do

      @settings.owner.must_equal('Jason Foo-Bar')

    end

  end

  describe 'hash' do

    it 'can set its values from a hash' do

      @settings.set_hash 'foo': 1
      @settings.get_key('foo').must_equal(1)

    end

    it 'can change the value of a key' do

      @settings.set_hash 'foo': 1
      @settings.get_key('foo').must_equal(1)
      @settings.set_key('foo', 2)
      @settings.get_key('foo').must_equal(2)

    end

    it 'can render the hash as a string' do

      @settings.set_hash 'foo': 1
      @settings.hash_as_string.must_equal("{\"foo\"=>1}")

    end

    it 'can delete a key' do

      @settings.set_hash 'foo': 1
      @settings.delete_key('foo')
      @settings.get_key('foo').must_equal(nil)

    end

    it 'can update its image in the database' do

      @settings.set_hash 'foo': 1111
      #  @settings.update
      # SettingsRepository.update @settings
      @settings2 = SettingsRepository.first
      skip @settings2.get_key('foo').must_equal(1111)

    end



  end


end
