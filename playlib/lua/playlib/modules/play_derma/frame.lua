if !PLAYLIB then return end

if SERVER then

elseif CLIENT then

    local PANEL = {}


    function PANEL:Init()
        self:SetSize(800,500)
        self:ShowCloseButton(false)
        self.startTime = os.time()
    end

    function PANEL:UseBlur(bool)
        PANEL.blur = bool
    end

    function PANEL:Paint(w,h)
      draw.RoundedBox(8,0,0,w,h,PLAYLIB.play_derma.MainBaseWindowColor)
      PLAYLIB.vgui.drawHalfCircle(self,0,0,w,30,PLAYLIB.play_derma.MainHighlightWindowColor,8)
    end

    function PANEL:Setup(table)

        if !table then return end

        local main = self

        if not table.title then table.title = "" end

        self:SetTitle("")
        self:Center()
        self:SetDraggable(false)
        self:MakePopup()

        local p = vgui.Create("DPanel",main)
        p:SetPos(0,0)
        p:SetSize(400,200)
        p.Paint = function(w,h)
            draw.DrawText(table.title, "Trebuchet18", 200, 5, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
        end

    vgui.Register("play_derma_frame", PANEL, "DFrame")
end
