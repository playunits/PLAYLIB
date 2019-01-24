if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then
	util.AddNetworkString("PLAYLIB::Test")

	util.AddNetworkString("PLAYLIB.Charsystem::Load")
	util.AddNetworkString("PLAYLIB.Charsystem::Unload")
	util.AddNetworkString("PLAYLIB.Charsystem::DrawUI")
	util.AddNetworkString("PLAYLIB.Charsystem::EditCharacter")
	util.AddNetworkString("PLAYLIB.Charsystem::CreateCharacter")
	util.AddNetworkString("PLAYLIB.Charsystem::RemoveCharacter")
	util.AddNetworkString("PLAYLIB.Charsystem::Sync")

	PLAYLIB.logger.addLogger("charsystem")

	PLAYLIB.chatcommands.addCommand("!test",function(ply,cmd,text)
		PLAYLIB.charsystem.syncChars(ply)
		net.Start("PLAYLIB::Test")
				net.WriteTable(PLAYLIB.charsystem.getPlayerChars(ply:SteamID64()) or {})
		net.Send(ply)
	end)

	net.Receive("PLAYLIB::LoadChar",function(len,ply)
		PLAYLIB.charsystem.useChar(ply,net.ReadFloat())
	end)

	net.Receive("PLAYLIB::CreateNewCharacter",function(len,ply)
		local name = net.ReadString()
		if !string.match(name, "^[a-zA-ZЀ-џ0-9]+$") then
			PLAYLIB.misc.notify(ply,"Dein Charaktername enthält unerlaubte Zeichen!",3,10)
		elseif #name > 20 then
			PLAYLIB.misc.notify(ply,"Dein Charaktername darf maximal 20 Zeichen lang sein!",3,10)
		else
			ply:ChatPrint("Reached Character Creation")
			PLAYLIB.charsystem.createCharacter(ply:SteamID64(),PLAYLIB.sql.sqlStr(false,name))
			PLAYLIB.charsystem.syncChars(ply)
			net.Start("PLAYLIB::ShowCharUI")
			net.Send(ply)
		end
	end)

	function PLAYLIB.charsystem.InitializeDatabase()
			local queryString = [[CREATE TALE IF NOT EXISTS playlib_characters (
				id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
				sid varchar(20) NOT NULL,
				name varchar(40) NOT NULL,
				money BIGINT NOT NULL,
				team INTEGER NOT NULL,
				creation_date varchar(19) NOT NULL
				);
			]]
			PLAYLIB.sql.query(false,queryString,function(res)
				PLAYLIB.logger.log("charsystem","Database Created or already existed!")
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Database Created or already existed!\n")
			end,function(error)
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Beim erstellen des SQLite Tables ist ein Error aufgetreten!\n")
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Error: "..error.."\n")
				PLAYLIB.logger.log("charsystem","Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
				PLAYLIB.logger.log("charsystem","Error: "..error)
			end)
	end

	function PLAYLIB.charsystem.createCharacter(ply,name,team)
		local creator_name = ply:Name()
		local creator_sid = ply:SteamID64()
		local create_date = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
		local queryString = "INSERT INTO playlib_characters (sid,name,money,team,creation_date) VALUES ('"..ply:SteamID64().."','"..name.."',"..PLAYLIB.charsystem.StartMoney..","..team..",'"..create_date.."');"

		PLAYLIB.sql.query(false,queryString,function(res)
				MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] "..ply:Name().."("..ply:SteamID64()..") hat sich einen neuen Charakter mit dem Namen:'"..name.."' und dem Team:'"..team.."' erstellt!\n")
				PLAYLIB.logger.log("charsystem",ply:Name().."("..ply:SteamID64()..") hat sich einen neuen Charakter mit dem Namen:'"..name.."' und dem Team:'"..team.."' erstellt!")
		end,function(error)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] [ERROR] "..ply:Name().."("..ply:SteamID64()..") hat versucht sich einen Charakter mit dem Namen:'"..name.."' und dem Team:'"..team.."' zu erstellen!\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] [ERROR] Error: "..error)
			PLAYLIB.logger.log("charsystem",ply:Name().."("..ply:SteamID64()..") hat versucht sich einen Charakter mit dem Namen:'"..name.."' und dem Team:'"..team.."' zu erstellen!")
			PLAYLIB.logger.log("charsystem","Error: "..error)
		end)

	end

	function PLAYLIB.charsystem.removeCharacter(id)
		local queryString = "DELETE FROM playlib_characters WHERE id="..id

		PLAYLIB.sql.query(false,queryString,function(res)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Succesfully removed Character with ID: "..id)
			PLAYLIB.logger.log("charsystem","Succesfully removed Character with ID: "..id)
		end,function(error)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] [ERROR] Error whilst removing Character with ID: "..id)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] [ERROR] Error: "..error)
			PLAYLIB.logger.log("charsystem","Error whilst removing Character with ID: "..id)
			PLAYLIB.logger.log("charsystem","Error: "..error)
		end)

	end

	function PLAYLIB.charsystem.editCharacter(id,steamid,name,money,team)
		local queryString = "UPDATE playlib_characters SET steamid='"..steamid.."', name='"..name.."', money="..money..", team="..team.." WHERE id ="..id
		PLAYLIB.sql.query(false,queryString,function(res)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] Succesfully edited Character with ID:"..id)
			PLAYLIB.logger.log("charsystem","Succesfully edited Character with ID: "..id)
		end,function(error)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] [ERROR] Error whilst editing Character with ID: "..id)
			MsgC(Color(255,255,255),"[",PLAYLIB.charsystem.PrefixColor,PLAYLIB.charsystem.Prefix,Color(255,255,255),"] [CHARSYSTEM] [ERROR] Error: "..error)
			PLAYLIB.logger.log("charsystem","Error editing removing Character with ID: "..id)
			PLAYLIB.logger.log("charsystem","Error: "..error)
		end)
	end

	function PLAYLIB.charsystem.getCharacter(id)
		local queryString = "SELECT * FROM playlib_characters WHERE id="..id
		local retval = {}
		PLAYLIB.sql.query(false,queryString,function(res)
			retval = res
		end,function(error)

		end)
		return retval
	end

	function PLAYLIB.charsystem.getCharacters(sid)
		local queryString = "SELECT * FROM playlib_characters WHERE sid='"..sid.."'"
		local retval = {}
		PLAYLIB.sql.query(false,queryString,function(res)
			retval = res
		end,function(error)

		end)
		return retval
	end

	function PLAYLIB.charsystem.allowedCharAmount(ply)
		return PLAYLIB.charsystem.UsergroupSettings[ply:GetUserGroup()] or PLAYLIB.charsystem.StandardCharSlots
	end

	function PLAYLIB.charsystem.getPlayerCharAmount(ply)
		local queryString = "SELECT COUNT(id) FROM playlib_characters WHERE sid='"..ply:SteamID64()"'"
		local number = -1
		PLAYLIB.sql.query(false,qzeryString,function(res)
			number = res[1]
		end,function(error)

		end)
		return number
	end

	function PLAYLIB.charsystem.setPlayerData(ply,name,money,team)
		ply:setDarkRPVar("rpname",name)
		ply:setDarkRPVar("money",money)
		ply:changeTeam(team,true,true)
	end

	function PLAYLIB.charsystem.getPlayerData(ply)
		return ply:getDarkRPVar("rpname"),ply:getDarkRPVar("money"),ply:Team(),
	end

	function PLAYLIB.charsystem.syncFromClientToDatabaseDirect(ply)
		local name,money,team = ply:GetData()
		local id = ply:GetID()
		PLAYLIB.charsystem.editCharacter(id,ply:SteamID64(),name,money,team)
	end

	function PLAYLIB.charsystem.syncFromDatabaseToClientDirect(ply)
		local data = PLAYLIB.charsystem.getCharacter(ply:GetID())
		ply:SetData(data.name,data.money,data.team)
	end

	function PLAYLIB.charsystem.saveCharacter(ply)
		PLAYLIB.charsystem.syncFromClientToDatabaseDirect(ply)
	end

	function PLAYLIB.charsystem.loadCharacter(ply,id)
		ply:SetID(id)
		PLAYLIB.charsystem.syncFromDatabaseToClientDirect(ply)
	end

	function PLAYLIB.charsystem.unloadCharacter(ply)
		ply:SetID(-1)
		ply:SetData(ply,ply:SteamName(),0,PLAYLIB.darkrp.teamNameToNumber(PLAYLIB.charsystem.StandardTeam))
	end

	function PLAYLIB.charsystem.freeChars(ply)
		local chars = ply:CharAmount()
		local max = ply:MaxChars()

		return (max-chars)
	end


	hook.Add("Initialize", "PLAYLIB.Charsystem::InitializeDatabase", function()
		PLAYLIB.charsystem.InitializeDatabase()
	end)

	hook.Add("PlayerInitialSpawn","PLAYLIB::StartCharID",function(ply)

	end)

	hook.Add("PlayerDisconnected","PLAYLIB.Charsystem::SaveCharacter",function(ply)
		ply:SaveCharacter()
	end)

	hook.Add("ShutDown","PLAYLIB.Charsystem::ShutdownProtection",function()
		for index,player in pairs(player.GetAll()) do
			player:SaveCharacter()
		end
	end)

	net.Receive("PLAYLIB.Charsystem::Sync",function(len,ply)
		net.Start("PLAYLIB.Charsystem::Sync")
			net.WriteTable(ply:GetCharacters())
		net.Send(ply)
	end)


