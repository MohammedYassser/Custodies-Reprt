FROM python:3.11-slim

# Install system dependencies for ODBC and SQL Server
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc-dev \
    unixodbc \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8080

# Start the application
CMD streamlit run app.py --server.port=$PORT --server.address=0.0.0.0
