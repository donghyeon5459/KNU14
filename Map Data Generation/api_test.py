import requests

url = 'http://openapi.tago.go.kr/openapi/service/BusSttnInfoInqireService/getSttnNoList'
serviceKey = "o0epgG67W%2FU%2BuVk%2FYH%2Fsb%2BvsH0Oknwv9zCuTO%2BG5K4r0n8I%2FzV6WUZ0eh2wmtPZjmhCd12L5D3W5C%2F3OoqT%2BFg%3D%3D"
serviceKey2 = "kM0%2BuQkdSyzOc2wngolZBkBT98a%2FQNsCL3OKQDHxGd6ePywTH0CQi3v%2B94fCrRGouR3EyDD2P3otUhNFXhKCyA%3D%3D"

formedurl = url + "?serviceKey=" + serviceKey2 + "&cityCode=22&nodeNm=경북대학교정문앞&numOfRows=10&pageNo=1&"
#print(formedurl)

r = requests.get(formedurl)
print(r.text)