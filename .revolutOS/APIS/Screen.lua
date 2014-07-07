--Screen API for revolutOS

verison=0.1;
build=1;

function init(this)
	new={};
	sX,sY=term.getSize();
	new.sx=sX;
	new.sy=sY-1;
	new.x=1;
	new.y=2;
	os.loadAPI(apisPath.."loadAPI");
	load=loadAPI.loadAPI;
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