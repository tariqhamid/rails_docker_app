# gets the docker image of ruby 2.5 and lets us build on top of that
FROM ruby:2.7.2-slim

# install rails dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libsqlite3-dev curl

# create a folder /myapp in the docker container and go into that folder
RUN mkdir /myapp
WORKDIR /myapp


# Install Yarn.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# Copy the whole app
COPY . /myapp

# Run yarn install to install JavaScript dependencies.
RUN rm -rf /myapp/yarn.lock
RUN rm -rf yarn.lock
RUN yarn install --check-files

# Copy the Gemfile and Gemfile.lock from app root directory into the /myapp/ folder in the docker container
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Run bundle install to install gems inside the gemfile
RUN bundle install
