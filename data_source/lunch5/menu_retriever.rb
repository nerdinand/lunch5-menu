require 'fileutils'

module DataSource
  module Lunch5
    class MenuRetriever

      COLUMNS_X = [367, 855, 1364, 1856, 2369]
      ROWS_Y = [90, 389, 693]

      CELL_WIDTH = 490
      CELL_HEIGHT = 285

      MENU_TOP_LEFT_POSITIONS = {
        mo: {
          'Vegetarian' => "+#{COLUMNS_X[0]}+#{ROWS_Y[0]}",
          'Lunch 1' =>     "+#{COLUMNS_X[0]}+#{ROWS_Y[1]}",
          'Lunch 2' =>     "+#{COLUMNS_X[0]}+#{ROWS_Y[2]}"
        },
        tu: {
          'Vegetarian' => "+#{COLUMNS_X[1]}+#{ROWS_Y[0]}",
          'Lunch 1' =>     "+#{COLUMNS_X[1]}+#{ROWS_Y[1]}",
          'Lunch 2' =>     "+#{COLUMNS_X[1]}+#{ROWS_Y[2]}"
        },
        we: {
          'Vegetarian' => "+#{COLUMNS_X[2]}+#{ROWS_Y[0]}",
          'Lunch 1' =>     "+#{COLUMNS_X[2]}+#{ROWS_Y[1]}",
          'Lunch 2' =>     "+#{COLUMNS_X[2]}+#{ROWS_Y[2]}"
        },
        th: {
          'Vegetarian' => "+#{COLUMNS_X[3]}+#{ROWS_Y[0]}",
          'Lunch 1' =>     "+#{COLUMNS_X[3]}+#{ROWS_Y[1]}",
          'Lunch 2' =>     "+#{COLUMNS_X[3]}+#{ROWS_Y[2]}"
        },
        fr: {
          'Vegetarian' => "+#{COLUMNS_X[4]}+#{ROWS_Y[0]}",
          'Lunch 1' =>     "+#{COLUMNS_X[4]}+#{ROWS_Y[1]}",
          'Lunch 2' =>     "+#{COLUMNS_X[4]}+#{ROWS_Y[2]}"
        }
      }

      WEEKDAYS = MENU_TOP_LEFT_POSITIONS.keys

      def initialize(weekday)
        if !WEEKDAYS.include? weekday.to_sym
          puts 'Pass one of [mo, tu, we, th, fr] as an argument.'
          exit -1
        end

        @weekday = weekday.to_sym
      end

      def retrieve_menu
        download_and_convert_menuplan

        menu_descriptions = ['Vegetarian', 'Lunch 1', 'Lunch 2'].map do |menu|
          description = `convert /tmp/multicrop2-output-000.png -crop #{CELL_WIDTH}x#{CELL_HEIGHT}#{MENU_TOP_LEFT_POSITIONS[weekday][menu]} png:- | tesseract - - -l deu -psm 4`.lines.reject { |line| line.scrub('').strip.empty? }.join

          MenuDescription.new(
            menu,
            description
          )
        end

        FileUtils.rm Dir.glob('/tmp/multicrop2-output-*.png')
        menu_descriptions
      end

      private

      MenuDescription = Struct.new(:title, :description) do
        def title_icon
          {
            'Vegetarian' => ':eggplant:',
            'Lunch 1' => ':spaghetti:',
            'Lunch 2' => ':knife_fork_plate:'
          }[title]
        end

        def to_s
          "#{title_icon} *#{title}*\n#{description}"
        end
      end

      attr_reader :weekday

      def download_and_convert_menuplan
        `curl http://www.lunch-5.ch/menu/menuplan.pdf | convert -chop 0x400 -density 300 - -threshold 80% -monochrome png:- | ./multicrop2 -d 3000000 - /tmp/multicrop2-output.png`
      end
    end
  end
end
