--revolutOS graphics library

--[[
	functions to add:
	paintSlidingBox
	paintSlidingText
]]

--So i can auto update this
version=0.1;
build=3;

local p=paintutils;
local sX,sY=term.getSize();
local col=colors.black
local tcol=colors.gray;
local setTcol=function(c) term.setTextColor(c or tcol); tcol=c or tcol;end
local setBcol=function(c) term.setBackgroundColor(c or col); col=c or col;end
local cursorPos=function(x,y) term.setCursorPos(x,y); end
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

paintSlidingLine=function(x,y,length,timea,color)
	setBcol(color);
	c=function()
		l=length/timea;
		for i=1,timea do
			line(x,y,x+(l*i),y);
			sleep(0.05);
		end
	end
	l=coroutine.create(c);
	coroutine.resume(l);
	return true;
end

writeTextCentered=function(x1,x2,y,text,tCol)
	setTcol(tCol);
	if #text>x2-x1 then error("Text %(Length "..tostring(#text).."%)is longer than "..x2-x1); end
	cursorPos(1+x1+((x2-x1)-#text)/2,y);
	write(text);
end

clear=function()
	oCol=col;
	paintFullScreen(colors.black);
	setBcol(oCol);
end

restore=function()
	for x=1,sX do
		for y=1,sY do
			if scr[x][y][bg] then
				p.drawPixel(x,y,getDecimal(scr[x][y][bg]));
			end
			cursorPos(x,y);
			setTcol(scr[x][y][tc]);
			write(scr[x][y][tx]);
		end
	end
end