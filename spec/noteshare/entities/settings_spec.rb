require 'spec_helper'

describe Settings do
  # place your tests here


  before do
    # The database is set up to have exactly one entry:n
    # SettingsRepository.clear
    # @settings = Settings.new(id: 1, message: 'Howdy', owner: 'Jason Foo-Bar')
    # puts @settings.owner.red
    # SettingsRepository.create @settings
    @settings = SettingsRepository.first
    puts @settings.owner.red
  end

  describe 'initialization' do

    it 'works 111' do

      @settings.owner.must_equal('Jason Foo-Bar')

    end

  end

  describe 'hash' do

    it 'can set its values from a hash' do

      @settings.set_key('foo',1)
      @settings.get_key('foo').must_equal(1)

    end

    it 'can change the value of a key' do

      @settings.set_key('foo',1)
      @settings.get_key('foo').must_equal(1)
      @settings.set_key('foo',2)
      @settings.get_key('foo').must_equal(2)

    end

    it 'can render the hash as a string' do

      @settings.set_key('foo',1)
      @settings.as_string.must_equal("{\"foo\"=>1}")

    end

    it 'can delete a key' do

      @settings.set_key('foo',1)
      @settings.delete_key('foo')
      @settings.get_key('foo').must_equal(nil)

    end

    it 'can update its image in the database' do

      @settings.set 'foo': 1111
      puts @settings.inspect.cyan
      # @settings.update
      SettingsRepository.update @settings
      @settings = SettingsRepository.first
      @settings.get_key('foo').must_equal('1111')

    end



  end


end
