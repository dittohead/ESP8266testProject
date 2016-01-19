brightness=0
keyLocal=1243
redPin = 1
greenPin = 2
bluePin= 3
pwm.setup(redPin, 1000, 0) --initial PMW setups
pwm.setup(greenPin, 1000, 0)
pwm.setup(bluePin, 1000, 0)

red=0 --init vals
blue=0
green=0

function setLEDs(r,g,b,key)
key=tonumber(key)
if (key==keyLocal) then 
    print("setLEDs")
    print("red:"..r.."\n","green:".. g.."\n","blue:"..b)
    pwm.start(redPin)
    pwm.start(greenPin)
    pwm.start(bluePin)
    pwm.setduty(redPin,checkPWMrange(r))
    pwm.setduty(greenPin,checkPWMrange(g))
    pwm.setduty(bluePin,checkPWMrange(b))
    collectgarbage()
    return("200 OK")
    else
    collectgarbage()
    return("403 Forbidden")
end
end

function checkPWMrange(pwmVal)
val=tonumber(pwmVal)
if (val == nil) then
    val=0
elseif (val>1023) then
    val=1023
else
    val=val
end
return(val)
end

srv=net.createServer(net.TCP)
srv:listen(80,function(conn)

--print("heap:"..node.heap())
    conn:on("receive",function(conn,payload)
    --print(payload)
     if (string.find(payload, "GET /brightness HTTP/1.1") ~= nil) then
         --print("brightness request")
         brightness=adc.read(0)
         local voltage=brightness*0.9765625
         print("voltage:"..voltage.."mV")
         conn:send("HTTP/ 1.1 200 OK\r\nAccess-Control-Allow-Origin: *\r\n"
         .."Content-Type: application/json\r\n\r\n"
         .."{brightness:"..brightness.."}")
         print("Brightness: "..brightness)
         conn:on("sent",function(conn) conn:close() end)
        elseif (string.find(payload, "GET /setled?") ~=nil) then
          local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)%?(.+) HTTP");
          print(method, path, vars)
            if (vars==nil) then 
                vars=""
            end
        if (string.match(vars, "r=[%d]+")==nil) then 
            print ("oops...red nil")
            red=red
        else
            red=string.match(vars, "r=[%d]+")
            red=string.match(red,"[%d]+")
        end
        
        if (string.match(vars, "g=[%d]+")==nil) then 
            print ("oops...green nil")
            green=green
        else
            green=string.match(vars, "g=[%d]+")
            green=string.match(green,"[%d]+")
        end
        if (string.match(vars, "b=[%d]+")==nil) then 
            print ("oops...blue nil")
            blue=blue
        else
            blue=string.match(vars, "b=[%d]+")
            blue=string.match(blue,"[%d]+")
        end
        if (string.match(vars, "key=[%d]+")==nil) then 
        print ("oops... keynil")
        key=0
        conn:send("HTTP/ 1.1 403 Forbidden\r\nAccess-Control-Allow-Origin: *\r\n"
         .."Content-Type: text/html\r\n\r\n"
         .."403")
        conn:on("sent",function(conn) conn:close() end)
        else
        key=string.match(vars, "key=[%d]+")
        key=string.match(key,"[%d]+")
        end
        print("founded color values \n red:"..red.."\n","green:".. green.."\n","blue:"..blue.."\n", "key:"..key)
        resp=setLEDs(red, green, blue,key)
        print("sended responce code:"..resp)
        conn:send("HTTP/ 1.1"..resp.."\r\nAccess-Control-Allow-Origin: *\r\n"
        .."Content-Type: text/html\r\n\r\n"
        ..resp)
        conn:on("sent",function(conn) conn:close() end)
		red=0
		green=0
		blue=0
		key=0
        collectgarbage()
        elseif (string.find(payload, "GET / HTTP/1.1") ~= nil) then
        conn:send('hello world')
        conn:on("sent",function(conn) conn:close() end)
        else
        conn:send("HTTP/ 1.1 404 Not Found\r\nAccess-Control-Allow-Origin: *\r\n"
        .."Content-Type: text/html\r\n\r\n"
        .."404")
        conn:on("sent",function(conn) conn:close() end)
        --print("heap:"..node.heap())
        collectgarbage()
        --print("heap cleared:"..node.heap())     
        end    
        end)
       end)
-- conn:on("sent",function(conn) conn:close() end)
 
