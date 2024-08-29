# Your Python version
FROM python:3.9

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies required
RUN pip install --no-cache-dir -r requirements.txt

# Start ScrapydWeb when the container launches
CMD ["scrapyd"]