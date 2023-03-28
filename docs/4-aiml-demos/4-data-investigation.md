## 𝌭️ Data Modelling and Investigation
## Superset, Trino, Hive, S3 example usage
> Create a simple dataset from s3 using trino and hive, discovery with superset 

1. Login as your **USER_NAME** using the **OpenShift v4** button and **FreeIPA** identity provider to **Superset** using the url.

   ```bash
   oc login --server=https://api.${CLUSTER_DOMAIN##apps.}:6443 -u <USER_NAME> -p <PASSWORD>
   ```

   ```bash
   echo -e https://$(oc get route superset --template='{{ .spec.host }}' -n ${PROJECT_NAME})
   ```

   ![4-superset-login-empty](./images/4-superset-login-empty.png)

2. Browse to **Data > Databases**
3. Select **+Database** button

   ![4-superset-browse-database](./images/4-superset-browse-database.png)

4. Choose **Trino** and supply the **SQLAlchemy URI** we connect using our ldap user credentials.

   ```bash
   trino://${USER_NAME}:${PASSWORD}@trino-service:8443
   ```

   ![4-superset-url](./images/4-superset-url.png)

5. Add the trino SSL CA certificate into the **Advanced > Security > ROOT CERTIFICATE** section

   ```bash
   cat /projects/data-mesh-pattern/supply-chain/trino/trino-certs/ca.crt
   ```

   ![4-superset-ca-cert](./images/4-superset-ca-cert.png)

6. Update the **Advanced > SQL Lab** and select these tick boxes:

   ```bash
   Expose database in SQL Lab
   Allow CREATE TABLE AS
   Allow DML
   Allow Multi Schema Metadata Fetch
   Enable query cost estimation
   Allow this database to be explored
   ```

   ![4-superset-sqllab-settings](./images/4-superset-sqllab-settings.png)

7. Select **Connect**, if settings correct the connection will be created. If it fails, double check the SSL steps for trino trustore in the [Secrets](2-platform-work/3-secrets.md) section were completed OK.

   ![4-superet-connect-ok](./images/4-superet-connect-ok.png)

8. Browse to **SQLLab > SLQEditor**
9. Create a **hive catalog** from our **wine_quality.csv** data stored in S3 (make sure you copy the csv fle into s3 from the Spark Exercise)

   ```iso92-sql
   CREATE TABLE hive.default.wine_quality
   (
   "fixed acidity" VARCHAR,
   "volatile acidity" VARCHAR,
   "citric acid" VARCHAR,
   "residual sugar" VARCHAR,
   "chlorides" VARCHAR,
   "free sulfur dioxide" VARCHAR,
   "total sulfur dioxide" VARCHAR,
   "density" VARCHAR,
   "pH" VARCHAR,
   "sulphates" VARCHAR,
   "alcohol" VARCHAR,
   "quality" VARCHAR
   )
   WITH (FORMAT = 'CSV',
   skip_header_line_count = 1,
   EXTERNAL_LOCATION = 's3a://data/'
   )
   ```

   ![4-superset-hive-s3-schema](./images/4-superset-hive-s3-schema.png)

10. Select the **+** in the SQLEditor to create a new query. This will run using trino and you should see rows returned. 

   ```iso92-sql
   select * from hive.default.wine_quality;
   ```

   ![4-superset-sql-select-all](./images/4-superset-sql-select-all.png)

11. We can see the **Finished** queries that ran when logged into the trino ui and drill down into them.

   ```bash
   echo -e https://$(oc get route trino --template='{{ .spec.host }}' -n ${PROJECT_NAME})
   ```

   ![4-trino-finished](./images/4-trino-finished.png)

12. In superset **SQLEditor** select **CREATE CHART** button from our select statement. Create different charts e.g. Bar Chart, Heat Graph, TreeMap etc.

  ![4-superset-graph-treemap](./images/4-superset-graph-treemap.png)

13. And publish these to the **Dashboard**.

   ![4-superset-dashboard](./images/4-superset-dashboard.png)

