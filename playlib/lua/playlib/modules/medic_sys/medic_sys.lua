
if !PLAYLIB then return end

PLAYLIB.medic_sys = PLAYLIB.medic_sys or {}

if SERVER then

	util.AddNetworkString("PLAYLIB::MedicSysOpenEntries")
	util.AddNetworkString("PLAYLIB::MedicSysDeleteEntry")
	util.AddNetworkString("PLAYLIB::MedicSysCreateEntry")

	PLAYLIB.Logger:Create("medic_sys")

 	PLAYLIB.medic_sys.log = function(text) PLAYLIB.Logger:Log("medic_sys",text) end
	PLAYLIB.chatcommand.addCommand("!medic_admin",function(ply,cmd,text)
		if PLAYLIB.medic_sys.viewRanks[ply:GetUserGroup()] then
			PLAYLIB.medic_sys.openUI(ply)
		end
		
	end)

	hook.Add("Initialize","PLAYLIB::MedicInitializeDB",function() 
		PLAYLIB.medic_sys.InitializeDatabase()
	end)

	net.Receive("PLAYLIB::MedicSysDeleteEntry",function(len,ply) 
		local id = tonumber(net.ReadString())

		if PLAYLIB.medic_sys.canDelete(ply,id) then
			PLAYLIB.medic_sys.deleteEntry(ply,id)

			PLAYLIB.medic_sys.openUI(ply)
		else
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] "..ply:Name().."("..ply:SteamID64()..") tried to delete Entry with ID: "..id.." but had no permissions to do so!\n")
			self.log(ply:Name().."("..ply:SteamID64()..") tried to delete Entry with ID: "..id.." but had no permissions to do so!")
			PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] You have no permissions to delete Entries!"})
		end
	end)

	net.Receive("PLAYLIB::MedicSysCreateEntry",function(len,ply) 
		local creator = ply
		local target = net.ReadEntity()
		local message = net.ReadString()

		message = PLAYLIB.sql.sqlStr(false,message)

		if #message > 255 then
			PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] - The Text Entry must not be bigger than 255 Characters!"})
			return
		end

		PLAYLIB.medic_sys.submitEntry(ply,target,message)
		PLAYLIB.medic_sys.openUI(ply)


	end)

