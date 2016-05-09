FROM ruby:2.3.1

RUN apt-get update && apt-get install -y imagemagick && \
  apt-get install -y tesseract-ocr && \
  apt-get install -y tesseract-ocr-deu && \
  apt-get install -y ghostscript && \
  apt-get install -y bc
RUN   apt-get clean -y && \
  apt-get autoclean -y && \
  apt-get autoremove -y && \
  rm -rf /usr/share/locale/* && \
  rm -rf /var/cache/debconf/*-old && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/share/doc/*

ADD . /lunch5-menu
WORKDIR /lunch5-menu
RUN bundle install
CMD bundle exec ruby lunch-bot.rb
