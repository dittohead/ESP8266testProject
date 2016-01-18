wifi.setmode(wifi.STATION)
--wifi.sta.config("Yalantis", "743v6RRyal")
wifi.sta.config ("Xiaomi", "fromchinawithlove")    
wifi.sta.connect()
tmr.alarm(0, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Connecting to AP...")
     else
     ip, nm, gw=wifi.sta.getip()
     print("IP:",ip)
     print("Net Mask:",nm)
     print("Gateway:",gw)
     print("Connected!")
     tmr.stop(0)
    collectgarbage()
dofile("webServer.lua")
--dofile("ddns.lua")    
     end
    end)
