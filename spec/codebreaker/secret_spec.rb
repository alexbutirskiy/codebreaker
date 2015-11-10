require 'spec_helper'

def collect_data size, &block
  size.times.inject([]) {|data| data << block.call }
end

module Codebreaker
  describe Secret do
    let(:secret) { Secret.new }
    describe "#get" do
      it "returns a String" do
        expect(secret.get).to be_a String
      end
      it "returns a code with size of 4" do
        expect(secret.get.length).to eq 4
      end
      it "returns a code with digits 1 - 6 only" do
        10.times { expect(secret.get).to match(/^[1-6]+$/) }
      end

      context "has good statistics", statistic_test: true do
        require 'descriptive_statistics'
          secret = Secret.new
          4.times do |digit|
            it "for digit #{digit}" do
              data = collect_data(100_000) { secret.get[digit] }
              expect(data.mean).to be_within(0.1).of(3.5)
            end
          end

      end
    end
  end
end