# frozen_string_literal: true

module LogParser
  class Game
    attr_reader :players

    def initialize(id:)
      @id = id
      @total_kills = 0
      @players = {}
      @kills = {}
    end

    def to_h
      {
        "match_#{id}" => {
          'total_kills' => total_kills,
          'players' => players.keys,
          'kills' => build_kills
        }
      }
    end

    def add_kill
      @total_kills += 1
    end

    private

    attr_reader :id, :total_kills, :kills

    def build_kills
      sorted_game_players.each_with_object({}) do |player, obj|
        obj[player.name] = player.kills
      end
    end

    def sorted_game_players
      players.values.sort_by(&:kills)
    end
  end
end
