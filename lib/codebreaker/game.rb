require_relative 'secret'
require_relative 'settings'
module Codebreaker
  class Game
    attr_reader :difficulty, :attempts_left, :hints_left

    def initialize
      @rng = Secret.new
    end
 
    def start difficulty = nil
      @difficulty = difficulty || @difficulty || "Medium"
      @secret = @rng.get
      @attempts_left = Settings::get(@difficulty)[:attempts]
      @hints_left = Settings::get(@difficulty)[:hints]
      'Ok'
    end

    def guess input
      @attempts_left -= 1 unless @attempts_left == 0
      check_input input
      secret_copy = @secret
      response = ""
      4.times do |i|
        if input[i] == secret_copy[i]
          response += '+'
          input[i] = '+'
          secret_copy[i] = ' '
        end
      end
      secret_copy.each_char { |number| input.sub!(number, '-') }
      response += '-' * input.count('-')
    end

    private

    def check_input s
      raise ArgumentError, "wrong input \"#{s}\"" unless s.match(/^[1-6]+$/)
      raise ArgumentError, "wrong input size \"#{s}\"" if s.size != 4
    end
  end
end
