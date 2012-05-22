require 'spec_helper'

describe GitGoggles::App do
  def app
    GitGoggles::App
  end

  describe 'GET /repositories' do
    it 'returns an empty JSON list if no repositories are found' do
      get '/repositories'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')
      last_response.body.should == "{\"repositories\":[]}"
    end

    it 'returns a JSON list of repositories' do
      create_repo('riak')
      create_repo('web2py')
      create_repo('rails')

      get '/repositories'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      repositories = JSON.parse(last_response.body)

      repositories['repositories'].should include('riak')
      repositories['repositories'].should include('web2py')
      repositories['repositories'].should include('rails')
    end
  end

  describe 'GET /repository/:name' do
    it 'returns a 404 if a repository is not found' do
      get '/repository/bad_repo'

      last_response.status.should == 404
    end

    it 'returns details of the repository as JSON' do
      create_repo('foo')

      get '/repository/foo'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      repository = JSON.parse(last_response.body)

      repository['name'].should == 'foo'
      repository['branches'].should include('master')
    end
  end

  describe 'GET /repository/:name/commits' do
    it 'returns a list of commits as JSON' do
      create_repo('foo', :commit_msg => 'my fake commit')

      get '/repository/foo/commits'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      commits = JSON.parse(last_response.body)

      commits.length.should == 1
      commits.first['message'].should == 'my fake commit'
    end

    it 'returns a list of commits as JSON' do
      get '/repository/bad_repo/commits'

      last_response.status.should == 404
    end
  end

  describe 'GET /repository/:name/commit/:sha' do
    it 'returns commit detail as JSON' do
      repo = create_repo('foo', :commit_msg => 'my fake commit')

      get "/repository/foo/commit/#{repo.commits.first.id}"

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      commit = JSON.parse(last_response.body)

      commit['message'].should == 'my fake commit'
    end

    it 'returns 404 if the commit does not exist' do
      get '/repository/foo/commit/badsha'

      last_response.status.should == 404
    end
  end

  describe 'GET /repository/:name/tags' do
    it 'returns a JSON array of tags' do
      create_repo('foo', :tags => ['0.0.1', '1.0.0-rc1'])

      get '/repository/foo/tags'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      tags = JSON.parse(last_response.body)

      tags.should include('0.0.1')
      tags.should include('1.0.0-rc1')
    end

    it 'returns an empty JSON array for no tags' do
      create_repo('foo')

      get '/repository/foo/tags'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      tags = JSON.parse(last_response.body)

      tags.should be_empty
    end
  end

  describe 'GET /repository/:name/tag/:tag' do
    it 'returns a JSON object for a tag' do
      create_repo('foo', :tags => ['0.0.1'])

      get '/repository/foo/tag/0.0.1'

      last_response.status.should == 200
      last_response.content_type.should match('application/json')

      tag = JSON.parse(last_response.body)

      tag['name'].should == '0.0.1'
    end

    it 'returns a 404 for a tag not found' do
      create_repo('foo')

      get '/repository/foo/tag/badtag'

      last_response.status.should == 404
    end
  end
end
