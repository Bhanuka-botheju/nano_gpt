# use a lightweigth python image
FROM python:3.10-slim

# set the working directory
WORKDIR /app

# Install system dependencies (needed for some torch operations)
RUN apt-get update $$ apt-get install -y --no-install-recommends \
build-essential \
&& rm -rf /var/lib/apt/lists/*

