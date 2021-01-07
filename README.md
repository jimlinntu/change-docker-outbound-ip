# Change Docker Host Outbound IP

## How to Run
* `BRIDGE_NAME=your_bridge OUTBOUND_IP=your_ip docker-compose up -d`
    * For example, I run `BRIDGE_NAME=mybridge OUTBOUND_IP=192.168.2.100 docker-compose up -d`, so that my container traffic will be masqueraded by `192.168.2.100`.
