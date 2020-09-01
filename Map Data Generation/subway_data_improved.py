import requests
from urllib.parse import urlparse
import pandas as pd
import json
import csv


# import geopandas

def getLatLng(station, lat, long):
    url = 'https://dapi.kakao.com/v2/local/search/keyword.json?query=' + station + "&x=" + str(lat) + "&y=" + str(long)
    # headers = {"Authorization":"KakaoAk 9136bbc87f43586c53b86cb5891625cc"}
    # results = json.loads(str(requests.get(url,headers=headers).text))
    # # match_first = results['documents'][0]['address']
    results = requests.get(urlparse(url).geturl(),
                           headers={"Authorization": "KakaoAK 9136bbc87f43586c53b86cb5891625cc"})
    results = results.json()['documents']

    station_results = [result for result in results if (result['category_group_name'] == '지하철역')]
    if station_results:
        station_result = station_results[0]
    else:
        station_result = results[0]

    return (station_result['y'], station_result['x'])


all_stations = []

with open('subway_combined_improvable.csv') as csvfile:
    reader = csv.reader(csvfile)

    for row in reader:
        break

    for i, row in enumerate(reader):
        print(row, i, ' ', end='')
        station = row[0]
        passengers = int(row[1])
        lat = float(row[2])
        long = float(row[3])
        print()
        lat, long = getLatLng(station, lat, long)
        print(station, lat, long)
        all_stations.append({"station": station, "passengers": passengers, "lat": lat, "long": long})


with open('subwaydata.json', 'w') as f:
    json.dump(all_stations, f)