elseif CLIENT then

end


function PLAYLIB.charsystem.createStandardDB()
	PLAYLIB.sql.query(false,"CREATE TABLE IF NOT EXISTS play_chars (id integer NOT NULL PRIMARY KEY AUTOINCREMENT,steamid varchar(17) NOT NULL,name varchar(40) NOT NULL,money BIGINT NOT NULL,team INTEGER NOT NULL)",
		function(res)
			MsgC( PLAYLIB.style.MainHighlightWindowColor, "[PLAYLIB] ",Color(255,255,255),"Database Succesfully created!\n" )
		end)
end

function PLAYLIB.charsystem.removeStandardDB()
		PLAYLIB.sql.query(false,"DROP TABLE IF EXISTS play_chars",
			function(res) MsgC( PLAYLIB.style.MainHighlightWindowColor, "[PLAYLIB] ",Color(255,255,255),"Database Succesfully removed!\n" ) end)
end

function PLAYLIB.charsystem.createCharacter(steamid64,name)
	print("PLAYLIB "..name)
	if #name > PLAYLIB.charsystem.MaxNameLength then return false end
	PLAYLIB.sql.query(false,"INSERT INTO play_chars (steamid,name,money,team) VALUES ('"..steamid64.."',"..name..","..PLAYLIB.charsystem.StartMoney..","..PLAYLIB.darkrp.teamNameToNumber(PLAYLIB.charsystem.StandardTeam)..")")
