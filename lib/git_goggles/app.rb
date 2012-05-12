module GitGoggles
  class App < Sinatra::Base
    get '/' do
      'Hello world'
    end

    get '/repositories' do
      content_type :json
      {:repositories => GitGoggles.repositories}.to_json
    end

    get '/repository/:name' do
      repository = GitGoggles::Repository.new(params[:name])

      if repository.exists?
        content_type :json
        repository.to_json
      else
        [404, "Repository #{params[:name]} not found"]
      end
    end

    get '/repository/:name/commits' do
      repository = GitGoggles::Repository.new(params[:name])
      content_type :json
      repository.commits.to_json
    end
  end
end
