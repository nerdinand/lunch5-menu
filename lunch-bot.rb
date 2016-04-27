require 'slack-ruby-bot'

class LunchBot < SlackRubyBot::Bot
  def self.retrieve_menu
    weekday_short = DateTime.now.strftime('%a').downcase[0..1]
    @@lunch5_menu_output = `./lunch5-menu.rb #{weekday_short}`
  end

  command 'lunch5' do |client, data, match|
    client.say(text: "Good day! Here is today's Lunch 5 menu: \n#{@@lunch5_menu_output}", channel: data.channel)
  end
end

LunchBot.retrieve_menu
LunchBot.run
