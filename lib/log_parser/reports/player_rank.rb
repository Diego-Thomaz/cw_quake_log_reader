# frozen_string_literal: true

require_relative 'base'

module LogParser
  module Reports
    class PlayerRank < Base
      def call
        pretty_print_player_rank
      end

      private

      attr_reader :matches

      def pretty_print_player_rank
        print_header(report_title:)
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

      def report_title
        'PLAYER RANK - ALL MATCHES'
      end
    end
  end
end
