--Screen API for revolutOS

verison=0.1;
build=1;

local apisNeeded={
	"Graphics",
}

function init(this)
	new={};
	sX,sY=term.getSize();
	new.sx=sX;
	new.sy=sY-2;
	new.x=1;
	new.y=3;
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

function addChild(self,child) --Child is a table with function 'draw' and string 'name'
	if not child.name then error("Needs child.name for later removal"); end
	if not child.draw then error("Needs child.draw for functionality"); end
	self.components[#self.components+1]=child;
end

function removeChild(self,name)
	for t,child in pairs(self.components) do
		if child.name==name then
			self.components[child]=nil;
		end
	end
end

function draw(self)
	for t,child in pairs(self.components) do
		child.draw();
	end
end