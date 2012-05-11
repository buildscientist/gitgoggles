module GitGoggles
  class Repository
    def initialize(name)
      @name = name
    end

    def exists?
      File.exists?(_path)
    end

    def to_json
      {
        :name => @name,
        :branches  => _repo.branches.map(&:name)
      }.to_json
    end

    def _path
      File.join(GitGoggles.root_dir, @name)
    end

    def _repo
      if exists?
        @repo ||= Grit::Repo.new(_path, :is_bare => true)
      else
        nil
      end
    end
  end
end
