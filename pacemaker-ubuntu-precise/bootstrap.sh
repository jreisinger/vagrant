#!/usr/bin/env bash

# update & install
apt-get update && apt-get upgrade -y
#apt-get install -y pacemaker cman fence-agents libdlm-dev libdlmcontrol-dev
apt-get install -y pacemaker cman fence-agents linux-image-extra-virtual
chown hacluster /var/lib/heartbeat

cat <<EOF > /etc/cluster/cluster.conf
<?xml version="1.0"?>
<cluster config_version="1" name="pacemaker1">
  <logging debug="off"/>
  <clusternodes>
    <clusternode name="node1" nodeid="1">
      <fence>
        <method name="pcmk-redirect">
          <device name="pcmk" port="node1"/>
        </method>
      </fence>
    </clusternode>
    <clusternode name="node2" nodeid="2">
      <fence>
        <method name="pcmk-redirect">
          <device name="pcmk" port="node2"/>
        </method>
      </fence>
    </clusternode>
  </clusternodes>
  <fencedevices>
    <fencedevice name="pcmk" agent="fence_pcmk"/>
  </fencedevices>
</cluster>
EOF

echo "CMAN_QUORUM_TIMEOUT=0" >> /etc/default/cman

# fix installer Warning: The home directory `/var/lib/heartbeat' does
# not belong to the user you are currently creating.
chown hacluster /var/lib/heartbeat

service cman start
service pacemaker start
