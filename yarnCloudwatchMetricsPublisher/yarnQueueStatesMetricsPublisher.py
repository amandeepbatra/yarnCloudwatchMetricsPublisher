#!/usr/bin/python
import json
import sys
import subprocess
import os
from pprint import pprint

baseURL = "http://<Hadoop UI IP>:8088/ws/v1/cluster/apps?"
states = ["NEW","NEW_SAVING","ACCEPTED","SUBMITTED","RUNNING","KILLED","FINISHED","FAILED"];
queues = ["production","non-production"];

def getQueryString(state, queue):
    finalURL = "curl "+baseURL+ "states="+state+"\&queue="+queue
    return finalURL

for state in states:    
   for queue in queues: 
        url =  getQueryString(state, queue)
        schedulerInfo   = subprocess.check_output(url ,shell=True) 
        data = None
        data = json.loads(schedulerInfo)
        if data is not None:
            apps = data["apps"]
            if apps is not None:            
                if apps.get('app'): 
                    numOfApps = len(apps.get('app'))
                    cmd="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_APP_STATE_"+str(queue) + "_"+str(state)+"\" --unit=\"Count\" --region=us-east-1 --value "+str(numOfApps)+ ""
                else:
                    print "Program should not come in this line"
            else:
                cmd="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_APP_STATE_"+str(queue) + "_"+str(state)+"\" --unit=\"Count\" --region=us-east-1 --value 0"   
        else: 
            print "Should not enter here "
        print cmd
        os.system(cmd)

