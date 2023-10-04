# frozen_string_literal: true

module LogParser
  class Player
    attr_reader :name, :kills

    def initialize(name:)
      @name = name
      @kills = 0
    end

    def add_kill(amount = 1)
      @kills += amount
    end

    def remove_kill(amount = 1)
      @kills -= amount
    end
  end
end
