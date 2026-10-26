-- [PATH] ReplicatedStorage / CharacterScripts / EventViewer @Type LocalScript


local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Main = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main");
local Notification = Main:WaitForChild("Notification");
local Map = Main:WaitForChild("Map"):WaitForChild("Frame"):WaitForChild("Map");
local TimedCrateTemplate = Map:WaitForChild("TimedCrateTemplate");
local BTRTemplate = Map:WaitForChild("BTRTemplate");
local BorisTemplate = Map:WaitForChild("BorisTemplate");
local BrutusTemplate = Map:WaitForChild("BrutusTemplate");
local BrunoTemplate = Map:WaitForChild("BrunoTemplate");
local HeliTemplate = Map:WaitForChild("HeliTemplate");
local Events = workspace:WaitForChild("Events");
local Modules = ReplicatedStorage:WaitForChild("Modules");
require(Modules:WaitForChild("NumberUtil"));
local MilitaryState = require(Modules:WaitForChild("MilitaryState"));
local u1 = {
    ["Bruno\'s M4A1"] = {
        Name = "Bruno",
        Template = BrunoTemplate
    },
    ["Military PKM"] = {
        Name = "Boris",
        Template = BorisTemplate
    },
    ["Military Grenade Launcher"] = {
        Name = "Brutus",
        Template = BrutusTemplate
    }
};
local Notification2 = script:WaitForChild("Notification");
local Loners = workspace:WaitForChild("Bases"):WaitForChild("Loners");
local u2 = nil;
local Vector2_new_ret = Vector2.new(0, 0);
local u3 = {
    BTR = "rbxassetid://16270992443",
    BTRfire = "rbxassetid://16270991717",
    ["Timed Crate"] = "rbxassetid://16018005011",
    Boris = "rbxassetid://18312187080",
    Bruno = "rbxassetid://16652579167",
    Brutus = "rbxassetid://134265072222654",
    AttackHeli = "rbxassetid://130971974270462",
    AttackHelifire = "rbxassetid://88572356825945"
};
local u4 = {};

local function _(p5) -- Line: 69
    -- upvalues: Vector2_new_ret (copy)
    local v6 = 0.5 + (p5.X - Vector2_new_ret.X) / 12800;
    local v7 = typeof(p5) == "Vector3" and p5.Z or p5.Y;

    return UDim2.new(v6, 0, 0.5 + (v7 - Vector2_new_ret.Y) / 12800, 0);
end;

