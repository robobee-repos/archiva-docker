#!/bin/bash
set -e

WRAPPER_CONF_FILE="${ARCHIVA_SOURCE_DIR}/archiva/conf/wrapper.conf"

cat > "${WRAPPER_CONF_FILE}" <<EOF
#********************************************************************
# Wrapper Properties
#********************************************************************
# Java Application
wrapper.java.command=java
wrapper.working.dir=..

# Java Main class.  This class must implement the WrapperListener interface
#  or guarantee that the WrapperManager class is initialized.  Helper
#  classes are provided to do this for you.  See the Integration section
#  of the documentation for details.
wrapper.java.mainclass=org.tanukisoftware.wrapper.WrapperSimpleApp
set.default.REPO_DIR=lib
set.default.ARCHIVA_BASE=.

# Java Classpath (include wrapper.jar)  Add class path elements as
#  needed starting from 1
wrapper.java.classpath.1=lib/wrapper.jar
wrapper.java.classpath.2=%REPO_DIR%/archiva-jetty-2.2.3.pom
wrapper.java.classpath.3=%REPO_DIR%/jetty-server-8.1.14.v20131031.jar
wrapper.java.classpath.4=%REPO_DIR%/javax.servlet-3.0.0.v201112011016.jar
wrapper.java.classpath.5=%REPO_DIR%/jetty-continuation-8.1.14.v20131031.jar
wrapper.java.classpath.6=%REPO_DIR%/jetty-http-8.1.14.v20131031.jar
wrapper.java.classpath.7=%REPO_DIR%/jetty-io-8.1.14.v20131031.jar
wrapper.java.classpath.8=%REPO_DIR%/jetty-jndi-8.1.14.v20131031.jar
wrapper.java.classpath.9=%REPO_DIR%/javax.mail.glassfish-1.4.1.v201005082020.jar
wrapper.java.classpath.10=%REPO_DIR%/javax.activation-1.1.0.v201105071233.jar
wrapper.java.classpath.11=%REPO_DIR%/jetty-start-8.1.14.v20131031.jar
wrapper.java.classpath.12=%REPO_DIR%/jetty-plus-8.1.14.v20131031.jar
wrapper.java.classpath.13=%REPO_DIR%/javax.transaction-1.1.1.v201105210645.jar
wrapper.java.classpath.14=%REPO_DIR%/jetty-webapp-8.1.14.v20131031.jar
wrapper.java.classpath.15=%REPO_DIR%/jetty-servlet-8.1.14.v20131031.jar
wrapper.java.classpath.16=%REPO_DIR%/jetty-security-8.1.14.v20131031.jar
wrapper.java.classpath.17=%REPO_DIR%/jetty-deploy-8.1.14.v20131031.jar
wrapper.java.classpath.18=%REPO_DIR%/jetty-xml-8.1.14.v20131031.jar
wrapper.java.classpath.19=%REPO_DIR%/jetty-util-8.1.14.v20131031.jar
wrapper.java.classpath.20=%REPO_DIR%/derby-10.10.1.1.jar
wrapper.java.classpath.21=%REPO_DIR%/mail-1.4.jar
wrapper.java.classpath.22=%REPO_DIR%/activation-1.1.jar
wrapper.java.classpath.23=%REPO_DIR%/ant-1.8.3.jar
wrapper.java.classpath.24=%REPO_DIR%/ant-launcher-1.8.3.jar
wrapper.java.classpath.25=%REPO_DIR%/tomcat-jdbc-7.0.54.jar
wrapper.java.classpath.26=%REPO_DIR%/tomcat-juli-7.0.54.jar
EOF

if [[ "${DB_TYPE}" == "mysql" ]]; then
    cat >> "${WRAPPER_CONF_FILE}" <<EOF
wrapper.java.classpath.27=%REPO_DIR%/mysql-connector-java-8.0.11.jar
EOF
fi

cat >> "${WRAPPER_CONF_FILE}" <<EOF
# Java Library Path (location of Wrapper.DLL or libwrapper.so)
wrapper.java.library.path.1=lib

