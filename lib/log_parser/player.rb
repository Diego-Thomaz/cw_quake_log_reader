# frozen_string_literal: true

module LogParser
  class Player
    attr_reader :name, :kills

    def initialize(name:, kills: 0)
      @name = name
      @kills = kills
    end

    def add_kill(amount = 1)
      @kills += amount
    end

    def remove_kill(amount = 1)
      @kills -= amount
    end
  end
end
