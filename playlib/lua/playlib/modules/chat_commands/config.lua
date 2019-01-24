if !PLAYLIB then return end

PLAYLIB.chatcommand = PLAYLIB.chatcommand or {}

--[[
	Language:
	PLAYLIB.chatcommand.Prefix = The Prefix displayed in the Chat, on execution of the Command.
	PLAYLIB.chatcommand.PrefixColor = The Color of the displayed Prefix.	
]]--
PLAYLIB.chatcommand.Prefix = "PLAYLIB"
PLAYLIB.chatcommand.PrefixColor = Color(250,128,114)

if SERVER then -- Serverside Code here
    --[[
		Adding Commands: (This has to be done Serverside!)



		Parameters: 
			1. String - The Text to enter in order to execute the command.
			2. String or function
				String - The text to reply in the Text. %pname is going to be replaced by the Executing Players Name.
				function - The function to execute. Has the executing Player as an Argument

    ]]--
    --PLAYLIB.chatcommand.addCommand("!workshop",function(ply) PLAYLIB.workshop.showWorkshopPanel(ply,false) end)
    --PLAYLIB.chatcommand.addCommand("!lulz","Much lulz for %pname!")
    
elseif CLIENT then -- Clientside Code here

end