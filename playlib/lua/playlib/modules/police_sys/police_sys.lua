
if !PLAYLIB then return end

PLAYLIB.police_sys = PLAYLIB.police_sys or {}

if SERVER then

	util.AddNetworkString("PLAYLIB::PoliceSysOpenEntries")
	util.AddNetworkString("PLAYLIB::PoliceSysDeleteEntry")
	util.AddNetworkString("PLAYLIB::PoliceSysCreateEntry")

	PLAYLIB.logger.addLogger("police_sys")
	
	PLAYLIB.chatcommand.addCommand("!police_admin",function(ply,cmd,text)
		if PLAYLIB.police_sys.viewRanks[ply:GetUserGroup()] then
			PLAYLIB.police_sys.openUI(ply)
		end
	end)
	
	hook.Add("Initialize","PLAYLIB::PoliceInitializeDB",function() 
		PLAYLIB.police_sys.InitializeDatabase()
	end)

	net.Receive("PLAYLIB::PoliceSysDeleteEntry",function(len,ply) 
		local id = tonumber(net.ReadString())

		if PLAYLIB.police_sys.canDelete(ply,id) then
			PLAYLIB.police_sys.deleteEntry(ply,id)

			PLAYLIB.police_sys.openUI(ply)
		else
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] "..ply:Name().."("..ply:SteamID64()..") tried to delete Entry with ID: "..id.." but had no permissions to do so!\n")
			PLAYLIB.logger.log("police_sys",ply:Name().."("..ply:SteamID64()..") tried to delete Entry with ID: "..id.." but had no permissions to do so!")
			PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] You have no permissions to delete Entries!"})
		end
	end)

	net.Receive("PLAYLIB::PoliceSysCreateEntry",function(len,ply) 
		local creator = ply
		local target = net.ReadEntity()
		local message = net.ReadString()

		message = PLAYLIB.sql.sqlStr(false,message)

		if #message > 255 then
			PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] - The Text Entry must not be bigger than 255 Characters!"})
			return
		end

		PLAYLIB.police_sys.submitEntry(ply,target,message)
		PLAYLIB.police_sys.openUI(ply)


	end)

function PLAYLIB.police_sys.openUI(ply)

	if PLAYLIB.police_sys.canView(ply) then
		net.Start("PLAYLIB::PoliceSysOpenEntries")
			net.WriteTable(PLAYLIB.police_sys.getPoliceEntries())
		net.Send(ply)
	else
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] "..ply:Name().."("..ply:SteamID64()..") tried to access the Police Panel without having permission!\n")
		PLAYLIB.logger.log("police_sys",ply:Name().."("..ply:SteamID64()..") tried to access the Police Panel without having permission!\n")
		PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] You have no permissions to view the Entries!"})
	end
	
end

function PLAYLIB.police_sys.canView(ply)
	local rank = false
	local job = false

	if PLAYLIB.police_sys.viewRanks[ply:GetUserGroup()] then
		rank = true
	end

	if PLAYLIB.police_sys.viewJobs[RPExtraTeams[ply:Team()].command] then
		job = true
	end 

	if PLAYLIB.police_sys.strict then
		return job and rank
	else
		return job or rank
	end
end

function PLAYLIB.police_sys.canDelete(ply,id)
	local res = PLAYLIB.police_sys.getEntry(id)
	if PLAYLIB.police_sys.viewRanks[ply:GetUserGroup()] then
		return true
	end
	if #res < 1 then
		ply:ChatPrint("No Result")
		return false
	else
		if res[1].creator_sid == ply:SteamID64() then
			return true
		else
			return false

		end
	end
end



