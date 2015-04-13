//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//

import inet.world.radio.ChannelControl;
import inet.world.traci.TraCIScenarioManagerLaunchd;


//import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;

network VeinsScenario
{
    @display("bgb=570,200");
	submodules:
        channelControl: ChannelControl {
            parameters:
                @display("p=256,128");
        }
        manager: TraCIScenarioManagerLaunchd {
            parameters:
                @display("p=512,128");
        }
        //        rsu[1]: RSU {
        //           @display("p=150,140;b=10,10,oval");
        //        }
//        configurator: IPv4NetworkConfigurator {
//            parameters:
//               config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
//                @display("p=52,162;i=block/cogwheel_s");
//        }
}
