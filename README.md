# lunch5-menu

This used to be a hacky script to extract information from http://www.lunch-5.ch/menu/menuplan.pdf into a sane, machine and human readable format

Now it is a Slack bot that runs that hacky script that still does the same thing. It also includes a script that scrapes http://swisscom-fiftyone.sv-group.ch/de/menuplan.html for the lunch menu.

## Prerequisites

* [imagemagick](http://www.imagemagick.org/script/index.php)
* [tesseract](https://github.com/tesseract-ocr/tesseract)
* [tesseract language data](https://github.com/tesseract-ocr/tessdata)

On a Mac just do this:

```
brew install imagemagick
brew install tesseract --with-all-languages
```

## Slack bot

This also includes a bot for Slack. Run it like this:

```SLACK_API_TOKEN=your-slack-bot-token bundle exec ruby lunch-bot.rb```

An interaction with the bot looks something like this:

![bot example interaction](https://raw.githubusercontent.com/nerdinand/lunch5-menu/master/doc/bot-example.png)

To run with Docker:

```
docker build -t lunch5-menu .
docker run -e "SLACK_API_TOKEN=your_slack_token_here" -ti lunch5-menu
```
