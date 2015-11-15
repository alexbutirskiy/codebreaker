require 'spec_helper'

describe 'Console' do
  before(:each) do
    @game = Console_game.new
  end



  describe '#play' do
    it 'takes a string as argument' do
      expect { @game.play('') }.to_not raise_error
    end

    it "returns nil when 'quit' command given" do
      expect(@game.play('quit')).to be_nil
    end

    it "returns 'Help topic' when 'help' command given" do
      #expect()
    end

    context 'when game is not started' do
      it "returns "
    end
  end
end