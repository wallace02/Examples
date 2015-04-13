import inet.physicallayer.ieee80211.Ieee80211ScalarRadioMedium;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.configurator.ipv4.HostAutoConfigurator;
import org.car2x.veins.modules.mobility.traci.TraCIScenarioManagerLaunchd;

network scenario2
{
    submodules:
        radioMedium: Ieee80211ScalarRadioMedium {
        }

        manager: TraCIScenarioManagerLaunchd {
        }

        configurator: IPv4NetworkConfigurator {
//        configurator: HostAutoConfigurator {
        }
}
