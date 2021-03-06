FROM ubuntu:18.04
ENV TIMEZONE America/Los_Angeles

RUN apt-get update && \
    apt-get install -y \
    git wget build-essential libz-dev libbz2-dev liblzma-dev libssl-dev libcurl4-gnutls-dev \
    autoconf automake libncurses5-dev wget gawk parallel && \
    cd /tmp && git clone -b v1.3 https://github.com/lh3/seqtk.git && \
    cd seqtk && make && make install && \
    cd /tmp && git clone -b 1.9 https://github.com/samtools/htslib && \
    cd htslib && autoheader && autoconf && \
    ./configure --prefix=/usr/local && make && make install && \
    cd /tmp && git clone -b 1.9 https://github.com/samtools/samtools && \
    cd samtools && autoheader && autoconf && \
    ./configure --prefix=/usr/local && make && make install && \
    cd /tmp && git clone -b v0.7.17 https://github.com/lh3/bwa.git && \
    cd bwa && make && cp bwa /usr/local/bin && \
    cd /tmp && git clone https://github.com/nh13/pbgzip && \
    cd pbgzip && sh autogen.sh && ./configure && make && make install && \
    cd /tmp && git clone -b v1.8.3 https://github.com/lz4/lz4 && \
    cd lz4 && make && make install && \
    cd /tmp && wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.4/sratoolkit.2.9.4-ubuntu64.tar.gz && \
    tar zxvf sratoolkit.2.9.4-ubuntu64.tar.gz && cp -R sratoolkit.2.9.4-ubuntu64/bin/* /usr/local/bin && \
    cd /tmp && rm -rf *
RUN wget https://github.com/4dn-dcic/pairix/archive/0.3.6.tar.gz && \
    tar -xzf 0.3.6.tar.gz && \
    rm 0.3.6.tar.gz && \
    cd pairix-0.3.6 && \
    make && \
    cd .. && \
    ln -s pairix-0.3.6 pairix

RUN apt-get install -y python3-dev libopenblas-dev python3-pip && \
    pip3 install numpy cython scipy pandas click && \
    pip3 install pairtools cooler HTSeq

RUN apt-get --purge remove -y build-essential git autoconf automake wget

RUN apt-get -y install locales && \
    sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV PYTHONUNBUFFERED=0
ENV PATH=/pairix/bin/:/pairix/util/:$PATH

COPY ./scripts/imargi_* /usr/local/bin/
COPY ./scripts/get_single_pairs_qc.py /usr/local/bin/
COPY ./scripts/get_merged_pairs_qc.py /usr/local/bin/
RUN chmod +x /usr/local/bin/imargi_* && mkdir /imargi && \
    sed -i -e 's/^\/repository\/user\/main\/public\/root = "$(HOME)\/ncbi\/public"/\/repository\/user\/main\/public\/root = "\/imargi"/' /usr/local/bin/ncbi/default.kfg

WORKDIR /imargi
