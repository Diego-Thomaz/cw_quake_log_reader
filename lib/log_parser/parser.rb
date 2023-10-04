# frozen_string_literal: true

require_relative 'log_regex'

module LogParser
  class Parser
    include LogParser::LogRegex

    DEFAULT_LOG_FILE_PATH = 'logs/quake.log'
    WORLD_KILL = '<world>'

    def initialize(file_path: DEFAULT_LOG_FILE_PATH)
      @file_path = file_path
      @grouped_matches = []
      @game = nil
    end

    def call
      read_log
    end

    private

    attr_reader :file_path, :grouped_matches, :game

    def read_log
      File.new(file_path).each_line do |line|
        parse_line(line)
      end

      store_game_stats
      grouped_matches
    end

    def parse_line(line)
      if new_game?(line)
        store_game_stats
        start_new_game
      elsif player?(line)
        find_or_initialize_player(line)
      elsif new_kill?(line)
        calculate_kill(line)
      end
    end

    def start_new_game
      @game = Game.new(id: @grouped_matches.size + 1)
    end

    def store_game_stats
      return if game.nil? || game.players.empty?

      grouped_matches << game.to_h
    end

    def find_or_initialize_player(line)
      nick_name = player_name(line)
      return unless game.players[nick_name].nil?

      game.players[nick_name] = Player.new(name: nick_name)
    end

    def calculate_kill(line)
      game.add_kill
      game.update_death_reason_counter(reason: death_reason(line))

      assassin = killer(line)

      if assassin == WORLD_KILL
        victim = victim(line)
        game.players[victim].remove_kill
      else
        game.players[assassin].add_kill
      end
    end
  end
end
