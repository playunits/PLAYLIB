if !PLAYLIB then return end

PLAYLIB.charsystem = PLAYLIB.charsystem or {}

if SERVER then

elseif CLIENT then
	LocalPlayer().Characters = {}

	PLAYLIB.charsystem.charactersPanel = nil

	net.Receive("PLAYLIB::Test",function()
			local t = net.ReadTable()
			PLAYLIB.charsystem.charsDerma(t)
	end)

	net.Receive("PLAYLIB.Charsystem::DrawUI",function()
			PLAYLIB.charsystem.drawCharacters(true)
	end)

	net.Receive("PLAYLIB.Charsysten::Sync",function(len)
		local characters = net.ReadTable()
		LocalPlayer().Characters = characters
	end)

	function PLAYLIB.charsystem.requestCharactersSync()
		net.Start("PLAYLIB.Charsystem::Sync")
		net.SendToServer()
	end

	function PLAYLIB.charsystem.drawCharacters(blur)
		if IsValid(PLAYLIB.charsystem.charactersPanel) then PLAYLIB.charsystem.charactersPanel:Remove() end

		local data = LocalPlayer().Characters

		gui.EnableScreenClicker(true)

		local blurScreen = vgui.Create("DPanel")
		blurScreen:SetSize(ScrW(),ScrH())
		blurScreen:MakePopup()
		blurScreen.Paint = function(self,w,h)
			if blur then
					PLAYLIB.vgui.blur( self, 10, 3 )
			end
		end

		local main = vgui.Create("DFrame")
		main:SetSize(800,500)
		main:ShowCloseButton(false)
		main:SetTitle("")
		main:Center()
		main:SetDraggable(false)
		main:MakePopup()
		local mw,mh = main:GetSize()
		main.Paint = function(self,w,h)
			draw.RoundedBox(8,0,0,w,h,PLAYLIB.charsystem.MainBaseWindowColor)
			PLAYLIB.vgui.drawHalfCircle(self,0,0,w,30,PLAYLIB.charsystem.MainHighlightWindowColor,8)
			for i=1,LocalPlayer():MaxChars()-1 do
				surface.DrawLine((mw/LocalPlayer():MaxChars())*i,31,(mw/LocalPlayer():MaxChars())*i,480)
			end
		end

		local bClose = vgui.Create("DButton",main)
		bClose:SetSize(25,25)
		bClose:SetText("")
		bClose:SetPos(mw-((mw/2)/10),2)
		bClose.DoClick = function()
			main:Remove()
			blurScreen:Remove()
			gui.EnableScreenClicker(false)
		end
		bClose.Paint = function(self,w,h)
				draw.DrawText("X","BFHUD.Size25",w/2,-2,exitBtn:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230))
		end

		local pScroller = vgui.Create("DHorizontalScrollerPanel",main)
		pScroller:SetSize(750,480)
		pScroller:SetPos(25,31)
		pScroller:SetOverlap(-10)



		if LocalPlayer():FreeChars()<0 then
			for i=1,#data do
				if i > LocalPlayer():MaxChars() then
					PLAYLIB.charsystem.addCharPanel(pScroller,250,480,i,charData[i],"locked",blurScreen)
				else
					PLAYLIB.charsystem.addCharPanel(pScroller,250,480,i,charData[i],"used",blurScreen)
				end
			end
		else
			for i=1,#LocalPlayer():MaxChars() do
				if i > #data then
					PLAYLIB.charsystem.addCharPanel(pScroller,250,480,i,{},"empty",blurScreen)
				else
					PLAYLIB.charsystem.addCharPanel(pScroller,250,480,i,charData[i],"used",blurScreen)
				end
			end
		end

		PLAYLIB.charsystem.charactersPanel = main
end

function PLAYLIB.charsystem.createCharPanel(parent,w,h,posMult,data,type,blurScreen)
	local char = vgui.Create("DModelPanel",parent)
	char:SetSize(w,h)
	if type == "empty" then

		char:SetModel("")
		char:SetColor(Color(0,0,0))
		char.LayoutEntity = function(Entity) return end
		char.Paint = function(self,w,h)
			draw.DrawText("Empty","BFHUD.Size25",w/2,h/2,charFrame:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230),TEXT_ALIGN_CENTER)
		end
		char.DoClick = function()
			LocalPlayer():ChatPrint("Charaktererstellung!")
		end

	elseif type == "locked" then

		char:SetModel("")
		char:SetColor(Color(0,0,0))
		char.LayoutEntity = function(Entity) return end
		char.Paint = function(self,w,h)
			draw.DrawText("Locked","BFHUD.Size25",w/2,h/2,charFrame:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230),TEXT_ALIGN_CENTER)
		end
		char.DoClick = function()
			LocalPlayer():ChatPrint("Gesperrt!")
		end

	elseif type == "used" then

		if type(RPExtraTeams[data.team].model) == "string" then
			char:SetModel(RPExtraTeams[data.team].model)
		elseif type(RPExtraTeams[data.team].model) == "table" then
			char:SetModel(RPExtraTeams[data.team].model[math.random(1,#RPExtraTeams[data.team].model)])
		end
		char.LayoutEntity = function(Entity) return end

		PLAYLIB.charsystem.createStatLabel(char,2,0,20,data,posMult)

		char.DoClick = function()
			LocalPlayer():ChatPrint("Charakter laden!")
		end

	end

	parent:AddPanel(char)

end

	function PLAYLIB.charsystem.createStatLabel(parent,sposx,sposy,spacing,charData,pos)
			local lID = vgui.Create("DLabel",parent)
			lID:SetPos(sposx,sposy+(spacing*0))
			lID:SetSize(200,20)
			lID:SetText("")
			lID.Paint = function(self,w,h)
					draw.DrawText( "ID: "..LocalPlayer().Chars[posmult].id, "BFHUD.Size20", sposx, sposy, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			end

			local lName = vgui.Create("DLabel",parent)
			lName:SetPos(sposx,sposy+(spacing*1))
			lName:SetSize(200,20)
			lName:SetText("")
			lName.Paint = function(self,w,h)
					draw.DrawText( "Name: "..LocalPlayer().Chars[posmult].name, "BFHUD.Size20", sposx, sposy, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			end

			local lTeam = vgui.Create("DLabel",parent)
			lTeam:SetPos(sposx,sposy+(spacing*2))
			lTeam:SetSize(200,20)
			lTeam:SetText("")
			lTeam.Paint = function(self,w,h)
					local tteam = tonumber(LocalPlayer().Chars[posmult].team)
					draw.DrawText( "Job: "..RPExtraTeams[tteam].name, "BFHUD.Size20", sposx, sposy, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			end

			local lMoney = vgui.Create("DLabel",parent)
			lMoney:SetPos(sposx,sposy+(spacing*3))
			lMoney:SetSize(200,20)
			lMoney:SetText("")
			lMoney.Paint = function(self,w,h)
					draw.DrawText( "Money: "..LocalPlayer().Chars[posmult].money, "BFHUD.Size20", sposx, sposy, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			end


	end

end
