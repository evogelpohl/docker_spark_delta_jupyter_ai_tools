# Base Image
FROM jupyter/all-spark-notebook:latest

# CLI Build CMD: docker-compose -f ./docker-compose_mac.yml up --build --force-recreate

# Authors and Documentation
LABEL version="1.0"
LABEL description="Docker image with Jupyter, Spark, and additional Python packages. NOTE: Ensure Spark & Delta are compatible @ https://docs.delta.io/latest/releases.html"

# Install necessary system packages and the jdk (required for a OHDSI Synthea data generator project only)
USER root
RUN apt update && apt install -y default-jdk && \
    chown -R jovyan:users /home/jovyan

# Switch to jovyan user and install Python packages
USER jovyan

# Uninstall any existing JupyterLab version
RUN pip uninstall -y jupyterlab
RUN pip uninstall -y jupyter

# Upgrade JupyterLab and dependencies forcefully
RUN pip install --upgrade --force-reinstall jupyterlab jupyter notebook jupyter-ai jupyter-ai-magics jupyterlab-git pandasai

# Clean and build JupyterLab to ensure all extensions and dependencies are correctly configured
RUN jupyter lab clean
RUN jupyter lab build

# Install and upgrade JupyterLab extensions (Optional)
RUN jupyter labextension install @jupyterlab/git

# Install data tools
RUN pip install delta-spark==3.2.0
RUN pip install delta-sharing
RUN pip install deltalake
RUN pip install plotly
RUN pip install polars
RUN pip install faker
RUN pip install youtube-transcript-api
RUN pip install nltk
RUN pip install wordcloud
RUN pip install pandasai
RUN pip install pandasai
RUN pip install openai

# Switch back to root to create the startup script
USER root

# Create a startup script to update JupyterLab extensions (Optional)
RUN echo '#!/bin/bash\njupyter lab build\nstart.sh' > /usr/local/bin/start-notebook.sh && \
    chmod +x /usr/local/bin/start-notebook.sh

# Switch back to jovyan user
USER jovyan