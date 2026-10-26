-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / PlayerDataModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Update = script.Parent:WaitForChild("NavBarUIModule"):WaitForChild("ShopUIModule"):WaitForChild("Update");
local ShopRemotes = ReplicatedStorage:WaitForChild("ShopRemotes");
local Fetch = ShopRemotes:WaitForChild("Fetch");
local Update2 = ShopRemotes:WaitForChild("Update");
local LocalSounds = ReplicatedStorage:WaitForChild("LocalSounds");
local u1 = {};
local u2 = false;

local function PlaySound(p3: string, p4: boolean) -- Line: 28
    -- upvalues: LocalSounds (copy), SoundService (copy)
    local v5 = LocalSounds:FindFirstChild(p3);

    if not v5 then
        return;
    end;

    if not p4 then
        v5.PlaybackSpeed = (p3 == "Hover" and 0.2 or (p3 == "WheelClick" and 0.35 or 0)) + math.random(95, 105) / 100;
    end;

    SoundService:PlayLocalSound(v5);
end;

local u6 = {};
script.AncestryChanged:Connect(function() -- Line: 40
    -- upvalues: u6 (copy)
    if script:IsDescendantOf(game) then
        return;
    end;

    for _, v in u6 do
        v:Disconnect();
    end;

    table.clear(u6);
end);
u6[#u6 + 1] = Update2.OnClientEvent:Connect(function(p7: string, ...) -- Line: 49
    -- upvalues: u2 (ref), u1 (copy), Update (copy), LocalSounds (copy), SoundService (copy)
    if not u2 then
        return;
    end;

    if p7 == "Bundles" then
        u1.Bundles = ...;
        Update:Fire("Bundles");

        return;
    end;

    if p7 == "Caps" then
        local v8 = ...;

        if not v8 then
            return;
        end;

        u1.BottleCaps = v8;
        Update:Fire("Caps");

        return;
    end;

    if p7 ~= "Cases" then
        if p7 ~= "Caps7" then
            if p7 == "PlaySound" then
                local v9 = ...;
                local v10 = LocalSounds:FindFirstChild(v9);

                if not v10 then
                    return;
                end;

                v10.PlaybackSpeed = (v9 == "Hover" and 0.2 or (v9 == "WheelClick" and 0.35 or 0)) + math.random(95, 105) / 100;
                SoundService:PlayLocalSound(v10);
            end;

            return;
        end;

        u1.ShowCaps7 = true;
        Update:Fire("Caps7");

        return;
    end;

    local v11 = ...;

    if not v11 then
        return;
    end;

    u1.Cases = v11;
    Update:Fire("Cases");
end);

while true do
    local success, result = pcall(function() -- Line: 79
        -- upvalues: Fetch (copy)
        return Fetch:InvokeServer();
    end);

    if success then
        if result then
            for i, v in pairs(result) do
                u1[i] = v;
            end;

            u2 = true;

            return u1;
        end;
    else
        warn("[PlayerDataModule] shop data fetch failed, retrying: " .. tostring(result));
    end;

    task.wait(2);
end;