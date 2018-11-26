if !PLAYLIB then return end

PLAYLIB.lockdown = PLAYLIB.lockdown or {}

PLAYLIB.lockdown.prefix = "Emergency"
PLAYLIB.lockdown.HiglightColor = Color(255,0,0)
PLAYLIB.lockdown.BasePanelColor = Color(0,0,0,255)

PLAYLIB.lockdown.AllowedTeams = {
	TEAM_CIVLIAN
}

PLAYLIB.lockdown.AllowedRanks = {
	"owner",
	"superadmin"
}

PLAYLIB.lockdown.PanelTitle = "EMERGENCY!"
PLAYLIB.lockdown.PanelText = {
	"This Base is currently under Attackt! Go to your Positions and return Fire!",
} 
PLAYLIB.lockdown.BeginChatText = "This Base is currently under Attack!"
PLAYLIB.lockdown.BeginSound = "hp/sky_battle.mp3"

PLAYLIB.lockdown.EndChatText = "The Base has been Secured"

PLAYLIB.lockdown.StartLockdownCommand = "/startlockdown"
PLAYLIB.lockdown.EndLockdownCommand = "/endlockdown"
PLAYLIB.lockdown.NotAllowed = "You are not allowed to use this Command!"


PLAYLIB.lockdown.StrictHandling = false

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

end