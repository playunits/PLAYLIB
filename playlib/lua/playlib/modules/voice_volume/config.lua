if !PLAYLIB then return end
--Icons made by https://www.flaticon.com/authors/chris-veigt

PLAYLIB.voice_volume = PLAYLIB.voice_volume or {}

local meter = 53 --ca. 53 Units = 1 Meter

PLAYLIB.voice_volume.incrementKey = KEY_G
PLAYLIB.voice_volume.buttonPressDelay = 3

PLAYLIB.voice_volume.Prefix = "PLAYLIB"
PLAYLIB.voice_volume.PrefixColor = Color(250,128,114)


PLAYLIB.voice_volume.volumeSettings = {

	[4] = {"Schreien",meter*12,Material("materials/modules/voice_volume/laut.png")},
	[3] = {"Normal",meter*10,Material("materials/modules/voice_volume/normal.png")},
	[2] = {"Leise",meter*6,Material("materials/modules/voice_volume/leise.png")},
	[1] = {"Flüstern",meter*3,Material("materials/modules/voice_volume/fluestern.png")},
}

PLAYLIB.voice_volume.standardVolume = 3

PLAYLIB.voice_volume.changeNotification = "Deine Lautstärke wurde zu %volume geändert!"
PLAYLIB.voice_volume.changeMessage = "Deine Lautstärke wurde zu %volume geändert!"

PLAYLIB.voice_volume.showCircleWhenNotTalking = true

if SERVER then -- Serverside Code here

elseif CLIENT then
	PLAYLIB.voice_volume.iconPos = {
		["X"] = (ScrW()/4),
		["Y"] = ScrH() - (ScrH()/22)
	}

	PLAYLIB.voice_volume.iconSize = {
		["W"] = 48,
		["H"] = 48
	}

	PLAYLIB.voice_volume.talkIndicatorPos = {
		["X"] = ScrW() - (ScrW()/4),
		["Y"] = ScrH() - (ScrH()/45),
	}
end
