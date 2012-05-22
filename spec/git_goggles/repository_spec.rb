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

  describe "#commit" do
    it 'returns nil when the commit is not found' do
      repo = create_repo('foo')

      GitGoggles::Repository.new('foo').commit('bad_sha').should be_nil
    end

    it 'returns a commit object' do
      repo = create_repo('foo',
        :commit_msg => 'my commit',
        :user_name => 'Bob',
        :user_email => 'bob@foo.com'
      )

      repository = GitGoggles::Repository.new('foo')
      commit = repository.commit(repo.commits.first.sha)

      commit[:author].should == 'Bob <bob@foo.com>'
      commit[:diffs].should be_kind_of(Array)
      commit[:date].should be_kind_of(String)
      commit[:date].length.should > 0
      commit[:message].should == 'my commit'
    end
  end

  describe '#to_json' do
    it 'returns itself as json' do
      create_repo('foo')
      repository = GitGoggles::Repository.new('foo')

      repository.to_json.should == '{"name":"foo","branches":["master"]}'
    end
  end

  describe '#tags' do
    it 'returns an array of tags' do
      create_repo('foo', :tags => ['0.0.1'])
      repository = GitGoggles::Repository.new('foo')

      repository.tags.should include('0.0.1')
    end
  end

  describe '#tag' do
    it 'returns an array of tags' do
      repo = create_repo('foo', :tags => ['0.0.1'])
      repository = GitGoggles::Repository.new('foo')
      tag = repository.tag('0.0.1')

      tag[:name].should == '0.0.1'
      tag[:commit].should == repo.commits.first.sha
    end

    it 'returns nil for a tag not found' do
      repo = create_repo('foo')
      repository = GitGoggles::Repository.new('foo')

      repository.tag('badtag').should be_nil
    end
  end
end