local function u24(p8) -- Line: 76
    -- upvalues: u4 (copy), u2 (ref), TimedCrateTemplate (copy), Vector2_new_ret (copy), Map (copy), Events (copy), BTRTemplate (copy), HeliTemplate (copy), MilitaryState (copy), u1 (copy)
    for i, v in pairs(u4) do
        if not p8 or v.Name == "BTR" then
            v:Destroy();
            u4[i] = nil;
        end;
    end;

    if u2 and (u2.Parent and not p8) then
        for _, child in pairs(u2:GetChildren()) do
            local u9 = TimedCrateTemplate:Clone();
            local Position = child.Main.Position;
            local v10 = 0.5 + (Position.X - Vector2_new_ret.X) / 12800;
            local v11 = typeof(Position) == "Vector3" and Position.Z or Position.Y;
            u9.Position = UDim2.new(v10, 0, 0.5 + (v11 - Vector2_new_ret.Y) / 12800, 0);
            u9.Parent = Map;
            u9.Visible = true;
            u4[child] = u9;
            u9.MouseEnter:Connect(function() -- Line: 94
                -- upvalues: u9 (copy)
                u9.TextLabel.Visible = true;
            end);
            u9.MouseLeave:Connect(function() -- Line: 97
                -- upvalues: u9 (copy)
                u9.TextLabel.Visible = false;
            end);
        end;
    end;

    local BTR = Events:FindFirstChild("BTR");

    if BTR then
        local v12 = BTRTemplate:Clone();
        v12.BTRImage.Image = BTR:GetAttribute("Destroyed") and "rbxassetid://16270991717" or "rbxassetid://16270992443";
        local Position = BTR.Hull.Position;
        local v13 = 0.5 + (Position.X - Vector2_new_ret.X) / 12800;
        local v14 = typeof(Position) == "Vector3" and Position.Z or Position.Y;
        v12.Position = UDim2.new(v13, 0, 0.5 + (v14 - Vector2_new_ret.Y) / 12800, 0);
        v12.Name = "BTR";
        v12.Parent = Map;
        v12.Visible = true;
        u4[BTR] = v12;
    end;

    for _, child in pairs(Events:GetChildren()) do
        local v15 = nil;
        local v16 = nil;

        if child.Name == "AttackHeli" and not child:GetAttribute("Crashed") then
            v15 = child:FindFirstChild("Main");

            if v15 then
                v15 = v15.Position;
            end;

            v16 = "rbxassetid://130971974270462";
        elseif child.Name == "HeliCrash" then
            v15 = child:GetAttribute("Position");
            v16 = "rbxassetid://88572356825945";
        end;

        if v15 then
            local v17 = HeliTemplate:Clone();
            v17.BTRImage.Image = v16;
            local v18 = 0.5 + (v15.X - Vector2_new_ret.X) / 12800;
            local v19 = typeof(v15) == "Vector3" and v15.Z or v15.Y;
            v17.Position = UDim2.new(v18, 0, 0.5 + (v19 - Vector2_new_ret.Y) / 12800, 0);
            v17.Name = "Heli";
            v17.Parent = Map;
            v17.Visible = true;
            u4[child] = v17;
        end;
    end;

    for _, v in pairs(MilitaryState.Entries) do
        local v20 = v.Boss and u1[v.Weapon];

        if v20 then
            local v21 = v20.Template:Clone();
            local Position = v.CF.Position;
            local v22 = 0.5 + (Position.X - Vector2_new_ret.X) / 12800;
            local v23 = typeof(Position) == "Vector3" and Position.Z or Position.Y;
            v21.Position = UDim2.new(v22, 0, 0.5 + (v23 - Vector2_new_ret.Y) / 12800, 0);
            v21.Name = v20.Name;
            v21.Parent = Map;
            v21.Visible = true;
            u4[v] = v21;
        end;
    end;
end;

local function u30(p25) -- Line: 151
    -- upvalues: Notification (copy), u3 (copy), TweenService (copy), Notification2 (copy)
    Notification.Bottom.Event.Text = string.upper(p25) .. " AVAILABLE";
    Notification.Image.Image = u3[p25];
    local TweenInfo_new_ret = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0);
    local v26 = {
        Position = Notification:GetAttribute("PositionOpen")
    };
    local v27 = {
        Position = Notification:GetAttribute("PositionClosed")
    };
    local v28 = TweenService:Create(Notification, TweenInfo_new_ret, v26);
    local v29 = TweenService:Create(Notification, TweenInfo_new_ret, v27);
    v28:Play();
    Notification2:Play();
    task.wait(8);
    v29:Play();
end;

local function v34(p31) -- Line: 171
    -- upvalues: u2 (ref), u24 (copy), u30 (copy)
    if not (p31 and (p31.Parent and p31.Name == "Timed Crate")) then
        return;
    end;

    u2 = p31;
    u2.ChildAdded:Connect(function(p32) -- Line: 174
        -- upvalues: u24 (ref), u30 (ref)
        if p32.Name == "Timed Crate" then
            u24();
            u30("Timed Crate");
        end;
    end);
    u2.ChildRemoved:Connect(function(p33) -- Line: 180
        -- upvalues: u24 (ref)
        if p33.Name == "Timed Crate" then
            u24();
        end;
    end);
    task.wait();
    u24();
end;

