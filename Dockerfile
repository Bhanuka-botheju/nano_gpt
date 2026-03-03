# use a lightweigth python image
FROM python:3.10-slim

# Grab the uv binary from astral's official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# set the working directory
WORKDIR /app

# copy the project dependencies manifests first to leverage Docker layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies into the system environment 
# --frozen ensures we strictly use the loskfile
# --system installs it globally in the container ( standard practice for docker )
RUN uv sync --frozen --no-dev --system 

# copy the rest of the your applications files
COPY . .

# Expose the port your Flask app runs on 
EXPOSE 5000

# set the command to run your application
CMD ["python","app.py"]


