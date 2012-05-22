module GitGoggles
  class Repository
    def initialize(name)
      @name = name
    end

    def commits
      output = []

      _repo.commits.each do |commit|
        output << {
          :author => "#{commit.author.name} <#{commit.author.email}>",
          :message => commit.message,
          :sha => commit.id
        }
      end

      output
    end

    def commit(sha)
      if commit = _repo.commit(sha)
        {
          :author => "#{commit.author.name} <#{commit.author.email}>",
          :message => commit.message,
          :date => commit.date.to_s,
          :diffs => commit.diffs.map(&:diff)
        }
      end
    end

    def exists?
      File.exists?(_path)
    end

    def tags
      _repo.tags.map(&:name)
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
