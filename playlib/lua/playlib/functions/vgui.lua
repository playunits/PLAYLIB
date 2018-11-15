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
            ["sText"] = sName,
            ["sFunc"] = sFunc,
            ["aFunc"] = aFunc,
            ["aText"] = aName,
            ["placeholder"] = placeholder,
            ["blur"] = blur
        })
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
