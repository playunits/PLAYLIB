if !PLAYLIB then return end

PLAYLIB.vgui = PLAYLIB.vgui or {}

if SERVER then -- Serverside Code here
    util.AddNetworkString("PLAYLIB::Test")

    hook.Add("PlayerSay","PLAYLIB::ChatTest",function(ply,text) 
        if text == "!test" then
            PLAYLIB.charsystem.syncChars(ply)
            net.Start("PLAYLIB::Test")
                net.WriteTable(PLAYLIB.charsystem.getPlayerChars(ply:SteamID64()) or {})
            net.Send(ply)
        end
    end)
elseif CLIENT then -- Clientside Code here

    for i=10, 100 do 

        surface.CreateFont( "BFHUD.Outlined.Size"..i, {
            font = "BFHUD", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = true,
            size = i,
            weight = 500,
            blursize = 0, 
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false, 
            strikeout = true,
            symbol = false,
            rotary = false,
            shadow = false, 
            additive = false,
            outline = true, 
        } ) 
        surface.CreateFont( "BFHUD.Blurred.Size"..i, {
            font = "BFHUD", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = false,
            size = i,
            weight = 500,
            blursize = 4, 
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false, 
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = true,
        } )
        surface.CreateFont( "BFHUD.Size"..i, {
            font = "BFHUD", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = false,
            size = i,
            weight = 500,
            blursize = 0,
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false, 
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = false,
        } )
    end

    net.Receive("PLAYLIB::Test",function()
        local t = net.ReadTable() 
        PLAYLIB.vgui.charsDerma(t)
    end)

    net.Receive("PLAYLIB::ShowCharUI",function()
        local t = net.ReadTable()
        PLAYLIB.vgui.charsDerma(t,true)
    end)
    /*
        Simple Creation of Yes/No Window
        
        Must Have Params
        @Params title (String) = The Window Title
        @Params text (String) = The Text displayed in the Window
        @Params yName (String) = The Name of the Y Button
        @Params yFunc (Function) = The Function to be executed on Y Button Press
        @Params nName (String) = The Name of the N Button
        @Params nFunc (Function) = The Function to be executed on N Button Press

    */

    function PLAYLIB.vgui.ynDerma(title,question,yText,yFunc,nName,nFunc,blur)

        local yn = vgui.Create("play_derma_yn")
        yn:Setup({
            ["title"] = title,
            ["yText"] = yText,
            ["yFunc"] = yFunc,
            ["nFunc"] = nFunc,
            ["nText"] = nName,
            ["question"] = question,
            ["blur"] = blur
        })
    end


    /*
        Simple Creation of Value Window
        
        Must Have Params
        @Params title (String) = The Window Title
        @Params text (String) = The Text displayed in the Window
        @Params yName (String) = The Name of the Y Button
        @Params yFunc (Function) = The Function to be executed on Y Button Press
        @Params nName (String) = The Name of the N Button
        @Params nFunc (Function) = The Function to be executed on N Button Press

    */

    function PLAYLIB.vgui.valueDerma(title,placeholder,sText,sFunc,aText,aFunc,blur)

        local val = vgui.Create("play_derma_value")
        val:Setup({
            ["title"] = title,
            ["sText"] = sText,
            ["sFunc"] = sFunc,
            ["aFunc"] = aFunc,
            ["aText"] = aText,
            ["placeholder"] = placeholder,
            ["blur"] = blur
        })
    end
    PLAYLIB.vgui.charsDermaPanel = nil 
    function PLAYLIB.vgui.charsDerma(charData,blur)

            if IsValid(PLAYLIB.vgui.charsDermaPanel) then PLAYLIB.vgui.charsDermaPanel:Close() end

            gui.EnableScreenClicker(true)
        
            local scr = vgui.Create("DPanel")
            scr:SetSize(ScrW(),ScrH())
            scr:MakePopup()
            scr.Paint = function(self,w,h)
                    if blur then
                        PLAYLIB.vgui.blur( self, 10, 3 )
                    end
             end

        local main = vgui.Create("DFrame")
        main:SetSize(800,500)
        local mw,mh = main:GetSize()
        main:ShowCloseButton(false)
        main:SetTitle("")
        main:Center()
        main:SetDraggable(false)
        main:MakePopup()
        main.Paint = function(self,w,h)
            draw.RoundedBox(8,0,0,w,h,PLAYLIB.style.MainBaseWindowColor)
            PLAYLIB.vgui.drawHalfCircle(self,0,0,w,30,PLAYLIB.style.MainHighlightWindowColor,8)
            for i=1,2 do
                surface.DrawLine((mw/3)*i,31,(mw/3)*i,480)
            end
            
        end

        

        local exitBtn = vgui.Create("DButton",main)
        exitBtn:SetSize(25,25)
        exitBtn:SetText("")
        exitBtn:SetPos(mw-((mw/2)/10),2)
        exitBtn.DoClick = function() 
            main:Remove()
            scr:Remove()
            gui.EnableScreenClicker(false)
        end
        exitBtn.Paint = function(self,w,h)
            draw.DrawText("X","BFHUD.Size25",w/2,-2,exitBtn:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230))
        end

        local allowed = LocalPlayer():allowedCharAmount()

        if allowed<#charData then

            for i=1,#charData-allowed do
                PLAYLIB.vgui.addCharPanel(main,mw,mh,i,charData[i],false,false,scr)
            end

        elseif allowed == #charData then

                for i=1,#charData do
                    PLAYLIB.vgui.addCharPanel(main,mw,mh,i,charData[i],false,false,scr)
                end
            

        elseif allowed>#charData then

                local free = allowed -#charData
                LocalPlayer():ChatPrint(free)
                for i=1,#charData do
                    PLAYLIB.vgui.addCharPanel(main,mw,mh,i,charData[i],false,false,scr)
                end

                for i=#charData+1,free+#charData do
                    PLAYLIB.vgui.addCharPanel(main,mw,mh,i,charData[i],false,true,scr)
                end

                if allowed<3 then
                    PLAYLIB.vgui.addCharPanel(main,mw,mh,3,charData[3],true,false,scr)
                end
        end
    
        PLAYLIB.vgui.charsDermaPanel = main
    end

    function PLAYLIB.vgui.addCharPanel(parent,mw,mh,posmult,charData,locked,empty,scr)
        if empty then
            local charFrame = vgui.Create("DModelPanel",parent)
            charFrame:SetSize(mw/3,480)
            charFrame:SetPos((mw/3)*(posmult-1),31)
            charFrame:SetModel("")
            charFrame:SetColor(Color(0,0,0))
            function charFrame:LayoutEntity( Entity ) return end
            charFrame.Paint = function(self,w,h)
                draw.DrawText("Empty","BFHUD.Size25",w/2,h/2,charFrame:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230),TEXT_ALIGN_CENTER)
            end
            charFrame.DoClick = function()
                LocalPlayer():ChatPrint("klick!")
                PLAYLIB.vgui.valueDerma("Charakter erstellen!","Charaktername",
                    "Abgeben!",function(self,val)
                        net.Start("PLAYLIB::CreateNewCharacter")
                            net.WriteString(val)
                        net.SendToServer()
                        self:Remove()
                        gui.EnableScreenClicker(false)
                    end,
                    "Abbrechen!",function(self) self:Remove() gui.EnableScreenClicker(false) end,true)
            end
            --function charFrame.Entity:GetPlayerColor() return Vector ( 0, 0, 0 ) end


        elseif locked then
            local charFrame = vgui.Create("DModelPanel",parent)
            charFrame:SetSize(mw/3,480)
            charFrame:SetPos((mw/3)*(posmult-1),31)
            charFrame:SetModel("")
            charFrame:SetColor(Color(0,0,0))
            function charFrame:LayoutEntity( Entity ) return end
            charFrame.Paint = function(self,w,h)
                draw.DrawText("Locked","BFHUD.Size25",w/2,h/2,charFrame:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230),TEXT_ALIGN_CENTER)
            end
        else
            local charFrame = vgui.Create("DModelPanel",parent)
            charFrame:SetSize(mw/3,480)
            charFrame:SetPos((mw/3)*(posmult-1),31)
            local tteam = tonumber(LocalPlayer().Chars[posmult].team)
            if type(RPExtraTeams[tteam].model) == "string" then
                charFrame:SetModel(RPExtraTeams[tteam].model)
             elseif type(RPExtraTeams[tteam].model) == "table" then
                 charFrame:SetModel(RPExtraTeams[tteam].model[math.random(1,#RPExtraTeams[tteam].model)])
             end
            function charFrame:LayoutEntity( Entity ) return end
            --function charFrame.Entity:GetPlayerColor() return Vector ( 0, 0, 0 ) end
            PLAYLIB.vgui.createStatLabel(charFrame,2,0,20,charData,posmult)

            charFrame.DoClick = function()
                net.Start("PLAYLIB::LoadChar")
                    net.WriteFloat(charData.id)
                net.SendToServer()
                scr:Remove()
                charFrame:GetParent():Remove()
                gui.EnableScreenClicker(false) 
            end

        end

        
    end

    function PLAYLIB.vgui.createStatLabel(parent,sposx,sposy,spacing,charData,pos)
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

    function PLAYLIB.vgui.blur( panel, amount, times )
        local blur = Material("pp/blurscreen")
        local x, y = panel:LocalToScreen(0, 0)
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( blur )
        for i = 1, times do
            blur:SetFloat( "$blur", (i / times ) * ( amount ) )
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
        end
    end

    function PLAYLIB.vgui.drawHalfCircle(panel,x,y,w,h,col,factor)
        draw.RoundedBox(factor,x,y,w,h,col)
        surface.SetDrawColor(col)
        surface.DrawRect(x,(y+h)-10,w,10)
    end
end
