if !PLAYLIB then return end

if SERVER then

elseif CLIENT then

    local PANEL = {}


    function PANEL:Init()
        self:SetSize(400,140)
        self:ShowCloseButton(false)
        self.startTime = os.time()
    end

    function PANEL:Paint(w,h)
         draw.RoundedBox(8,0,0,w,h,PLAYLIB.play_derma.MainBaseWindowColor)
         PLAYLIB.vgui.drawHalfCircle(self,0,0,w,30,PLAYLIB.play_derma.MainHighlightWindowColor,8)
    end

    function PANEL:Setup(table)

        if !table then return end

        local main = self

        main.val = ""

        if table.blur then

            local scr = vgui.Create("DPanel")
            scr:SetSize(ScrW(),ScrH())
            scr:MakePopup()
            scr.Paint = function(self,w,h)
                    PLAYLIB.vgui.blur( self, 10, 3 )
             end
            function scr:OnFocusChanged(bool)
                scr:KillFocus()
            end
             main.bp = scr
        end
        self:SetTitle("")
        self:Center()
        self:SetDraggable(false)
        self:MakePopup()

        self.sFunc = table.sFunc
        self.aFunc = table.aFunc

        local p = vgui.Create("DPanel",main)
        p:SetPos(0,0)
        p:SetSize(400,200)
        p.Paint = function(w,h)
            draw.DrawText(table.title, "Trebuchet18", 200, 5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
        end

        local text = vgui.Create( "DTextEntry", main)
        text:SetPos( 10,40 )
        text:SetSize(380,30)
        text:SetText(table.placeholder)
        text.OnEnter = function(self)
             main.sFunc(y,text:GetValue())
            if blur then
                main.bp:Remove()
            end
        end

        local s = vgui.Create("DButton",main)
        s:SetPos(10,100)
        s:SetSize(135,30)
        s:SetText(table.sText)
        s.DoClick = function()
            main.sPressed = true
            main.sFunc(s,text:GetValue())
            if table.blur then
                main.bp:Remove()
            end
            main:Remove()
        end
        main.sBtn = s

       local a = vgui.Create("DButton",main)
       a:SetPos(main:GetWide()-10-135,100)
       a:SetSize(135,30)
       a:SetText(table.aText)
       a.DoClick = function()
        main.nPressed = true
            main.aFunc(a)
            if table.blur then
                main.bp:Remove()
            end
            main:Remove()
        end
        main.aBtn = a
    end

    vgui.Register("play_derma_value", PANEL, "DFrame")
end
