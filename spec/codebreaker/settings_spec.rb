require 'spec_helper'

module Codebreaker
  describe Settings do
    describe "::get" do
      Levels =  %w{ Easy Medium Hard Impossible } 
      Attempts =  [  20,   15,   10,      1     ]
      Hints =     [   2,    1,    1,      0     ]

      Levels.each_with_index do |level, i|
        it "takes \"#{ level }\" string as difficulty level" do
          expect { Settings.get level }.to_not raise_error
        end

        it "returns #{ Attempts[i] } attempts when \"#{ level }\" level given" do
          expect(Settings.get(level)[:attempts]).to eq(Attempts[i])
        end

        it "returns #{ Hints[i] } hints when \"#{ level }\" level given" do
          expect(Settings.get(level)[:hints]).to eq(Hints[i])
        end

     end
 
      it "raises an ArgumentError when no argument given" do
        expect { Settings.get }.to raise_exception ArgumentError
      end

      it "raises an ArgumentError when unknown argument given" do
        expect { Settings.get 'Super Easy'}.to raise_exception ArgumentError
      end
    end
  end
end
