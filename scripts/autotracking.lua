-- autotracking lua code taken from the minecraft AP autotracker:
-- 
-- https://github.com/Cyb3RGER/minecraft_rando_tracker/blob/master/scripts/autotracking.lua
--
-- Code written by Cyb3RGER (https://github.com/Cyb3RGER), used with permission.

-- Configuration --------------------------------------
AUTOTRACKER_ENABLE_DEBUG_LOGGING = true or ENABLE_DEBUG_LOG
AUTOTRACKER_ENABLE_ITEM_TRACKING = true
AUTOTRACKER_ENABLE_LOCATION_TRACKING = true and not IS_ITEMS_ONLY
-------------------------------------------------------

print("")
print("Active Auto-Tracker Configuration")
print("---------------------------------------------------------------------")
print("Enable Item Tracking:        ", AUTOTRACKER_ENABLE_ITEM_TRACKING)
print("Enable Location Tracking:    ", AUTOTRACKER_ENABLE_LOCATION_TRACKING)
if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
    print("Enable Debug Logging:        ", "true")
end
print("---------------------------------------------------------------------")
print("")

CUR_INDEX = -1
SLOT_DATA = nil

ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("called onClear"), slot_data)
    end
    CUR_INDEX = -1
    for _, v in pairs(LOCATION_MAPPING) do --clear locations
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                   obj.Active = false 
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end

    for _, v in pairs(ITEM_MAPPING) do --clear items
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end

    for k, v in pairs(CREATURE_MAPPING) do  --reset creatures
        Tracker:FindObjectForCode(k).Active = false
        Tracker:FindObjectForCode(v).Active = true
    end

    SLOT_DATA = slot_data
    Tracker:FindObjectForCode("goal").CurrentStage = 0 --reset settings
    Tracker:FindObjectForCode("swimrule").CurrentStage = 0
    Tracker:FindObjectForCode("deathlink").Active = false
    Tracker:FindObjectForCode("pooltype").CurrentStage = 0
    Tracker:FindObjectForCode("finish").Active = false
    
    for k, v in pairs(SETTING_MAPPING) do
        local value = SLOT_DATA[k]
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(string.format("onClear: loading setting data %s of value %s into item %s", k, value, Tracker:FindObjectForCode(v)))
        end
        if v == "goal" then
            if value == "drive" then
                Tracker:FindObjectForCode(v).CurrentStage = 0
            elseif value == "infected" then
                Tracker:FindObjectForCode(v).CurrentStage = 1
            elseif value == "free" then
                Tracker:FindObjectForCode(v).CurrentStage = 2
            elseif value == "launch" then
                Tracker:FindObjectForCode(v).CurrentStage = 3
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: did not recognize goal %s", value))
            end
        elseif v == "swimrule" then
            if value == "easy" then
                Tracker:FindObjectForCode(v).CurrentStage = 0
            elseif value == "normal" then
                Tracker:FindObjectForCode(v).CurrentStage = 1
            elseif value == "hard" then
                Tracker:FindObjectForCode(v).CurrentStage = 2
            elseif value == "items_easy" then
                Tracker:FindObjectForCode(v).CurrentStage = 3
            elseif value == "items_normal" then
                Tracker:FindObjectForCode(v).CurrentStage = 4
            elseif value == "items_hard" then
                Tracker:FindObjectForCode(v).CurrentStage = 5
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print(string.format("onClear: did not recognize swimrule %s", value))
            end
        elseif v == "deathlink" then
            if value == 1 then
                Tracker:FindObjectForCode(v).Active = true
            end
        elseif v == "pooltype" then
            if value[1] then
                Tracker:FindObjectForCode(v).CurrentStage = 1
            else
                Tracker:FindObjectForCode(v).CurrentStage = 0
            end
        elseif k == "creatures_to_scan" then    --mapping creatures
            for a, b in pairs(value) do
                print(a, b, CREATURE_MAPPING[b])
                Tracker:FindObjectForCode(CREATURE_MAPPING[b]).Active = false
            end
        else
            print("setting", k, "not recognized")    
        end
    end
end

function onItem(index, item_id, item_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("called onItem: %s, %s, %s, %s", index, item_id, item_name, CUR_INDEX))
    end
    if index <= CUR_INDEX then return end
    CUR_INDEX = index;    
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            if obj.AcquiredCount < obj.MaxCount then
                obj.AcquiredCount = obj.AcquiredCount + 1
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end

function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])    
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)