import csv
import json

all_stops = []

with open('BusData_202005_WithTotals_Top1000.csv') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        name = row[0]
        passengers = int(row[1])
        lat, loc = get_lat_loc(name)
        all_stops.append({'busstop': name, 'passengers': passengers, 'lat': lat, 'loc': loc})

with open('busdata.json', 'w') as f:
    json.dump(all_stops)