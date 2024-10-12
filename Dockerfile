# Use a specific version of Python for more predictability
FROM python:3.9-slim

# Set environment variables to avoid Python buffering
ENV PYTHONUNBUFFERED 1

# Install system dependencies if needed (optional, e.g., psycopg2 dependencies)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create and set the working directory
WORKDIR /app

# Copy requirements.txt and install dependencies (Django and others)
COPY requirements.txt ./
RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# Copy project files into the container
COPY . .

# Run database migrations
RUN python manage.py migrate

# Expose the application port
EXPOSE 8000

# Command to run the Django server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
