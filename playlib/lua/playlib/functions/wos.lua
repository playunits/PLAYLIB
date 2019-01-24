if !PLAYLIB then return end

PLAYLIB.wos = PLAYLIB.wos or {}

if SERVER then -- Serverside Code here

elseif CLIENT then -- Clientside Code here

end

function PLAYLIB.wos.removeItemBySlot(ply,slot)
  if slot == -1 then return "Item not Found" end

	if ply.SaberInventory[slot] == "Empty" then return "Slot was Empty" end

	ply.SaberInventory[slot] = "Empty"
  return true
end

function PLAYLIB.wos.removeItemByID(ply,id)
	PLAYLIB.wos.removeItemBySlot(ply,PLAYLIB.wos.getSlotByID(ply,id))
end

function PLAYLIB.wos.removeItemByName(ply,id)
	return PLAYLIB.wos.removeItemBySlot(ply,PLAYLIB.wos.getSlotByName(ply,id))
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

function PLAYLIB.wos.getItemByName(name)
  for index,data in pairs(wOS.ItemList) do
    if data.Name == name then return data end
  end
  return false
end

function PLAYLIB.wos.hasFreeInventorySpace(ply)
  local inv = ply.SaberInventory
  local free = 0

  for i=1,#inv do
    if inv[i] == "Empty" then
      free = free + 1
    end
  end

  if free > 0 then
    return true
  end

  return false
end

function PLAYLIB.wos.getSlotByName(ply,name)
	local inv = ply.SaberInventory
	local iname = wOS:GetItemData(name).Name

	for index,entry in pairs(inv) do
		if entry == iname then
			return index
		end
	end

  return -1
end
