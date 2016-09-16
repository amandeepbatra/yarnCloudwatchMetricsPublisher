#!/usr/bin/python
import json
import sys
import subprocess
import os
from pprint import pprint

schedulerInfo   = subprocess.check_output("curl  http://<Hadoop UI IP>:8088/ws/v1/cluster/scheduler",shell=True)
data = json.loads(schedulerInfo)
queues = data["scheduler"]["schedulerInfo"]["queues"]["queue"]
numOfQueues = len(queues)
queuesInfo=""
for queueNum in range(0,numOfQueues):
    queue = queues[queueNum]
    queueName = queue["queueName"]
    usedCapacity = queue["usedCapacity"]
    absUsedCapacity = queue["absoluteUsedCapacity"]
    memory = queue["resourcesUsed"]["memory"]
    cores = queue["resourcesUsed"]["vCores"]

    cmdUsedCapacity="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_USED_CAPACITY_"+str(queueName) + "\" --unit=\"Percent\" --region=us-east-1 --value "+str(usedCapacity)+ "" 
    cmdAbsUsedCapacity="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_ABS_USED_CAPACITY_"+str(queueName) + "\" --unit=\"Percent\" --region=us-east-1 --value "+str(absUsedCapacity)+ ""
    cmdMemory="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_MEMORY__"+str(queueName) + "\" --unit=\"Megabytes\" --region=us-east-1 --value "+str(memory)+ ""
    cmdCores="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_CORES__"+str(queueName) + "\" --unit=\"Count\" --region=us-east-1 --value "+str(cores)+ ""
    
    if queue.get('numContainers'):
        numContainers = queue["numContainers"]
        cmdNumContainers="aws cloudwatch put-metric-data --namespace \"YARN_METRICS\" --metric-name \"YARN_QUEUE_NUM_CONTAINERS_"+str(queueName) + "\" --unit=\"Count\" --region=us-east-1 --value "+str(numContainers)+ ""
        os.system(cmdNumContainers)
    os.system(cmdAbsUsedCapacity)
    os.system(cmdUsedCapacity)
    os.system(cmdMemory)
    os.system(cmdCores)

