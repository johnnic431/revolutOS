--ScreenComponent API for revolutOS

verison=0.1;
build=1;

local apisNeeded={
	"Graphics",
}

function init(this)
	new={};
	new.components={};
	os.loadAPI("loadAPI");
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
	for k,v in pairs(this) do
		if k~="init" then
			new[k]=v;
		end
	end
	return setmetatable(new,this);
end