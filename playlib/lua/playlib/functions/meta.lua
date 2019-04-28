if !PLAYLIB then return end

PLAYLIB.meta = PLAYLIB.meta or {}

local ENTITY = FindMetaTable("Entity")

function ENTITY:SetNWTable(identifier,tbl)
    if not identifier or not type(identifier) == "string" then return end
    if not tbl or not type(tbl) == "table" then return end

    local json = util.TableToJSON(tbl)

    // Determine how often we have to Split the JSON string in order to oblige to the 200 Character Limit
    local splits = (math.Round(string.len(json)/199,0)+1)
    // Calculate the Amount of Characters we are left with, after doing the given amount of splits
    local remains = string.len(json)%199
    // Network how many Splits we have to do, so the Client can reassemble the Data fully
    self:SetNWInt("PLAYLIB.meta."..identifier..":Splits",splits)

    for i=1,splits do
        // We always want to start at the first and end at the 199th Position
        local sub_start = 1
        local sub_end = 199

        // Some Weird shit going on with sub, idk what but just set it to the double size *HACKY WORKAROUND*
        if i==splits then
            sub_end = remains*2
        end

        local sub = i==1 and 0 or 1
        local message = string.sub(json,sub_start+sub,sub_end)
        json = string.sub(json,sub_end)

        self:SetNWString("PLAYLIB.meta."..identifier..":Data"..i,message)
    end
end

function ENTITY:GetNWTable(identifier)
    local splits  = self:GetNWInt("PLAYLIB.meta."..identifier..":Splits",-1)
    assert(splits!=-1,"The given Identifier does not exist in this Context")
    local json = ""

    for i=1, splits do
        json = json..self:GetNWString("PLAYLIB.meta."..identifier..":Data"..i)
    end

    return util.JSONToTable(json)

end