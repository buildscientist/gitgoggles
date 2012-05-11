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

def create_repo(name)
  path = File.join(GitGoggles.root_dir, name)
  FileUtils.mkdir_p(path)
  FileUtils.touch(path+"/testfile")

  Dir.chdir(path) do
    repo = Grit::Repo.init(path)
    repo.add(path+"/testfile")
    repo.commit_index("test commit")
    `rm testfile && mv .git/* . && rm -rf .git/`
  end

end
