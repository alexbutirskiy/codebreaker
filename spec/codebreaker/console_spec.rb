require 'spec_helper'

shared_examples "codebreaker_answer_test" do |text, input|
  it "returns a string with game state when #{text} provided" do
    expect(console.play(input)).to match('Codebreaker')
    expect(console.play(input)).to match('Attempts left:')
    expect(console.play(input)).to match('Hints left:')
  end
end

describe 'Console' do
  GUESS_STRING = '1234'
  GUESS_ANSWER = '-+--'
  HINT_ANSWER = '_2__'

  before(:each) do
    @game = double('Game instance', guess: GUESS_ANSWER, win?: false,
                    lose?: false, attempts_left: 15, hints_left: 1, 
                    hint: HINT_ANSWER, input_valid?: true, is_finished?: false)
    allow(@game).to receive(:start)
    allow(Codebreaker::Game).to receive(:new).and_return(@game)
  end

  describe ".new" do
    it "calls 'Codebreaker::Game.new' when new method is called" do
      expect(Codebreaker::Game).to receive(:new)
      Console_game.new
    end
  end

  describe '#play' do
    let(:console) { Console_game.new }
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
      it "returns 'You have won!!!' when correct number provided" do
        allow(@game).to receive(:win?).and_return(true)
        expect(console.play('1111')).to match('You have won!!!')
      end
    end

      context "when player has lost" do
      it "returns 'You have lost!!!' when correct number provided" do
        allow(@game).to receive(:lose?).and_return(true)
        expect(console.play('1111')).to match('You have lost!!!')
      end
      end
    end
  end
end