  # Settings returns game parametres which are dependent on difficulty level
module Codebreaker
  class Settings
    DIGITS_TOTAL = 4

    class Difficulty
      EASY = 'Easy'
      MEDIUM = 'Medium'
      HARD = 'Hard'
      IMPOSSIBLE = 'Impossible'
    end

    def self.get level
      case level
      when Difficulty::EASY
        { attempts: 20, hints: 2 }
      when Difficulty::MEDIUM
        { attempts: 15, hints: 1 } 
      when Difficulty::HARD
        { attempts: 10, hints: 1 }
      when Difficulty::IMPOSSIBLE
        { attempts:  1, hints: 0 }
      else
        raise ArgumentError, "wrong level #{level}"
      end
    end
  end
end
