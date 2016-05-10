#!/usr/bin/env ruby

require 'fileutils'

COLUMNS_X = [367, 855, 1364, 1856, 2369]
ROWS_Y = [90, 389, 693]

CELL_WIDTH = 490
CELL_HEIGHT = 285

MENU_TOP_LEFT_POSITIONS = {
  mo: {
    'vegetarian' => "+#{COLUMNS_X[0]}+#{ROWS_Y[0]}",
    'lunch1' =>     "+#{COLUMNS_X[0]}+#{ROWS_Y[1]}",
    'lunch2' =>     "+#{COLUMNS_X[0]}+#{ROWS_Y[2]}"
  },
  tu: {
    'vegetarian' => "+#{COLUMNS_X[1]}+#{ROWS_Y[0]}",
    'lunch1' =>     "+#{COLUMNS_X[1]}+#{ROWS_Y[1]}",
    'lunch2' =>     "+#{COLUMNS_X[1]}+#{ROWS_Y[2]}"
  },
  we: {
    'vegetarian' => "+#{COLUMNS_X[2]}+#{ROWS_Y[0]}",
    'lunch1' =>     "+#{COLUMNS_X[2]}+#{ROWS_Y[1]}",
    'lunch2' =>     "+#{COLUMNS_X[2]}+#{ROWS_Y[2]}"
  },
  th: {
    'vegetarian' => "+#{COLUMNS_X[3]}+#{ROWS_Y[0]}",
    'lunch1' =>     "+#{COLUMNS_X[3]}+#{ROWS_Y[1]}",
    'lunch2' =>     "+#{COLUMNS_X[3]}+#{ROWS_Y[2]}"
  },
  fr: {
    'vegetarian' => "+#{COLUMNS_X[4]}+#{ROWS_Y[0]}",
    'lunch1' =>     "+#{COLUMNS_X[4]}+#{ROWS_Y[1]}",
    'lunch2' =>     "+#{COLUMNS_X[4]}+#{ROWS_Y[2]}"
  }
}

WEEKDAYS = MENU_TOP_LEFT_POSITIONS.keys

if ARGV.length != 1 || (!WEEKDAYS.include? ARGV[0].to_sym)
  puts 'Pass one of [mo, tu, we, th, fr] as an argument.'
  exit -1
end

weekday = ARGV[0].to_sym

def download_and_convert_menuplan
  `curl http://www.lunch-5.ch/menu/menuplan.pdf | convert -chop 0x400 -density 300 - -threshold 80% -monochrome png:- | ./multicrop2 -d 3000000 - /tmp/multicrop2-output.png`
end

download_and_convert_menuplan

%w(vegetarian lunch1 lunch2).each do |menu|
  puts menu
  puts
  menu_text = `convert /tmp/multicrop2-output-000.png -crop #{CELL_WIDTH}x#{CELL_HEIGHT}#{MENU_TOP_LEFT_POSITIONS[weekday][menu]} png:- | tesseract - - -l deu -psm 4`
  puts menu_text.lines.reject { |line| line.scrub('').strip.empty? }
  puts
end

FileUtils.rm Dir.glob('/tmp/multicrop2-output-*.png')
