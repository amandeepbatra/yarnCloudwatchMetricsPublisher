How to execute this?

Prerequisites:

Python, EMR over Yarn, Should be run on EMR Master and Hadoop Web UI 

You need to enter the <Hadoop Web UI IP> to make the script run

You can change the following in the script if you want
- Cloudwatch Metric Name  
- Cloudwatch Namespace in which you want to add metric  

To Run:

- sh yarnCloudwatchMetricsPublisher.sh Or 
- setup as cron Job: */10 * * * * sh /mnt/yarnMetricsScripts/yarnCloudwatchMetricsPublisher.sh > /dev/null 2>/dev/null

Output:

- See Metrics in CloudWatch
- You can setup Cloudwatch Alarms over those metrics  
