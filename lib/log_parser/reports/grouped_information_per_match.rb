# frozen_string_literal: true

require_relative 'base'

module LogParser
  module Reports
    class GroupedInformationPerMatch < Base
      def call
        pretty_print_grouped_matches
      end

      private

      attr_reader :matches

      def pretty_print_grouped_matches
        print_header(report_title:)
        matches.each { |match| pp match }
      end

      def report_title
        'GROUPED INFORMATION PER MATCH'
      end
    end
  end
end
