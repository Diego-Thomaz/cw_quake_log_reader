# frozen_string_literal: true

module LogParser
  module Reports
    class PlayerRank
      def initialize(matches:)
        @matches = matches
      end

      def call
        pretty_print_player_rank
      end

      private

      attr_reader :matches

      def pretty_print_player_rank
        p '*' * 100
        p 'PLAYER RANK - ALL MATCHES'
        p '*' * 100

        pp generate_player_rank.sort_by { |_key, value| -value }.to_h
      end

      def generate_player_rank
        matches.each_with_object({}) do |match, rank|
          match.values.first['kills'].each do |key, value|
            rank[key] ||= 0
            rank[key] += value
          end
        end
      end
    end
  end
end
