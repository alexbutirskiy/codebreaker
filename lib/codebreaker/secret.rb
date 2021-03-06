module Codebreaker
  class Secret
    def initialize size = 4
      @prng = Random.new
      @size = size
    end

    def get
      @size.times.inject('') { |s| s += (@prng.rand(1..6)).to_s }
    end
  end
end