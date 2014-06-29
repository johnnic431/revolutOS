--Button API for revolutOS

--Auto-updating
version=0.1;
build=2;

local apisPath="";
local apisNeeded={
	"Graphics",
}

function init(this,inf)
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
	for k,v in pairs(this) do
		if k~="init" then
			new[k]=v;
		end
	end
	return setmetatable(new,this);
end


function setSize(this,nX,nY)
	this.info.sizeX=nX;
	this.info.sizeY=nY;
	return this;
end

function setLoc(this,nX,nY)
	this.info.x=nX;
	this.info.y=nY;
	return this;
end

function setPos(this,nX,nY)
	this.info.x=nX;
	this.info.y=nY;
	return this;
end

function setBackColor(this,col)
	this.info.bCol=col;
	return this;
end

function setBackgroundColor(this,col)
	this.info.bCol=col;
	return this;
end

function setTextColor(this,col)
	this.info.tCol=col;
	return this;
end

function setText(this,tx)
	this.info.text=tx;
	return this;
end

function setVisible(this,bool)
	this.info.visible=bool;
	return this;
end

function getInfo(this)
	return this.info;
end

function clickAt(this,x,y)
	if x>=this.info.x and x<= this.info.x+this.info.sizeX-1 and y>=this.info.y and y<= this.info.y+this.info.sizeY-1 and this.info.visible then
		this.info.onClick();
	end
end

function setOnClick(this,oncl)
	this.info.onClick=oncl;
end

function onClick(this)
	this.info.onClick();
end

function draw(this)
	if this.info.visible then
		tX=this.info.x;
		tY=this.info.y;
		tX2=this.info.x+this.info.sizeX-1;
		tY2=this.info.y+this.info.sizeY;
		ok,err=pcall(Graphics.paintBox,tX,tY,tX2,tY2,this.info.bCol or colors.black);
		if not ok then print(err); return false; end
		ok,err=pcall(Graphics.writeTextCentered,tX,tX2,tY+(this.info.sizeY/2),this.info.text or "",this.info.tCol or colors.white);
		if not ok then print(err); return false; end
	end
	return true;
end