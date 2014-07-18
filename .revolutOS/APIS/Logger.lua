--Logger for revolutOS

verison=0.1;
build=1;
file=".revolutOS/log.txt";
sTime=0;
ln="\n";

fs.makeDir(".revolutOS");

new=function()
	sTime=os.time();
	f=fs.open(file,"w");
	f.write("File beginning at "..tostring(sTime)..ln);
	f.close();
end

log=function(message)
	nTime=os.time();
	f=fs.open(file,"a");
	f.write("["..nTime-sTime.."] "..message..ln);
	f.close();
end

e=function(message)
	nTime=os.time();
	f=fs.open(file,"a");
	f.write("\n\nBEGIN ERROR REPORT\n\n");
	f.write("["..nTime-sTime.."] "..message..ln);
	f.write("\nEND ERROR REPORT\n\n");
	f.close();
end