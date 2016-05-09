# lunch5-menu
Extracts information from http://www.lunch-5.ch/menu/menuplan.pdf into a sane, machine and human readable format

This is an awfully hacky script that extracts information about the current menu in the Lunch-5 to plain text. It does a very good job with this week's PDF, but who the hell knows what they'll put in there next week... >.<

Example output:
```
% ./lunch5-menu.rb mo
vegetarian

Teigwarengratin
mit diversem Gemüse und
Käse überbacken
dazu ein Menusalat Fr 9.90

lunch1

Weiderinds-Burger
Thymiansauce
Rosmarinkartoffeln
Tagesgemüse Fr 13.90

lunch2

Pouletspiessli
Pilzrahmsauce
Nudeln
Tagesgemüse Fr 16.90
```

It does this by:

1. Downloading [menuplan.pdf](http://www.lunch-5.ch/menu/menuplan.pdf)
2. Converting the PDF to a PNG using imagemagick
3. Cropping out the table using multicrop2
4. Running tesseract OCR on each of the (guessed) locations of the table cells

## Prerequisites

* [imagemagick](http://www.imagemagick.org/script/index.php)
* [tesseract](https://github.com/tesseract-ocr/tesseract)
* [tesseract language data](https://github.com/tesseract-ocr/tessdata)

On a Mac just do this:

```
brew install imagemagick
brew install tesseract --with-all-languages
```

To run with Docker

```
docker build -t lunch5-menu .
docker run -e "SLACK_API_TOKEN=your_slack_token_here" -ti lunch5-menu
```
