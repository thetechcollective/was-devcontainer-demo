FROM ruby:3.2.3-bullseye

# Set the language to support BOM characters in Liquid
ENV LANG C.UTF-8

# Set the default working directory
WORKDIR /app

# Expose the Jekyll related ports
EXPOSE 4000 35729

# Add your additional instructions here