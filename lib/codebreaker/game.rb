require_relative 'secret'
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

  end
end
