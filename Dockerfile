# Base Image
FROM jupyter/all-spark-notebook:spark-3.5.0

# Authors and Documentation
LABEL maintainer="Eric Vogelpohl <eric.vogelpohl@outlook.com>"
LABEL version="1.0"
LABEL description="Docker image with Jupyter, Spark, and additional Python packages. NOTE: Ensure Spark & Delta are compatible @ https://docs.delta.io/latest/releases.html"

# Arguments for pip packages
ARG PIP_PACKAGES="delta-spark==3.1.0 \
                  deltalake \
                  plotly \
                  duckdb \
                  polars \
                  youtube-transcript-api \
                  nltk \
                  wordcloud \
                  pandas \
                  openai \
                  delta-sharing \
                  notebook \
                  jupyter \
                  jupyter-ai \
                  jupyter-ai-magics"

# Install necessary system packages and JDK
USER root
RUN apt update && apt install -y default-jdk && \
    chown -R jovyan:users /home/jovyan

# Switch to jovyan user and install Python packages
USER jovyan
RUN pip install ${PIP_PACKAGES} && \
    jupyter lab build --minimize=False
