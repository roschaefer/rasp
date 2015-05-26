require 'spec_helper'

describe Asp::Element do
  context "output" do
    before(:each) do
      class AnElement
        include Asp::Element
        def self.from(string)
          if (string.include?("a"))
            new
          else
            nil
          end
        end
      end
    end

    after(:each) do
      Asp::Memory.instance.forget!
    end

    context "included methods can be overriden" do
      it { expect(AnElement.from("a")).not_to be_nil }
      it { expect(AnElement.from("b")).to be_nil }
    end

    context "parsing problem solutions" do
      subject { Asp::Problem.new("a.").solutions }
      it { is_expected.to have(1).item }

      context "first and only solution" do
        subject { super().first }
        it { is_expected.to be_a(Array) }
        its(:first) {is_expected.to be_kind_of(Asp::Element) }
      end
    end
  end
end
