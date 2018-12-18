if !PLAYLIB then return end

PLAYLIB.uptime = PLAYLIB.uptime or {}

PLAYLIB.uptime.timeBeforeMessage = (3600*10)--Time in Seconds
PLAYLIB.uptime.messageInterval = (60*10) --Time in Seconds
PLAYLIB.uptime.Message = "Der Server ist seit %time online. Es wird ein Maprestart empfohlen!"


if SERVER then

	PLAYLIB.chatcommand.addCommand("!uptime",function(ply)
		PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.chatcommand.PrefixColor,PLAYLIB.chatcommand.Prefix,Color(255,255,255),"] - ".."Der Server ist seit "..PLAYLIB.uptime.getTime().." Online!"})
	end)
	
elseif CLIENT then
	
end