#!/bin/bash

# Update and install necessary packages
apt-get update
apt-get install -y docker-compose git make

# Install Docker using the official Docker script
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Clone the IoT Docker repository
git clone https://github.com/jkpe/docker-compose-mosquitto-influxdb-telegraf-grafana
cd docker-compose-mosquitto-influxdb-telegraf-grafana

# Generate random values for InfluxDB settings
export INFLUXDB_ADMIN_TOKEN=$(openssl rand -hex 24)
export INFLUXDB_USERNAME=$(openssl rand -hex 8)
export INFLUXDB_PASSWORD=$(openssl rand -hex 8)

# Replace default values in docker-compose.yml with generated values
sed -i 's/DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=/DOCKER_INFLUXDB_INIT_ADMIN_TOKEN='$INFLUXDB_ADMIN_TOKEN'/g' docker-compose.yml
sed -i 's/DOCKER_INFLUXDB_INIT_USERNAME=default/DOCKER_INFLUXDB_INIT_USERNAME='$INFLUXDB_USERNAME'/g' docker-compose.yml
sed -i 's/DOCKER_INFLUXDB_INIT_PASSWORD=default/DOCKER_INFLUXDB_INIT_PASSWORD='$INFLUXDB_PASSWORD'/g' docker-compose.yml

# Replace the token in telegraf.conf
sed -i 's/token = \"\"/token = \"'$INFLUXDB_ADMIN_TOKEN'\"/g' telegraf.conf

# Replace the token in grafana-provisioning/datasources/automatic.yml
sed -i 's/token: /token: '$INFLUXDB_ADMIN_TOKEN'/g' grafana-provisioning/datasources/automatic.yml

# Start IoT using Docker Compose
docker-compose up -d

# Navigate back to the script's original directory
cd -
