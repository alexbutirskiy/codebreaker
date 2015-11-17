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
    Commands.constants.map{ |a| Commands.const_get a }.include?(cmd)
  end

end

# module States
#   GREETING = 1
#   RESTORE = 2
#   ASK_DIFFICULTY = 3
#   GAME = 4
# end

class Console_game
  include Codebreaker
  # include States

  EMPTY_STRING = ''

  def initialize
    @game = Game.new
  end

  def play inp
    inp.downcase!
    return command(inp) if Commands.include?(inp)
    return 'Start new game first' if @game.is_finished?
    unless @game.input_valid?(inp) || inp == EMPTY_STRING
      return "Wrong input '#{inp}' provided\n Press Enter to continue"
    end

    answer = codebreaker_display inp

    answer += if @game.win?
      "\nCongratulation!!! You have won!!!"
    elsif @game.lose?
      "\nYou have lost!!! Try again."
    else
      ''
    end
  end

  private

  def command cmd
    return case cmd
    when Commands::START
      start
    when Commands::HELP
      help
    when Commands::QUIT
      quit
    when Commands::HINT
      hint
    when Commands::SAVE
      save
    when Commands::RESTORE
      restore
    else
      raise ArgumentError, "Unknown command cmd"
    end
  end

  def start
    @game.start
    codebreaker_display
  end

  def codebreaker_display inp = ''
    codebreaker_answer = if inp != EMPTY_STRING
      "Your number: '#{inp}'\t Codebreakers answer: '#{@game.guess inp}'"
    else
      "\n"
    end

    game_state = <<-EOL
                Codebreaker
Attempts left: #{@game.attempts_left}
Hints left: #{@game.hints_left}
EOL

  game_state + codebreaker_answer
  end

  def hint
    hint_answer = @game.hint
    codebreaker_display + "Hint: #{hint_answer}"
  end

  def save
    @game.save
  end

  def restore
    @game.restore
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

  def quit
    nil
  end

end

