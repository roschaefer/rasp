require 'open3'
require 'tempfile'
require 'json'

module Asp
  module Solving
    class InvalidSyntaxException < StandardError
    end

    GROUNDER    = "gringo"
    SOLVER      = "clasp"
    SOLVER_OPTS = ["0", "--outf=2","--quiet=0", "--opt-mode=optN"]

    def solve(encoding)
      # TODO: try not to use Tempfile
      t = Tempfile.new("asp_solving_temp")
      begin
        t.write(encoding)
        t.rewind

        # GROUNDING
        cmd = "#{GROUNDER} #{t.path}"
        grounded_program, stderr, status = Open3.capture3(cmd)
        status.success? or raise Asp::Solving::InvalidSyntaxException.new

        # SOLVING
        Open3.popen3(SOLVER, *SOLVER_OPTS) do |stdin, stdout, stderr, wait_thr|
          stdin.puts grounded_program
          stdin.close
          json = JSON.parse(stdout.read)
          witnesses = json["Call"][0]["Witnesses"]
          n_optimals = json["Models"]["Optimal"]
          if witnesses
            if n_optimals
              witnesses = witnesses.last(n_optimals)
            end
            witnesses.each do |w|
              yield(w)
            end
          end
        end
      ensure
        t.close
        t.unlink
      end
    end
  end
end
