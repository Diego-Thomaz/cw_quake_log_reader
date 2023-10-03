# frozen_string_literal: true

module LogParser
  class Player
    attr_reader :name, :kills

    def initialize(name:)
      @name = name
      @kills = 0
    end

    def add_kill(amount)
      @kills += amount
    end
  end
end
