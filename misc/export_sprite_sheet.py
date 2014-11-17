# coding: utf-8

"""
此脚本用于利用TexturePacker来将序列图导出SpriteSheet及XML配置文件

注意：
- 转出前需将 TexturePacker.exe 加入环境变量
- 设置 API_KEY 以方便下接压缩图片
- 运行在 Python 3.x 环境下

- 参数1： 序列图所在目录，层级关系：精灵ID目录->动作目录->方向目录->序列图片
- 参数2： 导出目录
"""

import os
import sys
from os.path import dirname
from urllib.request import Request, urlopen
from base64 import b64encode

API_KEY = "输入API"

def encode(input_file, output_file):
    request = Request("https://api.tinypng.com/shrink", open(input_file, "rb").read())
    cafile = None

    auth = b64encode(bytes("api:" + API_KEY, "ascii")).decode("ascii")
    request.add_header("Authorization", "Basic %s" % auth)

    response = urlopen(request, cafile = cafile)
    if response.status == 201:
      result = urlopen(response.getheader("Location"), cafile = cafile).read()
      open(output_file, "wb").write(result)
    else:
      print("Compression failed")

def export(filename, in_path, out_path):
    image_path = '%s\%s.png' % (out_path, filename)
    command_string = 'TexturePacker.exe "%s" ' % in_path
    command_string += '--sheet "%s" ' % image_path
    command_string += '--data "%s\%s.xml" ' % (out_path, filename)
    command_string += '--texture-format png '
    command_string += '--format sparrow '
    print('-------------------------')
    print('action: %s, export: %s' % (filename, out_path))
    os.system(command_string)
    encode(image_path, image_path)

def handler(main_path, out_path):
    sprite_id_list = os.listdir(main_path)
    for sprite_id in sprite_id_list:
        sprite_path = main_path + "\\" + sprite_id;
        if (os.path.isdir(sprite_path)):
            action_id_list = os.listdir(sprite_path)
            for action_id in action_id_list:
                action_path = sprite_path + "\\" + action_id
                if (os.path.isdir(action_path)):
                    export(action_id, action_path, out_path + "\\" + sprite_id)
        

def main():
    main_path = sys.argv[1]
    out_path = sys.argv[2]
    handler(main_path, out_path)

if __name__ == "__main__":
    main();