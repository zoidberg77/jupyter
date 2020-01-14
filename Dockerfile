FROM docker.io/ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /home/install
COPY . /home/install/

# Update and create base image
RUN apt-get update -y
RUN apt-get install apt-utils -y
RUN apt-get install -y wget gcc g++ unzip git htop

# Install Anaconda
SHELL ["/bin/bash", "-c"]
RUN wget -q https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
RUN bash Anaconda3-2019.03-Linux-x86_64.sh -b -p /home/anaconda3
ENV PATH="/home/anaconda3/bin:${PATH}"
RUN conda update -y conda
RUN conda update -y conda-build

# Install cooltools environment
RUN conda create --name zoid

# Install bioframe, cooltools and pairlib as well as our own NGS library
RUN source activate zoid &&\
    conda install --file requirements.txt

WORKDIR /home

EXPOSE 8080

CMD [ "jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--allow-root"]
