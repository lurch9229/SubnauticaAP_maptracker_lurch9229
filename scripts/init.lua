local variant = Tracker.ActiveVariantUID

--LOADED SCRIPTS
ScriptHost:LoadScript("scripts/logic.lua")

--LOAD ITEMS
Tracker:AddItems("items/items.json")

-- Open Maps, Then Layouts, Then Locations
if (string.find(Tracker.ActiveVariantUID, "items_only")) 
    then
    Tracker:AddLayouts("layouts/items_only.json")
    Tracker:AddLayouts("layouts/broadcast_vertical.json")
    
    if PopVersion and PopVersion>="0.18.0" then
        ScriptHost:LoadScript("scripts/autotracking.lua")    
    end
else if (string.find(Tracker.ActiveVariantUID, "map_tracker")) 
    then
    Tracker:AddMaps("maps/maps.json")
    Tracker:AddLayouts("layouts/tracker_standard.json")
    Tracker:AddLayouts("layouts/broadcast_vertical.json")
    Tracker:AddLocations("locations/Crater.json")
    Tracker:AddLocations("locations/Cave_Networks.json")

    if PopVersion and PopVersion>="0.18.0" then
        ScriptHost:LoadScript("scripts/autotracking.lua")    
    end
end
end
