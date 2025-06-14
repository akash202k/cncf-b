# bran/Dockerfile
FROM python:3.12

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Copy project files
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

RUN pip install psycopg

# Copy application code
COPY . .

# Fix pyproject.toml issue
# RUN sed -i 's/\[tool.poetry.dev-dependencies\]/\[tool.poetry.group.dev.dependencies\]/' pyproject.toml

WORKDIR /app/backend

# Run migrations and start server
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

# EXPOSE 8000