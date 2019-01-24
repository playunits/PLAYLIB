if !PLAYLIB then return end

PLAYLIB.wos = PLAYLIB.wos or {}

if SERVER then -- Serverside Code here
 
elseif CLIENT then -- Clientside Code here

end

function PLAYLIB.wos.removeItemBySlot(ply,slot)
	if ply.SaberInventory[slot] == "Empty" then return end

	ply.SaberInventory[slot] = "Empty"
end

function PLAYLIB.wos.removeItemByID(ply,id)
	PLAYLIB.wos.removeItemBySlot(ply,PLAYLIB.wos.getSlotByID(ply,id))
end

function PLAYLIB.wos.removeItemByName(ply,id)
	PLAYLIB.wos.removeItemBySlot(ply,PLAYLIB.wos.getSlotByName(ply,id))
end

function PLAYLIB.wos.getSlotByID(ply,id)
	local inv = ply.SaberInventory
	local iname = wOS:GetItemData(id).Name

	for index,entry in pairs(inv) do
		if entry == iname then
			return index
		end
	end
end

function PLAYLIB.wos.getSlotByName(ply,name)
	local inv = ply.SaberInventory
	local iname = wOS:GetItemData(name).Name

	for index,entry in pairs(inv) do
		if entry == iname then
			return index
		end
	end
end