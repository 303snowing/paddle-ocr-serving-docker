# 镜像选择参见 https://github.com/PaddlePaddle/Serving/blob/develop/doc/DOCKER_IMAGES_CN.md#%E9%95%9C%E5%83%8F%E8%AF%B4%E6%98%8E
FROM registry.baidubce.com/paddlepaddle/serving:0.6.2-py38-runtime
LABEL "Mail":"303snowing@gmail.com"\
    "version":"v1.0.0"

EXPOSE 9998

WORKDIR /home

RUN ln -s /usr/local/bin/python3.8 /usr/local/bin/python \
    && ln -s /usr/local/bin/python3.8 /usr/local/bin/python3 \
    && mkdir /root/.pip
COPY ../pip.conf /root/.pip/pip.conf

# 拉取paddleocr仓库
#RUN apt update -y && apt install git -y
RUN git clone https://github.com/PaddlePaddle/PaddleOCR
# 从github拉取有时候会失败，直接COPY本地拉好的仓库
# COPY PaddleOCR /home/PaddleOCR
RUN ls -la /home/PaddleOCR
RUN echo "下载依赖库" &&  \
    cd PaddleOCR && pip3 install --upgrade pip && pip3 install -r requirements.txt
RUN echo "下载并解压 OCR 文本检测模型" &&  \
    wget https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_det_infer.tar && tar xf ch_ppocr_mobile_v2.0_det_infer.tar && \
    echo "下载并解压 OCR 文本识别模型" &&  \
    wget https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_rec_infer.tar && tar xf ch_ppocr_mobile_v2.0_rec_infer.tar &&  \
    echo "转换检测模型" && \
    python3 -m paddle_serving_client.convert --dirname ./ch_ppocr_mobile_v2.0_det_infer/ \
    --model_filename inference.pdmodel          \
    --params_filename inference.pdiparams       \
    --serving_server ./ppocr_det_mobile_2.0_serving/ \
    --serving_client ./ppocr_det_mobile_2.0_client/ && \
    echo "转换识别模型" && \
    python3 -m paddle_serving_client.convert --dirname ./ch_ppocr_mobile_v2.0_rec_infer/ \
    --model_filename inference.pdmodel          \
    --params_filename inference.pdiparams       \
    --serving_server ./ppocr_rec_mobile_2.0_serving/  \
    --serving_client ./ppocr_rec_mobile_2.0_client/ && \
    echo "复制模型到可用路径" &&  \
    pwd &&  \
    cp -r /home/ppocr_det_mobile_2.0_serving ./PaddleOCR/deploy/pdserving/ &&   \
    cp -r /home/ppocr_rec_mobile_2.0_serving ./PaddleOCR/deploy/pdserving/

COPY entrypoint.sh /home/entrypoint.sh

# 启动服务
ENTRYPOINT  ["bash", "entrypoint.sh"]