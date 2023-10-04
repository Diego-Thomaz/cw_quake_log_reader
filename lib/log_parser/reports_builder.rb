# frozen_string_literal: true

require_relative 'reports/death_reasons_per_match'
require_relative 'reports/grouped_information_per_match'
require_relative 'reports/player_rank'

module LogParser
  class ReportsBuilder
    def call
      grouped_information_per_match
      player_rank
      death_reasons_per_match
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
  end
end
