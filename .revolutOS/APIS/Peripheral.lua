--Peripheral API for revolutOS

version=0.1;
build=1;

function getPeripherals()
	local per={};
	for n,s in pairs(rs.getSides()) do
		if peripheral.isPresent(s) then
			y={name=peripheral.getType(s),side=s};
			if y.name=="modem" then
				y.name=(function() if peripheral.call(y.side,"isWireless") then return "wireless_modem"; end return "wired_modem";  end)();
			end
			table.insert(per,y);
		end
	end
	return per
end

function getPeripheralSide(periph)
	per=getPeripherals();
	for k,v in pairs(per) do
		if v.name==periph then
			return v.side;
		elseif periph=="modem" then
			if v.name=="wireless_modem" or v.name=="wired_modem" then
				return v.side;
			end
		end
	end
	return nil;
end

function hasPeripheral(periph)
	for t,v in pairs(getPeripherals()) do
		if v.name==periph then
			return true;
		elseif periph=="modem" then
			if v.name=="wireless_modem" or v.name=="wired_modem" then
				return true;
			end
		end
	end
	return false;
end

function getPeripheral(periph)
	if not hasPeripheral(periph) then return nil; end
	return peripheral.wrap(getPeripheralSide(periph));
end

function call(t,...)
	if not hasPeripheral(t) then return nil; end
	local args={...};
	local p=getPeripheral(t);
	return peripheral.call(p.side,unpack(args));
end