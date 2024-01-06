hs.network.reachability.forAddress("172.20.100.3"):setCallback(function(self, flags)
    -- note that because having an internet connection at all will show the remote network
    -- as "reachable", we instead look at whether or not our specific address is "local" instead
    if (flags & hs.network.reachability.flags.isLocalAddress) > 0 then
        print("VPN IS UP")
        network_set_on()
        -- VPN tunnel is up
    else
        print("VPN IS DOWN")
        network_set_off()
        -- VPN tunnel is down
    end
end):start()

hs.network.reachability.forAddress("172.20.100.2"):setCallback(function(self, flags)
    -- note that because having an internet connection at all will show the remote network
    -- as "reachable", we instead look at whether or not our specific address is "local" instead
    if (flags & hs.network.reachability.flags.isLocalAddress) > 0 then
        print("VPN IS UP")
        network_set_on()
        -- VPN tunnel is up
    else
        print("VPN IS DOWN")
        network_set_off()
        -- VPN tunnel is down
    end
end):start()