function PLAYLIB.police_sys.InitializeDatabase()
	local queryString = [[CREATE TABLE IF NOT EXISTS playlib_police_sys (
		id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
		creator_name varchar(255) NOT NULL,
		creator_sid  varchar(20) NOT NULL,
		message varchar(255),
		target_name varchar(255) NOT NULL,
		target_sid varchar(255) NOT NULL,
		create_date varchar(19) NOT NULL
		);
	]]
	PLAYLIB.sql.query(false,queryString, function(res)
		PLAYLIB.logger.log("police_sys","Erstellen der Datenbank erfolgreich!") 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Erstellen der Datenbank erfolgreich!\n")
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Beim erstellen des SQLite Tables ist ein Error aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Error: "..error.."\n")
		PLAYLIB.logger.log("police_sys","Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
		PLAYLIB.logger.log("police_sys","Error: "..error)
	end)
end

function PLAYLIB.police_sys.createDataDir()
	if !file.Exists("playlib/police_sys","DATA") then
		file.CreateDir("playlib/police_sys")
	end
end

function PLAYLIB.police_sys.getPoliceEntries()
	local queryString = "SELECT * FROM playlib_police_sys;"
	local retval = {}
	PLAYLIB.sql.query(false,queryString, function(res) 
		if res == nil or #res<1 then
			retval = {}
		else
			retval = res
		end
		
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Beim erfragen der Police Einträge ist ein Error aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Error: "..error.."\n")
		PLAYLIB.logger.log("police_sys","Beim erfragen der Police Einträge ist ein Error aufgetreten!")
		PLAYLIB.logger.log("police_sys","Error: "..error)
	end)

	return retval
end

function PLAYLIB.police_sys.submitEntry(ply,target,message)
	message = string.Replace(message,"'","")
	local creator_name = ply:Name()
	local creator_sid = ply:SteamID64()
	local ts = os.time()
    local h = os.date("%H:%M:%S",ts)
    ply:ChatPrint(h)
    local d = os.date("%d/%m/%Y",ts)
	local create_date = h.." - "..d
	local target_name = target:Name()
	local target_sid = target:SteamID64()
	local queryString = "INSERT INTO playlib_police_sys (creator_name,creator_sid,message,target_name,target_sid,create_date) VALUES ('"..creator_name.."','"..creator_sid.."','"..message.."','"..target_name.."','"..target_sid.."','"..create_date.."');"
	PLAYLIB.sql.query(false,queryString, function(res) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Eintrag zur Akte von "..target_name.."("..target_sid..") von "..creator_name.."("..creator_sid..") hinzugefügt!\n")
		if PLAYLIB.police_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] creator_name = "..creator_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] creator_sid = "..creator_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] message = "..message.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] target_name = "..target_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] target_sid = "..target_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] create_date = "..create_date.."\n")
		end
		PLAYLIB.logger.log("police_sys","Eintrag zur Akte von "..target_name.."("..target_sid..") von "..creator_name.."("..creator_sid..") hinzugefügt!")
		PLAYLIB.logger.log("police_sys","creator_name = "..creator_name)
		PLAYLIB.logger.log("police_sys","creator_sid = "..creator_sid)
		PLAYLIB.logger.log("police_sys","message = "..message)
		PLAYLIB.logger.log("police_sys","target_name = "..target_name)
		PLAYLIB.logger.log("police_sys","target_sid = "..target_sid)
		PLAYLIB.logger.log("police_sys","create_date = "..create_date)
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Beim erstellen eines Eintrag in "..target_name.."("..target_sid..") Akte von "..creator_name.."("..creator_sid..") ist ein Fehler aufgetreten!\n" )
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Error: "..error.."\n")
		if PLAYLIB.police_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] creator_name = "..creator_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] creator_sid = "..creator_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] message = "..message.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] target_name = "..target_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] target_sid = "..target_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] create_date = "..create_date.."\n")
		end
		PLAYLIB.logger.log("police_sys","Beim erstellen eines Eintrag in "..target_name.."("..target_sid..") Akte von "..creator_name.."("..creator_sid..") ist ein Fehler aufgetreten!")
		PLAYLIB.logger.log("police_sys","Error: "..error)
		PLAYLIB.logger.log("police_sys","creator_name = "..creator_name)
		PLAYLIB.logger.log("police_sys","creator_sid = "..creator_sid)
		PLAYLIB.logger.log("police_sys","message = "..message)
		PLAYLIB.logger.log("police_sys","target_name = "..target_name)
		PLAYLIB.logger.log("police_sys","target_sid = "..target_sid)
		PLAYLIB.logger.log("police_sys","create_date = "..create_date)
		
	end)

end

