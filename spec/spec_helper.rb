ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'git_goggles'

RSpec.configure do |config|
  config.expect_with :rspec
  config.include Rack::Test::Methods

  config.before(:each) do
    FileUtils.rm_rf(GitGoggles.root_dir)
  end
end

GitGoggles.root_dir = '/tmp/git_goggles'

def create_repo(name, options = {})
  commit_msg = options.fetch(:commit_msg, 'test commit')
  user_name = options.fetch(:user_name, 'Bob')
  user_email = options.fetch(:user_email, 'bob@foo.com')

  path = File.join(GitGoggles.root_dir, name)
  FileUtils.mkdir_p(path)
  FileUtils.touch(path+'/testfile')

  Dir.chdir(path) do
    repo = Grit::Repo.init(path)

    repo.config['user.name'] = user_name
    repo.config['user.email'] = user_email

    repo.add(path+'/testfile')
    repo.commit_index(commit_msg)
    `rm testfile && mv .git/* . && rm -rf .git/`
  end
  Grit::Repo.new(path, {:is_bare => true})
end
