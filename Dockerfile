FROM python:3.11-slim

# Install system dependencies for ODBC
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        unixodbc-dev \
        unixodbc \
        curl \
        gnupg \
        lsb-release \
        apt-transport-https && \
    [ ! -f /usr/lib/x86_64-linux-gnu/libodbc.so.2 ] && ln -s /usr/lib/x86_64-linux-gnu/libodbc.so /usr/lib/x86_64-linux-gnu/libodbc.so.2 || echo "Link exists, skipping" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir pyodbc pandas streamlit

# Set working directory
WORKDIR /app

# Copy app files
COPY . /app

# Streamlit command
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true"]
