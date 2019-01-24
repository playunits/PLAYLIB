if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then

  local PLAYER = FindMetaTable("Player")

  function PLAYER:SetCurCharID(id)
    PLAYLIB.charsystem:SetCurCharID(self,id)
  end

  function PLAYER:GetCurCharID()
    return PLAYLIB.charsystem:GetCurCharID(self)
  end

elseif CLIENT then

end
