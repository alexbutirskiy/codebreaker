require 'spec_helper'
 
module Codebreaker
  describe Game do
    let(:game) { Game.new }

    describe "::new", receive: true do
      it "creates new Random Number Generator" do
        expect(Secret).to receive(:new)
        Game.new
      end
    end

    describe "#start", receive: true do

      it "takes a string as difficulty level" do
        game.start("Easy")
        expect(game.difficulty).to eq "Easy"
        game.start("Hard")
        expect(game.difficulty).to eq "Hard"
      end
      context "when no parametres provided" do
        it "sets difficulty level to 'Medium' at first start" do
          game.start
          expect(game.difficulty).to eq "Medium"
        end

        it "keeps difficulty level from previous game st further starts" do
          game.start "Hard"
          game.start
          expect(game.difficulty).to eq "Hard"
        end
      end

      it "gets new secret code from Random Number Generator" do
        secret = double('Secret instance', get: "1234")
        allow(Secret).to receive(:new).and_return(secret)
        expect(secret).to receive(:get)
        game.start
      end

    end

    describe "#attempts_left" do
      it "returns number of attempts to lose the game" do
        game.start
        expect(game.attempts_left).to be_a Fixnum
      end
    end

    describe "#hints_left" do
      it "returns number of hints to be asked by player" do
        game.start
        expect(game.hints_left).to be_a Fixnum
      end
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
        it "'--' string when two number was guessed but not possition"
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
