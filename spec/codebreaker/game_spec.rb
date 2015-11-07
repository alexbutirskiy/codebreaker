require 'spec_helper'
 
module Codebreaker
  describe Game do
    describe "#start" do
      it "saves secret code" do
        game = Game.new
        game.start
        expect(game.send :secret).not_to be_empty
      end
      it "saves 4 numbers secret code" do
        
      end
      it "saves secret code with numbers from 1 to 6"
    end
  end
end
