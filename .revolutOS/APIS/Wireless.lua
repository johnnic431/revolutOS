--Wireless for revolutOS

version=0.1;
build=1;

apisPath="";
apisNeeded={"Peripheral","Logger"};
local modem;
local isInit=false;
local notInit="The function Wireless.init() was not yet called. It must be called to use the Wireless API.";

function init()
	Logger.log("Wireless initializing...");
	os.loadAPI(apisPath.."loadAPI");
	load=loadAPI.loadAPI;
	apisPath=loadAPI.apiPath
	local env=getfenv();
	for k,v in pairs(apisNeeded) do
		if not env[v] then
			if not load(apisPath..v..".lua") then
				error("Unable to load required API "..v);
			end
		end
	end
	if not Peripheral.hasPeripheral("wireless_modem") then Logger.log("No wireless modem found"); error("A wireless modem is required to use the Wireless API."); end
	modem=Peripheral.getPeripheral("wireless_modem");
	isInit=true;
	return true;
end

function open(channel)
	if not isInit then error(notInit) end
	Logger.log("Opening channel "..tostring(channel));
	modem.open(channel);
end

function close(channel)
	if not isInit then error(notInit) end
	modem.close(channel);
end

function isOpen(channel)
	if not isInit then error(notInit) end
	return modem.isOpen(channel);
end

function send(channel,rChannel,message,mID)
	if not isInit then error(notInit) end
	modem.transmit(channel,rChannel,textutils.serialize({content=message,senderID=os.getComputerID(),chan=channel,rChan=rChannel,messageID=mID or "revolutOS:wirelessAPI"}));
	Logger.log("Sent wireless message with content "..textutils.serialize({content=message,senderID=os.getComputerID(),chan=channel,rChan=rChannel,messageID=mID or "revolutOS:wirelessAPI"}));
	return true;
end

function sendNormal(channel,rChannel,message)
	if not isInit then error(notInit) end
	modem.transmit(channel,rChannel,message);
	Logger.log("Sent plain message with message "..tostring(message));
	return true;
end

function waitForMessage(channel)
	if not isInit then error(notInit) end
	if not isOpen(channel) then open(channel); end
	Logger.log("Waiting for message on channel "..tostring(channel));
	while true do
		e={os.pullEvent("modem_message")};
		if e[3]==channel then
			Logger.log("Received wireless message with content "..e[5])
			e[5]=textutils.unserialize(e[5]);
			return e[5];
		end
	end
end