function PLAYLIB.medic_sys.openUI(ply)

	if PLAYLIB.medic_sys.canView(ply) then
		net.Start("PLAYLIB::MedicSysOpenEntries")
			net.WriteTable(PLAYLIB.medic_sys.getMedicEntries())
		net.Send(ply)
	else
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] "..ply:Name().."("..ply:SteamID64()..") tried to access the Medic Panel without having permission!\n")
		self.log(ply:Name().."("..ply:SteamID64()..") tried to access the Medic Panel without having permission!\n")
		PLAYLIB.misc.chatNotify(ply,{Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] You have no permissions to view the Entries!"})
	end
	
end

function PLAYLIB.medic_sys.canView(ply)
	local rank = false
	local job = false

	if PLAYLIB.medic_sys.viewRanks[ply:GetUserGroup()] then
		rank = true
	end

	if PLAYLIB.medic_sys.viewJobs[RPExtraTeams[ply:Team()].command] then
		job = true
	end 

	if PLAYLIB.medic_sys.strict then
		return job and rank
	else
		return job or rank
	end
end

function PLAYLIB.medic_sys.canDelete(ply,id)
	local res = PLAYLIB.medic_sys.getEntry(id)

	if PLAYLIB.medic_sys.viewRanks[ply:GetUserGroup()] then
		return true
	end

	if #res < 1 then
		ply:ChatPrint("No Result")
		return false
	else
		if res[1].creator_sid == ply:SteamID64() then
			return true
		else
			ply:ChatPrint("wrong id yourid: "..ply:SteamID64().." needed ID: "..res[1].creator_sid)
			return false

		end
	end
end



function PLAYLIB.medic_sys.InitializeDatabase()
	local queryString = [[CREATE TABLE IF NOT EXISTS playlib_medic_sys (
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
		PLAYLIB.medic_sys.log("Erstellen der Datenbank erfolgreich!") 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Erstellen der Datenbank erfolgreich!\n")
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erstellen des SQLite Tables ist ein Error aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error.."\n")
		PLAYLIB.medic_sys.log("Beim erstellen des SQLite Tables ist ein Error aufgetreten!")
		PLAYLIB.medic_sys.log("Error: "..error)
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
		if res == nil or #res<1 then
			retval = {}
		else
			retval = res
		end
		
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erfragen der Medic Einträge ist ein Error aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error.."\n")
		self.log("Beim erfragen der Medic Einträge ist ein Error aufgetreten!")
		self.log("Error: "..error)
	end)

	return retval
end

function PLAYLIB.medic_sys.submitEntry(ply,target,message)
	message = string.Replace(message,"'","")
	local creator_name = ply:Name()
	local creator_sid = ply:SteamID64()
	local create_date = os.date( "%H:%M:%S - %d/%m/%Y" , os.time() )
	local target_name = target:Name()
	local target_sid = target:SteamID64()
	local queryString = "INSERT INTO playlib_medic_sys (creator_name,creator_sid,message,target_name,target_sid,create_date) VALUES ('"..creator_name.."','"..creator_sid.."','"..message.."','"..target_name.."','"..target_sid.."','"..create_date.."');"
	PLAYLIB.sql.query(false,queryString, function(res) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Eintrag zur Akte von "..target_name.."("..target_sid..") von "..creator_name.."("..creator_sid..") hinzugefügt!\n")
		if PLAYLIB.medic_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_name = "..creator_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_sid = "..creator_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] message = "..message.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_name = "..target_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_sid = "..target_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] create_date = "..create_date.."\n")
		end
		self.log("Eintrag zur Akte von "..target_name.."("..target_sid..") von "..creator_name.."("..creator_sid..") hinzugefügt!")
		self.log("creator_name = "..creator_name)
		self.log("creator_sid = "..creator_sid)
		self.log("message = "..message)
		self.log("target_name = "..target_name)
		self.log("target_sid = "..target_sid)
		self.log("create_date = "..create_date)
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erstellen eines Eintrag in "..target_name.."("..target_sid..") Akte von "..creator_name.."("..creator_sid..") ist ein Fehler aufgetreten!\n" )
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error.."\n")
		if PLAYLIB.medic_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_name = "..creator_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] creator_sid = "..creator_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] message = "..message.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_name = "..target_name.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] target_sid = "..target_sid.."\n")
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] create_date = "..create_date.."\n")
		end
		self.log("Beim erstellen eines Eintrag in "..target_name.."("..target_sid..") Akte von "..creator_name.."("..creator_sid..") ist ein Fehler aufgetreten!")
		self.log("Error: "..error)
		self.log("creator_name = "..creator_name)
		self.log("creator_sid = "..creator_sid)
		self.log("message = "..message)
		self.log("target_name = "..target_name)
		self.log("target_sid = "..target_sid)
		self.log("create_date = "..create_date)
		
	end)

end

function PLAYLIB.medic_sys.deleteEntry(ply,id)
	local entry = PLAYLIB.medic_sys.getEntry(id)
	PrintTable(entry)
	local entry_string = "{"..entry[1].id..","..entry[1].creator_name..","..entry[1].creator_sid..","..entry[1].message..","..entry[1].target_name..","..entry[1].target_sid..","..entry[1].create_date.."}"
	local queryString = "DELETE FROM playlib_medic_sys WHERE id = "..id..";"
	local deleter_name = ply:Name()
	local deleter_sid = ply:SteamID64()
	PLAYLIB.sql.query(false,queryString, function(res) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] "..deleter_name.."("..deleter_sid..") Deleted Entry with ID: "..id.."!\n")
		if PLAYLIB.medic_sys.debug then
			MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Deleted Entry Information: "..entry_string.."\n")
		end
		self.log(deleter_name.."("..deleter_sid..") Deleted Entry with ID: "..id.."!")
		self.log("Deleted Entry Information: "..entry_string)
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim löschen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error.."\n")
		self.log("Beim löschen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!\n")
		self.log("Error: "..error)
	end)
end

