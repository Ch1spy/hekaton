# CHANGED: Upgraded from 3.10 to 3.11 to support newer Numpy versions
FROM python:3.11-slim

WORKDIR /app

# FIXED: Replaced 'libgl1-mesa-glx' with 'libgl1' for newer Debian versions
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]