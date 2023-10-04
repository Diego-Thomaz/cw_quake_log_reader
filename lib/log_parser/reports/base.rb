# frozen_string_literal: true

module LogParser
  module Reports
    class Base
      def initialize(matches:)
        @matches = matches
      end

      def print_header(report_title:)
        puts '*' * 100
        puts "*#{" " * 98}*"
        puts report_title.center(100)
        puts "*#{" " * 98}*"
        puts '*' * 100
      end
    end
  end
end
