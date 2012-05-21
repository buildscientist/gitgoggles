module GitGoggles
  class CLI < Rack::Server
    class Options
      def parse!(args)
        args, options = args.dup, {}

        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: git-goggles [options]"
          opts.on("-R", "--root-dir=path", String,
                  "GitGoggles root directory") { |v| options[:root_dir] = v }

          opts.separator ""

          opts.on("-p", "--port=port", Integer,
                  "Runs GitGoggles on the specified port.", "Default: 9292") { |v| options[:Port] = v }
          opts.on("-b", "--binding=ip", String,
                  "Binds GitGoggles to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
          opts.on("-d", "--daemon", "Make server run as a Daemon.") { options[:daemonize] = true }
          opts.on("-P","--pid=pid",String,
                  "Specifies the PID file.",
                  "Default: rack.pid") { |v| options[:pid] = v }

          opts.separator ""

          opts.on("-h", "--help", "Show this help message.") { puts opts; exit }
        end

        opt_parser.parse! args

        options[:config] = File.expand_path("../../config.ru", File.dirname(__FILE__))
        options
      end
    end

    def initialize(options = nil)
      super
    end

    def opt_parser
      Options.new
    end

    def start
      throw 'Must specifify a root_dir' unless options[:root_dir]
      GitGoggles.root_dir = options[:root_dir]
      puts ">> Using root directory #{GitGoggles.root_dir}"

      super
    end
  end
end
