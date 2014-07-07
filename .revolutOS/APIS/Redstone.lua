--Application API for revolutOS

version=0.1;
build=1;

function init(self,info)
	os.loadAPI(apisPath.."loadAPI");
	load=loadAPI.loadAPI;
	apisPath=loadAPI.apiPath;
	local env=getfenv();
	for k,v in pairs(apisNeeded) do
		if not env[v] then
			if not load(apisPath..v..".lua") then
				error("Unable to load required API "..v);
			end
		end
	end
	new={};
	new.view=Screen:new();
	new.eventHandlers={};
	inf=info or {};
	for k,v in pairs(inf) do
		if new[k] then
			new[k]=v;
		end
	end
	for k,v in pairs(this) do
		if k~="init" then
			new[k]=v;
		end
	end
	return setmetatable(new,this);
end