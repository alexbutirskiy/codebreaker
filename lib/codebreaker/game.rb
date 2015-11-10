require_relative 'secret'
require_relative 'settings'
require_relative 'saver'
module Codebreaker
  class Game
    attr_reader :difficulty, :attempts_left, :hints_left

    def initialize
      @rng = Secret.new
    end

    def start(difficulty = nil)
      @difficulty = difficulty || @difficulty || 'Medium'
      @secret = @rng.get
      @attempts_left = Settings.get(@difficulty)[:attempts]
      @hints_left = Settings.get(@difficulty)[:hints]
      @win = @lose = false
      'Ok'
    end

    def guess(arg)
      return 'Game Over' if win? | lose?
      @attempts_left -= 1 unless @attempts_left == 0
      check_input arg
      input = arg.dup
      secret_copy = @secret.dup
      response = ''
      4.times do |i|
        next if input[i] != secret_copy[i]
        response += '+'
        input[i] = '+'
        secret_copy[i] = ' '
      end
      secret_copy.each_char { |number| input.sub!(number, '-') }
      response += '-' * input.count('-')
      @win = true if response.count('+') == @secret.size
      @lose = true if !win? && @attempts_left == 0
      response
    end

    def hint
      return '___' if @hints_left == 0
      @hints_left -= 1
      result = '_' * 4
      index = rand(4)
      result[index] = @secret[index]
      result
    end

    def win?
      @win || false
    end

    def lose?
      @lose || false
    end

    private

    def check_input(s)
      raise ArgumentError, "wrong input \"#{s}\"" unless s.match(/^[1-6]+$/)
      raise ArgumentError, "wrong input size \"#{s}\"" if s.size != 4
    end
  end
end
