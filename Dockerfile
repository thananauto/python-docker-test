# Use the official Python 3.10 slim image as the base image
FROM python:3.10-slim

# Copy the requirements.txt file to the /app_test directory in the image
COPY requirements.txt /app_test/requirements.txt

# Install Python dependencies listed in requirements.txt
RUN pip install -r /app_test/requirements.txt

# Set the working directory to /app_test
WORKDIR /app_test

# Specify the default entry point for the container to run Pytest
ENTRYPOINT ["pytest"]

# Specify the default command for Pytest to run tests in the current directory (.)
CMD ["."]