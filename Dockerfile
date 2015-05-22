FROM java:8u45

MAINTAINER Sharetribe Ltd. "http://github.com/sharetribe"
ENV REFRESHED_AT 2015-05-21

# Update
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install required packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y unzip

# Fetch and install datomic
RUN ["mkdir", "/temp"]
RUN ["wget", "-O", "/temp/datomic.zip", "https://my.datomic.com/downloads/free/0.9.5173"]
RUN ["unzip", "-u", "/temp/datomic.zip", "-d", "/temp"]

# Copy Datomic to correct directory
RUN ["cp", "-r", "/temp/datomic-free-0.9.5173/", "/opt/datomic/"]

# Remove unneccessary files
RUN ["rm", "-rf", "/temp/"]

# Copy default startup script
COPY ["files/startup.sh", "/opt/datomic/startup/startup.sh"]
RUN ["chmod", "700", "/opt/datomic/startup/startup.sh"]

CMD ["/opt/datomic/startup/startup.sh"]
