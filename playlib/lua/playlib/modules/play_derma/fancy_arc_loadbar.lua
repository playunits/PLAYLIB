if !PLAYLIB then return end

if SERVER then

elseif CLIENT then


  local PANEL = {}

  function PANEL:Init()

    self.IsCircular = false

    self.DrawBackCircle = true

    self.CircularStart = 0
    self.CircularEnd = 360
    self.HalfCircularStart =180
    self.HalfCircularEnd = 360

    self.Fraction = 0
    self.FractionFunc = nil

    self.FrontColor = Color(255,0,0,255)
    self.BackColor = Color(105,105,105,255)

    self.BackCircle = draw.CreateCircle(CIRCLE_OUTLINED)
    self.BackCircle:SetRadius(100)
    self.BackCircle:SetThickness(50)
    if self.IsCircular then
      self.BackCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
      self.BackCircle:SetAngles(270,269)
    else
      self.BackCircle:SetPos(self:GetWide()/2,self:GetTall())
      self.BackCircle:SetAngles(180,360)
    end

    self.FrontCircle = draw.CreateCircle(CIRCLE_OUTLINED)
    self.FrontCircle:SetRadius(100)
    self.FrontCircle:SetThickness(50)
    if self.IsCircular then
      self.FrontCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
      self.FrontCircle:SetAngles(270,(self.CircularStart+(360*self.Fraction))%360)
      self.FrontCircle:SetRotation(270)
    else
      self.FrontCircle:SetPos(self:GetWide()/2,self:GetTall())
      self.FrontCircle:SetAngles(180,self.HalfCircularStart+(self.HalfCircularStart*self.Fraction))
    end

  end

  function PANEL:Resize(number)
    self.SizeVal = number
    if self.IsCircular then

      self:SetSize(number,number)

      timer.Simple(.001,function()
        self.BackCircle:SetRadius(self:GetWide()/2)
        self.BackCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
        self.FrontCircle:SetRadius(self:GetWide()/2)
        self.FrontCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
      end)

    else

      self:SetSize(number,number/2)

      timer.Simple(.001,function()
        self.BackCircle:SetRadius(self:GetWide()/2)
        self.BackCircle:SetPos(self:GetWide()/2,self:GetTall())
        self.FrontCircle:SetRadius(self:GetWide()/2)
        self.FrontCircle:SetPos(self:GetWide()/2,self:GetTall())
      end)

    end

  end

  function PANEL:SetCircular(boolean)
    self.IsCircular = boolean
    if boolean then
      self.BackCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
      self.BackCircle:SetAngles(0,360)
      self.FrontCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
      self.FrontCircle:SetRotation(270)
      self.FrontCircle:SetAngles(self.CircularStart,(self.CircularStart+(360*self.Fraction))%360)
    else
      self.BackCircle:SetPos(self:GetWide()/2,self:GetTall())
      self.BackCircle:SetAngles(180,360)
      self.FrontCircle:SetPos(self:GetWide()/2,self:GetTall())
      self.FrontCircle:SetAngles(180,self.HalfCircularStart+(self.HalfCircularStart*self.Fraction))
    end

    self:Resize(500)
  end

  function PANEL:SetFraction(number)
    self.Fraction = number
    if self.IsCircular then
      self.FrontCircle:SetAngles(self.CircularStart,(self.CircularStart+(360*self.Fraction))%360)
    else
      self.FrontCircle:SetAngles(180,self.HalfCircularStart+(self.HalfCircularStart*number))
    end
  end

  function PANEL:SetDrawBackCircle(boolean)
    if !isbool(boolean) then return end
    self.DrawBackCircle = boolean
  end

  function PANEL:Paint(w,h)
    draw.NoTexture()
    if self.DrawBackCircle then
      surface.SetDrawColor(self.BackColor)
      self.BackCircle:Draw()
    end
    surface.SetDrawColor(self.FrontColor)
    self.FrontCircle:Draw()
  end

/*
  function PANEL:SetAngles(start,stop)
    self.StartAng = start
    self.EndAng = stop
    self.circle:SetAngles(self.StartAng,self.StartAng+((self.EndAng-self.StartAng)*self.Fraction))
    self.backCircle:SetAngles(self.StartAng,self.EndAng)
    if (self.EndAng-self.StartAng) > 180 then
      self:SetSize(self.SizeVal,self.SizeVal)
      timer.Simple(.001,function()
        self.backCircle:SetPos(self:GetWide()/2,self:GetTall()/2)
        self.circle:SetPos(self:GetWide()/2,self:GetTall()/2)
      end)
    end
  end


  function PANEL:SetSize2(number)
    if not isnumber(number) then return end
    self.SizeVal = number
    self:SetSize(number,number/2)
    timer.Simple(.001,function()
      self.backCircle:SetRadius(number/2)
      self.backCircle:SetPos(self:GetWide()/2,self:GetTall())
      self.circle:SetRadius(number/2)
      self.circle:SetPos(self:GetWide()/2,self:GetTall())
    end)


  end
*/
  function PANEL:SetThickness(number)
    self.BackCircle:SetThickness(number)
    self.FrontCircle:SetThickness(number)
  end



  function PANEL:SetFrontColor(color)
    if not IsColor(color) then return end
    self.FrontColor = color
  end

  function PANEL:SetBackColor(color)
    if not IsColor(color) then return end
    self.BackColor = color
  end

  vgui.Register("PArc_Loadbar", PANEL, "DPanel")
end