# Java Additional Parameters
#wrapper.java.additional.1=
wrapper.java.additional.1=-Dappserver.home=.
wrapper.java.additional.2=-Dappserver.base=%ARCHIVA_BASE%
wrapper.java.additional.3=-Djetty.logs=%ARCHIVA_BASE%/logs
wrapper.java.additional.4=-Djava.io.tmpdir=%ARCHIVA_BASE%/temp
wrapper.java.additional.5=-DAsyncLoggerConfig.WaitStrategy=Block
wrapper.java.additional.6=-Darchiva.repositorySessionFactory.id=jcr
wrapper.java.additional.7=-Darchiva.cassandra.configuration.file=%ARCHIVA_BASE%/conf/archiva-cassandra.properties
wrapper.java.additional.8=-XX:MaxPermSize=${JAVA_MAX_PERM_SIZE}

# Initial Java Heap Size (in MB)
#wrapper.java.initmemory=3
wrapper.java.initmemory=${JAVA_INITIAL_MEMORY_MB}

# Maximum Java Heap Size (in MB)
#wrapper.java.maxmemory=64
wrapper.java.maxmemory=${JAVA_MAX_MEMORY_MB}

# Application parameters.  Add parameters as needed starting from 1
wrapper.app.parameter.1=org.eclipse.jetty.start.Main
wrapper.app.parameter.2=%ARCHIVA_BASE%/conf/jetty.xml

#********************************************************************
# Wrapper Logging Properties
#********************************************************************
# Format of output for the console.  (See docs for formats)
wrapper.console.format=PM

# Log Level for console output.  (See docs for log levels)
wrapper.console.loglevel=INFO

# Log file to use for wrapper output logging.
wrapper.logfile=%ARCHIVA_BASE%/logs/wrapper-YYYYMMDD.log

# Format of output for the log file.  (See docs for formats)
wrapper.logfile.format=LPTM

# Log Level for log file output.  (See docs for log levels)
wrapper.logfile.loglevel=INFO

# Maximum size that the log file will be allowed to grow to before
#  the log is rolled. Size is specified in bytes.  The default value
#  of 0, disables log rolling.  May abbreviate with the 'k' (kb) or
#  'm' (mb) suffix.  For example: 10m = 10 megabytes.
wrapper.logfile.maxsize=0

# Maximum number of rolled log files which will be allowed before old
#  files are deleted.  The default value of 0 implies no limit.
wrapper.logfile.maxfiles=0

# Log Level for sys/event log output.  (See docs for log levels)
wrapper.syslog.loglevel=NONE

#********************************************************************
# Wrapper Windows Properties
#********************************************************************
# Title to use when running as a console
wrapper.console.title=Apache Archiva

#********************************************************************
# Wrapper Windows NT/2000/XP Service Properties
#********************************************************************
# WARNING - Do not modify any of these properties when an application
#  using this configuration file has been installed as a service.
#  Please uninstall the service before modifying this section.  The
#  service can then be reinstalled.

# Name of the service
wrapper.ntservice.name=archiva

# Display name of the service
wrapper.ntservice.displayname=Apache Archiva

# Description of the service
wrapper.ntservice.description=Archiva is an application for managing one or more remote
      repositories, including administration, artifact handling,
      browsing and searching.

# Service dependencies.  Add dependencies as needed starting from 1
wrapper.ntservice.dependency.1=

# Mode in which the service is installed.  AUTO_START or DEMAND_START
wrapper.ntservice.starttype=AUTO_START

# Allow the service to interact with the desktop.
wrapper.ntservice.interactive=false

wrapper.restart.delay=30
wrapper.java.additional.1.stripquotes=TRUE
wrapper.on_exit.0=SHUTDOWN
wrapper.logfile.rollmode=DATE
wrapper.on_exit.default=RESTART
EOF

if [[ "$DEBUG" == "true" ]]; then
    cat "${WRAPPER_CONF_FILE}"
fi
