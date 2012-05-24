module GitGoggles
  class App < Sinatra::Base
    register Sinatra::Namespace

    get '/' do
      'Hello world'
    end

    get '/repositories/?' do
      content_type :json
      {:repositories => GitGoggles.repositories}.to_json
    end

    namespace '/repository/:name/?' do
      before do
        @repository = GitGoggles::Repository.new(params[:name])
        halt 404, "Repository #{params[:name]} not found" unless @repository.exists?
      end

      get do
        content_type :json
        @repository.to_json
      end

      get '/commits/?' do
        content_type :json
        @repository.commits.to_json
      end

      get '/commit/:sha/?' do
        commit = @repository.commit(params[:sha])
        halt 404, "Commit #{params[:sha]} not found" if commit.nil?

        content_type :json
        commit.to_json
      end

      get '/tags/?' do
        content_type :json
        @repository.tags.to_json
      end

      get '/tag/:tag/?' do
        tag = @repository.tag(params[:tag])
        halt 404, "Tag #{params[:tag]} not found" if tag.nil?

        content_type :json
        tag.to_json
      end

      get '/branches/?' do
	content_type :json
	@repository.branches.to_json
      end

      get '/branch/:branch/?' do
        branch = @repository.branch(params[:branch])
        halt 404, "Branch #{params[:branch]} not found" if branch.nil?

        content_type :json
        branch.to_json

      end

    end
  end
end
