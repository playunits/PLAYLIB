if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then

	local PLAYER = FindMetaTable("Player")

	function PLAYER:CharAmount()
		return PLAYLIB.charsystem.getPlayerCharAmount(self)
	end

	function PLAYER:SetData(name,money,team)
		PLAYLIB.charsystem.setPlayerData(self,name,money,team)
	end

	function PLAYER:GetData()
		return PLAYLIB.charsystem.getPlayerData(self)
	end

	function PLAYER:SetID(id)
		self:SetNWInt("playlib_characters_id",id)
	end

	function PLAYER:GetID()
		self:GetNWInt("playlib_characters_id",-1)
	end

	function PLAYER:SaveCharacter()
		PLAYLIB.charsystem.saveCharacter(self)
	end

	function PLAYER:LoadChar(id)
		PLAYLIB.charsystem.loadCharacter(self,id)
	end

	function PLAYER:UnloadChar()
		PLAYLIB.charsystem.unloadCharacter(self)
	end

	function PLAYER:GetCharacters()
		PLAYLIB.charsystem.getCharacters(self:SteamID64())
	end

	function PLAYER:MaxChars()
		PLAYLIB.charsystem.allowedCharAmount(self)
	end

	function PLAYER:FreeChars()
		return PLAYLIB.charsystem.freeChars(self)
	end

elseif CLIENT then

  function PLAYLIB.charsystem.getPlayerCharAmount(ply)
    return #LocalPlayer().Characters
  end

  function PLAYLIB.charsystem.getPlayerData(ply)
		return ply:getDarkRPVar("rpname"),ply:getDarkRPVar("money"),ply:Team(),
	end

  function PLAYLIB.charsystem.getCharacters()
    return LocalPlayer().Characters
  end

  function PLAYLIB.charsystem.allowedCharAmount(ply)
    if PLAYLIB.charsystem.UsergroupSettings[ply:GetUserGroup()] == nil then
			return PLAYLIB.charsystem.StandardCharSlots
		end

		return PLAYLIB.charsystem.UsergroupSettings[ply:GetUserGroup()]
  end

  function PLAYLIB.charsystem.freeChars(ply)
		local chars = ply:CharAmount()
		local max = ply:MaxChars()

		return (max-chars)
	end

  local PLAYER = FindMetaTable("Player")

  function PLAYER:CharAmount()
		return PLAYLIB.charsystem.getPlayerCharAmount(self)
	end

  function PLAYER:GetData()
    return PLAYLIB.charsystem.getPlayerData(self)
  end

  function PLAYER:GetID()
		self:GetNWInt("playlib_characters_id",-1)
	end

  function PLAYER:GetCharacters()
		return PLAYLIB.charsystem.getCharacters()
	end

  function PLAYER:MaxChars()
		PLAYLIB.charsystem.allowedCharAmount(self)
	end

	function PLAYER:FreeChars()
		return PLAYLIB.charsystem.freeChars(self)
	end

end
