module Codebreaker
  class Settings
    def self.get level
      case level
      when 'Easy'
        20
      when 'Medium'
        15
      when 'Hard'
        10
      when 'Impossible'
        1
      else
        raise ArgumentError, "wrong level #{level}"
      end
    end
  end
end