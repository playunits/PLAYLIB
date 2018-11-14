if !PLAYLIB then return end

PLAYLIB.darkrp = PLAYLIB.darkrp or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

function PLAYLIB.darkrp.setname(ply,name)
    if !DarkRP then return end
    
    ply:setDarkRPVar("rpname",name)
end

function PLAYLIB.darkrp.money(ply,amount,set)
    if !DarkRP then return end
    
    if !set then
        ply:AddMoney(amount)
    elseif set then
        ply:AddMoney((ply:getDarkRPVar("money")*-1))
        ply:AddMoney(amount)
    end
end

function PLAYLIB.darkrp.getJobsFromCategory(category)
    if !DarkRP then return end

    local retval = {}
    for index,job in pairs(RPExtraTeams) do
        if job.category == category then
            table.insert(retval,job)
        end
    end
    return retval
end

function PLAYLIB.darkrp.numberToTeamName(number)
    return RPExtraTeams[number].name or ""
end

function PLAYLIB.darkrp.teamNameToNumber(name)
    for index,info in pairs(RPExtraTeams) do
        if info.name == name then
            return info.team
        end
    end

    return nil
end

function PLAYLIB.darkrp.changeJob(ply,team)
    if type(team) == "number" then
        ply:changeTeam(team,true,true)
    else
        ply:changeTeam(PLAYLIB.darkrp.teamNameToNumber(team),true,true)
    end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:setName(name)
    PLAYLIB.darkrp.setname(self,name)
end

function PLAYER:addMoney(amount)
    PLAYLIB.darkrp.money(self,amount,false)
end

function PLAYER:setMoney(amount)
    PLAYLIB.darkrp.money(self,amount,true)
end

function PLAYER:setJob(team)
    PLAYLIB.darkrp.changeJob(self,team)
end