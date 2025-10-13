# Intentionally use an older base image with known CVEs
FROM ubuntu:18.04

# Update package lists (without upgrading everything)
RUN apt-get update && \
    apt-get install -y \
    curl \
    openssl \
    python3 \
    python3-pip \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Add a simple Python app (optional)
WORKDIR /app
COPY . /app
RUN echo 'print("Hello from vulnerable container!")' > app.py

CMD ["python3", "app.py"]