local u35 = {
    Idle = {
        Rate = 5,
        Color = Color3.fromRGB(150, 150, 150),
        Size = { 0.5, 1.4, 2.4 }
    },
    Drive = {
        Rate = 14,
        Color = Color3.fromRGB(62, 62, 62),
        Size = { 0.7, 2, 3.4 }
    }
};
local u36 = { 0, 0.4, 1 };
local u37 = {
    [Enum.Material.Snow] = Color3.fromRGB(236, 240, 244),
    [Enum.Material.Glacier] = Color3.fromRGB(226, 234, 240),
    [Enum.Material.Sand] = Color3.fromRGB(206, 182, 142),
    [Enum.Material.Sandstone] = Color3.fromRGB(196, 166, 126),
    [Enum.Material.Grass] = Color3.fromRGB(124, 104, 74),
    [Enum.Material.LeafyGrass] = Color3.fromRGB(118, 102, 72),
    [Enum.Material.Mud] = Color3.fromRGB(92, 72, 56),
    [Enum.Material.Ground] = Color3.fromRGB(132, 112, 86)
};
local Color3_fromRGB_ret = Color3.fromRGB(140, 126, 106);
local u38 = { 0.6, 0.35, 0.15 };
local u39 = {
    { 4, Color3.fromRGB(118, 118, 118) },
    { 14, Color3.fromRGB(38, 38, 38) },
    { 20, Color3.fromRGB(24, 24, 24) }
};

