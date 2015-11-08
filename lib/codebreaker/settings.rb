module Codebreaker
  class Settings
    def self.get level
      case level
      when 'Easy'
        { attempts: 20, hints: 2 }
      when 'Medium'
        { attempts: 15, hints: 1 } 
      when 'Hard'
        { attempts: 10, hints: 1 }
      when 'Impossible'
        { attempts:  1, hints: 0 }
      else
        raise ArgumentError, "wrong level #{level}"
      end
    end
  end
end
