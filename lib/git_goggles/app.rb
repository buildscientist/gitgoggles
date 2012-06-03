module GitGoggles
  class App < Sinatra::Base
    register Sinatra::Namespace

    get '/' do
      'Hello world'
    end

    get '/repositories/?' do
      json(:repositories, {:repositories => GitGoggles.repositories})
    end

    namespace '/repository/:name/?' do
      before do
        @repository = GitGoggles::Repository.new(params[:name])
        halt 404, "Repository #{params[:name]} not found" unless @repository.exists?
      end

      get do
        json(:repository, @repository)
      end

      get '/commits/?' do
        json(:commits, @repository.commits)
      end

      get '/commit/:sha/?' do
        json(:commit, @repository.commit(params[:sha]))
      end

      get '/tags/?' do
        json(:tags, @repository.tags)
      end

      get '/tag/:tag/?' do
        json(:tag, @repository.tag(params[:tag]))
      end

      get '/branches/?' do
        json(:branches, @repository.branches)
      end

      get '/branch/:branch/?' do
        json(:branch, @repository.branch(params[:branch]))
      end
    end

    def json(type, object)
      halt 404, "#{type.to_s.capitalize} not found" if object.nil?

      json = object.to_json

      if params[:callback]
        content_type 'text/javascript'
        "#{params[:callback]}(#{json});"
      else
        content_type :json
        json
      end

    end
  end
end
