
import inet.applications.udpapp.UDPBasicBurst;
import org.car2x.veins.modules.application.traci.TraCIDemo11p;


import inet.transportlayer.udp.UDP;
import inet.networklayer.ipv4.IPv4NetworkLayer;
import inet.networklayer.ipv4.IPv4RoutingTable;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;

import inet.linklayer.ieee80211.Ieee80211Nic;
import inet.networklayer.common.InterfaceTable;
import org.car2x.veins.modules.mobility.traci.TraCIMobility;



module car2
{
    parameters:
        @node();
        @display("bgb=345,416");
                
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.routingTableModule = default(absPath(".routingTable"));
		wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");  // use adhoc management
//        string routingProtocol @enum("AODVUU","DYMOUM","DYMO","DSRUU","OLSR","OLSR_ETX","DSDV_2","Batman") = default("");  // used mobile routing protocol. see: inet.networklayer.manetrouting
        
//        bool multicastForwarding = default(false);
//        routingTable.multicastForwarding = multicastForwarding;   // for IPv4, IPv6, Generic
        
        *.mobilityModule = default(absPath(".mobility"));

    gates:
        input radioIn @directIn;

    submodules:
        app: UDPBasicBurst {
            parameters:
                @display("p=126,37");
//                mobilityModule = default("TraCIMobility");
        }

        udp: UDP {
            parameters:
                @display("p=126,167");
        }

        networkLayer: IPv4NetworkLayer {
            parameters:
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
                routingFile = "";
                @display("p=107,302");
        }

//      ac_wlan: IPv4NetworkConfigurator {
		ac_wlan: HostAutoConfigurator {
            @display("p=255,302");
        }

        wlan: Ieee80211Nic {
            parameters:
                @display("p=271,359;q=queue");
        }

        interfaceTable: InterfaceTable {
            parameters:
                @display("p=48,227");
        }

        mobility: TraCIMobility {
            parameters:
                @display("p=48,359");
        }               

    connections allowunconnected:
        udp.appOut++ --> app.udpIn;
        udp.appIn++ <-- app.udpOut;
//        udp.appOut++ --> app.lowerLayerIn;
//        udp.appIn++ <-- app.lowerLayerOut;

        udp.ipOut --> networkLayer.transportIn++;
        udp.ipIn <-- networkLayer.transportOut++;

        wlan.upperLayerOut --> networkLayer.ifIn[0];
        wlan.upperLayerIn <-- networkLayer.ifOut[0];

//        wlan.upperLayerOut --> app.lowerLayerIn;
//        wlan.upperLayerIn <-- app.lowerLayerOut;        

        radioIn --> wlan.radioIn;
}
