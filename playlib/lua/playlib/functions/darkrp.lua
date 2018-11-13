if !PLAYLIB then return end

PLAYLIB.darkrp = PLAYLIB.darkrp or {}

if SERVER then -- Serverside Code here
    
elseif CLIENT then -- Clientside Code here
    
end

-- Shared Code below here

function PLAYLIB.darkrp.setname(ply,name)
    if !DarkRP then return end
    
    ply:SetRPName(name)
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