FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1
WORKDIR /app

# system deps for common wheels; keep to minimum
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY . /app

# create unprivileged user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 9798
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "9798","--workers","1"]