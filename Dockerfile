FROM python:3.11-slim

# Install system dependencies for ODBC and SQL Server
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc-dev \
    unixodbc \
    lsb-release \
    apt-transport-https \
    && mkdir -p /etc/apt/keyrings \
    && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg \
    && curl -sSL https://packages.microsoft.com/config/debian/11/prod.list \
       | sed 's#deb https://#deb [trusted=yes] https://#g' \
       > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && ln -s /usr/lib/x86_64-linux-gnu/libodbc.so /usr/lib/x86_64-linux-gnu/libodbc.so.2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Python requirements
COPY requirements.txt .

# Install Python dependencies
RUN python -m venv .venv
RUN . .venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt

# Copy app code
COPY . .

# Run Streamlit
CMD [".venv/bin/streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]
