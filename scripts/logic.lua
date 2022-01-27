function has(item, amount)
  local count = Tracker:ProviderCountForCode(item)
  amount = tonumber(amount)
  if not amount then
    return count > 0
  else
    return count == amount
  end
end

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------DEPTH LOGIC-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
 
function canget400()
  if (has ("seaglide:2") and has ("rebreather"))
  or (has ("hightank") and has ("fins") and has ("rebreather") and has ("modify:3"))
  or (has ("$useSeamoth") and has ("rebreather"))
  or has ("$usePrawn")
  or has ("$useCyclops")
  then
    return 1
  else
    return 0
  end
end

function canget500()
  if (has ("$useSeaglide") and has ("hightank") and has ("rebreather") and has ("$canModify"))
  or (has ("$useSeamoth") and has ("rebreather") and has ("$useSMD1"))
  or has ("$usePrawn")
  or has ("$useCyclops")
  then
    return 1
  else
    return 0
  end
end

function canget750()
  if (has ("$useSeaglide") and has ("fins") and has ("hightank") and has ("rebreather") and has ("$canModify") and has ("$canget500"))
  or (has ("$useSeamoth") and has ("$canModifyUpgrade") and has ("$useSMD2") and has ("$canget500"))
  or has ("$usePrawn")
  or (has ("$useCyclops") and has ("rebreather") and has ("$canget500"))
  or (has ("$useCyclops") and has ("$useCD1") and has ("$canget500"))
  then
    return 1
  else
    return 0
  end
end

function canget900()
  if (has ("$useSeamoth") and has ("$useSMD3") and has ("$canget750"))
  or has ("$usePrawn")
  or (has ("$useCyclops") and has ("$useCD1") and has ("$canget750"))
  then
    return 1
  else
    return 0
  end
end

function canget1200()
  if (has ("$useSeamoth") and has ("$useSMD3") and has ("rebreather") and has ("hightank") and has ("$useSeaglide") and has ("$canget750"))
  or (has ("$usePrawn") and has ("$usePD1") and has ("$canget750"))
  or (has ("$usePrawn") and has ("rebreather") and has ("hightank") and has ("$useSeaglide") and has ("$canModify") and has ("$canget750"))
  or (has ("$useCyclops") and has ("$useCD2") and has ("$canget750"))
  or (has ("$useCyclops") and has ("$useCD1") and has ("rebreather") and has ("hightank") and has ("$useSeaglide") and has ("$canModify") and has ("$canget750"))
  then
    return 1
  else
    return 0
  end
end

function canget1500()
  if (has ("$usePrawn") and has ("$usePD2") and has ("$canget1200"))
  or (has ("$usePrawn") and has ("$usePD1") and has ("rebreather") and has ("hightank") and has ("$useSeaglide") and has ("$canget1200"))
  or (has ("$useCyclops") and has ("$useCD3") and has ("$canget1200"))
  or (has ("$useCyclops") and has ("$useCD2") and has ("rebreather") and has ("hightank") and has ("$useSeaglide") and has ("$canget1200"))
  then
    return 1
  else
    return 0
  end
end

function canget1800()
  if (has ("$usePrawn") and has ("$usePD2") and has ("$canget1500"))
  or (has ("$useCyclops") and has ("$useCD3") and has ("$canget1500"))
  then
    return 1
  else
    return 0
  end
end

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------RESOURCE ACCESS------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

function kyaniteACCESS()
  if (has ("$canget1200") and has ("$usePrawn") and has ("$usePD1"))
  or (has ("$useCyclops") and has ("$useCD2"))
  or (has ("$canget900") and has ("builder"))
  then
    return 1
  else
    return 0
  end
end

function nickelACCESS()
  if has ("$canget900")
  or (has ("$canget750") and has ("builder"))
  then
    return 1
  else
    return 0
  end
end

function sulfurACCESS()
  if has ("$canget900")
  or (has ("$canget750") and has ("builder"))
  then
    return 1
  else
    return 0
  end
end

function gelACCESS()
  if has ("$canget400")
  then
    return 1
  else
    return 0
  end
end

function rubyACCESS()
  if has ("$canget400")
  then
    return 1
  else
    return 0
  end
end

function kelpACCESS()
  if has ("$canget400")
  then
    return 1
  else
    return 0
  end
end

function magneACCESS()
  if (has ("rebreather") and has ("$useSeaglide"))
  or has ("$canget400")
  then
    return 1
  else
    return 0
  end
end

function getAero()
  if (has ("$rubyACCESS") and has ("$gelACCESS"))
  then
    return 1
  else
    return 0
  end
end

function shroomACCESS()
  if has ("$canget400")
  then
    return 1
  else
    return 0
  end
end


--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------VEHICLE ACCESS-------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

function useSeaglide()
  if has ("seaglide:2")
  then
    return 1
  else
    return 0
  end
end

function useVehicles()
  if has ("vehiclebay:3")
  then
    return 1
  else
    return 0
  end
end

function useSeamoth()
  if (has ("seaglide:3") and has ("$useVehicles"))
  then
    return 1
  else
    return 0
  end
end

function usePrawn()
  if (has ("prawn:4") and has ("$useVehicles"))
  then
    return 1
  else
    return 0
  end
end

function useCyclops()
  if (has ("cyclops:9") and has ("$useVehicles"))
  then
    return 1
  else
    return 0
  end
end

function canUpgrade()
  if (has ("pool:2") and has ("console") and has ("builder"))
  then
    return 1
  else
    return 0
  end
end

function canModify()
  if (has ("modify:3") and has ("builder"))
  then
    return 1
  else
    return 0
  end
end

function canModifyUpgrade()
  if (has ("$canUpgrade") and has ("$canModify"))
  then
    return 1
  else
    return 0
  end
end

function useSMD1()
  if (has ("$canUpgrade") and has ("smd1"))
  then
    return 1
  else
    return 0
  end
end

function useSMD2()
  if (has ("$canModifyUpgrade") and has ("$useSMD1") and has ("smd2") and has ("$magneACCESS"))
  then
    return 1
  else
    return 0
  end
end

function useSMD3()
  if (has ("$useSMD2") and has ("smd3") and has ("$rubyACCESS"))
  then
    return 1
  else
    return 0
  end
end

function usePD1()
  if (has ("$canUpgrade") and has ("pd1") and has ("$rubyACCESS") and has ("$nickelACCESS"))
  then
    return 1
  else
    return 0
  end
end

function usePD2()
  if (has ("$usePD1") and has ("$canModifyUpgrade") and has ("pd2") and has ("$kyaniteACCESS"))
  then
    return 1
  else
    return 0
  end
end

function useCD1()
  if (has ("$useCyclops") and has ("cd1") and has ("$rubyACCESS"))
  then
    return 1
  else
    return 0
  end
end

function useCD2()
  if (has ("$useCD1") and has ("$canModifyUpgrade") and has ("$nickelACCESS"))
  then
    return 1
  else
    return 0
  end
end

function useCD3()
  if (has ("$useCD2") and has ("cd3") and has ("$kyaniteACCESS"))
  then
    return 1
  else
    return 0
  end
end
