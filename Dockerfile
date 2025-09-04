#stage1: Builder
FROM python:3.12-slim-bullseye AS  builder

#set working directory for build stage
WORKDIR /build

#install system dependencies
RUN apt-get update && \
    apt-get install -y build-essential software-properties-common git && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

#upgrade pip version
#install application dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt





#stage2: Runtime
FROM python:3.12-slim-bullseye

#create non-root user for security
#create directory
#assign directory ownership to non-root user 
RUN useradd -m -r appuser && \
    mkdir /app && \
    chown -R appuser /app

#copy the Python dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

#set working directory for production stage
WORKDIR /app

#copy source code to container
COPY --chown=appuser:appuser src /app/

#set environment variables to optimize Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

#switch to non-root user
USER appuser

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]