end

function PLAYLIB.charsystem.editCharacter(id,steamid,name,money,team)
	PLAYLIB.sql.query(false,"UPDATE play_chars SET steamid='"..steamid.."', name='"..name.."', money="..money..", team="..team.." WHERE id="..id)
end

function PLAYLIB.charsystem.removeCharacter(id)
	PLAYLIB.sql.query(false,"DELETE FROM play_chars WHERE id="..id)
end

function PLAYLIB.charsystem.characterAmount(steamid)
	local amount = 0
	PLAYLIB.sql.query(false,"SELECT * FROM play_chars WHERE steamid='"..steamid.."'",function(res) amount = #res end )
	return amount
end

function PLAYLIB.charsystem.getChar(id)
	local data = {}
	PLAYLIB.sql.query(false,"SELECT * FROM play_chars WHERE id="..id,function(res) if not res then data = nil else data = res end  end)
	return data
end

function PLAYLIB.charsystem.getPlayerChars(steamid)
	local allChars = {}
	PLAYLIB.sql.query(false,"SELECT * FROM play_chars WHERE steamid='"..steamid.."'",function(res) allChars = res end)
	return allChars
end

function PLAYLIB.charsystem.useChar(ply,id)
	local data = PLAYLIB.charsystem.getChar(id)[1]
	ply:setCharID(data.id)
	ply:setDarkRPVar("rpname",data.name)
	ply:setDarkRPVar("money",tonumber(data.money))
	ply:changeTeam( tonumber(data.team) ,true,true)
	ply:Spawn()
end

function PLAYLIB.charsystem.getAllChars()
	local data = {}
	PLAYLIB.sql.query(false,"SELECT * FROM play_chars",function(res) data = res end)
	return data
end

function PLAYLIB.charsystem.resetDatabase()
	PLAYLIB.charsystem.removeStandardDB()
	timer.Simple(2,function()
		PLAYLIB.charsystem.createStandardDB()
		MsgC( PLAYLIB.style.MainHighlightWindowColor, "[PLAYLIB] ",Color(255,255,255),"Database Succesfully reseted!\n" )
	end)

end

function PLAYLIB.charsystem.allowedCharAmount(ply)
	if PLAYLIB.charsystem.allowed3Characters[ply:GetUserGroup()] then
		return 3
	else
		return 2
	end
end

function PLAYLIB.charsystem.syncChars(ply)
	net.Start("PLAYIB::SyncChars")
		net.WriteTable(PLAYLIB.charsystem.getPlayerChars(ply:SteamID64()))
	net.Send(ply)
end

hook.Add("DarkRPDBInitialized", "PLAYLIB::CreateDarkRP", function()
	PLAYLIB.charsystem.createStandardDB()
end)

hook.Add("OnPlayerChangedTeam", "PLAYLIB::UpdatePlayerTeam", function(ply, before, after)
	if SERVER then
		if ply:getCharID() == -1 then
			return
		else
			local charData = PLAYLIB.charsystem.getChar(ply:getCharID())[1]
			PrintTable(charData)
			PLAYLIB.charsystem.editCharacter(charData.id,charData.steamid,charData.name,charData.money,after)
		end
	end
end)

hook.Add("PlayerInitialSpawn","PLAYLIB::StartCharID",function(ply)
	timer.Simple(2,function()
		ply:setCharID(-1)
		PLAYLIB.charsystem.syncChars(ply)
		net.Start("PLAYLIB::ShowCharUI")
			net.WriteTable(PLAYLIB.charsystem.getPlayerChars(ply:SteamID64()) or {})
		net.Send(ply)
	end)
end)

local PLAYER = FindMetaTable("Player")
function PLAYER:getCharID()
	return self:GetNWInt("play_char_id",-1)
end

function PLAYER:setCharID(id)
	self:SetNWInt("play_char_id",id)
end

function PLAYER:allowedCharAmount()
	return PLAYLIB.charsystem.allowedCharAmount(self)
end

function PLAYER:addPLAYLIBMoney(amount)
	local data = PLAYLIB.charsystem.getChar(self:getCharID())
	if not data then self:ChatPrint("No Data") return end
	PLAYLIB.charsystem.editCharacter(data[1].id,data[1].steamid,data[1].name,data[1].money+amount,data[1].team)
end
