FROM python:3.10-slim
WORKDIR /app
COPY example_app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY example_app/ ./
CMD ["python", "app.py"]
