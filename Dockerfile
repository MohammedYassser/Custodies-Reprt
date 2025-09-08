# Use official Python slim image
FROM python:3.11-slim

# Install system dependencies for ODBC and clean up
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        unixodbc-dev \
        unixodbc \
        curl \
        gnupg \
        lsb-release \
        apt-transport-https && \
    # Safe symbolic link (won't fail if it exists)
    [ ! -f /usr/lib/x86_64-linux-gnu/libodbc.so.2 ] && ln -s /usr/lib/x86_64-linux-gnu/libodbc.so /usr/lib/x86_64-linux-gnu/libodbc.so.2 || echo "Link exists, skipping" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir pyodbc pandas

# Set working directory
WORKDIR /app

# Copy your app files (if any)
COPY . /app

# Default command
CMD ["python3"]
