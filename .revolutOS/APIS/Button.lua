--Button API for revolutOS

--Auto-updating
version=0.1;
build=2;

local apisPath="";
local apisNeeded={
	"Graphics",
}

function init(self,inf)
	new={};
	new.info={x=0,y=0,sizeX=0,sizeY=0,bCol=0,tCol=0,text="",visible=false,onClick=function() end};
	inf=inf or {};
	for k,v in pairs(inf) do
		if new.info[k] then
			new.info[k]=v;
		end
	end
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
	for k,v in pairs(self) do
		if k~="init" then
			new[k]=v;
		end
	end
	return setmetatable(new,self);
end


function setSize(self,nX,nY)
	self.info.sizeX=nX;
	self.info.sizeY=nY;
	return self;
end

function setLoc(self,nX,nY)
	self.info.x=nX;
	self.info.y=nY;
	return self;
end

function setPos(self,nX,nY)
	self.info.x=nX;
	self.info.y=nY;
	return self;
end

function setBackColor(self,col)
	self.info.bCol=col;
	return self;
end

function setBackgroundColor(self,col)
	self.info.bCol=col;
	return self;
end

function setTextColor(self,col)
	self.info.tCol=col;
	return self;
end

function setText(self,tx)
	self.info.text=tx;
	return self;
end

function setVisible(self,bool)
	self.info.visible=bool;
	return self;
end

function getInfo(self)
	return self.info;
end

function clickAt(self,x,y)
	if x>=self.info.x and x<= self.info.x+self.info.sizeX-1 and y>=self.info.y and y<= self.info.y+self.info.sizeY-1 and self.info.visible then
		self.info.onClick();
	end
end

function setOnClick(self,oncl)
	self.info.onClick=oncl;
end

function onClick(self)
	self.info.onClick();
end

function draw(self)
	if self.info.visible then
		tX=self.info.x;
		tY=self.info.y;
		tX2=self.info.x+self.info.sizeX-1;
		tY2=self.info.y+self.info.sizeY;
		ok,err=pcall(Graphics.paintBox,tX,tY,tX2,tY2,self.info.bCol or colors.black);
		if not ok then print(err); return false; end
		ok,err=pcall(Graphics.writeTextCentered,tX,tX2,tY+(self.info.sizeY/2),self.info.text or "",self.info.tCol or colors.white);
		if not ok then print(err); return false; end
	end
	return true;
end