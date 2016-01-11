myip=""
--dr=net.createConnection(net.TCP, 0)
--dr:dns("www.duckdns.org",function(conn,ip) print("ip: " ..ip)
--myip=ip
--end)

conn=net.createConnection(net.TCP, 0)

--print("my ip: " ..myip)
conn:connect(80, "duckdns.org")

conn:send("GET /update/dittohead/fcd6f0df-ae1d-4769-bff7-b90074d62a11 HTTP/1.1\r\n Host: www.duckdns.org\r\n Accept: */*\r\n User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n \r\n")
--conn:send("GET /update/dittohead/fcd6f0df-ae1d-4769-bff7-b90074d62a11 HTTP/1.1\r\n Host: www.duckdns.org\r\n Accept: */*\r\n User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n \r\n")
--conn:send("www.duckdns.org/update?domains=dittohead&token=fcd6f0df-ae1d-4769-bff7-b90074d62a11")
--conn:send("GET duckdns.org/update/dittohead/fcd6f0df-ae1d-4769-bff7-b90074d62a11")
conn:on("receive", function(conn, payload) print(payload) end)
print("duckdns done!")
dofile("webServer.lua")    
