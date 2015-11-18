require 'spec_helper'

describe 'Console' do
  GUESS_STRING = '1234'
  GUESS_ANSWER = '-+--'
  HINT_ANSWER = '_2__'
  SAVE_GAME_ANSWER = 'Game saved'
  GAME_STATS_REGEXP = /Codebreaker.*Attempts left:.*Hints left:/m

  let(:console) { Console_game.new }

  before(:each) do
    @game = double('Game instance', guess: GUESS_ANSWER, win?: false,
                    lose?: false, attempts_left: 15, hints_left: 1, start: nil,
                    hint: HINT_ANSWER, input_valid?: true, is_finished?: false,
                    save: nil, restore: nil)
    allow(Codebreaker::Game).to receive(:new).and_return(@game)
  end

  shared_examples "codebreaker_answer_test" do |text, input|
    it "returns a string with game state when #{text} provided" do
      expect(console.play(input)).to match(GAME_STATS_REGEXP)
    end
  end

  describe ".new" do
    it "calls 'Codebreaker::Game.new' when new method is called" do
      expect(Codebreaker::Game).to receive(:new)
      Console_game.new
    end
  end

  describe '#play' do
    it 'takes a string as argument' do
      expect { console.play('') }.to_not raise_error
    end

    it "returns nil when '#{Commands::QUIT}' command is given" do
      expect(console.play(Commands::QUIT)).to be_nil
    end

    it "returns 'Help topic' when '#{Commands::HELP}' command is given" do
      expect(console.play(Commands::HELP)).to match('Help topic')
    end

    include_examples "codebreaker_answer_test", "'#{Commands::START}'' command", ''

    it "returns a string with hint when '#{Commands::HINT}' command is given" do
      expect(console.play(Commands::HINT)).to match(HINT_ANSWER)
    end

    context "when '#{Commands::SAVE}' command is given" do
      it "calls 'save' method of the 'game' instance" do
        expect(@game).to receive(:save)
        console.play(Commands::SAVE)
      end

      it "returns #{SAVE_GAME_ANSWER}" do
        expect(console.play(Commands::SAVE)).to match(SAVE_GAME_ANSWER);
      end
    end

    context "when '#{Commands::RESTORE}' command is given" do
      it "calls 'restore' method of the 'game' instance" do
        expect(@game).to receive(:restore)
        console.play(Commands::RESTORE)
      end

      it "returns game state" do
        expect(console.play(Commands::RESTORE)).to match(GAME_STATS_REGEXP);
      end
    end

    context 'when game is started' do
      include_examples "codebreaker_answer_test", 'empty string', ''
      include_examples "codebreaker_answer_test", 'correct number',GUESS_STRING

      it "returns a codebreaker answer when correct number provided" do
        expect(console.play(GUESS_STRING)).to match(GUESS_ANSWER.gsub('+','\\\+'))
      end
    end

    context "when game is finished" do
      it "returns 'Start new game first' when no command entered" do
        allow(@game).to receive(:is_finished?).and_return(true)
        expect(console.play('1111')).to match('Start new game first')
        expect(console.play('wrong command')).to match('Start new game first')
      end

      context "when player has won" do
        it "returns 'You have won!!!'" do
          allow(@game).to receive(:win?).and_return(true)
          expect(console.play('1111')).to match('You have won!!!')
        end
      end

      context "when player has lost" do
        it "returns 'You have lost!!!'" do
          allow(@game).to receive(:lose?).and_return(true)
          expect(console.play('1111')).to match('You have lost!!!')
        end
      end
    end
  end
end