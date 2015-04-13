
import inet.applications.udpapp.UDPBasicBurst;
import org.car2x.veins.modules.application.traci.TraCIDemo11p;


import inet.transportlayer.udp.UDP;
import inet.networklayer.ipv4.IPv4NetworkLayer;
import inet.networklayer.ipv4.IPv4RoutingTable;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.contract.IManetRouting;

import inet.linklayer.ieee80211.Ieee80211Nic;
import inet.networklayer.common.InterfaceTable;
import org.car2x.veins.modules.mobility.traci.TraCIMobility;



module carMan2
{
    parameters:
        @node();
        @display("bgb=345,406");
		
		*.mobilityModule = default(absPath(".mobility"));
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.routingTableModule = default(absPath(".routingTable"));
        
        string routingProtocol @enum("AODVUU","DYMOUM","DYMO","DSRUU","OLSR","OLSR_ETX","DSDV_2","Batman") = default("");  // used mobile routing protocol. see: inet.networklayer.manetrouting

//        bool multicastForwarding = default(false);
//        routingTable.multicastForwarding = multicastForwarding;   // for IPv4, IPv6, Generic

    gates:
        input radioIn @directIn;

    submodules:
        app: UDPBasicBurst {
            parameters:
                @display("p=146,37");
        }

        udp: UDP {
            parameters:
                @display("p=146,166");
        }

        networkLayer: IPv4NetworkLayer {
            parameters:
                igmp.enabled = false;
                proxyARP = false;
                @display("p=271,227;q=queue");
            gates:
                ifIn[1];
                ifOut[1];
        }

        routingTable: IPv4RoutingTable {
            parameters:
                forwarding = true;
                //                routerId = "";
                //routingFile = "";
                @display("p=137,294");
        }

        manetrouting: <routingProtocol> like IManetRouting if routingProtocol != "" {
            @display("p=271,96");
        }

        //      ac_wlan: IPv4NetworkConfigurator {
        ac_wlan: HostAutoConfigurator {
            @display("p=251,294");
        }

        wlan: Ieee80211Nic {
            parameters:
                @display("p=271,359;q=queue");
        //        mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
        }

        interfaceTable: InterfaceTable {
            parameters:
                @display("p=48,212");          
        }

        mobility: TraCIMobility {
            parameters:
                @display("p=48,353");
        }

    connections allowunconnected:
        udp.appOut++ --> app.udpIn;
        udp.appIn++ <-- app.udpOut;
//        udp.appOut++ --> app.lowerLayerIn;
//        udp.appIn++ <-- app.lowerLayerOut;

        udp.ipOut --> networkLayer.transportIn++;
        udp.ipIn <-- networkLayer.transportOut++;

        networkLayer.transportOut++ --> manetrouting.from_ip if routingProtocol != "";
        networkLayer.transportIn++ <-- manetrouting.to_ip if routingProtocol != "";

        wlan.upperLayerOut --> networkLayer.ifIn[0];
        wlan.upperLayerIn <-- networkLayer.ifOut[0];

//        wlan.upperLayerOut --> app.lowerLayerIn;
//        wlan.upperLayerIn <-- app.lowerLayerOut;        

        radioIn --> wlan.radioIn;
}
