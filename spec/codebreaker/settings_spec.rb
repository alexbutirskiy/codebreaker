require 'spec_helper'

module Codebreaker
  describe Settings do
    describe '::get' do
      LEVELS =  %w{ Easy Medium Hard Impossible }
      ATTEMPTS =  [  20,   15,   10,      1     ]
      HINTS =     [   2,    1,    1,      0     ]

      LEVELS.each_with_index do |level, i|
        context "when takes  \"#{level}\" string as difficulty level" do
          it 'do not rise error' do
            expect { Settings.get level }.to_not raise_error
          end

          it "returns #{ ATTEMPTS[i] } attempts when \"#{level}\" level given" do
            expect(Settings.get(level)[:attempts]).to eq(ATTEMPTS[i])
          end

          it "returns #{ HINTS[i] } hints when \"#{level}\" level given" do
            expect(Settings.get(level)[:hints]).to eq(HINTS[i])
          end
        end
      end
 
      it 'raises an ArgumentError when no argument given' do
        expect { Settings.get }.to raise_exception ArgumentError
      end

      it 'raises an ArgumentError when unknown argument given' do
        expect { Settings.get 'Super Easy' }.to raise_exception ArgumentError
      end
    end
  end
end
