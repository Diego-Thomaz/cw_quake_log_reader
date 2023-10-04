# frozen_string_literal: true

require_relative 'base'

module LogParser
  module Reports
    class DeathReasonsPerMatch < Base
      def call
        pretty_print_death_reasons_per_match
      end

      def pretty_print_death_reasons_per_match
        print_header(report_title:)
        matches.each { |match| pp sanitize_match(match) }
      end

      private

      attr_reader :matches

      def report_title
        'DEATH REASONS PER MATCH'
      end

      def sanitize_match(match)
        match.each do |_key, value|
          value.delete('total_kills')
          value.delete('players')
          value.delete('kills')
          value['death_reasons'] = value['death_reasons'].sort_by { |_name, kills| -kills }.to_h
        end
      end
    end
  end
end
