require_relative 'game'
require 'byebug'

module Console
  GREETING = 1
  RESTORE = 2
  ASK_DIFFICULTY = 3
  GAME = 4

  @state = GREETING

  include Codebreaker
    def console_game inp=nil
      return false if inp.upcase == 'QUIT'
byebug
      case @state
      when GREETING
        @state = RESTORE
        return <<-EOL
Welcome to Codebreaker!

Would you like to start new game or restore saved
1. Start new game
2. Restore
EOL
      when RESTORE
        case inp
        when '1'
          @state = ASK_DIFFICULTY
          return <<-EOL  
Please, select difficulty level
1. Easy
2. Medium
3. High
4. Impossible
EOL
        else
          return "Wrong input '#{inp}', try again"
        end
      when ASK_DIFFICULTY
        @state = GAME
        case inp
        when '1' then @game.start(Settings::Difficulty::EASY)
        when '2' then @game.start(Settings::Difficulty::MEDIUM)
        when '3' then @game.start(Settings::Difficulty::HIGH)
        when '4' then @game.start(Settings::Difficulty::IMPOSSIBLE)
        else
          @state = ASK_DIFFICULTY
          return "Wrong input '#{inp}', try again"
        end
        'Enter number:'
      when GAME
        @game.guess
      else
        ""
    end
  end
end

