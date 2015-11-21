require_relative 'secret'
require_relative 'settings'
require_relative 'saver'
module Codebreaker
  GAME_OVER = 'Game Over'
  class Game
    include Saver
    attr_reader :difficulty, :attempts_left, :hints_left

    def initialize
      @rng = Secret.new
      start
    end

    def start(difficulty = nil)
      @difficulty = difficulty || @difficulty || Settings::Difficulty::MEDIUM
      @secret = @rng.get
      @attempts_left = Settings.get(@difficulty)[:attempts]
      @hints_left = Settings.get(@difficulty)[:hints]
      @win = @lose = false
      self
    end

    def guess(arg)
      raise ArgumentError, "wrong input \"#{arg}\"" unless input_valid?(arg)
      return GAME_OVER if win? || lose?
      @attempts_left -= 1 unless @attempts_left == 0
      input = arg.dup
      secret_copy = @secret.dup

      response = check_exact_match(input, secret_copy)
      response += check_close_match(input, secret_copy)

      @win = true if response.count('+') == @secret.size
      @lose = true if !win? && @attempts_left == 0
      response
    end

    def hint
      return '___' if @hints_left == 0
      @hints_left -= 1
      result = '_' * Settings::DIGITS_TOTAL
      index = rand(Settings::DIGITS_TOTAL)
      result[index] = @secret[index]
      result
    end

    def win?
      @win || false
    end

    def lose?
      @lose || false
    end

    def is_finished?
      win? || lose?
    end

    def input_valid? inp
      !!inp.match(/^[1-6]+$/) && inp.size == Settings::DIGITS_TOTAL
    end

    def save(arg = nil, **options)
      options[:except] = Array(options[:except]) + [:rng]
      super(arg, options)
    end

    private

    def check_exact_match(input, secret_copy)
      response = ''
      Settings::DIGITS_TOTAL.times do |i|
        next if input[i] != secret_copy[i]
        response += '+'
        input[i] = '+'
        secret_copy[i] = ' '
      end
      response
    end

    def check_close_match(input, secret_copy)
      secret_copy.each_char { |number| input.sub!(number, '-') }
      '-' * input.count('-')
    end
  end
end
