--revolutOS graphics library

--So i can auto update this
version=0;
build=3;

local p=paintutils;
local sX,sY=term.getSize();
local col=colors.black
local tcol=colors.gray;
local setTcol=function(c) term.setTextColor(c or tcol); tcol=c or tcol;end
local setBcol=function(c) term.setBackgroundColor(c or col); col=c or col;end
local cursorPos=function(x,y) term.setCursorPos(x,y); end
local drawPixelInternal=function(x,y) term.setCursorPos(x,y); term.write(" "); end
local round=function(num,idp) local mult=10^(idp or 0); if num>=0 then return math.floor(num*mult+0.5)/mult; else return math.ceil(num*mult-0.5)/mult end end
local getHex=function(color) return string.format("%X",math.floor(math.log(color)/math.log(2))); end
local getDecimal=function(hexRepresentation) return math.pow(2,tonumber(hexRepresentation,16)); end

paintFullScreen=function(color)
	setBcol(color);
	for y=1,sY,1 do
		p.drawLine(1,y,sX,y,col);
	end
	return true;
end

line=function(x1,y1,x2,y2,color)
	setBcol(color);
	p.drawLine(x1,y1,x2,y2,col);
end

paintBox=function(x1,y1,x2,y2,color)
	if x2<=x1 or y2<=y1 then return false; end
	setBcol(color);
	for y=y1,y2-1 do
		line(x1,y,x2,y,col);
	end
	return true;
end

paintSizedBorder=function(x1,y1,x2,y2,color)
	if x2<=x1 or y2<=y1 then return false; end
	setBcol(color);
	line(x1,y1,x2,y1);
	line(x1,y2,x2,y2);
	line(x1,y1+1,x1,y2-1);
	line(x2,y1+1,x2,y2-1);
	return true;
end

paintBorder=function(color)
	if paintSizedBorder(1,1,sX,sY,color) then return true; end
	return false;
end

paintRightPanel=function(width,depth,color)
	if paintBox(sX-width+1,1,sX,depth,color) then return true; end
	return false;
end

paintLeftPanel=function(width,depth,color)
	if paintBox(1,1,width-1,depth,color) then return true; end
	return false;
end

paintNamedLeftPanel=function(width,depth,name,color,topColor,textColor)
	if #name>width then return false; end
	setTcol(textColor);
	paintLeftPanel(width,depth,color);
	setBcol(topColor);
	line(1,1,width-1,1);
	cursorPos(1,1);
	write(name);
	return true;
end

paintNamedRightPanel=function(width,depth,name,color,topColor,textColor)
	if #name>width then return false; end
	setTcol(textColor);
	paintRightPanel(width,depth,color);
	setBcol(topColor);
	line(sX-width+1,1,sX,1);
	writeTextCentered(sX-width,sX,1,name);
	return true;
end

writeTextCentered=function(x1,x2,y,text,tCol)
	setTcol(tCol);
	if #text>x2-x1 then error("Text %(Length "..tostring(#text).."%)is longer than "..x2-x1); end
	cursorPos(1+x1+((x2-x1)-#text)/2,y);
	write(text);
end

function paintImage(tImage,xPos,yPos)
	for y=1,#tImage do
		local tLine=tImage[y];
		for x=1,#tLine do
			if tLine[x]>0 then
				term.setBackgroundColor(tLine[x]);
				drawPixelInternal(x+xPos-1,y+yPos-1);
			end
		end
	end
end