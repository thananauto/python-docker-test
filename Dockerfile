FROM python:3.10-slim
COPY requirements.txt /app_test/requirements.txt
RUN pip install -r /app_test/requirements.txt
WORKDIR /app_test
ENTRYPOINT ["pytest"]
CMD ["."]