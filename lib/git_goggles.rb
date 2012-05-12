require 'json'
require 'sinatra/base'
require 'grit'

require 'git_goggles/app'
require 'git_goggles/repository'

module GitGoggles
  class << self
    attr_accessor :root_dir
  end

  def self.repositories
    Dir.glob(root_dir + "/*/").map do |full_path|
      File.basename(full_path)
    end
  end
end
