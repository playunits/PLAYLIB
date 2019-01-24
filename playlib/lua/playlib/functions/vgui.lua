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

end
