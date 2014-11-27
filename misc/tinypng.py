# coding: utf-8

"""
此脚本用于给单独一张png图片进行压缩

注意：
- 设置 API_KEY 以方便下接压缩图片
- 运行在 Python 3.x 环境下

- 参数1： 图片路径
"""

import os
import sys
from os.path import dirname
from urllib.request import Request, urlopen
from base64 import b64encode

API_KEY = "API_KEY"

def encode(input_file):
    request = Request("https://api.tinypng.com/shrink", open(input_file, "rb").read())
    cafile = None

    auth = b64encode(bytes("api:" + API_KEY, "ascii")).decode("ascii")
    request.add_header("Authorization", "Basic %s" % auth)

    response = urlopen(request, cafile = cafile)
    if response.status == 201:
      result = urlopen(response.getheader("Location"), cafile = cafile).read()
      open(input_file, "wb").write(result)
    else:
      print("Compression failed")        

def main():
    main_path = sys.argv[1]
    encode(main_path)

if __name__ == "__main__":
    main();