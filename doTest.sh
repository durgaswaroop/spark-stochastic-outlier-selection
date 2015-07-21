#!/bin/sh


a=1
b=1

sbt assembly

while [ $b -lt 11 ]
do
	while [ $a -lt 21 ]
	do
   		docker-compose kill
   		docker-compose rm -f
   		docker-compose scale master=1 zookeeper=1 kafka=$a worker=$a

   		sec=`expr $a \* 5`
   		sleep $sec

		docker-compose run task /usr/spark/bin/spark-submit --class com.quintor.EvaluateOutlierDetectionDistributed --master spark://master:7077 /tmp/app/target/scala-2.10/QuintorSparkOutlier-assembly-1.0.jar 1000 $a /tmp/results/output$a.txt

		a=`expr $a + 1`
	done
b=`expr $b + 1`
done
