require 'spec_helper'
 
module Codebreaker
  shared_context "predefined games" do
    before(:each) do
      secret = double('Secret instance', get: "1234")
      allow(Secret).to receive(:new).and_return(secret)
      (@game = Game.new).start
    end
  end

  describe Game do
    SECRET = "1234"
    let(:game) { Game.new }

    describe "::new" do
      it "creates new Random Number Generator" do
        expect(Secret).to receive(:new)
        Game.new
      end
    end

    describe "#start" do

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
        secret = double('Secret instance', get: "#{SECRET}")
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
      include_context "predefined games"

      it "decreases attempts_left counter by 1" do
        expect{ @game.guess("1234") }.to change{ @game.attempts_left }.by(-1)
      end

      context "takes" do
        it "four-number string as parametr with numbers from 1 to 6" do
          expect { @game.guess("1234") }.to_not raise_error
          expect { @game.guess("3456") }.to_not raise_error
        end
      end

      context "raises" do
        it "ArgumentError when input string size is not equal 4" do
          expect { @game.guess("123") }.to raise_exception ArgumentError
          expect { @game.guess("12345") }.to raise_exception ArgumentError
        end

        it "ArgumentError when input string has wrong symbol" do
          %w{ A234 1A34 12A4 123A _234 a234 %234 0234 7234 }.each do |sample|
            expect { @game.guess(sample) }.to raise_exception ArgumentError
          end
        end
      end
      
      context "returns" do
        { "5555" => "",   "1555" => "+",  "1255" => "++",   "5155" => "-",
          "5125" => "--", "1125" => "+-", "1243" => "++--", "1234" => "++++",
          "2524" => "+-"
        }.each do |inp, outp|
          it "\"#{outp}\" when \"#{inp}\" is given and secret == \"#{SECRET}\"" do
            expect(@game.guess(inp)).to eq outp
          end
        end
      end

      context 'when game is over' do
        it 'returns "Game Over" if player won' do
          @game.guess('1234')
          expect(@game.guess('1111')).to eq 'Game Over'
        end

        it 'returns "Game Over" if player lost' do
          @game.attempts_left.times { @game.guess('1111') }
          expect(@game.guess('1111')).to eq 'Game Over'
        end
      end
    end

    describe "#hint" do
      include_context "predefined games"

      context "when there is some hints available" do
        it "returns string with one digit showed (ex. '_2__')" do
          hint_str = @game.hint
          expect(hint_str.size).to eq 4
          expect(hint_str.count('_')).to eq 3
          expect(hint_str).to match(/[1-6]/)
        end

        it "returns proper digit from secret code" do
          hint_str = @game.hint
          index = hint_str.index(hint_str.match(/[1-6]/).to_s)
          expect(hint_str[index]).to eq SECRET[index]
        end

        it "returns secret digit on random position" do
          hints = []
          10.times do
            @game.start
            hints << @game.hint
          end
          expect(hints.uniq.size).to_not eq 1
        end

        it "decreases internal hint counter by one" do
          expect{ @game.hint }.to change{ @game.hints_left }.by(-1)
        end
      end

      context "when there is no hints available", if: !@hint_failed do
        it "returns '____' " do
          4.times { @game.hint }
          expect(@game.hint).to eq '___'
        end
      end
    end

    describe '#win?' do
      include_context "predefined games"

      it "returns true if secret has been guessed " do
        @game.guess('1234')
        expect(@game).to be_win
      end

      it "returns false at other cases " do
        expect(@game).to_not be_win
        @game.attempts_left.times { @game.guess('1111') }
        expect(@game).to_not be_win
      end
    end

    describe '#lose?' do
      include_context "predefined games"

      it "returns true if secret has not guessed and no attempts available" do
        @game.attempts_left.times { @game.guess('1111') }
        expect(@game).to be_lose
      end
      
      it "returns false at other cases " do
        @game.guess '1234'
        @game.attempts_left.times { @game.guess('1111') }
        expect(@game).to_not be_lose
      end
    end
  end
end
