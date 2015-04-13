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

import org.car2x.veins.nodes.Scenario;
//import inet.world.traci.TraCIScenarioManagerLaunchd;
//import inet.world.radio.ChannelControl;
import inet.world.obstacles.ObstacleControl;
import inet.world.annotations.AnnotationManager;
import org.car2x.veins.modules.mobility.traci.TraCIScenarioManagerLaunchd;
import org.car2x.veins.base.modules.BaseWorldUtility;
import org.car2x.veins.base.connectionManager.ConnectionManager;

network VeinsScenario11a
{
    parameters:
        @display("bgb=678,221");
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
    submodules:
//        channelControl: ChannelControl {
 //           parameters:
 //               @display("p=96,39");
 //       }
 		connectionManager: ConnectionManager {
            parameters:
                @display("p=150,0;i=abstract/multicast");
        }

        world: BaseWorldUtility {
            parameters:
                playgroundSizeX = playgroundSizeX;
                playgroundSizeY = playgroundSizeY;
                playgroundSizeZ = playgroundSizeZ;
                @display("p=31,27;i=misc/globe");
        }
        manager: TraCIScenarioManagerLaunchd {
            parameters:
                @display("p=198,43");
        }
        obstacles: ObstacleControl {
            @display("p=286,40");
        }
        annotations: AnnotationManager {
            @display("p=340,54");
        }
    connections allowunconnected:
}
