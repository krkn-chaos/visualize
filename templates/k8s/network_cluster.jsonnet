local panels = import '../../assets/networking_cluster/panels.libsonnet';
local queries = import '../../assets/networking_cluster/queries.libsonnet';
local variables = import '../../assets/networking_cluster/variables.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

g.dashboard.new(
    'Kubernetes / Networking / Cluster',
)
    .addLink(grafonnet.dashboard.newLink.new(
        title = 'Kubernetes',
        type = 'dashboards',
        tags = ['kubernetes-mixin'],
        includeVars = true,
        keepTime = true,
        asDropdown = true,
    ))
    .addPanel(panels.currentRateBytesReceived {
        gridPos: { h: 9, w: 12, x: 0, y: 0 },
    })
    .addPanel(panels.currentRateBytesTransmitted {
        gridPos: { h: 9, w: 12, x: 12, y: 0 },
    })
    .addPanel(panels.currentStatus {
        gridPos: { h: 9, w: 24, x: 0, y: 9 },
    })
    .addPanel(panels.averageRateBytesReceived {
        gridPos: { h: 9, w: 12, x: 0, y: 18 },
    })
    .addPanel(panels.averageRateBytesTransmitted {
        gridPos: { h: 9, w: 12, x: 12, y: 18 },
    })
    .addPanel(panels.receiveBandwidth {
        gridPos: { h: 9, w: 12, x: 0, y: 27 },
    })
    .addPanel(panels.transmitBandwidth {
        gridPos: { h: 9, w: 12, x: 12, y: 27 },
    })
    .addPanel(panels.rateReceivedPackets {
        gridPos: { h: 9, w: 12, x: 0, y: 36 },
    })
    .addPanel(panels.rateTransmittedPackets {
        gridPos: { h: 9, w: 12, x: 12, y: 36 },
    })
    .addPanel(panels.rateReceivedPacketsDropped {
        gridPos: { h: 9, w: 12, x: 0, y: 45 },
    })
    .addPanel(panels.rateTransmittedPacketsDropped {
        gridPos: { h: 9, w: 12, x: 12, y: 45 },
    })
    .addPanel(panels.rateTcpRetransmits {
        gridPos: { h: 9, w: 12, x: 0, y: 54 },
    })
    .addPanel(panels.rateTcpSynRetransmits {
        gridPos: { h: 9, w: 12, x: 12, y: 54 },
    })
    .setRefresh('10s')
    .setTime({ from: 'now-1h', to: 'now' })
