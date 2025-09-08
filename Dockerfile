FROM python:3.11-slim

# Install system dependencies for ODBC
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    unixodbc \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https \
    && ln -s /usr/lib/x86_64-linux-gnu/libodbc.so /usr/lib/x86_64-linux-gnu/libodbc.so.2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app
COPY . .

# Set Streamlit as the entrypoint
CMD ["streamlit", "run", "app.py"]
