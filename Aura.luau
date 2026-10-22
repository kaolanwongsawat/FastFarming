while true do
            local p = Players.LocalPlayer
            local aurasFolder = p:FindFirstChild("aurasFolder") or p:FindFirstChild("AurasFolder") or p:FindFirstChild("Auras")
            local rEvents = ReplicatedStorage:FindFirstChild("rEvents") or ReplicatedStorage:FindFirstChild("remotes")
            local sellAuraEvent = rEvents and (rEvents:FindFirstChild("sellAuraEvent") or rEvents:FindFirstChild("SellAuraEvent") or rEvents:FindFirstChild("sellAura") or rEvents:FindFirstChild("SellAura"))

            if aurasFolder and sellAuraEvent then
                for _, rarityFolder in pairs(aurasFolder:GetChildren()) do
                    if rarityFolder:IsA("Folder") then
                        for _, aura in pairs(rarityFolder:GetChildren()) do
                            if autoSellAurasByName[aura.Name] then
                                pcall(function()
                                    if sellAuraEvent:IsA("RemoteFunction") then
                                        sellAuraEvent:InvokeServer("sellAura", aura)
                                    else
                                        sellAuraEvent:FireServer("sellAura", aura)
                                    end
                                end)
                                task.wait(0.1)
                            end
                        end
                    elseif rarityFolder:IsA("Model") or rarityFolder:IsA("BasePart") then
                        if autoSellAurasByName[rarityFolder.Name] then
                            pcall(function()
                                if sellAuraEvent:IsA("RemoteFunction") then
                                    sellAuraEvent:InvokeServer("sellAura", rarityFolder)
                                else
                                    sellAuraEvent:FireServer("sellAura", rarityFolder)
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
