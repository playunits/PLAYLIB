if !PLAYLIB then return end

PLAYLIB.lockdown = PLAYLIB.lockdown or {}

--[[
	Language:
	PLAYLIB.lockdown.prefix = The Prefix in front of the Chat Message
	PLAYLIB.lockdown.PanelTitle = The Title of the Panel displayed in the Center of the Screen
	PLAYLIB.lockdown.PanelText = The Text displayed beneath the PanelTitle. The More Entries you add to the Table the bigger the Panel gets.
	PLAYLIB.lockdown.BeginChatText = The Text to display when the Lockdown starts
	PLAYLIB.lockdown.EndChatText = The Text to display when the Lockdown ends
	PLAYLIB.lockdown.NotAllowed = The Text to display when a Person is not allowed to use the Command.
]]--
PLAYLIB.lockdown.prefix = "Emergency"
PLAYLIB.lockdown.PanelTitle = "EMERGENCY!"
PLAYLIB.lockdown.PanelText = {
	"This Base is currently under Attackt! Go to your Positions and return Fire!",
} 
PLAYLIB.lockdown.BeginChatText = "This Base is currently under Attack!"
PLAYLIB.lockdown.EndChatText = "The Base has been Secured"
PLAYLIB.lockdown.NotAllowed = "You are not allowed to use this Command!"

--[[
	Colors:
	PLAYLIB.lockdown.PrefixColor = The Color of the Prefix that is displayed in the Text
	PLAYLIB.lockdown.HighlightColor = The Color that is used in "Highlighted" Parts. (ex.: The PanelTitle,PanelText)
	PLAYLIB.lockdown.BasePanelColor = The Color of the Panel displayed in the Screen Center.
]]--
PLAYLIB.lockdown.PrefixColor = Color(250,128,114)
PLAYLIB.lockdown.HiglightColor = Color(255,0,0)
PLAYLIB.lockdown.BasePanelColor = Color(0,0,0,255)

--[[
	Sound:
	PLAYLIB.lockdown.BeginSound = The Sound to play when the Lockdown Starts.
]]--
PLAYLIB.lockdown.BeginSound = "hp/sky_battle.mp3"

--[[
	Commands:
	PLAYLIB.lockdown.StartLockdownCommand = The Text to enter in order to start the Lockdown.
	PLAYLIB.lockdown.EndLockdownCommand = The Text to enter in order to stop the Lockdown.
]]--
PLAYLIB.lockdown.StartLockdownCommand = "/startlockdown"
PLAYLIB.lockdown.EndLockdownCommand = "/endlockdown"

--[[
	The Teams that should be able to start and stop Lockdowns
]]--
PLAYLIB.lockdown.AllowedTeams = {
	TEAM_CIVLIAN,
	TEAM_MAYOR
}

--[[
	The Usergroups/Ranks that should be allowed to start and stop lockdowns
]]--
PLAYLIB.lockdown.AllowedRanks = {
	"owner",
	"superadmin"
}

--[[
	Should you need the Usergroup/Rank and the Job to Start/Stop a Lockdown?
]]--
PLAYLIB.lockdown.StrictHandling = false

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

end