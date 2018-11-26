if !PLAYLIB then return end

PLAYLIB.chatcommand = PLAYLIB.chatcommand or {}

PLAYLIB.chatcommand.Prefix = "PLAYLIB"

if SERVER then -- Serverside Code here
    -- Variables %pname = Name of sending Player
    PLAYLIB.chatcommand.addCommand("!workshop","Kollektion: <url>https://google.de</url>")
    PLAYLIB.chatcommand.addCommand("!lulz","Much lulz for %pname!")
elseif CLIENT then -- Clientside Code here

end