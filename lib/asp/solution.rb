module Asp
  class Solution < Array
    attr_reader :costs
    attr_reader :optimal
    alias_method :optimal?, :optimal


    def initialize(costs, optimal)
      @costs = costs
      @optimal = optimal
    end
  end
end
