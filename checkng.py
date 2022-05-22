#!/usr/bin/python3
# this on  
#checkng.py
import requests


url="http://54.215.65.27"

response = requests.get(url)
if str(response) == '<Response [200]>':
	print('请求200,nginx 容器正常')
