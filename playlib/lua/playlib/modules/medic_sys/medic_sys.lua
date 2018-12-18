
if !PLAYLIB then return end

PLAYLIB.medic_sys = PLAYLIB.medic_sys or {}

if SERVER then

	util.AddNetworkString("PLAYLIB::MedicSysOpenEntries")
	util.AddNetworkString("PLAYLIB::MedicSysDeleteEntry")

	PLAYLIB.logger.addLogger("medic_sys")
	PLAYLIB.chatcommand.addCommand("!medic_screen",function(ply,cmd,text)
		net.Start("PLAYLIB::MedicSysOpenEntries")
			net.WriteTable(PLAYLIB.medic_sys.getMedicEntries())
		net.Send(ply)
	end)

	net.Receive("PLAYLIB::MedicSysDeleteEntry",function(len,ply) 
		local id = tonumber(net.ReadString())

		if PLAYLIB.medic_sys.canDelete(ply) then
			PLAYLIB.medic_sys.deleteEntry(ply,id)

			net.Start("PLAYLIB::MedicSysOpenEntries")
				net.WriteTable(PLAYLIB.medic_sys.getMedicEntries())
			net.Send(ply)
		else
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] "..ply:Name().."("..ply:SteamID64()..") tried to delete Entry with ID: "..id.." but had no permissions to do so!")
			PLAYLIB.logger.log("medic_sys",ply:Name().."("..ply:SteamID64()..") tried to delete Entry with ID: "..id.." but had no permissions to do so!")
			PLAYLIB.misc.chatNotify(ply,Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] You have no permissions to delete Entries!")
		end
	end)

function PLAYLIB.medic_sys.canDelete(ply)
	local rank = false
	local job = false

	if PLAYLIB.medic.deleteRanks[ply:GetUserGroup()] then
		job = true
	end

	if PLAYLIB.medic.deleteJobs[ply:Team()] then
		job = true
	end

	if PLAYLIB.medic.strict then
		return job and rank
	else
		return job or rank
	end
end



function PLAYLIB.medic_sys.InitializeDatabase()
	local queryString = [[CREATE TABLE playlib_medic_sys (
		id int NOT NULL PRIMARY KEY AUTOINCREMENT,
		creator_name varchar(255) NOT NULL,
		creator_sid  varchar(20) NOT NULL,
		message varchar(255),
		target_name varchar(255) NOT NULL,
		target_sid varchar(255) NOT NULL,
		create_date varchar(19) NOT NULL
		);
	]]
	PLAYLIB.sql.query(false,queryString, function(res)
		PLAYLIB.logger.log("medic_sys","Erstellen der Datenbank erfolgreich!") 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Erstellen der Datenbank erfolgreich!")
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error)
		PLAYLIB.logger.log("medic_sys","Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
		PLAYLIB.logger.log("medic_sys","Error: "..error)
	end)
end

function PLAYLIB.medic_sys.createDataDir()
	if !file.Exists("playlib/medic_sys","DATA") then
		file.CreateDir("playlib/medic_sys")
	end
end

function PLAYLIB.medic_sys.getMedicEntries()
	local queryString = "SELECT * FROM playlib_medic_sys;"
	local retval = {}
	PLAYLIB.sql.query(false,queryString, function(res) 
		
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erfragen der Medic Einträge ist ein Error aufgetreten!")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error)
		PLAYLIB.logger.log("medic_sys","Beim erfragen der Medic Einträge ist ein Error aufgetreten!")
		PLAYLIB.logger.log("medic_sys","Error: "..error)
	end)

	return retval
end

function PLAYLIB.medic_sys.submitEntry(ply,target,message)
	local creator_name = ply:Name()
	local creator_sid = ply:SteamID64()
	local create_date = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
	local target_name = target:Name()
	local target_sid = target:SteamID64()
	local queryString = "INSERT INTO playlib_medic_sys (creator_name,creator_sid,message,target_name,target_sid,create_date)	VALUES ('"..creator_name.."','"..creator_sid.."','"..message.."','"..target_name.."','"..target_sid.."','"..create_date.."');"
	PLAYLIB.sql.query(false,queryString, function(res) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Eintrag zur Akte von "..target_name.."("..target_sid..") von "..creator_name.."("..creator_sid..") hinzugefügt!")
		if PLAYLIB.medic_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_name = "..creator_name)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_sid = "..creator_sid)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] message = "..message)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_name = "..target_name)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_sid = "..target_sid)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] create_date = "..create_date)
		end
		PLAYLIB.logger.log("medic_sys","Eintrag zur Akte von "..target_name.."("..target_sid..") von "..creator_name.."("..creator_sid..") hinzugefügt!")
		PLAYLIB.logger.log("medic_sys","creator_name = "..creator_name)
		PLAYLIB.logger.log("medic_sys","creator_sid = "..creator_sid)
		PLAYLIB.logger.log("medic_sys","message = "..message)
		PLAYLIB.logger.log("medic_sys","target_name = "..target_name)
		PLAYLIB.logger.log("medic_sys","target_sid = "..target_sid)
		PLAYLIB.logger.log("medic_sys","create_date = "..create_date)
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erstellen eines Eintrag in "..target_name.."("..target_sid..") Akte von "..creator_name.."("..creator_sid..") ist ein Fehler aufgetreten!" )
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error)
		if PLAYLIB.medic_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_name = "..creator_name)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_sid = "..creator_sid)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] message = "..message)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_name = "..target_name)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_sid = "..target_sid)
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] create_date = "..create_date)
		end
		PLAYLIB.logger.log("medic_sys","Beim erstellen eines Eintrag in "..target_name.."("..target_sid..") Akte von "..creator_name.."("..creator_sid..") ist ein Fehler aufgetreten!")
		PLAYLIB.logger.log("medic_sys","Error: "..error)
		PLAYLIB.logger.log("medic_sys","creator_name = "..creator_name)
		PLAYLIB.logger.log("medic_sys","creator_sid = "..creator_sid)
		PLAYLIB.logger.log("medic_sys","message = "..message)
		PLAYLIB.logger.log("medic_sys","target_name = "..target_name)
		PLAYLIB.logger.log("medic_sys","target_sid = "..target_sid)
		PLAYLIB.logger.log("medic_sys","create_date = "..create_date)
		
	end)

