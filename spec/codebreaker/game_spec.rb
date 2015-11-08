require 'spec_helper'
 
module Codebreaker
  describe Game do
    describe "#start" do
      let(:game) { Game.new }
      before { game.start }

      it "saves secret code" do
        expect(game.send :secret).not_to be_empty
      end
      it "saves 4 numbers secret code"
      it "generates enough random secret code"
      it "saves secret code with numbers from 1 to 6"
    end

    describe "#guess" do
      context "takes" do
        it "four-number string as parametr"
        it "string with numbers from 1 to 6"
      end
      context "raises" do
        it "ArgumentError when input string has wrong symbol"
        it "ArgumentError when input string size is not == 4"
      end
      context "returns" do
        it "an empty string when not any number guessed"
        it "'+' string when one number and  position was guessed"
        it "'++' string when two number and  position was guessed"
        it "'-' string when one number was guessed but not possition"
        it ".'--' string when two number was guessed but not possition"
      end
    end

    describe "#hint" do
      context "when there is some hints available" do
        it "returns string with one secret digit showed"
        it "returns secret digit on random position"
        it "decreases internal hint counter by one"
      end

      context "when there is no hints available" do
        it "returns 'No hints available' "
      end
    end
  end
end
