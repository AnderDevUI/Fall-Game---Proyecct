-- [PATH] ReplicatedStorage / Modules / WeldModule @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Attachments = ReplicatedStorage:WaitForChild("Attachments");
ReplicatedStorage:WaitForChild("Remotes");
local PlayerSounds = ReplicatedStorage:WaitForChild("PlayerSounds");
local Items = require(Modules:WaitForChild("Items"));
local SoundModule = require(Modules:WaitForChild("SoundModule"));
local u20 = {
    WeldParts = function(p1, p2, p3, p4) -- Line: 27, Name: WeldParts
        local v5;

        if p4 == "All" then
            v5 = nil;
        else
            v5 = Instance.new("Weld");
            v5.Part0 = p3;
            v5.Part1 = p2;

            if type(p4) == "string" or not p4 then
                local CFrame_new_ret = CFrame.new(v5.Part0.Position);
                v5.C0 = v5.Part0.CFrame:inverse() * CFrame_new_ret;
                v5.C1 = v5.Part1.CFrame:inverse() * CFrame_new_ret;
            else
                v5.C0 = p4;
            end;

            v5.Parent = p2;
        end;

        p2.Anchored = false;
        p2.CanCollide = false;
        p2.Massless = true;

        return v5;
    end,

    WeldModel = function(p6, p7, p8, p9) -- Line: 49, Name: WeldModel
        for _, child in pairs(p7:GetChildren()) do
            if child:IsA("BasePart") then
                if p7.PrimaryPart ~= child then
                    p6:WeldParts(child, p7.PrimaryPart, p8);
                end;

                if p9 then
                    child.CanTouch = false;
                    child.CanQuery = false;
                end;
            end;
        end;
    end,

    WeldModelToPart = function(p10, p11, p12, p13, p14) -- Line: 61, Name: WeldModelToPart
        p10:WeldModel(p11, p14 and "" or "All");

        return p10:WeldParts(p11.PrimaryPart, p12, p13);
    end,

    FullyWeldModels = function(p15, p16, p17, p18) -- Line: 66, Name: FullyWeldModels
        local v19 = {};

        for _, child in pairs(p16:GetChildren()) do
            if child:IsA("Model") then
                if p17:FindFirstChild(child.Name) then
                    child.PrimaryPart = child.PrimaryPart or child:FindFirstChild("Middle");
                    local PrimaryPart = child.PrimaryPart;
                    p15:WeldModel(child, nil, p18);
                    child.Parent = p17;
                    p15:WeldParts(PrimaryPart, p17[child.Name], CFrame.new());
                    PrimaryPart.Transparency = 1;
                    PrimaryPart.Name = child.Name;
                    child.Name = p16.Name;
                    table.insert(v19, child);
                end;
            else
                child.Parent = p17;
            end;
        end;

        p16:Destroy();

        return v19;
    end
};

