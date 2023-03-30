# Apache Superset

Apache Superset component installs Apache Superset tool which provides a portal for business intelligence. It provides tools for exploring and visualizing datasets and creating business intelligence dashboards. Superset can also connect to SQL databases for data access. For more information please visit [Apache Superset](https://superset.apache.org/)

### Superset config file customization

In addition to the above parameters, Superset is configured via a [`superset_config.py`](base/superset_config.py) script.
This script configures a number of important options, including:
  * The SQLAlchemy URL for Superset's Database
  * Superset session timeout settings
  * Superset role paramters
  * Superset OAuth configuration

Users may wish to extend this configuration to further customize their deployment,
for example to map specific user groups to roles in Superset via the
`AUTH_ROLES_MAPPING` variable. In order to do this, do the following:

1. Add your customization in the form of a python file and override the
   [Superset deploymment](base/deployment.yaml) so that the file is mounted
   inside the Superset container
2. Override the [Superset deployment](base/deployment.yaml) and add a
   variable to the Superset container with name `SUPERSET_ADDITIONAL_CONFIG`.
   The value of this environment variable should be the path to your script
   from step 1 above.

At runtime, the contents of your custom file will be dynamically read in
by [superset_config.py](superset_config.py) and executed via the
`exec` command in Python.
