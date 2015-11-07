require 'spec_helper'

module Codebreaker
  describe Settings do
    describe "::get" do
      levels =  %w{ Easy Medium Hard Impossible } 
      attempts =  [  20,   15,   10,      1     ]

      levels.each_with_index do |level, i|
        it "takes \"#{ level }\" string as difficulty level" do
          expect { Settings.get level }.to_not raise_error
        end

        it "returns #{ attempts[i] } when \"#{ level }\" level given" do
          expect(Settings.get level).to eq(attempts[i])
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