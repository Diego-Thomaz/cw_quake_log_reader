# frozen_string_literal: true

module LogParser
  module Reports
    class Base
      def initialize(matches:)
        @matches = matches
      end

      def print_header(report_title:)
        puts '*' * 100
        puts
        puts report_title
        puts
      end
    end
  end
end
