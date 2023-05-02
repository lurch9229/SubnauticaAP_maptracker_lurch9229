function has(item, amount)
  local obj = Tracker:FindObjectForCode(item)
  if obj.Type == "toggle" then
    if obj.Active then
      return true
    end
  elseif obj.Type == "consumable" then
    if obj.AcquiredCount == amount then
      return true
    end
  elseif obj.Type == "progressive" then
    if obj.CurrentStage == amount then
      return true
    end
  end
end

function canFinish()
  local goal = Tracker:FindObjectForCode("goal").CurrentStage
  if goal == 0 then
    if useSeaglide() and has("radsuit") and has("propcannon", 2) then
      Tracker:FindObjectForCode("finish").Active = true
    else
      Tracker:FindObjectForCode("finish").Active = false
    end
  elseif goal == 1 then
    if maxDepth() > 900 then
      Tracker:FindObjectForCode("finish").Active = true
    else
      Tracker:FindObjectForCode("finish").Active = false
    end
  elseif goal == 2 then
    if maxDepth() > 1444 then
      Tracker:FindObjectForCode("finish").Active = true
    else
      Tracker:FindObjectForCode("finish").Active = false
    end
  elseif goal == 3 then
    if has("base") and has("gantry") and has("boosters") and has("reserves") and has("cockpit") and has("vehiclebay", 3) and useCyclops() and has("shield") and has("ionbattery") and has("ionpower") and maxDepth() > 1444 then
      Tracker:FindObjectForCode("finish").Active = true
    else
      Tracker:FindObjectForCode("finish").Active = false
    end
  else
    print("goal not recognized")
  end
end
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------VEHICLE ACCESS-------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

function useSeaglide()
  if has("seaglide", 2) then
    return true
  end
end

function useVehicles()
  if has("vehiclebay", 3) then
    return true
  end
end

function useSeamoth()
  if has("seamoth", 3) and useVehicles() then
    return true
  end
end

function useCyclops()
  if (has("cyclopsbridge", 3) and has("cyclopsengine", 3)) and (has("cyclopshull", 3) and useVehicles()) then
    return true
  end
end

function usePrawn()
  if has("prawn", 4) and useVehicles() then
    return true
  end
end

function canUpgrade()
  if has("moonpool", 2) and has("console") then
    return true
  end
end

function canModify()
  if has("modify", 3) then
    return true
  end
end

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------DEPTH LOGIC-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

function swimDepth(swimrule)
  local rule = math.tointeger(swimrule)
  if rule ~= 5 then
    rule = Tracker:FindObjectForCode("swimrule").CurrentStage
  end 
  local depth = 0
  if rule == 0 or rule == 3 then
    depth = 200
  elseif rule == 1 or rule == 4 then
    depth = 400
  elseif rule == 2 or rule == 5 then
    depth = 600
  end
  if rule > 2 then
    if useSeaglide() then
      if has("ultratank") then
        depth = depth + 350
      else
        depth = depth + 200
      end
    elseif has("ultrafins") then
      if has("ultratank") then
        depth = depth + 150
      elseif has("lighttank") then
        depth = depth + 75
      else 
        depth = depth + 50
      end
    else
      if has("ultratank") then
        depth = depth + 100
      elseif has("lighttank") then
        depth = depth + 25
      end
    end
  end
  return depth
end

function seamothDepth()
  local depth = 0
  if useSeamoth() then
    if canUpgrade() and canModify() then
      depth = 900
    elseif canUpgrade() then
      depth = 300
    else
      depth = 200
    end
  end
  return depth
end

function cyclopsDepth()
  local depth = 0
  if useCyclops() then
    if has("cd1") then
      if canModify() then
        depth = 1700
      else
        depth = 900
      end
    else
      depth = 500
    end
  end
  return depth
end

function prawnDepth()
  local depth = 0
  if usePrawn() then
    if canUpgrade() and canModify() then
      depth = 1700
    elseif canUpgrade() then
      depth = 1300
    else
      depth = 900
    end
  end
  return depth
end

function maxDepth(swimrule)
  if useSeaglide() then
    Tracker:FindObjectForCode("depth").AcquiredCount = swimDepth() + math.max(seamothDepth(), cyclopsDepth(), prawnDepth())
    return swimDepth(swimrule) + math.max(seamothDepth(), cyclopsDepth(), prawnDepth()) 
  else
    Tracker:FindObjectForCode("depth").AcquiredCount = swimDepth()
    return swimDepth(swimrule) 
  end
end

function canAccess(x, y, z, swimrule)
  local swimrule = swimrule
  maxDepth()
  canFinish()
  if has("radsuit") ~= true then
    if math.sqrt((x - 1038)^2 + y^2 + (z + 163.1)^2) < 950 then
      return false
    end
  end
  if useSeaglide() ~= true then
    if (x^2 + z^2)^0.5 < 800 and -y < 200 then
      return true
    else
      return false
    end
  end
  if maxDepth(swimrule) > -y then
      return true
  end
end
