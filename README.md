# Paddle OCR docker-compose部署文件

## 特别说明
1. PaddleOCR文件夹是git拉取的官方paddleocr仓库，仓库地址:<https://github.com/PaddlePaddle/PaddleOCR>

2. `Dockerfile`构建镜像的时候，动态拉取paddleOCR官方仓库代码，由于是从github拉代码，可能会失败，可以预先拉取好仓库，修改Dockerfile（见注释），拷贝仓库代码进镜像即可

3. 本`docker-compose.yml`仅启动paddldocr服务，具体使用方式，参照官方paddleocr-client文件的代码<https://github.com/PaddlePaddle/PaddleOCR/blob/release/2.3/deploy/pdserving/pipeline_http_client.py>