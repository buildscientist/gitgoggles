module GitGoggles
  class App < Sinatra::Base
    register Sinatra::Namespace

    get '/' do
      'Hello world'
    end

    get '/repositories' do
      content_type :json
      {:repositories => GitGoggles.repositories}.to_json
    end

    namespace '/repository/:name' do
      before do
        @repository = GitGoggles::Repository.new(params[:name])
        halt 404, "Repository #{params[:name]} not found" unless @repository.exists?
      end

      get do
        content_type :json
        @repository.to_json
      end

      get '/commits' do
        content_type :json
        @repository.commits.to_json
      end

      get '/commit/:sha' do
        if @repository.commits.any? { |c| c[:sha] == params[:sha] }
          content_type :json
          @repository.commit(params[:sha]).to_json
        else
          [404, "Commit #{params[:sha]} not found in repository #{params[:name]} not found"]
        end
      end
    end
  end
end
