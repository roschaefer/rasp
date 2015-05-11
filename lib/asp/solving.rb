require 'open3'
module Asp
  module Solving
    class InvalidSyntaxException
    end

    GROUNDER    = "gringo"
    SOLVER      = "clasp"

    def solve(encoding)
      models = []
      # TODO: try not to use Tempfile
      t = Tempfile.new("asp_solving_temp")
      begin
        t.write(problem)
        t.rewind
        cmd = "#{GROUNDER} #{t.path}"
        grounded_program, stderr_str, status = Open3.capture3(cmd)
        status.success? or return
        options = []
        options.push(* SOLVER_OPTS)
      ensure
        t.close
        t.unlink
      end
    end
  end
end
