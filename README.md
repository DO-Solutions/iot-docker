# DigitalOcean IoT Docker
<!-- <div id="top"></div> -->
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://digitalocean.com/">
    <img src="./assets/DO_Logo-Blue.png" alt="Logo" >
  </a>

<h3 align="center">DigitalOcean | IoT Docker</h3>

  <p align="center">

<b>One-click Droplet for Mosquitto, InfluxDB, Telegraf & Grafana</b>
<br>
<br>[Eclipse Mosquitto](https://mosquitto.org) - An open source MQTT broker to collect your data via MQTT protocol
<br>[InfluxDB](https://www.influxdata.com/) - The Time Series Data Platform to store your data in time series database 
<br>[Telegraf](https://www.influxdata.com/time-series-platform/telegraf/) - The open source server agent to connect Mosquitto and InfluxDB together
<br>[Grafana](https://grafana.com/) - The open observability platform to draw some graphs and more
  </p>
</div>

Based on: https://github.com/Miceuz/docker-compose-mosquitto-influxdb-telegraf-grafana

# Getting Started

## Architecture diagram

## Prerequisites

1. A DigitalOcean account - [Sign up here](https://cloud.digitalocean.com)
2. doctl CLI - [Installation guide](https://docs.digitalocean.com)

## Running on an Existing Droplet

Instead of manually deploying a new Droplet, you can run `scripts/install.sh` on an existing DigitalOcean Droplet to set up the environment. This script automates the installation process.

1. Update package lists and upgrade all packages

```bash
apt-get update && apt-get upgrade
```

2. Download and install Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```

3. Install docker-compose and git

```bash
apt-get update && apt-get install -y docker-compose git
```

4. Run the installation script for this project

```bash
curl -sSL https://github.com/DO-Solutions/iot-docker/raw/master/scripts/install.sh | bash
```


## Deploying a New Droplet

To deploy a new Droplet with the necessary software installed:

1. Clone this repo: `git clone https://github.com/DO-Solutions/iot-docker`
2. Enter the directory: `cd iot-docker`
3. Deploy the Droplet using the following command:

```bash
doctl compute droplet create iot-droplet \
--size s-2vcpu-4gb --image ubuntu-23-10-x64 \
--region lon1 --enable-backups \
--user-data-file cloudinit.yml
```

4. To check on your deployment SSH into your Droplet and run `tail -f /var/log/cloud-init-output.log`
5. To check the running services run `cd /iot-docker && docker ps`
6. To shutdown the whole thing `cd /iot-docker && docker-compose down`

## Test your setup

1. Post messages into Mosquitto to see data in Grafana:

```bash
sudo docker container exec mosquitto mosquitto_pub -t 'paper_wifi/test/' -m '{"humidity":21, "temperature":21, "battery_voltage_mv":3000}'
```

2. Access Grafana at `http://<your-server-ip>:3000`. Username: `admin`, Password: `/iot-docker/grafanapassword.txt`.
3. Explore InfluxDB at `http://<your-server-ip>:8086`. Credentials in `docker-compose.yml`.

### Grafana

Open in your browser: 
`http://<your-server-ip>:3000`

Username is `admin`

Password can be found in `/iot-docker/grafanapassword.txt`

You should see a graph of the data you have entered with the `mosquitto_pub` command.

### InfluxDB

You can poke around your InfluxDB setup here: `http://<your-server-ip>:8086`

Username and password are found in `docker-compose.yml`

# Configuration

### Mosquitto

- Allows anonymous connections.
- Configured to listen on port 1883.

```yaml
listener 1883
allow_anonymous true
```

### InfluxDB

- Configuration details are available in `docker-compose.yml`.

### Telegraf

- Set up to pipe MQTT messages to InfluxDB.
- Listens for topic `paper_wifi/test`.
- Configuration can be modified as per the official documentation.

### Grafana data source

- Comes with a default data source pointing to InfluxDB.
- Configuration: `grafana-provisioning/datasources/automatic.yml`.
- Default dashboard setup in `grafana-provisioning/dashboards`.


<!-- CONTACT -->
# Contact

Jack Pearce, Solutions Engineer - jpearce@digitalocean.com

<p align="right">(<a href="#top">back to top</a>)</p>
