if !PLAYLIB then return end

if SERVER then
    
elseif CLIENT then

    local PANEL = {}


    function PANEL:Init()
        self:SetSize(400,200)
        self:ShowCloseButton(false)
        self.startTime = os.time()
    end

    function PANEL:UseBlur(bool)
        PANEL.blur = bool
    end

    function PANEL:Paint(w,h)
         draw.RoundedBox(8,0,0,w,h,PLAYLIB.style.MainBaseWindowColor)
         PLAYLIB.vgui.drawHalfCircle(self,0,0,w,30,PLAYLIB.style.MainHighlightWindowColor,8)
    end

    function PANEL:Setup(table)

        if !table then return end

        local main = self

        if not table.blur then table.blur = false end

        if table.blur then
            
            local scr = vgui.Create("DPanel")
            scr:SetSize(ScrW(),ScrH())
            scr:MakePopup()
            scr.Paint = function(self,w,h)
                    PLAYLIB.vgui.blur( self, 10, 3 )
             end
             main.bp = scr
        end
        self:SetTitle("")
        self:Center()
        self:SetDraggable(false)
        self:MakePopup()

        self.yFunc = table.yFunc
        self.nFunc = table.nFunc

        local p = vgui.Create("DPanel",main)
        p:SetPos(0,0)
        p:SetSize(400,200)
        p.Paint = function(w,h)
            draw.DrawText(table.title, "Trebuchet18", 200, 5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
        end

        local text = vgui.Create( "RichText", main)
        text:SetPos( 10,32 )
        text:SetSize(380,130)
        text.Paint = function(self,w,h)
            draw.DrawText( table.question, "Trebuchet18", 190, 0, Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER )
        end

        local y = vgui.Create("DButton",main)
        y:SetPos(10,150)
        y:SetSize(135,30)
        y:SetText(table.yText)
        y.DoClick = function() 
            main.yPressed = true
            main.yFunc(y)
            if table.blur then
                main.bp:Remove()
            end
            main:Remove()
        end
        main.yBtn = y

       local n = vgui.Create("DButton",main)
       n:SetPos(main:GetWide()-10-135,150)
       n:SetSize(135,30)
       n:SetText(table.nText)
       n.DoClick = function() 
        main.nPressed = true
            main.nFunc(n)
            if table.blur then
                main.bp:Remove()
            end
            main:Remove()
        end
        main.nBtn = n
    end

    vgui.Register("play_derma_yn", PANEL, "DFrame")
end