function u20.WeldAttachments(p21: table, p22: userdata, p23: any, p24: any, p25: any, p26: any, p27: any) -- Line: 87
    -- upvalues: Items (copy), Attachments (copy), u20 (copy), Players (copy), PlayerSounds (copy), SoundModule (copy), SoundService (copy)
    local v28 = type(p23) == "table";
    local v29 = {};
    local Attachments2 = p22:FindFirstChild("Attachments");
    local v30 = v28 and (p23.Attachments or {}) or {};
    local v31 = p22:FindFirstChild("Arrow") or p22:FindFirstChild("ArrowMain");

    if (p22:FindFirstChild("RocketRoot") or v31) and v28 then
        local Ammo = p23.Ammo;

        if Ammo and (Ammo.Amount > 0 and not p26) then
            p26 = Ammo.ID;
        end;

        if p26 then
            p26 = Items[p26];
        end;

        local v32 = p26 and p26.Name or "";

        for _, child in pairs(p22:GetChildren()) do
            local Name = child.Name;

            if Name ~= "RocketRoot" and (Name ~= "Arrow" and (Name ~= "ArrowMain" and (not v31 or Name:find("Arrow")))) and (v31 or Name:find("Rocket")) then
                local v33 = Name == v32;
                child.Transparency = v33 and 0 or 1;

                if Name == "Combustive Arrow" then
                    local ParticleHolder = child:FindFirstChild("ParticleHolder");

                    if ParticleHolder then
                        for _, child2 in pairs(ParticleHolder:GetChildren()) do
                            child2.Enabled = v33;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if not (Attachments2 and v30) then
        return;
    end;

    local v34 = {};

    for _, v in pairs(v30) do
        local v35 = Items[v.ID];

        if not v35.MaxDurability or v.Durability > 0 then
            v34[v35.Name] = v;
        end;
    end;

    for _, child in pairs(Attachments2:GetChildren()) do
        if not v34[child.Name] then
            child:Destroy();
        end;
    end;

    local v36 = 0;

    for i, v in pairs(v34) do
        local v37 = Attachments2:FindFirstChild(i);
        local AttachmentType = Items[v.ID].AttachmentType;
        v36 = AttachmentType == "Sight" and 1 or v36;
        local v38;

        if AttachmentType == "Sight" then
            if v28 then
                v38 = p23.ID == 198 and true or p23.ID == 221;
            else
                v38 = v28;
            end;
        else
            v38 = false;
        end;

        local v39;

        if v37 then
            for i2, v2 in pairs({ "AimFront", "AimBack", "FlashPart" }) do
                if v37 then
                    v39 = v37:FindFirstChild(v2);
                else
                    v39 = v37;
                end;

                if v39 then
                    v29[v2] = v39;
                end;
            end;
        else
            local v40 = p22:FindFirstChild(AttachmentType .. "Main");
            local v41 = Attachments:FindFirstChild(i);

            if v41 and v40 then
                v37 = v41:Clone();

                if p27 and p27 ~= 1 then
                    v37:ScaleTo(p27);
                end;

                v37.PrimaryPart = v37:FindFirstChild("Main");
                local Reticle = v37:FindFirstChild("Reticle");

                if Reticle and p25 then
                    for _, child in pairs(Reticle:GetChildren()) do
                        child.Enabled = false;
                    end;
                end;

                local v42 = false;

                if v38 then
                    local M4Riser = v37:FindFirstChild("M4Riser");

                    if M4Riser then
                        M4Riser.Transparency = 0;
                        v42 = true;
                    end;
                end;

                u20:WeldModelToPart(v37, v40, v42 and CFrame.new(0, 0.08, 0) or CFrame.new());
                v37.Parent = Attachments2;

                for i2, v2 in pairs({ "AimFront", "AimBack", "FlashPart" }) do
                    if v37 then
                        v39 = v37:FindFirstChild(v2);
                    else
                        v39 = v37;
                    end;

                    if v39 then
                        v29[v2] = v39;
                    end;
                end;
            end;
        end;
    end;

    local SightHide = p22:FindFirstChild("SightHide");

    if SightHide then
        SightHide.Transparency = v36;
    end;

    local RailExtender = p22:FindFirstChild("RailExtender");

    if RailExtender then
        RailExtender.Transparency = v36 == 0 and 1 or 0;
    end;

    local Silencer = v34.Silencer;

    if v28 and not p24 then
        local Parent = p22.Parent;

        if Players:GetPlayerFromCharacter(Parent) then
            local PrimaryPart = Parent.PrimaryPart;
            local v43 = Items[p23.ID];

            if PrimaryPart and v43 then
                local v44 = PlayerSounds:FindFirstChild(v43.Name);

                if v44 then
                    local v45 = p23.Skin or "Default";
                    local v46 = SoundModule.CustomSoundSkins[v45];

                    for _, v in v46 and { "", (`_{v45}`) } or { "" } do
                        local v47 = `Shoot{v}`;
                        local v48 = PrimaryPart:FindFirstChild(v43.Name .. v47);
                        local v49 = v44:FindFirstChild(v47);

                        if v48 and v49 then
                            v48.RollOffMaxDistance = Silencer and 250 or v49.RollOffMaxDistance;
                            v48.Volume = v49.Volume * (Silencer and ((v == "" or type(v46) ~= "number") and 0.95 or v46 or 1) or 1);
                            local SilencedEffect = v48:FindFirstChild("SilencedEffect");

                            if Silencer and not SilencedEffect then
                                SoundService.SilencedEffect:Clone().Parent = v48;
                            elseif SilencedEffect and not Silencer then
                                SilencedEffect:Destroy();
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v29.AimFront, v29.AimBack, v29.FlashPart;
end;

return u20;