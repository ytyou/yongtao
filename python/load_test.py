#!/usr/bin/python

import json
import random
import requests
import sys
import time
import threading

# host per thread cnt
HPT_CNT = 64
THREAD_CNT = 4
METRIC_CNT = 1024
LABEL_CNT = 1
LABEL_VALUE_CNT = 4
SLEEP_SEC = 30

lock = threading.RLock()

TST_ID = 1
TOKEN = "0f320e7db4a2d8ba0a3229753bf7c90d821479da"
HEADERS = {"Content-Type": "application/json", "_token": TOKEN}

DURATION = 24 * 60	# minutes
START_TS = time.time()
END_TS = START_TS + DURATION * 60;

threads = list()
metricsURL = "http://172.21.16.38:8080/_tsdb/api/put?details"

total = 0

def hostname(i, h):
    return "host" + str(i*1000+h+10000*TST_ID)

def send(i, url):
    global lock
    global total
    try:
        with requests.Session() as s:
            while True:
                now = time.time()
                if now > END_TS:
                    print 'end: {0:13d}, now: {1:13d}'.format(int(END_TS), int(now))
                    break
                ts = int(round(now * 1000))

                for h in range(int(HPT_CNT)):
                    host = hostname(i, h)

                    metrics = []

                    for m in range(METRIC_CNT):
                        metric = "metric_" + str(m+1)
                        value = random.randint(0, 1000)
                        labels = dict({})
                        labels["host"] = host
                        if m == 1:
                            label = "label0"
                            lval = "label_value_" + str(random.randint(0, 128))
                            labels[label] = lval
                        else:
                            for l in range(LABEL_CNT):
                                label = "label" + str(l+1)
                                lval = "label_value_" + str(random.randint(0, LABEL_VALUE_CNT))
                                labels[label] = lval
                        metrics.append({"metric":metric,"tags":labels,"timestamp":ts,"value":value})
                        with lock:
                            total = total + 1

                    dps = {"token":TOKEN,"metrics":metrics}
                    s.post(url, data=json.dumps(dps, ensure_ascii=False), headers=HEADERS)
                    #print(json.dumps(dps, ensure_ascii=False))
                    #requests.post(url, data=json.dumps(dps, ensure_ascii=False), headers=HEADERS)

                if (now - START_TS) > 550:
                    metrics = []
                    metric = "ingest_rate"
                    with lock:
                        value = total / (now - START_TS)
                    labels = dict({})
                    labels["host"] = hostname(0, 0)
                    labels["thread"] = str(i)
                    metrics.append({"metric":metric,"tags":labels,"timestamp":ts,"value":value})
                    with lock:
                        total = total + 1
                    dps = {"token":TOKEN,"metrics":metrics}
                    s.post(url, data=json.dumps(dps, ensure_ascii=False), headers=HEADERS)
                    #print(json.dumps(dps, ensure_ascii=False))

                time.sleep(SLEEP_SEC)

    except Exception as ex:
        print 'exception: {0}'.format(str(ex))

# start threads
start = time.time()
for i in range(THREAD_CNT):
    t = threading.Thread(target=send, args=(i, metricsURL))
    t.start()
    threads.append(t)

for t in threads:
    t.join()
end = time.time()

print 'total: {0}'.format(total)
print 'sleep-sec: {0}'.format(SLEEP_SEC)
print 'thread-cnt: {0}, metric-cnt: {1}, tag-cnt: {2}, tag-val-cnt: {3}'.format(THREAD_CNT, METRIC_CNT, LABEL_CNT, LABEL_VALUE_CNT)
#print 'ts-cnt: {0}sec, {1}min, {2}hr, {3}day'.format(TS_CNT, TS_CNT/60, TS_CNT/60/60, TS_CNT/60/60/24)
print 'expected duration: {0} minutes'.format(DURATION)
print 'duration: {0}s, {1}m, {2}h'.format(end-start, (end-start)/60, (end-start)/60/60)
