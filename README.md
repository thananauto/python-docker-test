# python-docker-test

## Description

This Dockerfile is designed to create a Docker image for running Python tests using Pytest. It is based on the official Python 3.10 slim image, installs project dependencies listed in `requirements.txt`, and sets up the working directory for Pytest execution.

## Usage

## Sample file

```bash 
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
```

### Building the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and the `requirements.txt` file and run the following command:

```bash
docker build -t your-image-name:tag .
```
Replace your-image-name with the desired name for your Docker image and tag with the version or tag you want to assign.

## Running Pytest in a Docker Container
Once the image is built, you can run Pytest inside a container using the following command:

```bash
docker run -it --rm  -v `pwd`:/app_test your-image-name:tag
```
This command runs Pytest with the default configuration on the tests located in the current directory (.).

Note: In the [Dockerfile](Dockerfile) I didn't mention any copy of test scripts during building of an image, the test scripts are pointed to `WORKDIR` of image during container creation by passing the flag `-v`

If there is any change in `requirements.txt`, you have to be build a image again

## Customizing Tests
If you want to run specific tests or provide additional options to Pytest, you can append them to the docker run command. For example:

```bash
docker run -it --rm your-image-name:tag -k test_module
```
This runs only the tests in the test_module.

If you want to run test alone
```bash
docker run -it --rm your-image-name:tag  test_numbers.py
```

## Multi stage builds
With docker, each layer is immutable. This means that even if you delete something that was installed in a previous layer, the total image size won’t decrease.

The recommended way to avoid bloated images is using multi-stage builds. Even if you’re just using docker for local development, saving space is always a plus!

```bash
# Stage 1: Build Stage
FROM python:3.10-slim as build

# Update package lists and install build essentials
RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential gcc 

# Set working directory for the build stage
WORKDIR /usr/app

# Create a Python virtual environment
RUN python -m venv /usr/app/venv

# Add the virtual environment to the PATH
ENV PATH="/usr/app/venv/bin:$PATH"

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Stage 2: Runtime Stage
FROM python:3.10-slim

# Set working directory for the runtime stage
WORKDIR /usr/app_test

# Copy the virtual environment from the build stage
COPY --from=build /usr/app/venv /usr/app_test/venv

# Copy the application code
COPY . .

# Add the virtual environment to the PATH for runtime
ENV PATH="/usr/app_test/venv/bin:$PATH"

# Execute the tests using pytest
ENTRYPOINT ["python","-m", "pytest"]
CMD ["."]

```
## Explanation:

### Build Stage (build):

* Uses the python:3.10-slim image as the base image.
* Installs build essentials (build-essential and gcc) necessary for building some Python packages.
* Creates a virtual environment, installs project dependencies, and sets the PATH to include the 
virtual environment.
### Runtime Stage:
* Uses a clean python:3.10-slim image as the base for the runtime stage.
* Sets the working directory for the runtime stage.
* Copies the virtual environment from the build stage to the runtime stage, reducing the size of the final image by excluding unnecessary build dependencies.
* Copies the application code.
* Sets the PATH to include the virtual environment for runtime.
* Defines the entry point to execute tests using Pytest.


This Dockerfile efficiently separates the build and runtime concerns, resulting in a smaller final image while ensuring that only necessary runtime dependencies are included.
