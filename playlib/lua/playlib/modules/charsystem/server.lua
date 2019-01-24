if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then
  timer.Simple(1,function()
    PLAYLIB.chatcommand.addCommand("!chars",function(ply,cmd,msg)
        PLAYLIB.charsystem:Sync(ply)
        net.Start("PLAYLIB.charsystem::OpenCharacterMenu")
        net.Send(ply)
    end)
  end)

  function PLAYLIB.charsystem:CreateCharacter(server,ply,name,team)
    if server then
      self:CreateEntry(name,self.config.StartingMoney,ply:SteamID64(),team)

      timer.Simple(1,function()
        local data = self:GetMatchingNameEntries(name)
        PLAYLIB.charsystem:OnCharacterCreation(ply,data)
        PLAYLIB.charsystem:Sync(ply)
      end)
    else
      local allowed = PLAYLIB.charsystem:CanCreateCharacter(ply,name,team)

      if allowed then

        self:CreateEntry(name,self.config.StartingMoney,ply:SteamID64(),team)

        timer.Simple(1,function()
          local data = self:GetMatchingNameEntries(name)
          PLAYLIB.charsystem:OnCharacterCreation(ply,data)
          PLAYLIB.charsystem:Sync(ply)
        end)

      else
        PLAYLIB.charsystem:OnCharacterCreationFailed(ply,name,team)
      end
    end

  end



  function PLAYLIB.charsystem:RemoveCharacter(server,ply,id)

    if server then
      local data = self:GetMatchingIDEntries(id)
      self:RemoveEntry(id)
      PLAYLIB.charsystem:Sync(ply)
      PLAYLIB.charsystem:OnCharacterRemoval(ply,data)
    else
      local allowed = PLAYLIB.charsystem:CanRemoveCharacter(ply,id)
      if allowed then
        local data = self:GetMatchingIDEntries(id)
        self:RemoveEntry(id)
        PLAYLIB.charsystem:Sync(ply)
        PLAYLIB.charsystem:OnCharacterRemoval(ply,data)
      else
        PLAYLIB.charsystem:OnCharacterRemovalFailed(ply,id)
      end
    end
  end



  function PLAYLIB.charsystem:EditCharacter(server,ply,id,data)

    if server then
      local old_data = PLAYLIB.charsystem:GetMatchingIDEntries(id)
      local new_data = table.Merge(old_data,data) --table.Merge(data,old_data)

      self:AlterEntry(id,new_data.name,new_data.money,new_data.team,new_data.last_played)
      PLAYLIB.charsystem:OnServerCharacterEdit(id,old_data,new_data)
    else
      local allowed = PLAYLIB.charsystem:CanEditCharacter(ply,id,data)

      local old_data = PLAYLIB.charsystem:GetMatchingIDEntries(id)
      local new_data = table.Merge(old_data,data)
      if allowed then
        self:AlterEntry(id,new_data.name,old_data.money,old_data.team,old_data.last_played)
        PLAYLIB.charsystem:OnClientCharacterEdit(ply,id,old_data,new_data)
        PLAYLIB.charsystem:Sync(ply)
      else
        PLAYLIB.charsystem:OnClientCharacterEditFailed(ply,id,actual_data,attempted_data)
      end

    end

  end

  function PLAYLIB.charsystem:GetCurCharID(ply)
    return ply:GetNWInt("PLAYLIB.charsystem.ID",-1)
  end

  function PLAYLIB.charsystem:SetCurCharID(ply,id)
    ply:SetNWInt("PLAYLIB.charsystem.ID",id)
  end


  function PLAYLIB.charsystem:LoadCharacter(ply,id)
    if not id or id == -1 then return end
    local data = self:GetMatchingIDEntries(id)

    if not data then return end
    if not data.id == id then return end
    if not data.steamid64 == ply:SteamID64() then return end

    PLAYLIB.charsystem:PreCharChange(ply,data.id,data.name,data.money,data.team,data.last_played)

    ply:setDarkRPVar("rpname",data.name)
    ply:setDarkRPVar("money",data.money)
    ply:changeTeam(tonumber(data.team),true)
    ply:SetCurCharID(id)

    ply:Spawn()

    PLAYLIB.charsystem:EditCharacter(true,ply,ply:GetCurCharID(),{["last_played"]=os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )})

  end

  function PLAYLIB.charsystem:UnloadCharacter(ply)

    PLAYLIB.charsystem:EditCharacter(true,ply,ply:GetCurCharID(),{["last_played"]=os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )})
    ply:setDarkRPVar("rpname",ply:SteamName())
    ply:setDarkRPVar("money",-1)
    ply:changeTeam(GAMEMODE.DefaultTeam,true,true)
    ply:SetCurCharID(-1)
  end


  function PLAYLIB.charsystem:GetPlayerCharacters(ply)
    return PLAYLIB.charsystem:GetMatchingSID64Entries(ply:SteamID64())
  end

  function PLAYLIB.charsystem:PlayerExceedsCharacterLimit(ply)
    if not PLAYLIB.charsystem:GetPlayerCharacters(ply) then return false end
    if #PLAYLIB.charsystem:GetPlayerCharacters(ply) >= PLAYLIB.charsystem.config.CharacterLimit then
      return true
    else
      return false
    end
  end


elseif CLIENT then

end
