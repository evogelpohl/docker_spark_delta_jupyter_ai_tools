# Base Image
FROM jupyter/all-spark-notebook:latest

# Authors and Documentation
LABEL version="1.0"
LABEL description="Docker image with Jupyter, Spark, and additional Python packages. NOTE: Ensure Spark & Delta are compatible @ https://docs.delta.io/latest/releases.html"

# Arguments for pip packages
ARG PIP_PACKAGES="delta-spark==3.0.0 \
                  deltalake \
                  plotly \
                  # duckdb \
                  polars \
                  sodapy \
                  faker \
                  youtube-transcript-api \
                  nltk \
                  wordcloud \
                  pandas \
                  pandasai \
                  openai \
                  delta-sharing"

# Install necessary system packages and the jdk (required for a OHDSI Synthea data generator project only)
USER root
RUN apt update && apt install -y default-jdk && \
    chown -R jovyan:users /home/jovyan

# Switch to jovyan user and install Python packages
USER jovyan

# Attempts to correct JupyterLabs AI chat error bug
RUN pip install -U jupyter
RUN pip install -U notebook
RUN pip install -U jupyter-ai
RUN pip install -U jupyter-ai-magics
RUN pip install -U jupyterlab-git
RUN pip install -U pandasai

# Jupyter lab build
RUN jupyter lab build --minimize=False

# Install other analytical tools
RUN pip install ${PIP_PACKAGES}
