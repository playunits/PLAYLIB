if !PLAYLIB then return end

PLAYLIB.logger = PLAYLIB.logger or {}

--[[
	Language:
	PLAYLIB.chatcommand.Prefix = The Prefix displayed in the Chat, on execution of the Command.
	PLAYLIB.chatcommand.PrefixColor = The Color of the displayed Prefix.	
]]--
PLAYLIB.logger.Prefix = "PLAYLIB"
PLAYLIB.logger.PrefixColor = Color(250,128,114)

if SERVER then -- Serverside Code here
	PLAYLIB.logger.newLogFileAfter = 3600*6 -- In Seconds
	PLAYLIB.logger.debug = false
    
elseif CLIENT then -- Clientside Code here

end