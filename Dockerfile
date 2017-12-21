FROM ruby:2.4.1

RUN mkdir -p /usr/src/app/log
WORKDIR /usr/src/app

EXPOSE 4567
CMD ["/bin/bash","-c","rm -f /usr/src/app/tmp/pids/server.pid ; ruby main.rb 2>&1 | tee /usr/src/app/log/stdout.log"]

RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -y net-tools --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY ./ /usr/src/app
RUN bundle install
