--Screen API for revolutOS

verison=0.1;
build=1;

local apisNeeded={
	"Graphics",
}

function init(this)
	Logger.log("Initializing new screen...");
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

function addChild(self,child) --Child is a table with function 'draw' and string 'name'
	if not child.name then error("Needs child.name for later removal"); end
	if not child.draw then error("Needs child.draw for functionality"); end
	table.insert(self.components,child);
end

function removeChild(self,name)
	Logger.log("Removing child "..name);
	for i=1,#self.components do
		if self.components[i].name==name then
			self.components[i]=nil;
		end
	end
end

function draw(self)
	Logger.log("Redrawing...");
	for t,child in pairs(self.components) do
		child.draw();
	end
	Logger.log("Done with redraw.");
end