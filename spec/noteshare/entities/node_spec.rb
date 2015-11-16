require 'spec_helper'

describe NSNode do

  before do
    NSNodeRepository.clear
  end

  it 'can count its objects' do

    NSNodeRepository.all.count.must_equal 0

    node = NSNode.new(name: 'foo')
    NSNodeRepository.create node
    NSNodeRepository.all.count.must_equal 1

  end

  it 'can find its objects' do

    NSNodeRepository.all.count.must_equal 0

    node = NSNode.new(name: 'foo')
    NSNodeRepository.create node
    NSNodeRepository.all.count.must_equal 1

  end


end
