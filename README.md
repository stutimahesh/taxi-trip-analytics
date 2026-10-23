# Taxi Trip Analytics

A local Apache Spark application for analyzing NYC yellow taxi trips from January 2025. It produces summary CSVs, trip clusters, and fare-model results.

## Requirements

- JDK 17
- Maven 3.9 or newer
- Python 3.9 or newer only if generating charts

Spark 3.5.3 is configured in `pom.xml`. Use JDK 17; the Maven launcher passes Spark's required JVM module options to the forked Java process.

## Run the analysis

From this directory, run:

```powershell
mvn clean compile exec:exec@run-spark
```

Make sure Maven is using JDK 17. The first run downloads Spark and its dependencies and may take several minutes. The input files are included under `data/`.

The program writes CSV results to `out/`.

## Generate charts (optional)

After the Java analysis completes:

```powershell
python -m pip install -r requirements.txt
python charts_real.py
```

Chart images are written to `out/` as well.

Open `out/index.html` in a browser to view all generated charts together.
