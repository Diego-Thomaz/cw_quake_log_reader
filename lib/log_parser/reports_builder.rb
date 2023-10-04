# frozen_string_literal: true

require_relative 'reports/death_reasons_per_match'
require_relative 'reports/grouped_information_per_match'
require_relative 'reports/player_rank'

module LogParser
  class ReportsBuilder
    VALID_OPTIONS = %w[gi pr dr].freeze

    def initialize(option: nil)
      @option = option
    end

    def call
      validate_option!

      return grouped_information_per_match if grouped_information_per_match_only?
      return player_rank if player_rank_only?
      return death_reasons_per_match if death_reasons_only?

      print_all_reports
    end

    private

    attr_reader :option

    def validate_option!
      return if VALID_OPTIONS.include?(option) || option.nil?

      abort "Invalid option. The valid options are: #{VALID_OPTIONS.join(", ")}"
    end

    def grouped_information_per_match
      Reports::GroupedInformationPerMatch.new(matches:).call
    end

    def player_rank
      Reports::PlayerRank.new(matches:).call
    end

    def death_reasons_per_match
      Reports::DeathReasonsPerMatch.new(matches:).call
    end

    def matches
      @matches ||= LogParser::Parser.new.call
    end

    def grouped_information_per_match_only?
      symbolized_option == :gi
    end

    def player_rank_only?
      symbolized_option == :pr
    end

    def death_reasons_only?
      symbolized_option == :dr
    end

    def print_all_reports
      grouped_information_per_match
      player_rank
      death_reasons_per_match
    end

    def symbolized_option
      return nil if option.nil? || option.empty?

      option.scan(/[[:alpha:]]/).join.to_sym
    end
  end
end
