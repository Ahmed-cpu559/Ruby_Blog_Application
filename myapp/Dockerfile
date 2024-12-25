
FROM ruby:3.2


RUN apt-get update -qq && \
    apt-get install -y default-mysql-client nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install
COPY . .


CMD ["rails", "server", "-b", "0.0.0.0"]
