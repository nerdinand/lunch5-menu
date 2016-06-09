require 'date'

require_relative 'lunch5/menu_retriever'

module DataSource
  module Lunch5
    class LunchBotContext
      attr_reader :lunch5_menu_output

      def retrieve_menu
        @lunch5_menu_output = DataSource::Lunch5::MenuRetriever.new(weekday_today).retrieve_menu.map(&:to_s).join("\n\n").force_encoding(Encoding::UTF_8)
        @data_day = Date.today
      end

      def data_current?
        return false unless @data_day
        @data_day == Date.today
      end

      private

      def weekday_today
        Date.today.strftime('%a').downcase[0..1]
      end
    end

    class Lunch5
      def command(client, data, match)
        operation = proc do
          lunch_bot_context.retrieve_menu
        end
        callback = proc do |result|
          output_menu(client, data)
        end

        unless lunch_bot_context.data_current?
          client.say(text: 'Hold on, fetching the latest menu for you...', channel: data.channel)
          EventMachine.defer(operation, callback)
        else
          output_menu(client, data)
        end
      end

      private

      def lunch_bot_context
        @@lunch_bot_context ||= LunchBotContext.new
      end

      def output_menu(client, data)
        client.say(text: ":pizza: Here is today's Lunch 5 menu: :pizza: \n\n#{lunch_bot_context.lunch5_menu_output}", channel: data.channel)
      end
    end
  end
end
