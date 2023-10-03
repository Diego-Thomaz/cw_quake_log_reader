# frozen_string_literal: true

require_relative 'parse_regex'

module LogParser
  class Parser
    include LogParser::ParseRegex

    DEFAULT_LOG_FILE_PATH = 'logs/quake.log'
    WORLD_KILL = '<world>'

    def initialize(file_path: DEFAULT_LOG_FILE_PATH)
      @file_path = file_path
      @grouped_matches = []
      @game = nil
    end

    def call
      read_log
      grouped_matches
    end

    private

    attr_reader :file_path, :grouped_matches, :game

    def read_log
      File.new(file_path).each_line do |line|
        parse_line(line)
      end

      store_game_stats
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
      assassin = killer(line)
      victim = victim(line)

      if assassin == WORLD_KILL
        game.players[victim].add_kill(-1)
      else
        game.players[assassin].add_kill(1)
      end
    end
  end
end
