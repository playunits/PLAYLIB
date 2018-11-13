if CLIENT then
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

    function draw.text3D(text, font, x, y, color, alignX, alignY)
        draw.DrawText(text, font, x+1, y+1, color_black, alignX, alignY)
        draw.DrawText(text, font, x, y, color, alignX, alignY)
    end
    function draw.OutlinedBox( x, y, w, h, thickness, clr )
        surface.SetDrawColor( clr )
        for i=0, thickness - 1 do
            surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
        end
    end
    function draw.OutlinedRect(x, y, w, h, InnerColor, OutlineThickness, OutlineColor)
        draw.RoundedBox( 0, x, y, w, h, InnerColor)
        draw.OutlinedBox( x, y, w, h, OutlineThickness, OutlineColor )
    end
    function draw.Line(startX, startY, endX, endY, color, thickness, horizontal)
        surface.SetDrawColor( color )
        for i=1,thickness do
            if horizontal then
                surface.DrawLine(startX, startY + i, endX, endY + i)
            else
                surface.DrawLine(startX + i, startY, endX + i, endY)
            end
        end  
    end
    function surface.JohnnyTextSize(text, font)
        surface.SetFont(font)
        return surface.GetTextSize(text)
    end
    local blur = Material("pp/blurscreen")

    function JohnnyBlur( p, a, d )
        local x, y = p:LocalToScreen(0, 0)
        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( blur )
        for i = 1, d do
            blur:SetFloat( "$blur", (i / d ) * ( a ) )
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
        end
    end

else



end