function PLAYLIB.police_sys.deleteEntry(ply,id)
	local entry = PLAYLIB.police_sys.getEntry(id)
	PrintTable(entry)
	local entry_string = "{"..entry[1].id..","..entry[1].creator_name..","..entry[1].creator_sid..","..entry[1].message..","..entry[1].target_name..","..entry[1].target_sid..","..entry[1].create_date.."}"
	local queryString = "DELETE FROM playlib_police_sys WHERE id = "..id..";"
	local deleter_name = ply:Name()
	local deleter_sid = ply:SteamID64()
	PLAYLIB.sql.query(false,queryString, function(res) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] "..deleter_name.."("..deleter_sid..") Deleted Entry with ID: "..id.."!\n")
		if PLAYLIB.police_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Deleted Entry Information: "..entry_string.."\n")
		end
		PLAYLIB.logger.log("police_sys",deleter_name.."("..deleter_sid..") Deleted Entry with ID: "..id.."!")
		PLAYLIB.logger.log("police_sys","Deleted Entry Information: "..entry_string)
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Beim löschen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Error: "..error.."\n")
		PLAYLIB.logger.log("police_sys","Beim löschen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!\n")
		PLAYLIB.logger.log("police_sys","Error: "..error)
	end)
end

function PLAYLIB.police_sys.getEntry(id)
	local queryString = "SELECT * FROM playlib_police_sys WHERE id = "..id..";"
	local retval = {}
	PLAYLIB.sql.query(false,queryString, function(res) 
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Beim erfragen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] [POLICE SYS] Error: "..error.."\n")
		PLAYLIB.logger.log("police_sys","Beim erfragen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!")
		PLAYLIB.logger.log("police_sys","Error: "..error)
	end)

	return retval
end


