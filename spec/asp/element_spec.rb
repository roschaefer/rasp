require 'spec_helper'

describe Asp::Element do
  context "input" do
    before(:each) do
      class InputElement
        include Asp::Element
      end
    end

    after(:each) do
      Asp::Memory.instance.forget!
    end

    subject { Asp::Problem.new }

    describe "::asp_attributes" do
      before(:each) do
        class InputElement
          def self.asp_attributes
            [:attribute_1, :attribute_2, :attribute_3]
          end
        end
      end

    describe "::asp_schema" do
      before(:each) do
        class InputElement
          include Asp::Element
          asp_schema :a, :b, :c, :d, :e
        end
      end
      it "defines ::asp_attributes on the class" do
        expect(InputElement.asp_attributes).to eq [:a, :b, :c, :d, :e]
      end
    end

      context "uses placeholder as default for attributes" do
        before(:each) { subject.never { InputElement.asp } }
        its(:asp_representation) { is_expected.to eq ":- inputelement(_,_,_)." }
      end

      context "placeholder can be overriden" do
        before(:each) { subject.never { InputElement.asp(:attribute_1 => "foo", :attribute_2 => "bar") } }
        its(:asp_representation) { is_expected.to eq ":- inputelement(foo,bar,_)." }
      end

      context "unknown attributes are ignored" do
        before(:each) { subject.never { InputElement.asp(:something => "foo", :else => "bar") } }
        its(:asp_representation) { is_expected.to eq ":- inputelement(_,_,_)." }
      end
    end

  end

  context "output" do
    before(:each) do
      class OutputElement
        include Asp::Element
        attr_reader :a, :b, :c
        asp_schema :a, :b, :c
        def self.from(string)
          if (string.include?("a"))
            super(string)
          else
            nil
          end
        end

        def initialize(opts={})
          @a = opts[:a]
          @b = opts[:b]
          @c = opts[:c]
        end
      end
    end

    after(:each) do
      Asp::Memory.instance.forget!
    end

    context "included methods can be overriden" do
      it { expect(OutputElement.from("a")).not_to be_nil }
      it { expect(OutputElement.from("b")).to be_nil }
    end

    context "parsing element strings" do
      it "extracts attributes" do
        element = OutputElement.from("outputelement(1,aaa,3.5)")
        expect(element.a).to eq "1"
        expect(element.b).to eq "aaa"
        expect(element.c).to eq "3.5"
      end
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
