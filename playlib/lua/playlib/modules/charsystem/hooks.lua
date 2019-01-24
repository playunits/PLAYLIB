if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then

  hook.Add("Initialize","PLAYLIB.charsystem::InitializeDatabase",function()
    PLAYLIB.charsystem:InitializeDatabase()
  end)

  function PLAYLIB.charsystem:OnCharacterCreation(ply,data)
    PLAYLIB.charsystem:log(ply:Name().."("..ply:SteamID64()..") created Character with ID: "..data.id)
  end

  function PLAYLIB.charsystem:OnCharacterCreationFailed(ply,name,team)
    PLAYLIB.charsystem:log(ply:Name().."("..ply:SteamID64()..") failed at creating Character with Attributes: Name - "..name.." | Team - "..team)
  end

  function PLAYLIB.charsystem:CanCreateCharacter(ply,name,team)
    if self:PlayerExceedsCharacterLimit(ply) then return false end

    return true
  end

  function PLAYLIB.charsystem:CanRemoveCharacter(ply,id)
    local data = PLAYLIB.charsystem:GetMatchingIDEntries(id)

    if not data then return false end
    if not data.id == id then return false end

    if not ply:SteamID64() == data.steamid64 then return false end

    return true

  end

  function PLAYLIB.charsystem:OnCharacterRemoval(ply,data)
    PLAYLIB.charsystem:log(ply:Name().."("..ply:SteamID64()..") successfully removed Char with: ID - "..data.id.." | Name - "..data.name.." | Money - "..data.money.." | Team - "..data.team.." | SteamID64 - "..data.steamid64.." | Creation Date - "..data.creation_date.." | Last Played - "..data.last_played)
  end

  function PLAYLIB.charsystem:OnCharacterRemovalFailed(ply,id)
    PLAYLIB.charsystem:log(ply:Name().."("..ply:SteamID64()") tried, but not succeeded, to remove Entry with ID - "..id)
  end

  function PLAYLIB.charsystem:CanEditCharacter(ply,id,data)
    local old_data = PLAYLIB.charsystem:GetMatchingIDEntries(id)

    if not old_data then return false end
    if not old_data.id then return false end
    if not ply:SteamID64() == data.steamid64 then return false end

    return true
  end

  function PLAYLIB.charsystem:OnServerCharacterEdit(id,old_data,new_data)
    PLAYLIB.charsystem:log("Charakter "..id.." wurde geändert! Alte Daten: "..PLAYLIB.table.tableToString(old_data).." - Neue Daten: "..PLAYLIB.table.tableToString(new_data))
  end

  function PLAYLIB.charsystem:OnClientCharacterEdit(ply,id,old_data,new_data)
    PLAYLIB.charsystem:log(ply:Name().."("..ply:SteamID64()..") hat Charakter "..id.." bearbeitet! Alte Daten: "..PLAYLIB.table.tableToString(old_data).." - Neue Daten: "..PLAYLIB.table.tableToString(new_data))
  end

  function PLAYLIB.charsystem:OnClientCharacterEditFailed(ply,id,actual_data,attempted_data)
    PLAYLIB.charsystem:log(ply:Name().."("..ply:SteamID64()..") attempted, but did not succeeded, to edit Character Data of "..id.." ! Current Data: "..PLAYLIB.table.tableToString(attempted_data).." - Attempted Change Data: ")
  end

  function PLAYLIB.charsystem:PreCharChange(ply,id,name,money,team,last_played)
    if ply:GetCurCharID() == -1 then return end
    PLAYLIB.charsystem:EditCharacter(true,ply,ply:GetCurCharID(),{["last_played"]=os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )})
  end

  hook.Add("PlayerInitialSpawn","PLAYLIB.charsystem::StandardSpawnValues",function(ply)
    PLAYLIB.charsystem:SetCurCharID(ply,-1)
  end)






elseif CLIENT then

end
