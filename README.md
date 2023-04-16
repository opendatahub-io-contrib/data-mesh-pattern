# Data Mesh Pattern

![images/data-mesh-components.png](images/data-mesh-components.png)

<p align="center">
  Rainforest
  <a href="https://argocd-server-rainforest-ci-cd.apps.sno.sandbox242.opentlc.com/applications/rainforest-ci-cd-app-of-apps">
    <img alt="Rainforest App-of-Apps" src="https://argocd-server-rainforest-ci-cd.apps.sno.sandbox242.opentlc.com/api/badge?name=rainforest-ci-cd-app-of-apps&revision=true">
  </a><br/>
  Daintree
  <a href="https://argocd-server-rainforest-ci-cd.apps.sno.sandbox242.opentlc.com/applications/daintree-dev-app-of-apps">
    <img alt="Daintree App-of-Apps" src="https://argocd-server-rainforest-ci-cd.apps.sno.sandbox242.opentlc.com/api/badge?name=daintree-dev-app-of-apps&revision=true">
  </a>  
</p>

<<<<<<< HEAD
A mono-repo containing a platform-as-a-product approach for deploying data mesh components to a Red Hat OpenShift Container Platform.
=======
| Component | Description |
| --------- | ----------- |
| Object Storage ([Ceph)][2]]| Responsible for secure storage of raw data and object-level data access for data ingestion / loading. This is a system layer where data transactions are system-based, considered to be privileged activity and typically handled via automated processes. The data security at this layer is to be governed through secure code management validating the logic of the intended data transaction and secret management to authenticate all access requests for privileged credentials and then enforce data security policies. |
| Data Serving ([Apache Iceberg][3]) | Open standard, high-performance table format responsible for managing the availability, integrity and consistency of data transactions and data schema for huge analytic datasets. This includes the management of schema evolution (supporting add, drop, update, rename), transparent management of hidden partitioning / partitioning layout for data objects, support of ACID data transactions (particularly multiple concurrent writer processes) through eventually-consistent cloud-object stores, and time travel / version rollback for data. This layer is critical to our data-as-code approach as it enables reproducible queries based on any past table snapshot as well as examination of historical data changes. |
| Distributed SQL Query Engine ([Trino][4]) | Centralized data access and analytics layer with query federation capability. This component ensures that authentication and data access query management is standardized and centralized for all data clients consuming data, by providing management capabilities for role-based access control at the data element level in Data Commons. This being a federation layer it can support query across multiple external distributed data sources for cross-querying requirements. |
|Data Versioning and Lineage Management ([Pachyderm][5]) | Automate data transformations with data versioning and lineage. This component helps us provide an immutable lineage with data versioning of any data type, for data being processed in pipelines. It is data-agnostic, supporting both unstructured data such as documents, video and images as well as tabular data from data warehouses. It can automatically detect changes to data, trigger data processing pipelines on change, and ensure both source and processed data are version controlled. |
| Data Transformation ([DBT][6]) | SQL-first transformation workflow tooling that lets teams quickly and collaboratively deploy analytics code following software engineering best practices like modularity, portability, CI/CD, and documentation for data pipelines. This component supports our Data-as-Code approach by providing Git-enabled version control which enables full traceability of code related to data changes and allows a return to previous states. It also supports programmatic and repeatable data validation as it allows automating data pipeline testing, and sharing dynamically generated documentation with all data stakeholders, including dependency graphs and dynamic data dictionaries to promote trust and transparency for data consumers. |
| Data Validation ([Great Expectations][7]) | Open-source library for validating, documenting, and profiling data. This component provides automated testing based on version-controlled assertions which are essentially unit tests for data quality. It also helps speed up the development of data quality controls by profiling source data to get basic statistics, and automatically generating a suite of expectations based on what is observed in the data. Finally, it also provides clean, human-readable documentation, which is integrated with the metadata management system to facilitate data discovery. |
| Metadata Management ([Open Metadata][8]) | Component responsible for data pipeline and metadata management. By tying together data pipeline code and execution, it provides file-based automated data and metadata versioning across all stages of our data pipelines (including intermediate results), including immutable data lineage tracking for every version of code, models and data to ensure full reproducibility of data and code for transparency and compliance purpose. |
| Workflow Management ([Airflow][9]) | This component is the workflow management platform for all data engineering pipelines and associated metadata processing. It provides the ability for dynamic pipeline generation leveraging  standard Python features to create workflows, including date time formats for scheduling and loops to dynamically generate tasks which are required to integrate data ingestion and validation tasks with various ingestion methods. It also provides a robust and modern web front-end to monitor, schedule and manage workflows. |
| Data Security Management (Open Policy Agent & [Fybrik][10]) | Framework responsible for the monitoring and management of comprehensive data security across the entire Data Commons, as a multi-tenant environment. It provides centralized security administration for all security related tasks in a management UI, fine-grained authorization for specific action / operation on data at the data set / data element level including metadata-based authorization and controls. It also centralizes the auditing of user / process-level access for all data transactions. Ultimately, we want this layer to provide data access management and visibility directly to the data / data product owners as a self-service capability. |
| Analytics Dashboard ([Apache Superset][11]) | Software application for data exploration and data visualization able to handle data at petabyte scale. Superset connects to any datasource in Data Commons through Trino, so it allows integrating data from cloud native databases and engines to build rich visualizations and dashboard. The  visualization plug-in architecture makes it easy to build custom visualizations that can be integrated into reactive web application front-end if required. |
| Data Analysis ([pandas][12]) | Software library written for the Python programming language for data manipulation and analysis. In particular, it offers data structures and operations for manipulating numerical tables and time series that may be required for complex data manipulation in line with requirements of machine learning pipelines |

[1]: https://opendatahub.io/
[2]: https://old.ceph.com/ceph-storage/object-storage/
[3]: https://iceberg.apache.org/
[4]: https://trino.io/
[5]: https://www.pachyderm.com/
[6]: https://www.getdbt.com/
[7]: https://greatexpectations.io/
[8]: https://open-metadata.org/
[9]: https://airflow.apache.org/
[10]: https://fybrik.io/v1.2/
[11]: https://superset.apache.org/
[12]: https://pandas.pydata.org/
>>>>>>> ad9725e (Main page update for the repo)
