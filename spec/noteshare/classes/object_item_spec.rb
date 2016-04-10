require 'spec_helper'
require_relative '../../../lib/noteshare/modules/toc_item'
include Noteshare::Core

describe ObjectItem do

         it 'can be initialized from a hash' do

           item1 = ObjectItem.new(22, 'Hello')
           item2 = ObjectItem.from_hash(id: 22, title: 'Hello')
           item1.id.must_equal(item2.id)
           item1.title.must_equal(item2.title)

         end

end

describe ObjectItemList do

  it 'can be built up from ObjectItems' do

    hash1 = { id: 11, title: 'Hello'}
    hash2 = { id: 22, title: 'Goodbye' }
    array = [hash1, hash2]
    object_list = ObjectItemList.new(array)
    puts object_list.display

  end

  it 'can be converted to an array of hashes' do

    hash1 = { id: 11, title: 'Hello'}
    hash2 = { id: 22, title: 'Goodbye' }
    array = [hash1, hash2]
    oil = ObjectItemList.new(array)
    puts oil.to_hash_array
    oil.table[0].id.must_equal(hash1[:id])
    oil.table[0].title.must_equal(hash1[:title])

  end

  it 'can be converted to and from JSON' do

    hash1 = { id: 11, title: 'Hello'}
    hash2 = { id: 22, title: 'Goodbye' }
    array = [hash1, hash2]
    oil = ObjectItemList.new(array)
    str = oil.encode
    oil2 = ObjectItemList.decode(str)
    str2 = oil2.encode
    str.must_equal(str2)
  end

  it 'can accept insertions of new elements in any valid position' do

    hash1 = { id: 11, title: 'Hello'}
    hash2 = { id: 22, title: 'Goodbye' }
    array = [hash1, hash2]
    oil = ObjectItemList.new(array)
    oi = ObjectItem.new(33, 'Shaking hands')
    oil.insert(1, oi)
    puts oil

  end

end

