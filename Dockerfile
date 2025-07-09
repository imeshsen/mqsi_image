FROM ubuntu:22.04

# Install runtime dependencies required by ACE
RUN apt-get update && apt-get install -y \
    bash \
    gzip \
    tar \
    libatomic1 \
    libx11-6 \
    libxext6 \
    libxtst6 \
    libxi6 \
    libglib2.0-0 \
    libnss3 \
    libsm6 \
    libice6 \
    libxt6 \
    libxrender1 \
    libxrandr2 \
    libxfixes3 \
    libxcursor1 \
    libxinerama1 \
    libfontconfig1 \
    libfreetype6 \
    libasound2 \
    libicu70 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ibm

# Copy and extract ACE
COPY deps/12.0.12.13-ACE-LINUX64-DEVELOPER.tar.gz .

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN mkdir ace-12 && \
    tar -xzf 12.0.12.13-ACE-LINUX64-DEVELOPER.tar.gz \
        --strip-components=1 -C ace-12 && \
    rm 12.0.12.13-ACE-LINUX64-DEVELOPER.tar.gz

# Accept license and set up registry
RUN ./ace-12/ace make registry global accept license silently

RUN echo 'source $PWD/ace-12/server/bin/mqsiprofile' >> ~/.bashrc 

ENTRYPOINT ["/entrypoint.sh"]

