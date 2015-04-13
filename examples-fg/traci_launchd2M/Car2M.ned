//
// Copyright (C) 2006-2012 Christoph Sommer <christoph.sommer@uibk.ac.at>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

package inet.examples.traci_launchd2M;

import inet.applications.traci.TraCIDemo;
import inet.applications.udpapp.UDPBasicBurst;

import inet.linklayer.ieee80211.Ieee80211Nic;
import inet.mobility.group.TraCIMobility;
import inet.networklayer.common.InterfaceTable;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import inet.networklayer.ipv4.IPv4NetworkLayer;
import inet.networklayer.ipv4.IPv4RoutingTable;
import inet.transportlayer.udp.UDP;
import inet.networklayer.contract.IManetRouting;


module Car2M
{
    parameters:
        @node();
        *.mobilityModule = default(absPath(".mobility"));
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        *.routingTableModule = default(absPath(".routingTable"));

        string routingProtocol @enum("AODVUU","DYMOUM","DYMO","DSRUU","OLSR","OLSR_ETX","DSDV_2","Batman") = default("");

    gates:
        input radioIn @directIn;

    submodules:
        ac_wlan: HostAutoConfigurator {
            @display("p=296,402");
        }
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=155,349");
        }
        //        app: TraCIDemo {
        app: UDPBasicBurst {
            parameters:
                @display("p=384,46");
        }
        mobility: TraCIMobility {
            parameters:
                @display("p=60,459");
                traciScenarioManagerModule = default("manager");
        }
        routingTable: IPv4RoutingTable {
            parameters:
                forwarding = true;
                // routerId = "";
                routingFile = "";
                @display("p=60,326");
        }
        udp: UDP {
            parameters:
                @display("p=384,146");
        }
        networkLayer: IPv4NetworkLayer {
            parameters:
                proxyARP = false;
                @display("p=304,327;q=queue");
            gates:
                ifIn[1];
                ifOut[1];
        }
        manetrouting: <routingProtocol> like IManetRouting if routingProtocol != "" {
            @display("p=233,146");
        }
        wlan: Ieee80211Nic {
            parameters:
                @display("p=304,461;q=queue");
        }
    connections allowunconnected:
        udp.appOut++ --> app.udpIn;
        udp.appIn++ <-- app.udpOut;

        udp.ipOut --> networkLayer.transportIn++;
        udp.ipIn <-- networkLayer.transportOut++;

        networkLayer.transportOut++ --> manetrouting.from_ip if routingProtocol != "";
        networkLayer.transportIn++ <-- manetrouting.to_ip if routingProtocol != "";

        wlan.upperLayerOut --> networkLayer.ifIn[0];
        wlan.upperLayerIn <-- networkLayer.ifOut[0];

        radioIn --> wlan.radioIn;
}

