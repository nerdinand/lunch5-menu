require 'slack-ruby-bot'

class LunchBotContext
  attr_reader :lunch5_menu_output

  def retrieve_menu
    @lunch5_menu_output = `./lunch5-menu.rb #{weekday_today}`.force_encoding(Encoding::UTF_8)
    @data_weekday = weekday_today
  end

  def data_current?
    return false unless @data_weekday
    @data_weekday == weekday_today
  end

  private

  attr_reader :data_weekday

  def weekday_today
    DateTime.now.strftime('%a').downcase[0..1]
  end
end

class LunchBot < SlackRubyBot::Bot
  command 'lunch5' do |client, data, match|
    operation = proc do
      lunch_bot_context.retrieve_menu
    end
    callback = proc do |result|
      self.output_menu(client, data)
    end

    unless lunch_bot_context.data_current?
      client.say(text: 'Hold on, fetching the latest menu for you...', channel: data.channel)
      EventMachine.defer(operation, callback)
    else
      self.output_menu(client, data)
    end
  end

  def self.output_menu(client, data)
    client.say(text: "Here is today's Lunch 5 menu: \n#{lunch_bot_context.lunch5_menu_output}", channel: data.channel)
  end
end

def lunch_bot_context
  @@lunch_bot_context ||= LunchBotContext.new
end

SlackRubyBot::Client.logger.level = Logger::WARN

LunchBot.run
