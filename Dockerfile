# use a lightweight python image
FROM python:3.10-slim

# Grab the uv binary from astral's official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# set the working directory
WORKDIR /app

# copy the project dependencies manifests first to leverage Docker layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies into a virtual environment (.venv) inside the container
# --frozen ensures we strictly use the lockfile
# --no-dev skips development dependencies
RUN uv sync --frozen --no-dev

# This is the magic line: it activates the virtual environment for all future commands
ENV PATH="/app/.venv/bin:$PATH"

# copy the rest of your application files
COPY . .

# Expose the port your Flask app runs on 
EXPOSE 5000

# set the command to run your application
CMD ["python","app.py"]