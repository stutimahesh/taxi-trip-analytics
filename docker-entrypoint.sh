#!/bin/sh
# Runs the Spark analysis, then builds the charts and gallery into out/
set -e
java $JAVA_OPTS @jvm.config -cp "classes:lib/*" TripAnalytics
python3 charts_real.py