end

function PLAYLIB.medic_sys.deleteEntry(ply,id)
	local entry = PLAYLIB.medic_sys.getEntry(id)

	local entry_string = "{"..entry.id..","..entry.creator_name..","..entry.creator_sid..","..entry.message..","..entry.target_name..","..entry.target_sid..","..entry.create_date.."}"
	local queryString = "DELETE FROM playlib_medic_sys WHERE id = "..id..";"
	local deleter_name = ply:Name()
	local deleter_sid = ply:SteamID64()
	PLAYLIB.sql.query(false,queryString, function(res) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] "..deleter_name.."("..deleter_sid..") Deleted Entry with ID: "..id.."!")
		if PLAYLIB.medic_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Deleted Entry Information: "..entry_string)
		end
		PLAYLIB.logger.log("medic_sys",deleter_name.."("..deleter_sid..") Deleted Entry with ID: "..id.."!")
		PLAYLIB.logger.log("medic_sys","Deleted Entry Information: "..entry_string)
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim löschen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error)
		PLAYLIB.logger.log("medic_sys","Beim löschen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!")
		PLAYLIB.logger.log("medic_sys","Error: "..error)
	end)
end

function PLAYLIB.medic_sys.getEntry(id)
	local queryString = "SELECT * FROM playlib_medic_sys WHERE id = "..id..";"
	local retval = {}
	PLAYLIB.sql.query(false,queryString, function(res) 
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erfragen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error)
		PLAYLIB.logger.log("medic_sys","Beim erfragen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!")
		PLAYLIB.logger.log("medic_sys","Error: "..error)
	end)

	return retval[1]
end


elseif CLIENT then

	PLAYLIB.medic_sys.entries = nil
	PLAYLIB.medic_sys.entry = nil

	net.Receive("PLAYLIB::MedicSysOpenEntries",function(len)
		local entries = net.ReadTable() 
		PLAYLIB.medic_sys.drawEntries(entries)
	end)

	function PLAYLIB.medic_sys.delete(id)
		net.Start("PLAYLIB::MedicSysDeleteEntry")
			net.WriteString(id)
		net.SendToServer()
	end


	
	function PLAYLIB.medic_sys.drawEntries(tbl)
		if IsValid(PLAYLIB.medic_sys.entries) then PLAYLIB.medic_sys.entries:Remove() end
		local main = vgui.Create("DFrame")
		main:SetSize(500,500)
		main:Center()
		main:MakePopup()

		local entries = vgui.Create("DListView",main)
		entries:Dock(FILL)
		entries:SetMultiSelect(false)

		entries:AddColumn("ID")
		entries:AddColumn("Creator Name")
		entries:AddColumn("Target Name")
		entries:AddColumn("Creation Date")

		for index,entry in pairs(tbl) do
			entries:AddLine(entry.id,entry.creator_name,entry.target_name,entry.create_date)
		end

		entries.OnRowRightClick = function(line,panel)
			PLAYLIB.medic_sys.drawEntryMenu(tbl[tonumber(entries:GetLine(line):GetValue(1))])
		end

		entries.DoDoubleClick = function(line,panel)
			PLAYLIB.medic_sys.drawEntryPanel(tbl[tonumber(entries:GetLine(line):GetValue(1))])
		end
		PLAYLIB.medic_sys.entries = main
	end

	function PLAYLIB.medic_sys.drawEntryMenu(tbl)
		local m = DermaMenu()

		m:AddOption("Delete Entry",function() 
			net.Start("PLAYLIB::MedicSysDeleteEntry")
				net.WriteString(tbl.id)
			net.SendToServer()


		end)


		m:Open()
	end

	function PLAYLIB.medic_sys.drawEntryPanel(tbl)
		if IsValid(PLAYLIB.medic_sys.entry) then PLAYLIB.medic_sys.entry:Remove() end

		local main = vgui.Create("DFrame")
		main:SetSize(300,500)
		main:Center()
		main:SetTitle("ENTRY ID: "..tbl.id)
		main:MakePopup()

		local tCreator = vgui.Create("DTextEntry",main)
		tCreator:SetPos(20,20)
		tCreator:SetSize(100,20)
		tCreator:SetText(tbl.creator_name)
		tCreator:SetDisabled(true)

		local tTarget = vgui.Create("DTextEntry",main)
		tCreator:SetPos(20,50)
		tCreator:SetSize(100,20)
		tCreator:SetText(tbl.target_name)
		tCreator:SetDisabled(true)

		local tDate = vgui.Create("DTextEntry",main)
		tDate:SetPos(20,80)
		tDate:SetSize(100,20)
		tDate:SetText(tbl.create_date)
		tDate:SetDisabled(true)

		local rtfText = vgui.Create("RichText",main)
		rtfText:SetPos(20,110)
		rtfText:SetSize(260,370)
		rtfText:AppendText(tbl.message)

		PLAYLIB.medic_sys.entry = main
	end
	
end