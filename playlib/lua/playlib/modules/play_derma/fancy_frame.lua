if !PLAYLIB then return end

if SERVER then

elseif CLIENT then


  local PANEL = {}

  function PANEL:Init()

  	self:SetContentAlignment( 5 )
    self.Title = "DFrame"
    self.HeaderSize = 30
    self.HeaderColor = Color(255,0,0,255)
    self.BaseColor = Color(255,255,255,255)
    self.TitleFont = "DermaDefault"
    self.TitleColor = Color(255,255,255,255)


  	--
  	-- These are Lua side commands
  	-- Defined above using AccessorFunc
  	--
    /*
  	self:SetDrawBorder( true )
  	self:SetPaintBackground( true )

  	self:SetSize(self.RelativeSize,self.RelativeSize)
  	self:SetMouseInputEnabled( true )
  	self:SetKeyboardInputEnabled( true )
    */
    self:SetTitle("")
  	--self:SetFont( "DermaDefault" )

  end

  function PANEL:SetTitleText(str)
    if not str then return end
    if !isstring(str) then return end
    self.Title = str
  end

  function PANEL:SetFont(str)
    if not str then return end
    if !isstring(str) then return end
    self.TitleFont = str
  end

  function PANEL:SetHeaderColor(normal)

    if normal then
      if IsColor(normal) then
        self.HeaderColor = normal
      end
    end

  end

    function PANEL:SetBaseColor(normal)

      if normal then
        if IsColor(normal) then
          self.BaseColor = normal
        end
      end


  end

  function PANEL:SetTextColor(normal,hover)

    if normal then
      if IsColor(normal) then
        self.TextColor = normal
      end
    end

  end

  function PANEL:Paint( w, h )
    draw.RoundedBox(8,0,0,w,h,self.BaseColor)
    PLAYLIB.vgui.drawHalfCircle(self,0,0,w,self.HeaderSize,self.HeaderColor,8)
    draw.DrawText(self.Title,self.TitleFont,self:GetWide()/2,(self.HeaderSize/2)-(draw.GetFontHeight(self.TitleFont)/2),self.TitleColor,TEXT_ALIGN_CENTER)
  end

  vgui.Register("PFrame", PANEL, "DFrame")
end
