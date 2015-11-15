require_relative 'game'
require 'byebug'

module Commands
  START = 'start'
  HELP = 'help'
  QUIT = 'quit'
  HINT = 'hint'
  SAVE = 'save'
  RESTORE = 'restore'

  def self.include? cmd
    Commands.constants.map{|a| Commands.const_get a}.include?(cmd)
  end

end

module States
  GREETING = 1
  RESTORE = 2
  ASK_DIFFICULTY = 3
  GAME = 4
end

class Console_game
  include Codebreaker
  include States

  def initialize
    @state = GREETING
  end

  def play inp
    inp.downcase!
    return command(inp) if Commands.include?(inp)
    'Enter your command'
  end

  private

  def command cmd
    return case cmd
    when Commands::START
      start
    when Commands::HELP
      help
    when Commands::QUIT
      nil
    when Commands::HINT
      'This is a hint'
    when Commands::SAVE
      'This is a save'
    when Commands::RESTORE
      'This is a restore'
    else
      raise ArgumentError, "Unknown command cmd"
    end
  end

  def help
<<-EOL
        Help topic
Comands list:
  start   - start new game
  quit    - terminate caurrent game end exit
  hint    - display a hint
  save    - save current game to file
  restore - load game from file and continue 
EOL
  end

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

