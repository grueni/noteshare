require 'spec_helper'

describe NSNodeRepository do

  before do
    NSNodeRepository.clear
  end

  it 'can count its objects' do

    NSNodeRepository.all.count.must_equal 0

    node = NSNode.new(name: 'foo')
    NSNodeRepository.create node
    NSNodeRepository.all.count.must_equal 1

  end

  it 'can find its objects by owner_id' do


    node = NSNode.new(name: 'foo', owner_id: 44)
    NSNodeRepository.create node

    node2 = NSNodeRepository.for_owner_id(44)

    node2.name.must_equal 'foo'

  end


end
