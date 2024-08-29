# Use an official Python runtime as a base image
FROM python:3.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY scrapydweb_settings_v10.py /app

# Install dependencies required
RUN pip install scrapydweb

# Start Scrapydweb when the container launches
CMD ["scrapydweb"]