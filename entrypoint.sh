#!/bin/bash

cd /home/PaddleOCR/deploy/pdserving
echo "正在启动paddle ocr serving..."
python3 web_service.py
