require 'open3'
require 'tempfile'

module Asp
  module Solving
    class InvalidSyntaxException < StandardError
    end

    GROUNDER    = "gringo"
    SOLVER      = "clasp"

    def solve(encoding)
      models = [[]]
      # TODO: try not to use Tempfile
      t = Tempfile.new("asp_solving_temp")
      begin
        t.write(encoding)
        t.rewind

        # GROUNDING
        cmd = "#{GROUNDER} #{t.path}"
        grounded_program, stderr, status = Open3.capture3(cmd)
        stderr.empty? or raise Asp::Solving::InvalidSyntaxException.new

        options = []
        # SOLVING
        Open3.popen3(SOLVER, *options) do |stdin, stdout, stderr, wait_thr|
          stdin.puts grounded_program
          stdin.close
        end


      ensure
        t.close
        t.unlink
      end
      models
    end
  end
end
