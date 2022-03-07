FROM nvcr.io/nvidia/pytorch:19.04-py3

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.163.com/@g /etc/apt/sources.list


RUN apt-get -y update && apt-get install -y \
	python3-pip \
	software-properties-common \
	wget \
	ca-certificates \
	libcurl4-openssl-dev \
	libssl-dev \
	ffmpeg

RUN pip3 install -U pip -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple 

RUN pip install jupyterlab==1.2.4 


RUN apt-get clean
RUN update-ca-certificates -f

RUN mkdir -p /root/.torch/models

RUN mkdir -p /data/models

RUN wget -O /root/.torch/models/vgg16_bn-6c64b313.pth https://download.pytorch.org/models/vgg16_bn-6c64b313.pth

RUN wget -O /root/.torch/models/resnet34-333f7ec4.pth https://download.pytorch.org/models/resnet34-333f7ec4.pth



# if you want to avoid image building with downloading put your .pth file in root folder
COPY Dockerfile ColorizeArtistic_gen.* /data/models/
COPY Dockerfile ColorizeVideo_gen.* /data/models/


ADD . /data/

WORKDIR /data

# force download of file if not provided by local cache
#RUN [[ ! -f /data/models/ColorizeArtistic_gen.pth ]] && wget -O /data/models/ColorizeArtistic_gen.pth https://data.deepai.org/deoldify/ColorizeArtistic_gen.pth
#RUN [[ ! -f /data/models/ColorizeVideo_gen.pth ]] && wget -O /data/models/ColorizeVideo_gen.pth https://data.deepai.org/deoldify/ColorizeVideo_gen.pth

COPY run_notebook.sh /usr/local/bin/run_notebook
COPY run_image_api.sh /usr/local/bin/run_image_api
COPY run_video_api.sh /usr/local/bin/run_video_api

RUN chmod +x /usr/local/bin/run_notebook
RUN chmod +x /usr/local/bin/run_image_api
RUN chmod +x /usr/local/bin/run_video_api

EXPOSE 8888
EXPOSE 5000

# run notebook
# ENTRYPOINT ["sh", "run_notebook"]

# run image api
# ENTRYPOINT ["sh", "run_image_api"]

# run image api
# ENTRYPOINT ["sh", "run_video_api"]
