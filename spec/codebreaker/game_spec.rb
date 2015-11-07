require 'spec_helper'
 
module Codebreaker
  describe Game do
    describe "#start" do
      let(:game) { Game.new }
      before { game.start }

      it "saves secret code" do
        expect(game.send :secret).not_to be_empty
      end
      it "saves 4 numbers secret code" do
        
      end
      it "saves secret code with numbers from 1 to 6"
    end
  end
end
