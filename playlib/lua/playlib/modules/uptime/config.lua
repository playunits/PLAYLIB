if !PLAYLIB then return end

--[[
	Dependencies:

		-Modules:

			-chatcommands

]]--

PLAYLIB.uptime = PLAYLIB.uptime or {}
--[[
	The time in  Seconds before the Message is displayed.

	Reference:

	1 Minute = 60 Seconds
	1 Hour = 3600 Seconds

	Example:

	10 Hours = 3600 * 10
	10 Minutes = 60 * 10
]]--
PLAYLIB.uptime.timeBeforeMessage = (3600*10)
--[[
	When the Online Time of above is hit, it will message every x Seconds.
]]--
PLAYLIB.uptime.messageInterval = (60*10)
--[[
	The Message to display every x Seconds (PLAYLIB.uptime.messageInterval)
]]--
PLAYLIB.uptime.Message = "Der Server ist seit %time online. Es wird ein Maprestart empfohlen!"


PLAYLIB.uptime.Prefix = "PLAYLIB"
PLAYLIB.uptime.PrefixColor = Color(250,128,114)

--[[

	DO NOT REMOVE OR EDIT THIS PART BELOW!!!

]]--
if SERVER then

	PLAYLIB.chatcommand.addCommand("!uptime",function(ply)
		PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.uptime.PrefixColor,PLAYLIB.uptime.Prefix,Color(255,255,255),"] - ".."Der Server ist seit "..PLAYLIB.uptime.getTime().." Online!"})
	end)

elseif CLIENT then

end
