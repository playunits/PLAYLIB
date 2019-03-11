if !PLAYLIB then return end

PLAYLIB.vgui = PLAYLIB.vgui or {}

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

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

        return yn
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

        return val
    end

    function PLAYLIB.vgui.frame(title)
      local frame = vgui.Create("play_derma_frame")
      frame:Setup({
        ["title"] = title
      })

      return frame
    end

    function PLAYLIB.vgui.closeButton(sizeX,sizeY)
      local closeButton = vgui.Create("DButton",main)
      closeButton:SetSize(25,25)
      closeButton:SetText("")
      closeButton:SetPos(mw-((mw/2)/10),2)
      closeButton.DoClick = function()
          main:Remove()
          scr:Remove()
          gui.EnableScreenClicker(false)
      end
      closeButton.Paint = function(self,w,h)
          draw.DrawText("X","BFHUD.Size25",w/2,-2,exitBtn:IsHovered() and Color(100,50,50,230) or Color(204,0,0,230))
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

    function PLAYLIB.vgui.drawTriangle(posx,posy,scale,col,left)
        local triangle = {}
        if left then
            posx = posx + (100*scale)
            triangle = {
                { x = posx, y = posy },
                { x = posx-(100*scale), y = posy },
                { x = posx-(100*scale), y = posy-(100*scale) }
            }
        else
            posx = posx - (100*scale)
            triangle = {
                { x = posx, y = posy },
                { x = posx+(100*scale), y = posy },
                { x = posx+(100*scale), y = posy-(100*scale) }
            }
        end


        surface.SetDrawColor( col.r, col.g, col.b, col.a )
        surface.DrawPoly( triangle )
    end

    function PLAYLIB.vgui.drawFilledCircle(centerX,centerY,radius,circleColor)

        local function PointOnCircle(ang,radius,offX,offY)
                ang = math.rad(ang)

                local x = math.cos(ang) * radius + offX
                local y = math.sin(ang) * radius + offY
                return x,y
            end

            local numSquares = 36

            local interval = 360/numSquares
            local verts= {}

            for degrees = 1,360, interval do
                local x,y = PointOnCircle(degrees,radius,centerX,centerY)
                table.insert(verts, {x=x,y=y})
            end

            surface.SetDrawColor(circleColor)
            draw.NoTexture()
            surface.DrawPoly(verts)
    end

    PLAYLIB.vgui.deg2rad = 0.0174532925

    function PLAYLIB.vgui.drawArc(center_x,center_y,radius,thickness,start_ang,end_ang,color)
      if not IsColor(color) then color = Color(255,255,255,255) end

      draw.NoTexture()
    	surface.SetDrawColor( color )

      aa = (radius/100);
      start_ang = math.Clamp( start_ang or 0, 0, 360 );
      end_ang = math.Clamp( end_ang or 360, 0, 360 );

      if end_ang < start_ang then
          local temp = end_ang;
          end_ang = start_ang;
          start_ang = temp;
      end

      for i=start_ang, end_ang, aa do
          local _i = i * PLAYLIB.vgui.deg2rad;
          surface.DrawTexturedRectRotated(math.cos( _i ) * (radius - thickness) + center_x,math.sin( _i ) * (radius - thickness) + center_y, thickness, aa*(radius/50), -i );
      end

    end


end

/*
ARGS
*/

