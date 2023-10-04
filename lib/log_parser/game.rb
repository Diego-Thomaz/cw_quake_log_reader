# frozen_string_literal: true

module LogParser
  class Game
    attr_reader :players

    DEATH_REASONS = %w[MOD_UNKNOWN
                       MOD_SHOTGUN
                       MOD_GAUNTLET
                       MOD_MACHINEGUN
                       MOD_GRENADE
                       MOD_GRENADE_SPLASH
                       MOD_ROCKET
                       MOD_ROCKET_SPLASH
                       MOD_PLASMA
                       MOD_PLASMA_SPLASH
                       MOD_RAILGUN
                       MOD_LIGHTNING
                       MOD_BFG
                       MOD_BFG_SPLASH
                       MOD_WATER
                       MOD_SLIME
                       MOD_LAVA
                       MOD_CRUSH
                       MOD_TELEFRAG
                       MOD_FALLING
                       MOD_SUICIDE
                       MOD_TARGET_LASER
                       MOD_TRIGGER_HURT
                       MOD_NAIL
                       MOD_CHAINGUN
                       MOD_PROXIMITY_MINE
                       MOD_KAMIKAZE
                       MOD_JUICED
                       MOD_GRAPPLE].freeze

    def initialize(id:)
      @id = id
      @total_kills = 0
      @players = {}
      @kills = {}
      @death_reasons = {}
    end

    def to_h
      {
        "game_#{id}" => {
          'total_kills' => total_kills,
          'players' => players.keys,
          'kills' => build_kills,
          'death_reasons' => death_reasons
        }
      }
    end

    def add_kill
      @total_kills += 1
    end

    def update_death_reason_counter(reason:)
      return unless DEATH_REASONS.include? reason

      @death_reasons[reason] = @death_reasons[reason].to_i + 1
    end

    private

    attr_reader :id, :total_kills, :kills, :death_reasons

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
