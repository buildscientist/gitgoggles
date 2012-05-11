require 'spec_helper'

describe GitGoggles::Repository do
  describe '#exists?' do
    it 'is true if the repo exists inside the root_dir' do
      create_repo('foo')
      repository = GitGoggles::Repository.new('foo')

      repository.exists?.should be_true
    end
  end

  describe '#to_json' do
    it 'returns itself as json' do
      create_repo('foo')
      repository = GitGoggles::Repository.new('foo')

      repository.to_json.should == '{"name":"foo","branches":["master"]}'
    end
  end
end
