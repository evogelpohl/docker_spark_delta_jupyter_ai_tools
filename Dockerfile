

# Base Image
FROM jupyter/all-spark-notebook:x86_64-spark-3.5.0

# Authors and Documentation
LABEL maintainer="Eric Vogelpohl <eric.vogelpohl@outlook.com>"
LABEL version="1.0"
LABEL description="Docker image with Jupyter, Spark, and additional Python packages. NOTE: Ensure Spark & Delta are compatible @ https://docs.delta.io/latest/releases.html"

# Arguments for pip packages
ARG PIP_PACKAGES="delta-spark==3.0.0 \
                  deltalake \
                  plotly \
                  dash \
                  dash-bootstrap-components \
                  pandas \
                  pivottablejs \
                  pyspark-ai \
                  jupyter_ai \
                  openai \
                  delta-sharing "

# Change permissions for the jovyan user
USER root
RUN chown -R jovyan:users /home/jovyan

# Switch to jovyan user and install the specified pip packages
USER jovyan
RUN pip install ${PIP_PACKAGES}

# Expose the port Dash will run on
EXPOSE 8050
