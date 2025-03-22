-- pfUI-EmbedPlus: Combat toggle for pfUI's dock feature - Version 1.0

local T = pfUI.api and pfUI.api.T or function(text) return text end

pfUI:RegisterModule("EmbedPlus", "vanilla", function()
  -- Default configuration structure
  if not C.embedplus then C.embedplus = {} end
  
  -- Configuration setup
  local defaults = {
    ["enabled"] = "1",
    ["showOnEnterCombat"] = "1", 
    ["hideOnExitCombat"] = "1",
    ["combatExitDelay"] = "10.0",
    ["forceRefreshOnLogin"] = "1"
  }
  
  -- Apply default settings where needed
  for k, v in pairs(defaults) do
    if not C.embedplus[k] then C.embedplus[k] = v end
  end

  -- Variables to store state
  local exitingCombat = false
  local exitTimer, toggleTimer = nil, nil

  -- Create frame for events
  local pfEmbedPlus = CreateFrame("Frame", "pfEmbedPlus", UIParent)

  -- Helper function for timers
  local function CreateTimer(duration, callback)
    local timer = CreateFrame("Frame")
    if duration then
      timer.timeLeft = duration
      timer:SetScript("OnUpdate", function()
        timer.timeLeft = timer.timeLeft - arg1
        if timer.timeLeft <= 0 then
          if callback then callback() end
          timer:SetScript("OnUpdate", nil)
        end
      end)
    end
    return timer
  end

  -- Force toggle dock visibility state
  local function ForceRefreshDock(callback)
    if not pfUI.thirdparty or not pfUI.thirdparty.meters then 
      if callback then callback() end
      return 
    end
    
    -- Clear existing toggle timer
    if toggleTimer then toggleTimer:SetScript("OnUpdate", nil) end
    
    -- First toggle
    local firstToggleTimer = CreateFrame("Frame")
    firstToggleTimer.time = GetTime()
    firstToggleTimer:SetScript("OnUpdate", function()
      if GetTime() > this.time + 0.1 then
        pfUI.thirdparty.meters:Toggle()
        
        -- Second toggle
        local secondToggleTimer = CreateFrame("Frame")
        secondToggleTimer.time = GetTime()
        secondToggleTimer:SetScript("OnUpdate", function()
          if GetTime() > this.time + 0.05 then
            pfUI.thirdparty.meters:Toggle()
            if callback then callback() end
            this:SetScript("OnUpdate", nil)
          end
        end)
        
        this:SetScript("OnUpdate", nil)
      end
    end)
    
    -- Store timer to prevent garbage collection
    toggleTimer = firstToggleTimer
  end

  -- Visibility controls
  local function ShowMeters()
    if not pfUI.thirdparty or not pfUI.thirdparty.meters then return end
    pfUI.thirdparty.meters.state = nil -- Next toggle shows meters
    pfUI.thirdparty.meters:Toggle()
  end

  local function ShowChat()
    if not pfUI.thirdparty or not pfUI.thirdparty.meters then return end
    pfUI.thirdparty.meters.state = true -- Next toggle shows chat
    pfUI.thirdparty.meters:Toggle()
  end

  -- Combat state check
  local function CheckCombatState()
    if UnitAffectingCombat("player") and C.embedplus.showOnEnterCombat == "1" then
      ShowMeters()
    end
  end

  -- Make functions globally accessible
  pfUI.embedplus = {}

  -- Load configuration
  function pfUI.embedplus:UpdateConfig()
    if C.embedplus.enabled == "1" then
      pfEmbedPlus:RegisterEvent("PLAYER_REGEN_DISABLED")
      pfEmbedPlus:RegisterEvent("PLAYER_REGEN_ENABLED")
      
      -- Force dock refresh and then check combat state
      if C.embedplus.forceRefreshOnLogin == "1" then
        ForceRefreshDock(CheckCombatState)
      else
        CheckCombatState()
      end
    else
      pfEmbedPlus:UnregisterEvent("PLAYER_REGEN_DISABLED")
      pfEmbedPlus:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
  end

  -- Event handler
  pfEmbedPlus:RegisterEvent("PLAYER_ENTERING_WORLD")
  pfEmbedPlus:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
      pfUI.embedplus:UpdateConfig()
      
    elseif event == "PLAYER_REGEN_DISABLED" then
      -- Only process if addon + feature is enabled
      if C.embedplus.enabled ~= "1" or C.embedplus.showOnEnterCombat ~= "1" then return end
      
      -- Cancel hide timer when entering combat
      if exitingCombat then
        if exitTimer then exitTimer:SetScript("OnUpdate", nil) end
        exitingCombat = false
      end
      
      -- Show meters when entering combat
      ShowMeters()
      
    elseif event == "PLAYER_REGEN_ENABLED" then
      -- Only process if addon + feature is enabled
      if C.embedplus.enabled ~= "1" or C.embedplus.hideOnExitCombat ~= "1" then return end
      
      -- Leaving combat - start timer
      exitingCombat = true
      
      -- Clear existing timer
      if exitTimer then exitTimer:SetScript("OnUpdate", nil) end
      
      -- Hide meters after set delay
      exitTimer = CreateTimer(tonumber(C.embedplus.combatExitDelay), function()
        ShowChat()
        exitingCombat = false
      end)
    end
  end)
end)

-- Register GUI component
pfUI:RegisterModule("EmbedPlusGUI", "vanilla", function()
  local T = pfUI.api and pfUI.api.T or function(text) return text end
  
  -- Register using CreateGUIEntry
  pfUI.gui.CreateGUIEntry(T("Thirdparty"), T("Embed Plus"), function()
    pfUI.gui.CreateConfig(nil, T("Enable Combat Auto-Toggle"), C.embedplus, "enabled", "checkbox")
    pfUI.gui.CreateConfig(nil, T("Show Meters When Entering Combat"), C.embedplus, "showOnEnterCombat", "checkbox")
    pfUI.gui.CreateConfig(nil, T("Hide Meters When Leaving Combat"), C.embedplus, "hideOnExitCombat", "checkbox")
    pfUI.gui.CreateConfig(nil, T("Hide Delay (seconds)"), C.embedplus, "combatExitDelay")
    pfUI.gui.CreateConfig(nil, T("Fix Login Visibility"), C.embedplus, "forceRefreshOnLogin", "checkbox")
  end)
  
  -- Set essential default values
  pfUI:UpdateConfig("embedplus", nil, "enabled", "1")
  pfUI:UpdateConfig("embedplus", nil, "showOnEnterCombat", "1")
  pfUI:UpdateConfig("embedplus", nil, "hideOnExitCombat", "1")
  pfUI:UpdateConfig("embedplus", nil, "combatExitDelay", "10.0")
  pfUI:UpdateConfig("embedplus", nil, "forceRefreshOnLogin", "1")
end)