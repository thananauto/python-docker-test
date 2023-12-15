# python-docker-test

## Description

This Dockerfile is designed to create a Docker image for running Python tests using Pytest. It is based on the official Python 3.10 slim image, installs project dependencies listed in `requirements.txt`, and sets up the working directory for Pytest execution.

## Usage

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

Note: In the Dockerfile I didn't mention any copy of test scripts during building of an image, the test scripts are pointed to `WORKDIR` of image during container creation by passing the flag `-v`

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

## Project Structure
* `requirements.txt`: List of Python dependencies required for running the tests.
* `Dockerfile`: Configuration for building the Docker image.
