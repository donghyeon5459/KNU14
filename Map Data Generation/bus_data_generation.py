#-*- coding:utf-8 -*-
import requests
import xml.etree.ElementTree as et
import time

url = 'http://openapi.tago.go.kr/openapi/service/BusSttnInfoInqireService/getSttnNoList'
serviceKey_old = "o0epgG67W%2FU%2BuVk%2FYH%2Fsb%2BvsH0Oknwv9zCuTO%2BG5K4r0n8I%2FzV6WUZ0eh2wmtPZjmhCd12L5D3W5C%2F3OoqT%2BFg%3D%3D"
serviceKey_new = "kM0%2BuQkdSyzOc2wngolZBkBT98a%2FQNsCL3OKQDHxGd6ePywTH0CQi3v%2B94fCrRGouR3EyDD2P3otUhNFXhKCyA%3D%3D"
# serviceKey = "kM0%2BuQkdSyzOc2wngolZBkBT98a%2FQNsCL3OKQDHxGd6ePywTH0CQi3v%2B94fCrRGouR3EyDD2P3otUhNFXhKCyA%3D%3D"
formedurl = url + "?serviceKey=" + serviceKey_new + "&cityCode=22&nodeNm=경북대학교정문앞&numOfRows=10&pageNo=1&"
print(formedurl)

def get_lat_long(busstop_name):
    formedurl = url + "?serviceKey=" + serviceKey_new + "&cityCode=22&nodeNm=" + busstop_name + "&numOfRows=10&pageNo=1&"
    r = requests.get(formedurl)
    root = et.fromstring(r.content)
    for a, b in zip(root.iter('gpslati'), root.iter('gpslong')):
        lat = a.text
        long = b.text
    return (lat, long)

import csv
import json

all_stops = []

with open('BusData_202005_WithTotals_Top1000.csv') as csvfile:
    reader = csv.reader(csvfile)

    for row in reader:
        break

    for i, row in enumerate(reader):
        print(row, i, ' ', end='')
        try:
            name = row[0]
            passengers = int(row[1])
            time.sleep(0.2)
            lat, long = get_lat_long(name)
            all_stops.append({'busstop': name, 'passengers': passengers, 'lat': lat, 'long': long})
            print('ok')
        except:
            print('failed')
            continue

        # if i > 5:
        #     break

with open('busdata.json', 'w') as f:
    json.dump(all_stops, f)