function PLAYLIB.medic_sys.getEntry(id)
	local queryString = "SELECT * FROM playlib_medic_sys WHERE id = "..id..";"
	local retval = {}
	PLAYLIB.sql.query(false,queryString, function(res) 
		retval = res
	end,
	function(error) 
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Beim erfragen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!\n")
		MsgC(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] [MEDIC SYS] Error: "..error.."\n")
		self.log("Beim erfragen des Eintrag mit der ID: "..id.." ist ein Fehler aufgetreten!")
		self.log("Error: "..error)
	end)

	return retval
end


elseif CLIENT then

	PLAYLIB.medic_sys.entries = nil
	PLAYLIB.medic_sys.entry = nil
	PLAYLIB.medic_sys.create = nil

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
		main:SetTitle(PLAYLIB.medic_sys.Language["List.Title"])
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

		local File = MenuBar:AddMenu( PLAYLIB.medic_sys.Language["Menu.File"] )
		File:AddOption(PLAYLIB.medic_sys.Language["MenuFile.CreateNew"],function()
			PLAYLIB.medic_sys.drawCreatePanel()
		end):SetIcon(PLAYLIB.medic_sys.Language["Icon.NewEntry"])

		local entries = vgui.Create("DListView",main)
		entries:Dock(FILL)
		entries:SetMultiSelect(false)

		entries:AddColumn(PLAYLIB.medic_sys.Language["List.ID"])
		entries:AddColumn(PLAYLIB.medic_sys.Language["List.CreatorName"])
		entries:AddColumn(PLAYLIB.medic_sys.Language["List.TargetName"])
		entries:AddColumn(PLAYLIB.medic_sys.Language["List.CreationDate"])

		for index,entry in pairs(tbl) do
			entries:AddLine(entry.id,entry.creator_name,entry.target_name,entry.create_date)
		end

		entries.OnRowRightClick = function(panel,line)

			for index,entry in pairs(tbl) do
				if entry.id == entries:GetLine(line):GetValue(1) then
					PLAYLIB.medic_sys.drawEntryMenu(entry)
				end
			end
			
		end

		entries.DoDoubleClick = function(panel,line)

			for index,entry in pairs(tbl) do
				if entry.id == entries:GetLine(line):GetValue(1) then
					PLAYLIB.medic_sys.drawEntryPanel(entry)
				end
			end
			
		end
		PLAYLIB.medic_sys.entries = main
	end

	function PLAYLIB.medic_sys.drawEntryMenu(tbl)
		local m = DermaMenu()

		m:AddOption(PLAYLIB.medic_sys.Language["Menu.DeleteFile"],function()

			net.Start("PLAYLIB::MedicSysDeleteEntry")
				net.WriteString(tbl.id)
			net.SendToServer()


		end):SetIcon(PLAYLIB.medic_sys.Language["Icon.DeleteEntry"])


		m:Open()
	end

	function PLAYLIB.medic_sys.drawEntryPanel(tbl)
		if IsValid(PLAYLIB.medic_sys.entry) then PLAYLIB.medic_sys.entry:Remove() end

		local main = vgui.Create("DFrame")
		main:SetSize(300,500)
		main:Center()
		main:SetTitle(string.Replace(PLAYLIB.medic_sys.Language["Entry.Title"],"%id",tbl.id))
		main:MakePopup()


		local lCreator = vgui.Create("DLabel",main)
		lCreator:SetPos(20,25)
		lCreator:SetSize(200,15)
		lCreator:SetText(PLAYLIB.medic_sys.Language["Entry.CreatorName"])

		local tCreator = vgui.Create("DTextEntry",main)
		tCreator:SetPos(20,40)
		tCreator:SetSize(200,20)
		tCreator:SetText(tbl.creator_name)
		tCreator:SetDisabled(true)

		local lTarget = vgui.Create("DLabel",main)
		lTarget:SetPos(20,75)
		lTarget:SetSize(200,15)
		lTarget:SetText(PLAYLIB.medic_sys.Language["Entry.TargetName"])

		local tTarget = vgui.Create("DTextEntry",main)
		tTarget:SetPos(20,90)
		tTarget:SetSize(200,20)
		tTarget:SetText(tbl.target_name)
		tTarget:SetDisabled(true)

		local lDate = vgui.Create("DLabel",main)
		lDate:SetPos(20,125)
		lDate:SetSize(200,15)
		lDate:SetText(PLAYLIB.medic_sys.Language["Entry.CreationDate"])

		local tDate = vgui.Create("DTextEntry",main)
		tDate:SetPos(20,140)
		tDate:SetSize(200,20)
		tDate:SetText(tbl.create_date)
		tDate:SetDisabled(true)

		local lText = vgui.Create("DLabel",main)
		lText:SetPos(20,175)
		lText:SetSize(200,15)
		lText:SetText(PLAYLIB.medic_sys.Language["Entry.FileEntry"])

		local tText = vgui.Create("DTextEntry",main)
		tText:SetPos(20,190)
		tText:SetSize(260,290)
		tText:SetMultiline(true)
		tText:SetDisabled(true)
		tText:SetText(string.Replace(tbl.message,"%n","\n"))


		PLAYLIB.medic_sys.entry = main
	end

	function PLAYLIB.medic_sys.drawCreatePanel()
		if IsValid(PLAYLIB.medic_sys.create) then PLAYLIB.medic_sys.create:Remove() end

		local selectedPlayer = ""

		local main = vgui.Create("DFrame")
		main:SetSize(300,500)
		main:Center()
		main:SetTitle(PLAYLIB.medic_sys.Language["Create.CreateNew"])
		main:MakePopup()


		local lCreator = vgui.Create("DLabel",main)
		lCreator:SetPos(20,25)
		lCreator:SetSize(200,15)
		lCreator:SetText(PLAYLIB.medic_sys.Language["Create.CreatorName"])

		local tCreator = vgui.Create("DTextEntry",main)
		tCreator:SetPos(20,40)
		tCreator:SetSize(100,20)
		tCreator:SetText(LocalPlayer():Name())
		tCreator:SetDisabled(true)

		local lTarget = vgui.Create("DLabel",main)
		lTarget:SetPos(20,75)
		lTarget:SetSize(200,15)
		lTarget:SetText(PLAYLIB.medic_sys.Language["Create.TargetName"])


		local dTarget = vgui.Create("DComboBox",main)
		dTarget:SetPos(20,90)
		dTarget:SetSize(200,20)
		dTarget:SetValue(PLAYLIB.medic_sys.Language["Create.SelectPlayer"])

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

		local lText = vgui.Create("DLabel",main)
		lText:SetPos(20,175)
		lText:SetSize(200,15)
		lText:SetText(PLAYLIB.medic_sys.Language["Create.FileEntry"])

		local lCharsLeft = vgui.Create("DLabel",main)
		lCharsLeft:SetPos(50,420)
		lCharsLeft:SetSize(200,10)
		lCharsLeft:SetContentAlignment(5)
		lCharsLeft:SetText(string.Replace(string.Replace(PLAYLIB.medic_sys.Language["Create.Characters"],"%maxchars","255"),"%chars","0"))

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
				lCharsLeft:SetText(string.Replace(string.Replace(PLAYLIB.medic_sys.Language["Create.Characters"],"%maxchars","255"),"%chars",#tText:GetValue()))
			else
				lCharsLeft:SetTextColor( Color( 255, 255, 255 ) )
				lCharsLeft:SetText(string.Replace(string.Replace(PLAYLIB.medic_sys.Language["Create.Characters"],"%maxchars","255"),"%chars",#tText:GetValue()))
			end
			
		end



		local bSubmit = vgui.Create("DButton",main)
		bSubmit:SetPos(100,440)
		bSubmit:SetSize(100,40)
		bSubmit:SetText(PLAYLIB.medic_sys.Language["Create.Submit"])
		bSubmit.DoClick = function() 
			if type(selectedPlayer) != "Player" or !IsValid(selectedPlayer) then
				chat.AddText(Color(255,255,255),"[",PLAYLIB.medic_sys.PrefixColor,PLAYLIB.medic_sys.Prefix,Color(255,255,255),"] - You have not chosen a Player or the chosen Player is Invalid!")
				return
			end
			net.Start("PLAYLIB::MedicSysCreateEntry")
				net.WriteEntity(selectedPlayer)
				net.WriteString(string.Replace(tText:GetValue(),"\n","%n"))
			net.SendToServer()
			main:Remove()
		end


		PLAYLIB.medic_sys.create = main
	end
	
end