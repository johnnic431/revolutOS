--Application API for revolutOS

version=0.1;
build=1;

apisNeeded={"Screen"};

function init(this,name,info)
	Logger.log("Initializing application "..name);
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
	new={};
	new.view=nil;
	new.eventHandlers={};
	new.isTerminatable=true;
	new.name=name;
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

function addEventHandler(self,eHandler,typef)
	Logger.log("Adding event handler that handles event type "..typef);
	if typeof then
		eventHandlers:insert({handler=eHandler,typeof=typef});
	else
		eventHandlers:insert({handler=eHandler,typeof="all"});
	end
end

function start(this)
	Logger.log("Starting application "..this.name);
	this.view:draw();
	t=coroutine.create((function() 
		e={os.pullEvent()};
		Logger.log("Event "..e[1].." received");
		for t,y in pairs(this.eventHandlers) do
			if y.typeof==e[1] or y.typeof=="all" then
				Logger.log("Event handled.");
				y.handler(e);
			end
		end
	end));
	Logger.log("Created main coroutine for application "..this.name);
	coroutine.resume(t);
	Logger.log("Main coroutine is running.");
end

function redraw(this)
	this.view:draw();
end