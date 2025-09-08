FROM python:3.11-slim

# Install system dependencies for ODBC and SQL Server
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc-dev \
    unixodbc \
    lsb-release \
    && mkdir -p /etc/apt/keyrings \
    && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg \
    && curl -sSL https://packages.microsoft.com/config/debian/11/prod.list | sed 's#deb https://#deb [signed-by=/etc/apt/keyrings/microsoft.gpg] https://#g' > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
