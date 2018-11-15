if !PLAYLIB then return end

PLAYLIB.vgui = PLAYLIB.vgui or {}

if SERVER then -- Serverside Code here
    util.AddNetworkString("PLAYLIB::Test")

	hook.Add("PlayerSay","PLAYLIB::TEST",function(ply,text) 
		if text == "!test" then
			net.Start("PLAYLIB::Test")
			net.Send(ply)
		end
	end)
elseif CLIENT then -- Clientside Code here
    net.Receive("PLAYLIB::Test",function()
    /* 
    	PLAYLIB.vgui.valueDerma("Workshop Content","Workshop ID",
            "Abgeben",function(self,val) LocalPlayer():ChatPrint(val) self:GetParent():Close() end,
            "Abbrechen",function(self) LocalPlayer():ChatPrint("Nein")  self:GetParent():Close() end,
            true)
    */
        local val = vgui.Create("play_derma_value")
        val:Setup({
            ["title"] = "Trag einen Wert ein!",
            ["sText"] = "Abgeben!",
            ["sFunc"] = function(self,val)
                LocalPlayer():ChatPrint(val)
            end,
            ["aFunc"] = function(self)
                LocalPlayer():ChatPrint("Abgebrochen")
            end,
            ["aText"] = "Nein!",
            ["placeholder"] = "SID64",
            ["blur"] = true
        })
        --PLAYLIB.vgui.valueDerma(ltitle,ltext,placeholder,sName,sFunc,aName,aFunc,blur)
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

    function PLAYLIB.vgui.ynDerma(ltitle,ltext,yName,yFunc,nName,nFunc,blur)

        local scr = vgui.Create("DPanel")
        scr:SetSize(ScrW(),ScrH())
         scr:MakePopup()
        scr.Paint = function(self,w,h)
            if blur then
                PLAYLIB.vgui.blur( self, 10, 3 )
            end
            
         end

    	local main = vgui.Create("DFrame")
    	main:SetSize(400,200)
    	main:Center()
    	main:SetDraggable(false)
    	main:ShowCloseButton(false)
    	main:SetTitle("")
    	main:MakePopup()
        main.Paint = function(self,w,h)
            
            draw.RoundedBox(8,0,0,w,h,Color(255,250,240))
            PLAYLIB.vgui.drawHalfCircle(main,0,0,w,30,Color(250,128,114),8)

            draw.DrawText(ltitle, "Trebuchet18", 200, 5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
        end

        local text = vgui.Create( "RichText", main)
        text:SetPos( 10,32 )
        text:SetSize(380,130)
        text.Paint = function(self,w,h)
            draw.DrawText( ltext, "Trebuchet18", 190, 0, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
        end


    	local y = vgui.Create("DButton",main)
    	y:SetPos(10,150)
    	y:SetSize(135,30)
    	y:SetText(yName)
    	y.DoClick = function() 
            yFunc(y)
            if blur then
                scr:Remove()
            end
        end

    	local n = vgui.Create("DButton",main)
    	n:SetPos(main:GetWide()-10-135,150)
    	n:SetSize(135,30)
    	n:SetText(nName)
    	n.DoClick = function() 
            nFunc(n)
            if blur then
                scr:Remove()
            end
        end
    end

        function PLAYLIB.vgui.valueDerma(ltitle,placeholder,sName,sFunc,aName,aFunc,blur)

        local scr = vgui.Create("DPanel")
        scr:SetSize(ScrW(),ScrH())
         scr:MakePopup()
        scr.Paint = function(self,w,h)
            if blur then
                PLAYLIB.vgui.blur( self, 10, 3 )
            end
            
         end

        local main = vgui.Create("DFrame")
        main:SetSize(400,140)
        main:Center()
        main:SetDraggable(false)
        main:ShowCloseButton(false)
        main:SetTitle("")
        main:MakePopup()
        main.Paint = function(self,w,h)
            
            draw.RoundedBox(8,0,0,w,h,Color(255,250,240))
            PLAYLIB.vgui.drawHalfCircle(main,0,0,w,30,Color(250,128,114),8)

            draw.DrawText(ltitle, "Trebuchet18", 200, 5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
        end

        local text = vgui.Create( "DTextEntry", main)
        text:SetPos( 10,40 )
        text:SetSize(380,30)
        text:SetText(placeholder)
        text.OnEnter = function(self)
            sFunc(y,self:GetValue())
            if blur then
                scr:Remove()
            end
        end

        local s = vgui.Create("DButton",main)
        s:SetPos(10,100)
        s:SetSize(135,30)
        s:SetText(sName)
        s.DoClick = function() 
            sFunc(s,text:GetValue())
            if blur then
                scr:Remove()
            end
        end

        local a = vgui.Create("DButton",main)
        a:SetPos(main:GetWide()-10-135,100)
        a:SetSize(135,30)
        a:SetText(aName)
        a.DoClick = function() 
            aFunc(a,val)
            if blur then
                scr:Remove()
            end
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
