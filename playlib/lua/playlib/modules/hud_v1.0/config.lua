if !PLAYLIB then return end

PLAYLIB.hud = PLAYLIB.hud or {}

PLAYLIB.hud.moneyPrefix = "Credits :"
PLAYLIB.hud.teamPrefix = "Team :"

PLAYLIB.hud.wallet = Material("materials/modules/hud/bank-building.png")
PLAYLIB.hud.job = Material("materials/modules/hud/portfolio.png")
PLAYLIB.hud.name = Material("materials/modules/hud/user-name.png")
PLAYLIB.hud.armor = Material("materials/modules/hud/bulletproof-vest.png")
PLAYLIB.hud.health = Material("materials/modules/hud/cardiogram.png")

if SERVER then
	
elseif CLIENT then

end