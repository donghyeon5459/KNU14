import requests
from urllib.parse import urlparse
import pandas as pd
import json
import csv


# import geopandas


def getLatLng(addr):
    url = 'https://dapi.kakao.com/v2/local/search/keyword.json?query=' + addr
    # headers = {"Authorization":"KakaoAk 9136bbc87f43586c53b86cb5891625cc"}
    # result = json.loads(str(requests.get(url,headers=headers).text))
    # # match_first = result['documents'][0]['address']
    result = requests.get(urlparse(url).geturl(), headers={"Authorization": "KakaoAK 9136bbc87f43586c53b86cb5891625cc"})
    result = result.json()

    gps = result['documents'][0]['address']
    print(gps['x'], gps['y'])
    rlist = []
    rlist.append(gps['x'])
    rlist.append(gps['y'])
    return rlist

getLatLng("대구광역시 수성구 범어동 835")

mylist = []
xl = pd.read_excel("./subway.xlsx", encoding="utf-8")
for i in range(0, 91):
    station = xl["역명"][i];
    add = xl["지번주소"][i];
    print(station, end="")
    tlist = getLatLng(add)
    mylist.append([station, tlist[0], tlist[1]])

print(mylist)
f = open("subway.csv", "w", newline="")
wr = csv.writer(f)
for i in range(0, 91):
    wr.writerow(mylist[i])
# getLatLng("대구광역시 동구 신서동 627-15")
