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

1. A DigitalOcean account ([Log in](https://cloud.digitalocean.com/login))
2. doctl CLI ([tutorial](https://docs.digitalocean.com/reference/doctl/how-to/install/))

# Quick / Easy version

1. Clone this repo `git clone https://github.com/DO-Solutions/iot-docker`
2. Enter the directory `cd iot-docker`
3. Deploy the Droplet

```bash
doctl compute droplet create iot-droplet \
--size s-2vcpu-4gb --image ubuntu-23-10-x64 \
--region lon1 --enable-backups \
--user-data-file cloudinit.yml
```

To check on your deployment SSH into your Droplet and run `tail -f /var/log/cloud-init-output.log`

To check the running services run `cd /iot-docker && docker ps`

To shutdown the whole thing `cd /iot-docker && docker-compose down`

## Test your setup

Post some messages into your Mosquitto so you'll be able to see some data in Grafana already:

```bash
sudo docker container exec mosquitto mosquitto_pub -t 'paper_wifi/test/' -m '{"humidity":21, "temperature":21, "battery_voltage_mv":3000}'
```

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

Mosquitto is configured to allow anonymous connections and posting of messages

```yaml
listener 1883
allow_anonymous true
```

### InfluxDB

The configuration is fully in `docker-compose.yml`.

### Telegraf

Telegraf is responsible for piping mqtt messages to influxdb. It is set up to listen for topic `paper_wifi/test`. You can alter this configuration according to your needs, check the official documentation on how to do that.

### Grafana data source

Grafana is provisioned with a default data source pointing to the InfluxDB instance installed in this same compose. The configuration file is `grafana-provisioning/datasources/automatic.yml`.

### Grafana dashboard

Default Grafana dashboard is also set up in this directory: `grafana-provisioning/dashboards`


<!-- CONTACT -->
# Contact

Jack Pearce, Solutions Engineer - jpearce@digitalocean.com

<p align="right">(<a href="#top">back to top</a>)</p>
