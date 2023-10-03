# frozen_string_literal: true

module LogParser
  module Reports
    class GroupedInformationPerMatch
      def initialize(matches:)
        @matches = matches
      end

      def call
        pretty_print_grouped_matches
      end

      def pretty_print_grouped_matches
        p '*' * 100
        p 'GROUPED INFORMATION PER MATCH'
        p '*' * 100

        matches.each do |match|
          pp match
          p '-' * 100
        end
      end

      private

      attr_reader :matches
    end
  end
end
