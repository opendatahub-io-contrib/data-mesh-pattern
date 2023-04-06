# team spark dev cluster

1. Create a team cluster.

    ```bash
    oc apply -k team-spark/overlays/cluster-dev/daintree-dev
    ```

2. SparkConf - set memory, cores as desired, so you can share cluster when running sessions.

    single spark core, partial memory (2/3)GiB

    ```bash
    submit_args = f"
    --conf spark.executor.memory=2g \
    --conf spark.cores.max=1 \
    "
    ```

    all cluster resources

    ```bash
        submit_args = f"
    --conf spark.executor.memory=3g \
    --conf spark.cores.max=3 \
    "
    ```

3. Set SPARK_CLUSTER explicitly to be shared cluster name before creating your spark session.

    ```python
    os.environ['SPARK_CLUSTER']="spark-cluster-daintree-dev"
    spark_session = spark_util.getOrCreateSparkSession("Hello Spark user1", submit_args)
    ``` 
