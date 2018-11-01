import requests
import time
from threading import Thread

threads = list()
reachableURL = "http://httpbin.org/get"
unreachableURL = "https://www.google.com"

def get(i, url):
    print("getting " + str(i))
    with requests.Session() as s:
        for _ in range(5):
            r = s.get(url)
            print(str(i) + ": " + str(r.status_code))

for i in range(5):
    t = Thread(target=get, args=(i,reachableURL,))
    t.start()
    threads.append(t)

for t in threads:
    t.join()
