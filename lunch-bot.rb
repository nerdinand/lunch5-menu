require 'slack-ruby-bot'

require_relative 'data_source/lunch5'
require_relative 'data_source/fifty_one'

class LunchBot < SlackRubyBot::Bot
  command 'lunch5' do |client, data, match|
    DataSource::Lunch5::Lunch5.new.command(client, data, match)
  end

  command 'fiftyone' do |client, data, match|
    DataSource::FiftyOne::FiftyOne.new.command(client, data, match)
  end

  command 'everything' do |client, data, match|
    DataSource::Lunch5::Lunch5.new.command(client, data, match)
    DataSource::FiftyOne::FiftyOne.new.command(client, data, match)
  end
end

SlackRubyBot::Client.logger.level = Logger::WARN

LunchBot.run
