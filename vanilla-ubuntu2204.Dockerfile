# Use the official Ubuntu 22.04 as a base image
FROM ubuntu:22.04

# Set environment variables to non-interactive to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget apt-transport-https && \
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

# Install .NET 9 SDK
RUN apt-get update && \
    apt-get install -y dotnet-sdk-9.0

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the application code
COPY ./net9app ./net9app

WORKDIR /app/net9app

# Restore dependencies
RUN dotnet restore

# Build and publish the application
RUN dotnet publish -f net9.0 -o out

# Set the working directory to the output directory
WORKDIR /app/net9app/out

# Set the entry point for the container
ENTRYPOINT ["dotnet", "net9app.dll"]
