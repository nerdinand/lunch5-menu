require 'net/http'
require 'oga'

module DataSource
  module FiftyOne
    class FiftyOne

      def command(client, data, match)
        fifty_one_menus = retrieve_menu.map(&:to_s).join("\n\n").force_encoding(Encoding::UTF_8)
        client.say(text: ":pizza: Here is today's Fifty One menu: :pizza: \n\n#{fifty_one_menus}", channel: data.channel)
      end

      private

      MenuDescription = Struct.new(:title, :description, :price) do
        def title_icon
          {
            'Home' => ':house:',
            'World' => ':earth_africa:',
            'Kitchen' => ':hocho:'
          }[title]
        end

        def to_s
          "#{title_icon} *#{title}*\n#{description}\n:moneybag: #{price}"
        end
      end

      def retrieve_menu
        uri = URI('http://swisscom-fiftyone.sv-group.ch/de/menuplan.html')
        html_string = Net::HTTP.get(uri)

        oga_document = Oga.parse_html(html_string)
        offers = oga_document.css('.offer')

        offers.map do |offer|
          title = offer.css('.offer-description').text.strip
          description = offer.css('.maindish').text.strip
          price = offer.css('.price').text.strip

          MenuDescription.new(
            title,
            description,
            price
          )
        end
      end
    end
  end
end
