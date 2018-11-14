if !PLAYLIB then return end

PLAYLIB.doorlock = PLAYLIB.doorlock or {}
if SERVER then

elseif CLIENT then

end

PLAYLIB.doorlock.lockGroup = {"Polizei"}
PLAYLIB.doorlock.lockTeams = {"Banker","SWAT","Miami Police Departement"}