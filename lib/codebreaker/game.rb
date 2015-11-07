module Codebreaker
  class Game

    def initialize
      @secret_code = ""
    end
 
    def start
      self.secret = 'Hello'
      'Ok'
    end

    private

    attr_accessor :secret

  end
end