function PLAYLIB.vgui.colorInterpolation(steps,startColor,endColor,curStep,tbl)
  if curStep == steps then
    table.insert(tbl,endColor)
  --  print("[StartColor] = R: "..startColor.r.." G: "..startColor.g.." B: "..startColor.b.." [EndColor] = "..endColor.r.." G: "..endColor.g.." B: "..endColor.b.." [NewColor] = R: "..endColor.r.." G: "..endColor.g.." B: "..endColor.b.." [CurStep] "..steps.." [LERPVAL] 1")
    return
  end
  local lerp_val = curStep/steps
  local r = Lerp(lerp_val,startColor.r,endColor.r)
  local g = Lerp(lerp_val,startColor.g,endColor.g)
  local b = Lerp(lerp_val,startColor.b,endColor.b)
  --print("[StartColor] = R: "..startColor.r.." G: "..startColor.g.." B: "..startColor.b.." [EndColor] = "..endColor.r.." G: "..endColor.g.." B: "..endColor.b.." [NewColor] = R: "..r.." G: "..g.." B: "..b.." [CurStep] "..curStep.."[STEPS] "..steps.." [LERPVAL] "..lerp_val)
  table.insert(tbl,Color(r,g,b,255))
  PLAYLIB.vgui.colorInterpolation(steps,startColor,endColor,curStep+1,tbl)
end

function PLAYLIB.vgui.createColorInterpolationTable(steps,startColor,endColor)
  local retval = {}
  PLAYLIB.vgui.colorInterpolation(steps,startColor,endColor,1,retval)
  return retval
end




function PLAYLIB.vgui.colorInterpolationAnimation(changeValue,steps,time,startColor,endColor)
  local interp_tbl = PLAYLIB.vgui.createColorInterpolationTable(steps,startColor,endColor)

  local function recursion(index)

    --print("[COLOR] Recursion Called for "..index.." times")
    if index == steps+1 then return end
    changeValue.r = interp_tbl[index].r
    changeValue.g = interp_tbl[index].g
    changeValue.b = interp_tbl[index].b
    timer.Simple(time/steps,function()
      recursion(index+1)
    end)

  end

  recursion(1)
end

function PLAYLIB.vgui.coordinateInterpolation(steps,startVal,endVal,curStep,tbl)
  if curStep == steps then
    table.insert(tbl,endVal)
    return
  end
  local lerp_val = curStep/steps
  local val = Lerp(lerp_val,startVal,endVal)
  print("[STARTVAL] = "..startVal.." [ENDVAL] = "..endVal.." [NEWVAL] = "..val.." [CURSTEP] = "..curStep.." [STEPS] = "..steps.." [LERPVAL] = "..lerp_val)
  table.insert(tbl,val)
  PLAYLIB.vgui.coordinateInterpolation(steps,startVal,endVal,curStep+1,tbl)
end

function PLAYLIB.vgui.createCoordinateInterpolationTable(steps,startVal,endVal)
  local retval = {}
  PLAYLIB.vgui.coordinateInterpolation(steps,startVal,endVal,1,retval)
  return retval
end

/*
    changeValue wird nicht erhöht, Viel Glück Zukunfts Juri. BTW, ist das Richtige Script und ist geladen...
*/
function PLAYLIB.vgui.coordinateInterpolationAnimation(val,steps,time,startVal,endVal)
  local interp_tbl = PLAYLIB.vgui.createCoordinateInterpolationTable(steps,startVal,endVal) // Geting a Dynamic Table with the Interpolation Values |Debug: Values created from the Table are Correct

  local function recursion(index)  //Local Recursion Function to execute the "Animation"
    print("[COORDINATE] Recursion Called for "..index.." times")
    if index == steps+1 then return end //Recursion Anchor ... Dont know the exact English Term
    val = interp_tbl[index] // Set the external Value to the Value of the Interpolation Table
    print(interp_tbl[index]) // Debug: See if the Table has a Value. Unfortunately it does
    print("[COORIDNATE] VAL: "..val) //Debug: See if the Value gets one... Yeah it gets the Correct Values from the Table
    timer.Simple(time/steps,function() // Starting the next Recursion after the defined Timeframe: time/steps
      recursion(index+1) // Calling Recursion with the next index
    end)
  end
  recursion(1) // Starting the Initial Recursion. Making an "Animation" with less then 1 Step appears to be very useless
end

function PLAYLIB.vgui.Interpolation(fraction,start,stop)
  local val = start-stop
  return start+(fraction*val)
end
