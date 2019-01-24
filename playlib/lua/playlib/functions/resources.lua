if !PLAYLIB then return end

PLAYLIB.resources = PLAYLIB.resources or {}

if SERVER then -- Serverside Code here

  function PLAYLIB.resources.downloadAllFromTable(path,tbl)
    for i=1,#tbl do
      print("PLAYLIB ADDED: "..path.."/"..tbl[i])
      resource.AddFile(path.."/"..tbl[i])
    end

  end

      local files,dirs = file.Find("materials/wos_custom_icons/saboteur/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/saboteur",files)

      local files,dirs = file.Find("materials/wos_custom_icons/scharfschuetze/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/scharfschuetze",files)

      local files,dirs = file.Find("materials/wos_custom_icons/marodeur/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/marodeur",files)

      local files,dirs = file.Find("materials/wos_custom_icons/hexer/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/hexer",files)

      local files,dirs = file.Find("materials/wos_custom_icons/juggernaut/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/juggernaut",files)

      local files,dirs = file.Find("materials/wos_custom_icons/attentaeter/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/attentaeter",files)

      local files,dirs = file.Find("materials/wos_custom_icons/soeldner/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/soeldner",files)

      local files,dirs = file.Find("materials/wos_custom_icons/powertech/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/powertech",files)
      local files,dirs = file.Find("materials/wos_custom_icons/trooper/*.png","GAME")
      PLAYLIB.resources.downloadAllFromTable("materials/wos_custom_icons/trooper",files)




elseif CLIENT then -- Clientside Code here

end
