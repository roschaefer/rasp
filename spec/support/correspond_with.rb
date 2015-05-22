require 'rspec/expectations'

RSpec::Matchers.define :correspond_with do |expected|
  match do |actual|
    e = map_array(expected)
    a = map_array(actual)
    match_array(a).matches?(e)
  end

  private
  def map_array(array)
    array.map do |solution|
      solution.map do |element|
        if element.respond_to?(:asp_representation)
          element.asp_representation
        elsif element.respond_to?(:init_string)
          element.init_string
        else
          element.to_s
        end
      end
    end
  end

end