elseif CLIENT then

	PLAYLIB.police_sys.entries = nil
	PLAYLIB.police_sys.entry = nil
	PLAYLIB.police_sys.create = nil

	net.Receive("PLAYLIB::PoliceSysOpenEntries",function(len)
		local entries = net.ReadTable() 
		PLAYLIB.police_sys.drawEntries(entries)
	end)

	function PLAYLIB.police_sys.delete(id)
		net.Start("PLAYLIB::PoliceSysDeleteEntry")
			net.WriteString(id)
		net.SendToServer()
	end


	
	function PLAYLIB.police_sys.drawEntries(tbl)
		if IsValid(PLAYLIB.police_sys.entries) then PLAYLIB.police_sys.entries:Remove() end
		local main = vgui.Create("DFrame")
		main:SetSize(500,500)
		main:Center()
		main:SetTitle(PLAYLIB.police_sys.Language["List.Title"])
		main:SetDraggable(false)
		main:MakePopup()

		local creator = vgui.Create("DImageButton",main)
		creator:SetPos(380,2.5)
		creator:SetSize(20,20)
		creator:SetImage("icon16/information.png")
		creator:SetToolTip("Go to the Creators Profile")
		creator.DoClick = function() 
			gui.OpenURL("https://steamcommunity.com/id/playunits/")
		end

		local MenuBar = vgui.Create( "DMenuBar", main )
		MenuBar:DockMargin( -3, -6, -3, 0 ) --corrects MenuBar pos

		local File = MenuBar:AddMenu( PLAYLIB.police_sys.Language["Menu.File"] )
		File:AddOption(PLAYLIB.police_sys.Language["MenuFile.CreateNew"],function()
			PLAYLIB.police_sys.drawCreatePanel()
		end):SetIcon(PLAYLIB.police_sys.Language["Icon.NewEntry"])

		local entries = vgui.Create("DListView",main)
		entries:Dock(FILL)
		entries:SetMultiSelect(false)

		entries:AddColumn(PLAYLIB.police_sys.Language["List.ID"])
		entries:AddColumn(PLAYLIB.police_sys.Language["List.CreatorName"])
		entries:AddColumn(PLAYLIB.police_sys.Language["List.TargetName"])
		entries:AddColumn(PLAYLIB.police_sys.Language["List.CreationDate"])

		for index,entry in pairs(tbl) do
			entries:AddLine(entry.id,entry.creator_name,entry.target_name,entry.create_date)
		end

		entries.OnRowRightClick = function(panel,line)

			for index,entry in pairs(tbl) do
				if entry.id == entries:GetLine(line):GetValue(1) then
					PLAYLIB.police_sys.drawEntryMenu(entry)
				end
			end
			
		end

		entries.DoDoubleClick = function(panel,line)

			for index,entry in pairs(tbl) do
				if entry.id == entries:GetLine(line):GetValue(1) then
					PLAYLIB.police_sys.drawEntryPanel(entry)
				end
			end
			
		end
		PLAYLIB.police_sys.entries = main
	end

	function PLAYLIB.police_sys.drawEntryMenu(tbl)
		local m = DermaMenu()

		m:AddOption(PLAYLIB.police_sys.Language["Menu.DeleteFile"],function()

			net.Start("PLAYLIB::PoliceSysDeleteEntry")
				net.WriteString(tbl.id)
			net.SendToServer()


		end):SetIcon(PLAYLIB.police_sys.Language["Icon.DeleteEntry"])


		m:Open()
	end

	function PLAYLIB.police_sys.drawEntryPanel(tbl)
		if IsValid(PLAYLIB.police_sys.entry) then PLAYLIB.police_sys.entry:Remove() end

		local main = vgui.Create("DFrame")
		main:SetSize(300,500)
		main:Center()
		main:SetTitle(string.Replace(PLAYLIB.police_sys.Language["Entry.Title"],"%id",tbl.id))
		main:MakePopup()


		local lCreator = vgui.Create("DLabel",main)
		lCreator:SetPos(20,25)
		lCreator:SetSize(200,15)
		lCreator:SetText(PLAYLIB.police_sys.Language["Entry.CreatorName"])

		local tCreator = vgui.Create("DTextEntry",main)
		tCreator:SetPos(20,40)
		tCreator:SetSize(200,20)
		tCreator:SetText(tbl.creator_name)
		tCreator:SetDisabled(true)

		local lTarget = vgui.Create("DLabel",main)
		lTarget:SetPos(20,75)
		lTarget:SetSize(200,15)
		lTarget:SetText(PLAYLIB.police_sys.Language["Entry.TargetName"])

		local tTarget = vgui.Create("DTextEntry",main)
		tTarget:SetPos(20,90)
		tTarget:SetSize(200,20)
		tTarget:SetText(tbl.target_name)
		tTarget:SetDisabled(true)

		local lDate = vgui.Create("DLabel",main)
		lDate:SetPos(20,125)
		lDate:SetSize(200,15)
		lDate:SetText(PLAYLIB.police_sys.Language["Entry.CreationDate"])

		local tDate = vgui.Create("DTextEntry",main)
		tDate:SetPos(20,140)
		tDate:SetSize(200,20)
		tDate:SetText(tbl.create_date)
		tDate:SetDisabled(true)

		local lText = vgui.Create("DLabel",main)
		lText:SetPos(20,175)
		lText:SetSize(200,15)
		lText:SetText(PLAYLIB.police_sys.Language["Entry.FileEntry"])

		local tText = vgui.Create("DTextEntry",main)
		tText:SetPos(20,190)
		tText:SetSize(260,290)
		tText:SetMultiline(true)
		tText:SetDisabled(true)
		tText:SetText(string.Replace(tbl.message,"%n","\n"))


		PLAYLIB.police_sys.entry = main
	end

	function PLAYLIB.police_sys.drawCreatePanel()
		if IsValid(PLAYLIB.police_sys.create) then PLAYLIB.police_sys.create:Remove() end

		local selectedPlayer = ""
		local preset = string.lower(PLAYLIB.police_sys.Language["Create.PresetNone"])

		local main = vgui.Create("DFrame")
		main:SetSize(300,500)
		main:Center()
		main:SetTitle(PLAYLIB.police_sys.Language["Create.CreateNew"])
		main:MakePopup()


		local lCreator = vgui.Create("DLabel",main)
		lCreator:SetPos(20,25)
		lCreator:SetSize(200,15)
		lCreator:SetText(PLAYLIB.police_sys.Language["Create.CreatorName"])

		local tCreator = vgui.Create("DTextEntry",main)
		tCreator:SetPos(20,40)
		tCreator:SetSize(100,20)
		tCreator:SetText(LocalPlayer():Name())
		tCreator:SetDisabled(true)

		local lTarget = vgui.Create("DLabel",main)
		lTarget:SetPos(20,75)
		lTarget:SetSize(200,15)
		lTarget:SetText(PLAYLIB.police_sys.Language["Create.TargetName"])


		local dTarget = vgui.Create("DComboBox",main)
		dTarget:SetPos(20,90)
		dTarget:SetSize(200,20)
		dTarget:SetValue(PLAYLIB.police_sys.Language["Create.SelectPlayer"])

		for index,ply in pairs(player.GetAll()) do
			if !IsValid(ply) then continue end
			dTarget:AddChoice(ply:Name())
		end

		dTarget.OnSelect = function(panel,index,value)		
			for index,ply in pairs(player.GetAll()) do
				if !IsValid(ply) then continue end
				if ply:Name() == value then
					selectedPlayer = ply
				end
			end
		end

		local lPresets = vgui.Create("DLabel",main)
		lPresets:SetPos(20,125)
		lPresets:SetSize(200,15)
		lPresets:SetText(PLAYLIB.police_sys.Language["Create.Presets"])

		

		local lText = vgui.Create("DLabel",main)
		lText:SetPos(20,175)
		lText:SetSize(200,15)
		lText:SetText(PLAYLIB.police_sys.Language["Create.FileEntry"])

		local lCharsLeft = vgui.Create("DLabel",main)
		lCharsLeft:SetPos(50,420)
		lCharsLeft:SetSize(200,10)
		lCharsLeft:SetContentAlignment(5)
		lCharsLeft:SetText(string.Replace(string.Replace(PLAYLIB.police_sys.Language["Create.Characters"],"%maxchars","255"),"%chars","0"))

		local tText = vgui.Create("DTextEntry",main)
		tText:SetPos(20,190)
		tText:SetSize(260,220)
		tText:SetMultiline(true)
		tText:SetDisabled(false)
		tText:SetText("")
		tText:SetUpdateOnType(true)

		tText.OnChange = function()
			if #tText:GetValue() > 255 then
				lCharsLeft:SetTextColor( Color( 255, 0, 0 ) )
				lCharsLeft:SetText(string.Replace(string.Replace(PLAYLIB.police_sys.Language["Create.Characters"],"%maxchars","255"),"%chars",#tText:GetValue()))
			else
				lCharsLeft:SetTextColor( Color( 255, 255, 255 ) )
				lCharsLeft:SetText(string.Replace(string.Replace(PLAYLIB.police_sys.Language["Create.Characters"],"%maxchars","255"),"%chars",#tText:GetValue()))
			end
			
		end

		local dPresets = vgui.Create("DComboBox",main)
		dPresets:SetPos(20,140)
		dPresets:SetSize(200,20)
		dPresets:SetValue(PLAYLIB.police_sys.Language["Create.SelectPreset"])
		dPresets:AddChoice(PLAYLIB.police_sys.Language["Create.PresetNone"])
		for index,entry in pairs(PLAYLIB.police_sys.Language["Presets"]) do
			dPresets:AddChoice(entry)
		end

		dPresets.OnSelect = function(panel,index,value)
			preset = value
			if string.lower(preset) != string.lower(PLAYLIB.police_sys.Language["Create.PresetNone"]) then
				tText:SetValue(preset)
			end
			
		end



		local bSubmit = vgui.Create("DButton",main)
		bSubmit:SetPos(100,440)
		bSubmit:SetSize(100,40)
		bSubmit:SetText(PLAYLIB.police_sys.Language["Create.Submit"])
		bSubmit.DoClick = function() 
			if type(selectedPlayer) != "Player" or !IsValid(selectedPlayer) then
				chat.AddText(Color(255,255,255),"[",PLAYLIB.police_sys.PrefixColor,PLAYLIB.police_sys.Prefix,Color(255,255,255),"] - You have not chosen a Player or the chosen Player is Invalid!")
				return
			end

			local sendval = ""

			if string.lower(preset) == string.lower(PLAYLIB.police_sys.Language["Create.PresetNone"]) or preset == PLAYLIB.police_sys.Language["Create.SelectPreset"] then
				sendval = string.Replace(tText:GetValue(),"\n","%n")
			else
				sendval = preset
			end
			net.Start("PLAYLIB::PoliceSysCreateEntry")
				net.WriteEntity(selectedPlayer)
				net.WriteString(sendval)
			net.SendToServer()
			main:Remove()
		end


		PLAYLIB.police_sys.create = main
	end
	
end