local function u108(u40) -- Line: 217
    -- upvalues: u35 (copy), u36 (copy), u39 (copy), u38 (copy), RunService (copy), u37 (copy), Color3_fromRGB_ret (copy)
    local Hull = u40:WaitForChild("Hull", 10);
    local v41;

    if Hull then
        v41 = Hull:WaitForChild("WheelJoints", 10);
    else
        v41 = Hull;
    end;

    local u42;

    if Hull then
        u42 = Hull:WaitForChild("GunBase", 10);
    else
        u42 = Hull;
    end;

    local Detail = u40:WaitForChild("Detail", 10);
    local u43;

    if Detail then
        u43 = Detail:WaitForChild("GunBase", 10);
    else
        u43 = Detail;
    end;

    if u43 then
        u43 = u43:WaitForChild("GunPivot", 10);
    end;

    if not (v41 and (u42 and u43)) then
        return;
    end;

    local C1 = u42.C1;
    local C12 = u43.C1;
    local Gun = Detail:FindFirstChild("Gun");
    local GunPivot = Detail:FindFirstChild("GunPivot");

    if GunPivot then
        GunPivot = GunPivot:FindFirstChild("Gun");
    end;

    local u44;

    if GunPivot then
        u44 = GunPivot.C1;
    else
        u44 = GunPivot;
    end;

    local u45 = 0;

    local function u47(u46) -- Line: 232
        -- upvalues: Hull (copy)
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not (u46 and (workspace_CurrentCamera and (workspace_CurrentCamera.CFrame.Position - Hull.Position).Magnitude <= 1000)) then
            return;
        end;

        for _, child in u46:GetChildren() do
            if child:IsA("ParticleEmitter") or child:IsA("Light") then
                child.Enabled = true;
            end;
        end;

        task.delay(0.06, function() -- Line: 240
            -- upvalues: u46 (copy)
            for _, child in u46:GetChildren() do
                if child:IsA("ParticleEmitter") or child:IsA("Light") then
                    child.Enabled = false;
                end;
            end;
        end);
    end;

    u40:GetAttributeChangedSignal("CannonShot"):Connect(function() -- Line: 248
        -- upvalues: u47 (copy), Gun (copy), u45 (ref)
        local v48 = Gun and Gun:FindFirstChild("Muzzle");
        pcall(u47, v48);
        u45 = 0.7;
    end);
    u40:GetAttributeChangedSignal("CoaxShot"):Connect(function() -- Line: 252
        -- upvalues: u47 (copy), Gun (copy)
        local v49 = Gun and Gun:FindFirstChild("CoaxMuzzle");
        pcall(u47, v49);
    end);
    local u50 = {};

    for _, child in v41:GetChildren() do
        if child:IsA("Motor6D") then
            local Z = child.C0.Position.Z;
            local v51 = {
                Travel = 0,
                Want = 0,
                Joint = child,
                C1Inv = child.C1:Inverse(),
                Rest = child.C0.Position - child.C1.Position,
                Steer = Z < -6 and 1 or (Z < 0 and 0.55 or 0)
            };
            table.insert(u50, v51);
        end;
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { u40, workspace:FindFirstChild("VFX") };
    RaycastParams_new_ret.RespectCanCollide = true;
    local u52 = {};
    local u53 = {};
    local u54 = nil;
    local u55 = 0;
    local u56 = 0;
    local u57 = 0;
    local u58 = 0;
    local u59 = 0;

    for _, child in Hull:GetChildren() do
        local v60 = child:IsA("Attachment") and child:FindFirstChildOfClass("ParticleEmitter");

        if v60 then
            if child.Name:find("^Exhaust") then
                table.insert(u52, v60);
            elseif child.Name:find("^Dust") then
                local v61 = child;
                local v62 = (1 / 0);
                local v63 = nil;

                for _, v in u50 do
                    local Magnitude = (v.Rest - v61.Position).Magnitude;

                    if Magnitude < v62 then
                        v63 = v;
                        v62 = Magnitude;
                    end;
                end;

                table.insert(u53, {
                    Rate = 0,
                    Material = false,
                    Emitter = v60,
                    Wheel = v63
                });
            end;
        end;
    end;

    local u64 = 0;
    local u65 = -1;
    local u66 = 0;

    local function u75(p67, p68) -- Line: 292
        -- upvalues: u54 (ref), u52 (copy), u65 (ref), u64 (ref), u66 (ref), u35 (ref), u36 (ref)
        local v69 = p67 ~= nil;

        if v69 ~= (u54 ~= nil) then
            for _, v in u52 do
                v.Enabled = v69;
            end;
        end;

        u54 = p67;

        if not v69 then
            u65 = -1;

            return;
        end;

        local v70 = p67 == "Drive" and 1 or 0;
        local v71 = p68 / 1.5;
        u64 = u64 + math.clamp(v70 - u64, -v71, v71);
        local os_clock_ret = os.clock();

        if math.abs(u64 - u65) < 0.001 or not (u64 == v70) and os_clock_ret < u66 then
            return;
        end;

        u65 = u64;
        u66 = os_clock_ret + 0.1;
        local Idle = u35.Idle;
        local Drive = u35.Drive;
        local v72 = u64;
        local v73 = {};

        for i, v in u36 do
            v73[i] = NumberSequenceKeypoint.new(v, Idle.Size[i] + (Drive.Size[i] - Idle.Size[i]) * v72);
        end;

        local v74 = Idle.Rate + (Drive.Rate - Idle.Rate) * v72;
        local ColorSequence_new_ret = ColorSequence.new(Idle.Color:Lerp(Drive.Color, v72));
        local NumberSequence_new_ret = NumberSequence.new(v73);

        for _, v in u52 do
            v.Rate = v74;
            v.Color = ColorSequence_new_ret;
            v.Size = NumberSequence_new_ret;
        end;
    end;

    local u76 = {
        Smoke = {},
        Sparks = {},
        Fire = {}
    };
    local u77 = 0;

    for _, child in Hull:GetChildren() do
        if child:IsA("Attachment") and child.Name:find("^Damage") then
            local v78 = child;

            for _, child2 in child:GetChildren() do
                if child2:IsA("ParticleEmitter") or child2:IsA("Light") then
                    table.insert(u76[v78.Name == "DamageVFX" and "Smoke" or (v78.Name == "DamageSparks" and "Sparks" or "Fire")], child2);
                end;
            end;
        end;
    end;

    local u79 = 0;
    local u80 = nil;
    local u81 = 0;

    local function u85(p82) -- Line: 336
        -- upvalues: u77 (ref), u39 (ref), u76 (copy), u80 (ref), u79 (ref)
        if p82 == u77 then
            return;
        end;

        local v83 = u77;
        u77 = p82;
        local v84 = u39[p82];

        for _, v in u76.Smoke do
            v.Enabled = v84 ~= nil;
        end;

        if v84 and (v83 == 0 or not u80) then
            u79 = v84[1];
            u80 = v84[2];

            for _, v in u76.Smoke do
                local ColorSequence_new_ret = ColorSequence.new(u80);
                v.Rate = u79;
                v.Color = ColorSequence_new_ret;
            end;
        end;

        for _, v in u76.Sparks do
            v.Enabled = p82 >= 2;
        end;

        for _, v in u76.Fire do
            v.Enabled = p82 >= 3;
        end;
    end;

    local function u91(p86) -- Line: 353
        -- upvalues: u39 (ref), u77 (ref), u80 (ref), u79 (ref), u81 (ref), u76 (copy)
        local v87 = u39[u77];

        if not (v87 and u80) then
            return;
        end;

        local v88 = v87[1];
        local v89 = v87[2];

        if math.abs(v88 - u79) + math.abs(v89.R - u80.R) * 30 < 0.05 then
            return;
        end;

        local v90 = 1 - math.exp(-1.6 * p86);
        u79 = u79 + (v88 - u79) * v90;
        u80 = u80:Lerp(v89, v90);
        local os_clock_ret = os.clock();

        if os_clock_ret < u81 then
            return;
        end;

        u81 = os_clock_ret + 0.15;

        for _, v in u76.Smoke do
            local ColorSequence_new_ret = ColorSequence.new(u80);
            v.Rate = u79;
            v.Color = ColorSequence_new_ret;
        end;
    end;

    local function u93() -- Line: 369
        -- upvalues: u40 (copy), u38 (ref)
        local Attribute = u40:GetAttribute("Health");
        local Attribute2 = u40:GetAttribute("MaxHealth");

        if type(Attribute) ~= "number" or (type(Attribute2) ~= "number" or Attribute2 <= 0) then
            return 0;
        end;

        local v92 = 0;

        for i, v in u38 do
            if Attribute / Attribute2 < v then
                v92 = i;
            end;
        end;

        return v92;
    end;

    local function _(p94, p95) -- Line: 379
        if p95 == p94.Rate then
            return;
        end;

        p94.Rate = p95;
        p94.Emitter.Rate = p95;
        p94.Emitter.Enabled = p95 > 0;
    end;

    local u96 = nil;
    u96 = RunService.Heartbeat:Connect(function(u97) -- Line: 386
        -- upvalues: u40 (copy), u96 (ref), u54 (ref), u52 (copy), u65 (ref), u85 (copy), u53 (copy), Hull (copy), u75 (copy), u93 (copy), u91 (copy), u57 (ref), u58 (ref), u42 (copy), C1 (copy), u43 (copy), C12 (copy), GunPivot (copy), u45 (ref), u44 (copy), u55 (ref), u59 (ref), u56 (ref), u50 (copy), RaycastParams_new_ret (copy), u37 (ref), Color3_fromRGB_ret (ref)
        pcall(function() -- Line: 387
            -- upvalues: u40 (ref), u96 (ref), u54 (ref), u52 (ref), u65 (ref), u85 (ref), u53 (ref), Hull (ref), u75 (ref), u97 (copy), u93 (ref), u91 (ref), u57 (ref), u58 (ref), u42 (ref), C1 (ref), u43 (ref), C12 (ref), GunPivot (ref), u45 (ref), u44 (ref), u55 (ref), u59 (ref), u56 (ref), u50 (ref), RaycastParams_new_ret (ref), u37 (ref), Color3_fromRGB_ret (ref)
            if not u40.Parent or u40:GetAttribute("Destroyed") then
                u96:Disconnect();

                if u54 ~= nil ~= false then
                    for _, v in u52 do
                        v.Enabled = false;
                    end;
                end;

                u54 = nil;
                u65 = -1;
                u85(0);

                for _, v in u53 do
                    if v.Rate ~= 0 then
                        v.Rate = 0;
                        v.Emitter.Rate = 0;
                        v.Emitter.Enabled = false;
                    end;
                end;

                return;
            end;

            local workspace_CurrentCamera = workspace.CurrentCamera;
            local v98 = workspace_CurrentCamera and (workspace_CurrentCamera.CFrame.Position - Hull.Position).Magnitude or (1 / 0);
            local v99 = u40:GetAttribute("Speed") or 0;
            local math_abs_ret = math.abs(v99);
            u75(v98 <= 450 and (math_abs_ret > 1.5 and "Drive" or "Idle") or nil, u97);
            u85(v98 <= 600 and u93() or 0);
            u91(u97);

            if v98 > 350 then
                for _, v in u53 do
                    if v.Rate ~= 0 then
                        v.Rate = 0;
                        v.Emitter.Rate = 0;
                        v.Emitter.Enabled = false;
                    end;
                end;
            end;

            if v98 > 1000 then
                return;
            end;

            local Attribute = u40:GetAttribute("Aim");

            if typeof(Attribute) == "Vector2" then
                local v100 = 1 - math.exp(-12 * u97);
                u57 = u57 + ((Attribute.X - u57 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v100;
                u58 = u58 + (Attribute.Y - u58) * v100;
                u42.C1 = CFrame.Angles(0, -u57, 0) * C1;
                u43.C1 = CFrame.Angles(0, 0, -u58) * C12;
            end;

            if GunPivot and (GunPivot.Parent and (u45 > 0.005 or GunPivot.C1 ~= u44)) then
                u45 = u45 * math.exp(-14 * u97);
                GunPivot.C1 = CFrame.new(0, 0, -u45) * u44;
            end;

            if v98 > 350 then
                return;
            end;

            local v101 = u40:GetAttribute("Speed") or 0;
            u55 = u55 + ((u40:GetAttribute("Steer") or 0) * 0.4886921905584123 - u55) * (1 - math.exp(-8 * u97));
            u59 = (u59 - v101 / 2.45 * u97) % 6.283185307179586;
            local os_clock_ret = os.clock();
            local v102 = u56 <= os_clock_ret;

            if v102 then
                u56 = os_clock_ret + 0.05;
            end;

            local CFrame2 = Hull.CFrame;
            local UpVector = CFrame2.UpVector;
            local v103 = 1 - math.exp(-10 * u97);

            for _, v in u50 do
                if v102 then
                    local v104 = workspace:Raycast(CFrame2 * v.Rest + UpVector * 2, -UpVector * 5.65, RaycastParams_new_ret);
                    v.Want = v104 and math.clamp(4.45 - v104.Distance, -0.6, 0.9) or math.max(v.Want - 0.15, -0.6);

                    if v104 then
                        v104 = v104.Material;
                    end;

                    v.Material = v104;
                end;

                v.Travel = v.Travel + (v.Want - v.Travel) * v103;
                v.Joint.C1 = (v.C1Inv * CFrame.new(0, v.Travel, 0) * CFrame.Angles(0, u55 * v.Steer, 0) * CFrame.Angles(u59, 0, 0)):Inverse();
            end;

            for _, v in u53 do
                local v105 = v.Wheel and v.Wheel.Material;
                local v106;

                if v105 == nil then
                    v106 = false;
                else
                    v106 = v105 ~= Enum.Material.Water;
                end;

                local v107;

                if v98 <= 250 and (v106 and math_abs_ret > 2) then
                    local math_floor_ret = math.floor(math_abs_ret * 0.8);
                    v107 = math.clamp(math_floor_ret, 2, 10) or 0;
                else
                    v107 = 0;
                end;

                if v107 ~= v.Rate then
                    v.Rate = v107;
                    v.Emitter.Rate = v107;
                    v.Emitter.Enabled = v107 > 0;
                end;

                if v106 and v105 ~= v.Material then
                    v.Material = v105;
                    v.Emitter.Color = ColorSequence.new(u37[v105] or Color3_fromRGB_ret);
                end;
            end;
        end);
    end);
end;

local function v110(p109) -- Line: 453
    -- upvalues: u30 (copy), u108 (copy)
    if p109.Name == "AttackHeli" then
        if not p109:GetAttribute("Marked") then
            p109:SetAttribute("Marked", true);
            u30("AttackHeli");
        end;

        return;
    end;

    if p109.Name == "BTR" then
        task.spawn(u108, p109);

        if not p109:GetAttribute("Marked") then
            p109:SetAttribute("Marked", true);
            u30("BTR");
        end;
    end;
end;

Loners.ChildAdded:Connect(v34);
v34(Loners:FindFirstChild("Timed Crate"));
Events.ChildRemoved:Connect(function() -- Line: 474
    -- upvalues: u24 (copy)
    u24();
end);
Events.ChildAdded:Connect(v110);
MilitaryState.BossSpawned:Connect(function(p111) -- Line: 481
    -- upvalues: u1 (copy), u30 (copy)
    local v112 = u1[p111];

    if v112 then
        u30(v112.Name);
    end;
end);

for _, child in pairs(Events:GetChildren()) do
    v110(child);
end;

while true do
    u24();
    task.wait(2);
end;