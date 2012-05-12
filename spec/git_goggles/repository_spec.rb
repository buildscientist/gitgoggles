require 'spec_helper'

describe GitGoggles::Repository do
  describe '#exists?' do
    it 'is true if the repo exists inside the root_dir' do
      create_repo('foo')
      repository = GitGoggles::Repository.new('foo')

      repository.exists?.should be_true
    end
  end

  describe "#commits" do
    it 'returns a array of commit objects' do
      create_repo('foo',
        :commit_msg => 'my commit',
        :user_name => 'Bob',
        :user_email => 'bob@foo.com'
      )

      repository = GitGoggles::Repository.new('foo')

      repository.commits.first[:author].should == 'Bob <bob@foo.com>'
      repository.commits.first[:message].should == 'my commit'
      repository.commits.first[:sha].should be_kind_of(String)
      repository.commits.first[:sha].length.should > 0
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
