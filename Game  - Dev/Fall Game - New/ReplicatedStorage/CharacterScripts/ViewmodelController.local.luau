

Run = game:GetService("RunService");
Replicated = game:GetService("ReplicatedStorage");
InputService = game:GetService("UserInputService");
Players = game:GetService("Players");
Sound = game:GetService("SoundService");
Debris = game:GetService("Debris");
Lighting = game:GetService("Lighting");
VFX_PARTS = workspace:WaitForChild("VFX");
VM_PARTS = VFX_PARTS:WaitForChild("VMs");
Drops = workspace:WaitForChild("Drops");
Nodes = workspace:WaitForChild("Nodes");
Plants = workspace:WaitForChild("Plants");
VMs = Replicated:WaitForChild("VMs");
Modules = Replicated:WaitForChild("Modules");
Values = Replicated:WaitForChild("Values");
VFX_STORAGE = Replicated:WaitForChild("VFX");
Sleeves = Replicated:WaitForChild("Sleeves");
Player = Players.LocalPlayer;
PlayerGui = Player:WaitForChild("PlayerGui");
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
Camera = workspace.CurrentCamera;
local Mouse = Player:GetMouse();
StateController = script_Parent:WaitForChild("StateController");
InventoryController = script_Parent:WaitForChild("InventoryController");
WheelController = script_Parent:WaitForChild("WheelController");
CameraController = script_Parent:WaitForChild("CameraController");
WaterController = script_Parent:WaitForChild("WaterController");
InteractController = script_Parent:WaitForChild("InteractController");
TeamNavigationController = script_Parent:WaitForChild("TeamNavigationController");
local PreferredInputController = Player:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local ChatController = Player:WaitForChild("PlayerScripts"):WaitForChild("ChatController");

local function _() -- Line: 58
    -- upvalues: PreferredInputController (copy)
    local v1 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    return v1;
end;

local function _() -- Line: 61
    -- upvalues: PreferredInputController (copy)
    local v2 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Touch";

    return v2;
end;

function isCrosshairAlwaysOn()
    -- upvalues: PreferredInputController (copy)
    local v3 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" or PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Touch";

    return v3;
end;

local ToolInfo = require(Modules:WaitForChild("ToolInfo"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local TableUtil = require(Modules:WaitForChild("TableUtil"));
local Spring = require(Modules:WaitForChild("Spring"));
local Items = require(Modules:WaitForChild("Items"));
local VFXModule = require(Modules:WaitForChild("VFXModule"));
local WeldModule = require(Modules:WaitForChild("WeldModule"));
local ItemClass = require(Modules:WaitForChild("ItemClass"));
local SoundModule = require(Modules:WaitForChild("SoundModule"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local TweenUtil = require(Modules:WaitForChild("TweenUtil"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local u4 = require(Modules:WaitForChild("AssetContainer"))();
EquipVM = script:WaitForChild("EquipVM");
UpdateVM = script:WaitForChild("UpdateVM");
PlayVMAnimation = script:WaitForChild("PlayVMAnimation");
local Main = PlayerGui:WaitForChild("Main");
local Crosshair = Main:WaitForChild("Crosshair");
local HitMarker = Main:WaitForChild("HitMarker");
local Scope = Main:WaitForChild("Scope");
local Codelock = Main:WaitForChild("Codelock");
local RenameBed = Main:WaitForChild("RenameBed");
local GiveBed = Main:WaitForChild("GiveBed");
local Toolbar = Main:WaitForChild("Toolbar");
local Stats = Main:WaitForChild("Stats");
local GamepadControls = Main:WaitForChild("GamepadControls");
local Highlight = VFX_STORAGE:WaitForChild("Highlight");
local CameraRoot = Replicated:WaitForChild("CameraRoot");
local u5 = RaycastUtil:FilterFunction("View");
local u6 = RaycastUtil:FilterFunction("HitIgnore");
local u7 = RaycastUtil:FilterFunction("HitMelee");
local u8 = RaycastUtil:FilterFunction("HitMeleeIgnore");
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = {
    Local = {},
    Global = {},
    Camera = {}
};
local u24 = 0;
local u25 = 0;
local u26 = 0.0135;
local u27 = 0.0025;
local u28 = 0.015;
local u29 = 0.006;
local CFrame_new_ret = CFrame.new();
local CFrame_new_ret2 = CFrame.new();
local CFrame_new_ret3 = CFrame.new();
local u30 = false;
local u31 = false;
mobileADSToggled = false;
mobileAimFire = {
    Hold = 0,
    Raised = false,
    Firing = false,
    Tap = false
};
CameraInputModule = require(Player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("CameraInput"));
local u32 = tick();
local u33 = tick();
local CFrame_new_ret4 = CFrame.new();
local u34 = 0;
local u35 = 0;
local u36 = 1;
local u37 = 1;
local u38 = 7;
local u39 = false;
local u40 = 1;
local u41 = {};
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = "None";
local u46 = "None";
local u47 = false;
local u48 = false;
local u49 = false;
local u50 = 0;
local u51 = 0;
local u52 = 0;
local u53 = 0;
local u54 = 0;
local u55 = nil;
local u56 = 0;
local u57 = 0;
local u58 = 0;
local u59 = 0;
local u60 = 0;
local u61 = 0;
local u62 = 1;
local u63 = 0;
local u64 = tick();
local u65 = tick();
local u66 = 0;
local u67 = nil;
local u68 = tick();
local u69 = 0;
local u70 = 0;
local CFrame_new_ret5 = CFrame.new();
local u71 = 1;
local u72 = 1;
npcMarker = {
    Count = 0,
    At = (-1 / 0),
    ConfirmAt = (-1 / 0)
};
local u73 = tick();
local u74 = 0;
local u75 = 0;
local u76 = 0;
local u77 = 0;
local CFrame_new_ret6 = CFrame.new();
local u78 = 0;
local u79 = 0;
local u80 = {
    Code = nil,
    Pos = Vector3.new(),
    Rot = Vector3.new()
};
local u81 = tick();
local CFrame_new_ret7 = CFrame.new();
local u82 = 1;
local u83 = false;
local u84 = false;
local u85 = 0;
local u86 = 1;
local u87 = true;
local Size = Scope.Size;
local u88 = 0;
local u89 = nil;
local CFrame_new_ret8 = CFrame.new();
local CFrame_new_ret9 = CFrame.new();
local CFrame_new_ret10 = CFrame.new();
local CFrame_new_ret11 = CFrame.new();
local CFrame_new_ret12 = CFrame.new();
local u90 = false;
local u91 = nil;
local u92 = false;
local u93 = Spring.new((Vector3.new()));
u93.Damper = 0.48;
u93.Speed = 25;
local u94 = Spring.new((Vector3.new()));
u94.Damper = 0.55;
u94.Speed = 25;
local u95 = Spring.new((Vector3.new()));
u95.Damper = 0.6;
u95.Speed = 20;
local u96 = nil;
local u97 = Spring.new((Vector3.new()));
u97.Damper = 0.6;
u97.Speed = 20;
local u98 = 0;
local u99 = 0;
local u100 = 1;
local CFrame_new_ret13 = CFrame.new();
local Vector3_new_ret = Vector3.new();
local u101 = Spring.new((Vector3.new()));
u101.Damper = 0.36;
u101.Speed = 25;
local u102 = nil;
local u103 = Spring.new((Vector3.new()));
u103.Damper = 0.2;
u103.Speed = 40;
local u104 = nil;

local function _(p105) -- Line: 283
    local v106 = InventoryController.Fetch:Invoke();

    if not v106 then
        return;
    end;

    local Toolbar2 = v106.Toolbar;

    if Toolbar2 then
        local v107 = Toolbar2[p105 or script:GetAttribute("Equipped")];

        if v107 == nil then
            v107 = false;
        elseif v107 == 0 then
            v107 = false;
        end;

        return v107;
    end;
end;

local function u118(p108) -- Line: 292
    -- upvalues: SettingsModule (copy), u10 (ref), Humanoid (copy), u87 (ref), u21 (ref), TableUtil (copy)
    if not SettingsModule.GetSetting("Graphics", "Bullet Casings") then
        return;
    end;

    local v109 = VFX_STORAGE[p108.Type];

    if not (v109 and (u10 and (Humanoid and (Humanoid.Parent and u87)))) then
        return;
    end;

    if not u21 then
        warn("CasingRelease not found in VM.");

        return;
    end;

    local Attribute = StateController:GetAttribute("Direction");
    local v110 = p108.ExtraMoveVelocities or { 0, 0 };
    local v111 = (Attribute:find("Left") and v110[1] or (Attribute:find("Right") and v110[2] or 0)) * (Humanoid.WalkSpeed / 10);
    local v112 = v109:Clone();
    local PrimaryPart = v112.PrimaryPart;
    v112:PivotTo(u21.CFrame * p108.Offset);
    PrimaryPart.Velocity = PrimaryPart.CFrame.RightVector * (TableUtil:TableRandom(p108.Velocity) + v111);
    local RotationVariance = p108.RotationVariance;
    local v113 = math.random(-RotationVariance * 10, RotationVariance * 10) / 10;
    local v114 = math.random(-RotationVariance * 10, RotationVariance * 10) / 10;
    local v115 = math.random(-RotationVariance * 10, RotationVariance * 10) / 10;
    PrimaryPart.RotVelocity = Vector3.new(v113, v114, v115);
    local u116 = nil;
    u116 = PrimaryPart.Touched:Connect(function(p117) -- Line: 306
        -- upvalues: PrimaryPart (copy), u116 (ref)
        if not (p117 and (p117.Parent and (p117.CanCollide and (PrimaryPart and PrimaryPart.Parent)))) then
            return;
        end;

        PrimaryPart.Velocity = Vector3.new();
        PrimaryPart.RotVelocity = Vector3.new();
        u116:Disconnect();
    end);
    v112.Parent = VFX_PARTS;
    Debris:AddItem(v112, 6);
end;

local function u135(p119, p120, p121) -- Line: 316
    -- upvalues: u23 (copy), u11 (ref), u9 (ref), script_Parent (copy), Items (copy), ToolInfo (copy), u118 (copy), u13 (ref), SoundModule (copy)
    for i, _ in pairs(u23) do
        local v122 = {};
        local v123 = i == "Local";
        local v124 = p119[i .. "Anims"];

        if v123 and p121 then
            v124 = p119:FindFirstChild((`LocalAnims{p121}`)) or v124;
        end;

        local v125 = i;

        for _, child in pairs(v124:GetChildren()) do
            local v126 = (v125 == "Camera" and u11.AnimationController or (v123 and u9 or script_Parent).Humanoid):LoadAnimation(child);
            v122[child.Name] = v126;

            if v123 then
                v126.KeyframeReached:Connect(function(p127) -- Line: 328
                    -- upvalues: Items (ref), script_Parent (ref), ToolInfo (ref), u118 (ref), u13 (ref), SoundModule (ref)
                    local v128 = p127 == "Bolt Back" and "BoltBack" or p127;
                    local v129 = InventoryController.Fetch:Invoke();
                    local v130;

                    if v129 then
                        local Toolbar2 = v129.Toolbar;

                        if Toolbar2 then
                            v130 = Toolbar2[script:GetAttribute("Equipped")];

                            if v130 == nil then
                                v130 = false;
                            elseif v130 == 0 then
                                v130 = false;
                            end;
                        else
                            v130 = nil;
                        end;
                    else
                        v130 = nil;
                    end;

                    if not v130 then
                        return;
                    end;

                    local v131 = Items[v130.ID];

                    if not (v131 and (script_Parent and script_Parent.PrimaryPart)) then
                        return;
                    end;

                    local Name = v131.Name;
                    local Casing = ToolInfo[Name].Casing;

                    if v128 == "EjectCasing" and Casing then
                        u118(Casing);

                        return;
                    end;

                    if v128 == "ShowLoader" then
                        u13.Python_Loader.Transparency = 0;

                        return;
                    end;

                    if v128 == "HideLoader" then
                        u13.Python_Loader.Transparency = 1;

                        return;
                    end;

                    local v132 = v128 == "Pin" and u13:FindFirstChild("Pin");

                    if v132 then
                        v132.Transparency = 1;
                    end;

                    local v133 = v128:find("Transparency%d") and u13:FindFirstChild((v128:gsub("Transparency", "")));

                    if v133 then
                        v133.Transparency = 0;
                    end;

                    local v134 = script_Parent.PrimaryPart:FindFirstChild(Name .. v128);

                    if not v134 then
                        return;
                    end;

                    SoundModule:PlaySound(v134, nil, nil, v130.Skin);
                end);
            end;
        end;

        u23[v125] = v122;
    end;
end;

local function u139(p136) -- Line: 368
    -- upvalues: u23 (copy)
    if not u23.Local[p136] then
        local _ = u23.Global[p136];
    end;

    for _, v in pairs({ "Local", "Global" }) do
        local v137 = u23[v];

        if v137 then
            local v138 = v137[p136];

            if v138 == nil and v137[p136 .. "1"] then
                for i = 1, 100 do
                    v138 = v137[p136 .. i];

                    if not v138 then
                        break;
                    end;

                    if v138.IsPlaying then
                        return true;
                    end;

                    local _ = i;
                end;
            end;

            if v138 then
                return v138.IsPlaying;
            end;
        end;
    end;

    return false;
end;

local function u149(p140, p141, p142, p143) -- Line: 391
    -- upvalues: u139 (copy), u23 (copy)
    local v144 = u139(p140);
    local v145 = nil;

    for i, v in pairs(u23) do
        local v146 = v[p140];
        local v147;

        if v146 == nil and v[p140 .. "1"] then
            v147 = i;
            local v148 = v;

            for i2 = 1, 100 do
                if not v148[p140 .. i2] then
                    v146 = v148[p140 .. math.random(1, i2 - 1)];
                    break;
                end;

                local _ = i2;
            end;
        else
            v147 = i;
        end;

        if v146 ~= nil then
            if not v144 then
                v146:Play(p142 or 0.1, p143 or 1, p141 or 1);
            end;

            if v147 == "Local" then
                if v144 or not (Run:IsStudio() and p140:find("Reload")) then
                    v145 = v146;
                else
                    print(p140, v146.Length / (p141 or 1));
                    v145 = v146;
                end;
            end;
        end;
    end;

    return v145;
end;

local function u155(p150, p151) -- Line: 415
    -- upvalues: u23 (copy)
    for _, v in pairs(u23) do
        local v152 = v[p150];

        if v152 == nil then
            if v[p150 .. "1"] then
                local v153 = v;

                for i = 1, 100 do
                    local v154 = v153[p150 .. i];

                    if not v154 then
                        break;
                    end;

                    v154:Stop();
                    local _ = i;
                end;
            end;
        else
            v152:Stop(p151);
        end;
    end;
end;

local function u157(p156) -- Line: 430
    -- upvalues: u23 (copy)
    for i, v in pairs(u23) do
        if i ~= "Local" or not p156 then
            for _, v2 in pairs(v) do
                v2:Stop();
            end;
        end;
    end;
end;

local function u160() -- Line: 439
    -- upvalues: u9 (ref), u10 (ref), u34 (ref), u35 (ref), u71 (ref), u76 (ref), Scope (copy), Toolbar (copy), u39 (ref), u157 (copy), u23 (copy), u84 (ref), script_Parent (copy)
    if u9 then
        u9:Destroy();
    end;

    u9 = nil;
    local v158;

    if u10 then
        v158 = u10.Name;
        u10:Destroy();
    else
        v158 = nil;
    end;

    u10 = nil;
    script:SetAttribute("Equipped", 0);
    script:SetAttribute("Using", false);
    script:SetAttribute("CanUse", nil);
    script:SetAttribute("SReduction", nil);
    script:SetAttribute("LocalAmmo", 0);
    script:SetAttribute("HasPrimaryAction", false);
    script:SetAttribute("IsBow", false);
    script:SetAttribute("CanReload", false);
    script:SetAttribute("EquippedType", nil);
    script:SetAttribute("CanInspect", false);
    u34 = 0;
    u35 = 0;

    if mobileADSToggled then
        mobileADSToggled = false;
        MouseButton2UpFunc();
    end;

    local v159 = mobileAimFire;
    v159.Hold = v159.Hold + 1;
    mobileAimFire.Tap = false;

    if mobileAimFire.Raised then
        mobileAimFire.Raised = false;
        MouseButton2UpFunc();
    end;

    if not isCrosshairAlwaysOn() then
        u71 = 1;
    end;

    u76 = 0;
    Scope.Visible = false;

    if CameraController:GetAttribute("UI") then
        Toolbar.Visible = true;
    end;

    u39 = false;
    u157(true);
    u23.Local = {};
    u23.Global = {};

    for _, v in u23.Camera do
        v:Destroy();
    end;

    u23.Camera = {};
    WheelController.Close:Invoke("Reload");
    u84 = false;
    local PrimaryPart = script_Parent.PrimaryPart;

    if PrimaryPart and v158 then
        for _, child in pairs(PrimaryPart:GetChildren()) do
            if child.Name:sub(1, v158:len()) == v158 and v158:sub(v158:len() - 4) ~= "Shoot" then
                child:Stop();
            end;
        end;
    end;
end;

local function _(p161) -- Line: 503
    -- upvalues: u41 (ref), ItemClass (copy)
    if type(p161) ~= "table" then
        return;
    end;

    u41 = ItemClass.AttachmentStats(p161, script:GetAttribute("Aiming"));
end;

local function u170(p162) -- Line: 508
    -- upvalues: u41 (ref), u42 (ref), u43 (ref), u44 (ref), u9 (ref), u23 (copy), u155 (copy), u139 (copy), u149 (copy), WeldModule (copy), u13 (ref), u10 (ref), ItemClass (copy), Items (copy), u19 (ref), VFXModule (copy)
    u41 = {};
    u42 = nil;
    u43 = nil;
    u44 = nil;

    if not u9 then
        return;
    end;

    local v163 = type(p162) == "table";

    if v163 and u23.Local.Loaded then
        local Ammo = p162.Ammo;

        if Ammo and Ammo.Amount > 0 then
            u155("Unloaded", 0);

            if not u139("Loaded") then
                u149("Loaded", 1, 0);
            end;
        else
            u155("Loaded", 0);

            if not u139("Unloaded") then
                u149("Unloaded", 1, 0);
            end;
        end;
    end;

    local v164, v165, v166 = WeldModule:WeldAttachments(u13, p162, nil, nil, nil, u10:GetScale());
    u42 = v164;
    u43 = v165;
    u44 = v166;

    if type(p162) == "table" then
        u41 = ItemClass.AttachmentStats(p162, script:GetAttribute("Aiming"));
    end;

    local v167 = false;

    for _, v in pairs(v163 and p162.Attachments or {}) do
        local v168 = Items[v.ID];

        if v168 and v168.AttachmentType == "Sight" then
            v167 = true;
        else
            local AttachmentStats = v168.AttachmentStats;

            if u19 and (AttachmentStats and AttachmentStats.Toggle) then
                local v169 = u19:FindFirstChild(v168.Name);

                if v169 then
                    if v168.Name == "Weapon Flashlight" then
                        v169.Base.Light.Enabled = v.On;
                    elseif v168.Name:find(" Lasersight") then
                        local Laser = v169.Laser;
                        Laser.Laser.Enabled = v.On;

                        if v.On then
                            VFXModule:InitializeLaser(Laser);
                        end;
                    end;
                end;
            end;
        end;
    end;

    if u23.Local.SightFix then
        if v167 and not u139("SightFix") then
            u149("SightFix");

            return;
        end;

        if not v167 and u139("SightFix") then
            u155("SightFix");
        end;
    end;
end;

local function u180() -- Line: 559
    -- upvalues: u10 (ref), u14 (ref), WeldModule (copy)
    if not (u10 and (u14 and u14.Parent)) then
        return;
    end;

    local v171 = Player:GetAttribute("ArmorSleeves") or "";
    local string_split_ret = string.split(v171, "^");
    local Scale = u10:GetScale();

    for _, child in pairs(u14:GetChildren()) do
        local Name = child.Name;

        if Name:sub(1, 5) == "Armor" and child:IsA("Model") then
            local v172 = Name:sub(6);
            local v173 = child;
            local v174 = false;

            for _, v in pairs(string_split_ret) do
                if v == v172 then
                    v174 = true;
                    break;
                end;
            end;

            if not v174 then
                v173:Destroy();
            end;
        end;
    end;

    for _, v in pairs(string_split_ret) do
        if v and v ~= "" then
            local v175, v176 = unpack(string.split(v, "/"));
            local v177 = Sleeves[v175][v176]:Clone();

            if Scale ~= 1 then
                v177:ScaleTo(Scale);
            end;

            local v178 = WeldModule:FullyWeldModels(v177, u14, true);
            local v179 = v;

            for _, v2 in pairs(v178) do
                v2.Name = "Armor:" .. v179;
            end;
        end;
    end;
end;

local function v181() -- Line: 591
    -- upvalues: u92 (ref)
    u92 = true;
end;

local function u189(p182, p183) -- Line: 597
    -- upvalues: ToolInfo (copy)
    if type(p182) ~= "table" then
        p182 = nil;
    end;

    if p183 then
        p183 = ToolInfo[p183];
    end;

    if p183 then
        p183 = p183.Weapon;
    end;

    local v184 = script;
    local v185;

    if type(p183) == "table" and (p183.CustomUse ~= true and p182 ~= nil) then
        v185 = p182.Type ~= "Bench";
    else
        v185 = false;
    end;

    v184:SetAttribute("HasPrimaryAction", v185);
    local v186;

    if type(p183) == "table" then
        v186 = p183.IsBow == true;
    else
        v186 = false;
    end;

    script:SetAttribute("IsBow", v186);
    local v187;

    if p182 == nil or p182.AmmoType == nil then
        v187 = false;
    else
        v187 = not v186;
    end;

    script:SetAttribute("CanReload", v187);
    local v188;

    if p182 == nil then
        v188 = nil;
    else
        v188 = p182.Type or nil;
    end;

    script:SetAttribute("EquippedType", v188);
end;

local function u209(p190, p191, p192) -- Line: 614
    -- upvalues: Items (copy), u23 (copy), u9 (ref), u160 (copy), u189 (copy), Humanoid (copy), ToolInfo (copy), u12 (ref), u13 (ref), u14 (ref), u15 (ref), u19 (ref), u17 (ref), u18 (ref), u21 (ref), u20 (ref), u16 (ref), CFrame_new_ret3 (ref), u22 (ref), WeldModule (copy), u10 (ref), script_Parent (copy), u135 (copy), u170 (copy), u92 (ref), SettingsModule (copy), Highlight (copy), CFrame_new_ret4 (ref), SoundModule (copy), u87 (ref), u45 (ref), u46 (ref), u49 (ref), u149 (copy)
    local v193 = InventoryController.Fetch:Invoke();
    local v194;

    if v193 then
        local Toolbar2 = v193.Toolbar;

        if Toolbar2 then
            v194 = Toolbar2[p190 or script:GetAttribute("Equipped")];

            if v194 == nil then
                v194 = false;
            elseif v194 == 0 then
                v194 = false;
            end;
        else
            v194 = nil;
        end;
    else
        v194 = nil;
    end;

    local v195;

    if v194 then
        v195 = Items[v194.ID];
    else
        v195 = v194;
    end;

    local v196;

    if v195 then
        v196 = v195.Type == "Bench" and "Blueprint" or v195.Name;
    else
        v196 = v195;
    end;

    local Attribute = script:GetAttribute("Equipped");

    if Attribute > 0 and (u23.Local.Idle == nil and u23.Global.Idle or u9 and (Attribute ~= p190 or v195 and u9.Name ~= v195.Name)) then
        u160();
    end;

    u189(v195, v196);

    if not (v194 and (Humanoid.Parent and Humanoid.Health > 0)) then
        return;
    end;

    local v197 = ToolInfo[v196];
    local v198 = VMs:FindFirstChild(v196);

    if not (v198 and v197) then
        return;
    end;

    local Weapon = v197.Weapon;
    local Offsets = v197.Offsets;
    local Skin = v194.Skin;
    local v199 = v198:FindFirstChild(Skin) or v198:FindFirstChild("Default");
    local v200 = nil;

    if v199 then
        v199 = v199:Clone();
        v199.Name = v196;
        v199:SetAttribute("_", true);
        u12 = v199:WaitForChild("HumanoidRootPart");
        u13 = v199:WaitForChild("Weapon");
        u14 = v199:WaitForChild("Arms");
        u15 = u14:WaitForChild("RightArm");
        u19 = u13:FindFirstChild("Attachments");
        u17 = u13:FindFirstChild("AimFront");
        u18 = u13:FindFirstChild("AimBack");
        u21 = u13:FindFirstChild("CasingRelease");
        u20 = u13:FindFirstChild("FlashPart");
        u16 = u13:FindFirstChild("Handle") or u13.Main;
        CFrame_new_ret3 = Offsets[`Local{Skin}`] or Offsets.Local;
        u22 = Offsets.RootPartBased;

        if u18 then
            u18.CFrame = CFrame.new(u18.Position, u17.Position) * (Offsets.SightBack or CFrame.new());
            WeldModule:WeldParts(u18, u16);
        end;

        u10 = v199;
        u9 = v199;

        for _, v in pairs(u14 and u14:GetChildren() or {}) do
            if v:IsA("BasePart") then
                local v201 = script_Parent:FindFirstChild(v.Name:find("Left") and "LeftUpperArm" or "RightUpperArm");

                if v201 then
                    v.Color = v201.Color;
                end;
            end;
        end;

        u10 = v199;
        u9 = v199;
        v199.Parent = Camera;
        u135(v198, p191, Skin);
        u170(v194);
        u92 = true;
        local Setting = SettingsModule.GetSetting("Graphics", "Outline Transparency");

        if SettingsModule.GetSetting("Graphics", "Toggle Outline") == true and Setting < 1 then
            v200 = Highlight:Clone();
            v200.OutlineTransparency = Setting;
            v200.Parent = u10;
            v200.Enabled = true;
        end;

        CFrame_new_ret4 = u18 and u12.CFrame:ToObjectSpace(u18.CFrame):inverse() or Offsets.Aim;

        if script_Parent.PrimaryPart then
            local Equip = script_Parent.PrimaryPart:FindFirstChild("Equip");

            if Equip then
                SoundModule:PlaySound(Equip);
            end;
        end;
    else
        u135(v198, p191);
    end;

    local v202;

    if u9 == nil then
        v202 = false;
    else
        v202 = (u23.Local.Inspect or u23.Local.Inspect1) ~= nil;
    end;

    script:SetAttribute("CanInspect", v202);
    local v203 = script;
    local v204;

    if type(Weapon) == "table" then
        v204 = Weapon.CanSprintWhileAttacking;
    else
        v204 = false;
    end;

    v203:SetAttribute("CanUse", v204);
    local v205 = script;
    local v206;

    if type(Weapon) == "table" then
        v206 = Weapon.SReduction;
    else
        v206 = false;
    end;

    v205:SetAttribute("SReduction", v206);
    script:SetAttribute("Equipped", p190);
    local Ammo = v194.Ammo;
    script:SetAttribute("LocalAmmo", Ammo and Ammo.Amount or 0);

    for _, child in pairs(VM_PARTS:GetChildren()) do
        if child ~= v199 then
            child:Destroy();
        end;
    end;

    u87 = true;
    u45 = "None";
    u46 = "None";
    u49 = false;
    u149("Idle");
    local v207;

    if Weapon then
        local v208;

        if type(Weapon.EquipAnimSpeed) == "table" then
            v208 = Weapon.EquipAnimSpeed[v194.Skin or "Default"] or Weapon.EquipAnimSpeed.Default;
        else
            v208 = Weapon.EquipAnimSpeed;
        end;

        v207 = v208 or 1;
    else
        v207 = 1;
    end;

    u149("Equip", v207 * (p192 or 1));
    task.wait(0.1);

    if v199 and v199.Parent then
        v199.Parent = VM_PARTS;

        if v200 and v200.Parent then
            v200.Adornee = u10;
        end;
    end;
end;

local function u212(p210) -- Line: 736
    -- upvalues: u87 (ref), u10 (ref), u14 (ref), u13 (ref), u19 (ref)
    if p210 == u87 or not u10 then
        return;
    end;

    local v211 = {};

    for _, child in pairs(u14:GetChildren()) do
        if child:IsA("Model") then
            table.insert(v211, child);
        end;
    end;

    for _, v in pairs({
        u14,
        u13,
        u19 and u19:GetChildren() or {},
        unpack(v211)
    }) do
        for _, v2 in pairs(type(v) == "table" and v and v or { v }) do
            for _, child in pairs(v2:GetChildren()) do
                if child:IsA("BasePart") then
                    local Attribute = child:GetAttribute("OrigTrans");

                    if Attribute then
                        if child.Name == "RailExtender" then
                            child.LocalTransparencyModifier = p210 and 0 or 1;
                        else
                            child.Transparency = p210 and Attribute and Attribute or 1;
                        end;

                        if child.Name == "Bolt" then
                            for _, child2 in pairs(child:GetChildren()) do
                                if child2:IsA("Beam") then
                                    child2.Enabled = p210;
                                end;
                            end;
                        end;
                    elseif child.Transparency ~= 1 then
                        Attribute = child.Transparency;
                        child:SetAttribute("OrigTrans", Attribute);

                        if child.Name == "RailExtender" then
                            child.LocalTransparencyModifier = p210 and 0 or 1;
                        else
                            child.Transparency = p210 and Attribute and Attribute or 1;
                        end;

                        if child.Name == "Bolt" then
                            for _, child2 in pairs(child:GetChildren()) do
                                if child2:IsA("Beam") then
                                    child2.Enabled = p210;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u87 = p210;

    return true;
end;

local function _(p213, p214, p215) -- Line: 770
    -- upvalues: u80 (copy)
    u80.Code = math.random(1, 100000000);
    u80.X = 0;
    u80.Increment = 1.5 / p215;
    u80.PrevPos = u80.Pos;
    u80.PrevRot = u80.Rot;
    u80.NewPos = p213;
    u80.NewRot = p214;
end;

local function u226(p216, p217) -- Line: 780
    -- upvalues: u98 (ref), u99 (ref), u100 (ref), u97 (copy), Vector3_new_ret (ref)
    if not p216 then
        return;
    end;

    local v218 = (p216.Strength or Vector3.new(1, 1, 1)) * (p217 or 1);
    local v219 = p216.Speed or 1;
    local v220 = p216.Angles or { -75, 75 };
    local _ = p216.SnapBack;
    local v221 = p216.DelayTime or 0;

    if v218 == 0 or v219 <= 0 then
        return;
    end;

    if v221 > 0 then
        task.wait(v221);
    end;

    u98 = 0;
    u99 = 0;
    u100 = 0.15 * v219;
    local math_random_ret = math.random(v220[1], v220[2]);
    local math_rad_ret = math.rad(math_random_ret);
    local v222 = math.sin(math_rad_ret) / 300 * v218.X;
    local v223 = math.cos(math_rad_ret) / 225 * v218.Y;
    local math_random_ret2 = math.random(-15, 15);
    local v224 = math.rad(math_random_ret2) / 15 * v218.Z;
    local v225 = -0.005235987755982988 * v218.Y;
    u97.Damper = 0.6;
    u97.Speed = 20;
    Vector3_new_ret = Vector3.new(v222, v223, v224);
    task.wait(0.15 * v219);
    u97.Damper = 0.4;

    if p216.SnapBack then
        u97.Speed = 30;
        Vector3_new_ret = Vector3.new(-v222, -v223 + v225, -v224);
        task.wait(0.15 * v219);
        u97.Speed = 20;
        Vector3_new_ret = Vector3.new(0, -v225, 0);
        task.wait(0.175 * v219);
    end;

    Vector3_new_ret = Vector3.new();
end;

local function u229(p227) -- Line: 815
    -- upvalues: u72 (ref), HitMarker (copy), TweenUtil (copy)
    Sound:PlayLocalSound(Sound[p227]);
    u72 = 0;
    HitMarker.Rotation = math.random(430, 470) / 10;
    local v228 = p227 == "HitHead" and true or p227 == "HitRotor";

    for _, child in pairs(HitMarker:GetChildren()) do
        if not HitMarker.Visible then
            child.BackgroundColor3 = Color3.new(1, 1, 1);
        end;

        TweenUtil:Tween(child, "BackgroundColor3", v228 and Color3.new(1, 0, 0) or Color3.new(1, 1, 1), 0.09, "Quart", "In");
    end;
end;

local function _(p230) -- Line: 837
    return p230.X ^ 2 + p230.Y ^ 2 + p230.Z ^ 2;
end;

local function u236(p231, p232, p233) -- Line: 841
    -- upvalues: u9 (ref), u10 (ref), u236 (ref)
    if not (u9 and u10) then
        return;
    end;

    local HumanoidRootPart = u9.HumanoidRootPart;
    local HumanoidRootPart2 = u10.HumanoidRootPart;

    for _, child in pairs(p231:GetChildren()) do
        local v234 = p232:FindFirstChild(child.Name);

        if v234 then
            if child.Name ~= "HumanoidRootPart" and (child:IsA("BasePart") and v234:IsA("BasePart")) then
                local v235 = HumanoidRootPart.CFrame:ToObjectSpace(child.CFrame);
                v234.CFrame = HumanoidRootPart2.CFrame * v235;
            end;

            u236(child, v234, p233);
        end;
    end;
end;

local function u257(p237, p238, p239, p240) -- Line: 879
    -- upvalues: u4 (copy), u229 (copy), VFXModule (copy)
    local v241 = p237[1];
    local v242 = p237[2];
    local v243 = p237[3];
    local v244 = p237[4];
    local v245 = p237[5];
    local v246 = p237[6];
    local v247 = p237[7] or {};
    local v248 = v241 and v241.Parent;

    if v248 then
        if v242 then
            v242 = v241.CFrame:PointToObjectSpace(v242);
        end;
    else
        v242 = v248;
    end;

    if v244 then
        v244 = v244.Name;
    end;

    if v242 and (v243 and v242 == v243) then
        return;
    end;

    local v249 = {
        v246,
        v245,
        v244,
        v243,
        v242 or "nil",
        v241
    };

    if p237[8] or p237[9] then
        v249[7] = p237[8];
        v249[8] = p237[9];
    end;

    u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\194\163\239\191\189\048\195\161\239\191\189\104\239\191\189\122\239\191\189\075\239\191\189\082\056\098\239\191\189\102\239\191\189", unpack(v249));

    if not (v241 and v241.Parent) then
        return;
    end;

    local v250 = v241.Parent:FindFirstChild("Humanoid") or v241.Parent.Parent:FindFirstChild("Humanoid");
    local v251;

    if v241.Parent.Name == "MilitaryHitbox" or v241.Parent.Name == "ZombieHitbox" then
        v251 = v241.Parent;
    else
        v251 = false;
    end;

    local v252;

    if v250 or not (v241.Parent:GetAttribute("Health") and (v241.Parent.Name == "AttackHeli" or v241.Parent.Name == "BTR")) then
        v252 = v241.Parent.Parent and v241.Parent.Parent:GetAttribute("Health") and (v241.Parent.Parent.Name == "AttackHeli" and true or v241.Parent.Parent.Name == "BTR");
    else
        v252 = true;
    end;

    local v253;

    if p239 == true then
        v253 = true;
    elseif p239 then
        v253 = p239 ~= "Stick";
    else
        v253 = p239;
    end;

    if not (v250 or (v252 or v251)) then
        if not v253 then
            if p238 and (p238[1] and p238[1].Parent) then
                p237 = p238 or p237;
            end;

            task.defer(VFXModule.CreateHole, VFXModule, p237[1], p237[2], p237[3], p237[4], nil, p239 == "Stick");
        end;

        return;
    end;

    local v254 = v250 or (v252 or v251);
    local v255 = v247[v254];
    local v256;

    if v250 or v251 then
        v256 = v241.Name == "Head" and "HitHead" or "Hit";
    else
        v256 = (v241:GetAttribute("RotorBonus") or 0) > 0 and "HitRotor" or "Hit";
    end;

    if not v255 then
        v255 = {};
        v247[v254] = v255;
    end;

    if not v255[v256] then
        v255[v256] = true;

        if not p240 then
            u229(v256);

            if v251 then
                npcMarker.Count = (os.clock() - npcMarker.At < 1 and npcMarker.Count or 0) + 1;
                npcMarker.At = os.clock();
            end;
        end;
    end;

    if v253 then
        return;
    end;

    if not v252 then
        task.defer(VFXModule.CreateBlood, VFXModule, unpack(p237));

        return;
    end;

    if p238 and (p238[1] and p238[1].Parent) then
        p237 = p238 or p237;
    end;

    task.defer(VFXModule.CreateHole, VFXModule, p237[1], p237[2], p237[3], p237[4], nil, p239 == "Stick");
end;

local function u266(p258, p259, p260, p261) -- Line: 945
    -- upvalues: u10 (ref), u160 (copy), u209 (copy)
    local v262 = p261 or tick();
    local v263;

    if p259.Amount == 1 then
        v263 = true;
    else
        v263 = false;
    end;

    while tick() - v262 < p258 and u10 == u10 do
        task.wait();
    end;

    local v264 = InventoryController.Fetch:Invoke();
    local v265;

    if v264 then
        local Toolbar2 = v264.Toolbar;

        if Toolbar2 then
            v265 = Toolbar2[script:GetAttribute("Equipped")];

            if v265 == nil then
                v265 = false;
            elseif v265 == 0 then
                v265 = false;
            end;
        else
            v265 = nil;
        end;
    else
        v265 = nil;
    end;

    if v265 then
        if v265.ID == p259.ID then
            if v263 and v265.Amount == 1 then
                u160();

                return;
            end;

            local Attribute = script:GetAttribute("Equipped");
            u160();
            u209(Attribute, nil, p260);
        end;
    else
        u160();
    end;
end;

function ChooseRandom(p267)
    local math_random_ret = math.random(1, 100);
    local v268 = 0;

    for i, v in p267 do
        v268 = v268 + v[1];

        if v268 >= math_random_ret then
            return math.random(v[2] * 100, v[3] * 100) / 100, i;
        end;
    end;
end;

local u269 = nil;
local u270 = nil;

local function u453(u271) -- Line: 980
    -- upvalues: u30 (ref), u33 (ref), u91 (ref), Items (copy), u139 (copy), u84 (ref), ToolInfo (copy), script_Parent (copy), SoundModule (copy), Humanoid (copy), u46 (ref), u64 (ref), u31 (ref), u45 (ref), u269 (ref), u47 (ref), u270 (ref), u48 (ref), u13 (ref), u149 (copy), u10 (ref), u41 (ref), u155 (copy), u118 (copy), u44 (ref), u20 (ref), VFXModule (copy), u73 (ref), u75 (ref), u74 (ref), RaycastUtil (copy), u6 (copy), u257 (copy), u4 (copy), TableUtil (copy), u80 (copy), u78 (ref), u79 (ref), u81 (ref), PreferredInputController (copy), CFrame_new_ret6 (ref), u226 (copy), u49 (ref), u23 (copy), u16 (ref), u5 (copy), u266 (copy), u7 (copy), u8 (copy), u103 (copy)
    if WheelController:GetAttribute("Open") then
        return;
    end;

    u30 = true;

    if script:GetAttribute("Using") then
        u33 = tick();

        return;
    end;

    if u91 then
        task.cancel(u91);
    end;

    u91 = task.spawn(function() -- Line: 990
        -- upvalues: u30 (ref), Items (ref), u139 (ref), u84 (ref), ToolInfo (ref), script_Parent (ref), SoundModule (ref), Humanoid (ref), u46 (ref), u64 (ref), u31 (ref), u45 (ref), u269 (ref), u47 (ref), u270 (ref), u48 (ref), u13 (ref), u149 (ref), u10 (ref), u41 (ref), u155 (ref), u118 (ref), u44 (ref), u20 (ref), VFXModule (ref), u73 (ref), u75 (ref), u74 (ref), RaycastUtil (ref), u6 (ref), u257 (ref), u4 (ref), TableUtil (ref), u80 (ref), u78 (ref), u79 (ref), u81 (ref), PreferredInputController (ref), CFrame_new_ret6 (ref), u226 (ref), u49 (ref), u23 (ref), u16 (ref), u271 (copy), u5 (ref), u266 (ref), u7 (ref), u8 (ref), u103 (ref), u33 (ref)
        local v272 = false;
        local v273 = false;
        local v274 = false;

        while true do
            local u275, u276, v277, v278, v279, v280, v281, v282, v283, v284, v285, v286, u287, u288, v289, v290, v291, v292, v293, v294, v295, v296, v297, v298, v299, v300, v301, v302, v303, v304, v305, u306, v307, v308, v309, v310, v311, v312, v313, v314, v315, u316, v317, v318, v319, v320, u321, v322, v323, v324, v325, v326, v327, v328, v329, v330, v331, v332, v333, v334, v335, v336, u337, v338, v339, v340, v341, v342, v343, v344, u345, u346, v347, u348, u349, u350, u351, u352, u353, u354, v355, v356, v357, v358, v359, v360;

            while true do
                if not (u30 or v274) then
                    script:SetAttribute("Using", false);

                    return;
                end;

                local v361 = InventoryController.Fetch:Invoke();

                if v361 then
                    local Toolbar2 = v361.Toolbar;

                    if Toolbar2 then
                        u275 = Toolbar2[script:GetAttribute("Equipped")];

                        if u275 == nil then
                            u275 = false;
                        elseif u275 == 0 then
                            u275 = false;
                        end;
                    else
                        u275 = nil;
                    end;
                else
                    u275 = nil;
                end;

                u276 = nil;
                local v362;

                if u275 then
                    v362 = u275.Ammo;
                    v277 = Items[u275.ID];
                else
                    v362 = nil;
                    v277 = nil;
                end;

                if v362 then
                    u276 = Items[v362.ID].AmmoStats;
                end;

                v278 = script:GetAttribute("LocalAmmo");

                if v277 and (v277.Type ~= "Bench" and not (u139("Equip") or (u84 or (InventoryController:GetAttribute("Open") or not (u275 and (not v277.MaxDurability or u275.Durability > 0)))))) then
                    local Type = v277.Type;
                    local Name = v277.Name;
                    v279 = ToolInfo[Name];

                    if not v279 then
                        return;
                    end;

                    v280 = v279.Weapon;

                    if v280 and v280.CustomUse then
                        return;
                    end;

                    local v363;

                    if v280 == nil then
                        v363 = false;
                    else
                        v363 = v280.ThrowInfo;
                    end;

                    if v280 == nil then
                        v281 = false;
                    else
                        v281 = v280.IsBow;
                    end;

                    local Melee = v279.Melee;
                    v282 = v279.Shake;

                    if Type == "Gun" and (script_Parent.PrimaryPart and (v273 == false and (v280 and (v280.IgnoreEmptyClick ~= true and (v362 == nil or v278 <= 0))))) then
                        local GunEmpty = script_Parent.PrimaryPart:FindFirstChild("GunEmpty");

                        if GunEmpty then
                            SoundModule:PlaySound(GunEmpty);
                            v273 = true;
                        end;
                    end;

                    if not ((Type == "Gun" and (v362 ~= nil and v278 > 0) or Type == "Tool" and (v280 and v280.Cooldown)) and ((Humanoid.SeatPart == nil or Humanoid.SeatPart.Name ~= "VehicleSeat") and not ((not (v281 and (u46 == "Holding" or u46 == "NoneJump")) or WaterController:GetAttribute("IsSwim")) and (v281 or not (Melee and Melee.MeleeChecks) and tick() - u64 < 0.1)))) then
                        Run.Heartbeat:Wait();
                        v272 = false;
                 
                    end;

                    local v364;

                    if v280.AimDownSpeed == nil or not (v363 and (u31 ~= false and u45 ~= "Holding")) then
                        v364 = Type ~= "Gun" and true or not CameraController:GetAttribute("ViewmodelCFrame");
                    else
                        v364 = false;
                    end;

                    script:SetAttribute("Using", v364);

                    if Type == "Gun" then
                        CameraController:SetAttribute("FreeLooking", false);
                    end;

                    if not v364 then
                        Run.Heartbeat:Wait();
                        v272 = false;
                 
                    end;

                    if v280.RequiresAim then
                        v274 = true;

                        if not v272 then
                            v272 = true;

                            if not u31 then
                                task.spawn(u269, "Auto");
                            end;
                        end;

                        if u47 then
                            if u31 == "Auto" then
                                u270();
                            else
                                u48 = true;
                                task.delay(0.7, function() -- Line: 1056
                                    -- upvalues: u48 (ref)
                                    u48 = false;
                                end);
                            end;

                        
                        end;

                        Run.Heartbeat:Wait();
                    else
                        local v365 = 0;

                        while true do
                            if v365 == 0 then
                                v365 = -1;
                                local v366, v367, v368, v369, v370, u371, v372, v373, v374, v375, v376, v377, v378, v379, v380, v381, v382, v383, v384, v385, v386, v387, v388, v389, v390, v391, v392, v393, u394, v395, u396, u397, u398, u399, u400, v401, v402, v403, v404, v405, v406, v407, v408, v409, v410, v411, v412, v413, v414, v415, v416, v417, v418, u419, u420, u421, u422, u423, u424, u425, v426, v427, v428, v429;

                                if Name == "Salvaged Shotgun" then
                                    local Fuse = u13:FindFirstChild("Fuse");

                                    if Fuse and u149("Light") then
                                        local v430 = u10;
                                        task.wait(0.5);

                                        if u10 == v430 and (u10 and (u10.Parent and Fuse.Parent)) then
                                            for _, child in Fuse.Effect:GetChildren() do
                                                child.Enabled = true;
                                            end;

                                            local v431 = ChooseRandom({ { 15, 0.25, 0.5 }, { 20, 0.5, 1 }, { 35, 1, 1.5 }, { 15, 2, 2 }, { 15, 2.5, 3 } });
                                            local v432 = ChooseRandom({ { 45, 0, 0 }, { 25, 0, 0.5 }, { 20, 0.5, 1 }, { 10, 1.5, 2 } });
                                            local v433 = 0;

                                            while v433 < v431 do
                                                v433 = v433 + task.wait(0.03333333333333333);

                                                if u10 ~= v430 or not (u10 and (u10.Parent and Fuse.Parent)) then
                                                    v433 = false;
                                                    break;
                                                end;

                                                local math_clamp_ret = math.clamp(v433 / v431, 0, 1);
                                                local math_floor_ret = math.floor(math_clamp_ret / 0.2);
                                                local v434 = Fuse[tostring(math_floor_ret + 1)];
                                                local v435 = math.ceil(math_clamp_ret / 0.2) + 1;
                                                local v436 = Fuse[tostring(v435)];
                                                Fuse.Effect.CFrame = v434.CFrame:Lerp(v436.CFrame, (math_clamp_ret - math_floor_ret * 0.2) / 0.2);
                                            end;

                                            if v433 then
                                                local v437 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Fuse");

                                                if v437 then
                                                    SoundModule:StopSound(v437);
                                                end;

                                                for _, child in Fuse.Effect:GetChildren() do
                                                    child.Enabled = false;
                                                end;

                                                if v432 > 0 then
                                                    task.wait(v432);

                                                    if u10 == v430 and (u10 and (u10.Parent and Fuse.Parent)) then
                                                        if Type == "Gun" then
                                                            v283 = v279.Spread;
                                                            v284 = v279.Bullet;
                                                            v285 = v279.Casing;
                                                            v286 = v279.Recoil;
                                                            u287 = v286.VM;
                                                            u288 = v286.Camera;
                                                            v289 = 1 - (u41.FireRateMult or 0);
                                                            v290 = 60 / v280.RPM * v289;
                                                            v291 = 60 / v280.BurstRPM * v289;

                                                            for i = 1, v280.Burst do
                                                                u155("Inspect", 0);
                                                                u155("Shoot", 0);
                                                                u149("Shoot", 1, 0);

                                                                if v285 and not v285.IgnoreShoot then
                                                                    u118(v285);
                                                                end;

                                                                v292 = script:GetAttribute("Aiming");
                                                                v293 = u44 or u20;

                                                                if not (u41.Scope and v292) then
                                                                    VFXModule:FlashPart(v293);
                                                                end;

                                                                v294 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Shoot");

                                                                if v294 then
                                                                    SoundModule:PlayDuplicateSound(v294, nil, nil, true, u275.Skin);
                                                                end;

                                                                u73 = tick();
                                                                v295 = u275.Skin == "Hot Rod" and 0.75 or 1;
                                                                v296 = 1 + (v292 and u41.GunRecoilAimMult or 0);
                                                                v297 = v283[v292 and "Aiming" or "Hip"].ShootingExtra * (1 + (u41[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 0)) * (u75 < 0.001 and 0 or u75) * (u276[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 1);
                                                                u75 = math.min(u75 + 1 / v283.Shooting.BulletsForMax, 1);
                                                                v298 = u74 < 0.001 and 0 or math.floor(u74 * 100) / 100;
                                                                v299 = v297 < 0.001 and 0 or math.floor(v297 * 100) / 100;
                                                                v300 = v298 + v299;
                                                                v301 = CFrame.Angles(v284.Offset or 0, 0, 0);
                                                                v302 = Camera.CFrame;
                                                                v303 = workspace:GetServerTimeNow();
                                                                v304 = math.round(v303 * 10000);
                                                                v305 = Random.new(v304);
                                                                u306 = v305.NextInteger(v305, 1, 1000000000);
                                                                v307 = Random.new(v304);
                                                                v308 = i;
                                                                v309 = {};

                                                                for i2 = 1, u276.Bullets or 1 do
                                                                    v310 = {
                                                                        Radius = v307:NextNumber(0, math.floor(v300 * 100) / 100) / 500,
                                                                        Degree = v307:NextNumber(0, 6.283185307179586)
                                                                    };
                                                                    v311 = math.floor(v300 * 100) / 100;
                                                                    v312 = math.max(1, v311) * 1000000000;
                                                                    v310.ID = v307:NextInteger(1, (math.ceil(v312)));
                                                                    table.insert(v309, v310);
                                                                    v313 = i2;
                                                                end;

                                                                v314 = v293.Position;
                                                                v315 = script_Parent.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0);
                                                                u316 = {};
                                                                v317, v318 = RaycastUtil:MouseRaycast(u6, VFXModule.WithSeatedVehicles({ script_Parent, VFX_PARTS }));

                                                                if u41.HideTracer then
                                                                    v319 = "";
                                                                elseif table.find(VFXModule.TracerSkins, u275.Skin) then
                                                                    v319 = u275.Skin .. "Bullet";
                                                                else
                                                                    v319 = u276.TracerName;
                                                                end;

                                                                for _, v in pairs(v309) do
                                                                    v320 = v301 * CFrame.Angles(math.sin(v.Degree) * v.Radius, math.cos(v.Degree) * v.Radius, 0);
                                                                    u321 = v.ID;
                                                                    v322 = VFXModule;
                                                                    v323 = {
                                                                        FilterType = "Blacklist",
                                                                        Position = v314,
                                                                        Direction = (CFrame.new(v314, v317) * v320).LookVector,
                                                                        PositionFirst = v315.p
                                                                    };
                                                                    v324 = RaycastParams.new();
                                                                    v324.FilterType = Enum.RaycastFilterType.Include;
                                                                    v324.FilterDescendantsInstances = { workspace.Terrain };
                                                                    v324.IgnoreWater = true;

                                                                    if workspace:Raycast(v315.p, v314 - v315.p, v324) then
                                                                        v325 = (v314 - v315.p).Unit;
                                                                    else
                                                                        v325 = (v302 * v320).LookVector;
                                                                    end;

                                                                    v323.DirectionFirst = v325;
                                                                    v323.Filters = {
                                                                        script_Parent,
                                                                        VFX_PARTS,
                                                                        Drops,
                                                                        Plants
                                                                    };
                                                                    v323.FilterFunction = u276.FilterType or "Hit";
                                                                    v323.VisualizeRay = script:GetAttribute("DebugShowRays");
                                                                    v323.Speed = v284.Speed * (1 + (u41.SpeedMult or 0)) * (u276.SpeedMult or 1);
                                                                    v323.Gravity = v284.Gravity * (u276.GravityMult or 1);
                                                                    v323.MaxRange = v284.MaxRange * (1 + (u41.RangeMult or 0)) * (u276.RangeMult or 1);
                                                                    v323.Size = u276.BulletSize;
                                                                    v323.TracerName = v319;

                                                                    function v323.HitFunction(...) -- Line: 1191
                                                                        -- upvalues: u257 (ref), u306 (copy), u321 (copy), u316 (copy), u276 (ref)
                                                                        local v438 = { ... };
                                                                        u257({
                                                                            v438[1],
                                                                            v438[2],
                                                                            v438[3],
                                                                            v438[4],
                                                                            u306,
                                                                            u321,
                                                                            u316
                                                                        }, nil, u276.Impact);
                                                                    end;

                                                                    function v323.MissFunction() -- Line: 1195
                                                                        -- upvalues: u4 (ref), u321 (copy), u306 (copy)
                                                                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\194\163\239\191\189\048\195\161\239\191\189\104\239\191\189\122\239\191\189\075\239\191\189\082\056\098\239\191\189\102\239\191\189", u321, u306);
                                                                    end;

                                                                    v322:CreateProjectile(v323);
                                                                end;

                                                                v278 = v278 - 1;
                                                                script:SetAttribute("LocalAmmo", v278);
                                                                u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v303, v277.Name, v302, v315:PointToObjectSpace(v314), v315, v298, v299, v317);
                                                                v326 = TableUtil:TableRandom(u287.Pos.X);
                                                                v327 = TableUtil:TableRandom(u287.Pos.Y);
                                                                v328 = Vector3.new(v326, v327, TableUtil:TableRandom(u287.Pos.Z)) * v295;
                                                                v329 = TableUtil:TableRandom(u287.Rot.Y);
                                                                v330 = math.rad(v329);
                                                                v331 = TableUtil:TableRandom(u287.Rot.X);
                                                                v332 = math.rad(v331) * v296;
                                                                v333 = TableUtil:TableRandom(u287.Rot.Z);
                                                                v334 = math.rad(v333) * v296;
                                                                v335 = Vector3.new(v330, v332, v334) * v295;
                                                                v336 = u287.StartTime;
                                                                u80.Code = math.random(1, 100000000);
                                                                u80.X = 0;
                                                                u80.Increment = 1.5 / v336;
                                                                u80.PrevPos = u80.Pos;
                                                                u80.PrevRot = u80.Rot;
                                                                u80.NewPos = v328;
                                                                u80.NewRot = v335;
                                                                u337 = u80.Code;
                                                                u78 = 0;
                                                                u79 = u79 + 1;
                                                                u81 = tick();
                                                                v338, v339 = u288.RecoilStart(u79);
                                                                v340, v341 = u288.RecoilFinish(u79);
                                                                v342 = v338 + TableUtil:TableRandom(u288.Shake.Y);
                                                                v343 = v339 + TableUtil:TableRandom(u288.Shake.X);
                                                                v344 = -math.rad(v343);
                                                                u345 = math.rad(v342);
                                                                u346 = v344;
                                                                v347 = -math.rad(v341);
                                                                u348 = math.rad(v340);
                                                                u349 = v347;
                                                                u350 = tick();
                                                                u351 = 0;
                                                                u352 = 0;
                                                                u353 = 0;
                                                                u354 = u288.Duration - u288.FinishStart;
                                                                task.spawn(function() -- Line: 1238
                                                                    -- upvalues: u41 (ref), PreferredInputController (ref), u351 (ref), u288 (copy), u345 (ref), u346 (ref), CFrame_new_ret6 (ref), u353 (ref), u352 (ref), u354 (copy), u348 (ref), u349 (ref), u350 (copy), u287 (copy), u80 (ref), u337 (copy)
                                                                    local v439 = true;
                                                                    local v440 = false;

                                                                    while v439 or not v440 do
                                                                        local Attribute = script:GetAttribute("DebugFrameworkSpeed");
                                                                        local v441 = Run.Heartbeat:Wait() * Attribute;

                                                                        if v439 then
                                                                            local v442 = (script:GetAttribute("Aiming") and 0.7 or 1.2) * (StateController:GetAttribute("IsCrouch") and 0.75 or 1) * (1 + (u41.RecoilMult or 0));
                                                                            local v443 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Touch";
                                                                            local v444;

                                                                            if v443 then
                                                                                v444 = 0.55;
                                                                            else
                                                                                local v445 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
                                                                                v444 = v445 and 0.65 or 1;
                                                                            end;

                                                                            local v446 = v442 * v444;
                                                                            local v447 = u351;
                                                                            u351 = math.min(u351 + v441, u288.FinishStart);
                                                                            local v448 = (u351 - v447) / u288.FinishStart * v446;
                                                                            local CFrame_Angles_ret = CFrame.Angles(u345 * v448, u346 * v448, 0);
                                                                            CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret;
                                                                            Camera.CFrame = Camera.CFrame * CFrame_Angles_ret;
                                                                            local v449 = u353;
                                                                            u352 = math.min(u352 + v441, u288.Duration);
                                                                            u353 = math.clamp(u352 - u288.FinishStart, 0, u354);
                                                                            local v450 = (u353 - v449) / u354 * v446;
                                                                            local CFrame_Angles_ret2 = CFrame.Angles(u348 * v450, u349 * v450, 0);
                                                                            CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret2;
                                                                            Camera.CFrame = Camera.CFrame * CFrame_Angles_ret2;

                                                                            if tick() - u350 >= u288.Duration / Attribute then
                                                                                v439 = false;
                                                                            end;
                                                                        end;

                                                                        if tick() - u350 >= u287.StartTime / Attribute and not v440 then
                                                                            v440 = true;

                                                                            if u80.Code == u337 or not u80.Code then
                                                                                local Vector3_new_ret2 = Vector3.new();
                                                                                local Vector3_new_ret3 = Vector3.new();
                                                                                local EndTime = u287.EndTime;
                                                                                u80.Code = math.random(1, 100000000);
                                                                                u80.X = 0;
                                                                                u80.Increment = 1.5 / EndTime;
                                                                                u80.PrevPos = u80.Pos;
                                                                                u80.PrevRot = u80.Rot;
                                                                                u80.NewPos = Vector3_new_ret2;
                                                                                u80.NewRot = Vector3_new_ret3;
                                                                            end;
                                                                        end;
                                                                    end;
                                                                end);
                                                                task.defer(u226, v282, v292 and 0.4 or 1);

                                                                if v280.BurstRPM > 0 then
                                                                    task.wait(v291);

                                                                    if v278 <= 0 or (u139("Equip") or (InventoryController:GetAttribute("Open") or (CameraController:GetAttribute("ViewmodelCFrame") or tick() - u64 < 0.1))) then
                                                                        script:SetAttribute("Using", false);

                                                                        if not u275 then
                                                                            return;
                                                                        end;

                                                                        break;
                                                                    else
                                                                        v355 = InventoryController.Fetch:Invoke();

                                                                        if v355 then
                                                                            v356 = v355.Toolbar;

                                                                            if v356 then
                                                                                v357 = v356[script:GetAttribute("Equipped")];

                                                                                if v357 == nil then
                                                                                    v357 = false;
                                                                                elseif v357 == 0 then
                                                                                    v357 = false;
                                                                                end;
                                                                            else
                                                                                v357 = nil;
                                                                            end;
                                                                        else
                                                                            v357 = nil;
                                                                        end;

                                                                        if v357 and (u275.Durability ~= nil and u275.Durability > 0) then
                                                                            continue;
                                                                        else
                                                                            break;
                                                                        end;
                                                                    end;
                                                                end;
                                                            end;

                                                            if v281 then
                                                                u155("AimStart");
                                                                u155("AimHold");
                                                                u46 = "None";
                                                                u49 = false;

                                                                for _, child in pairs(u13:GetChildren()) do
                                                                    if child:IsA("BasePart") and child.Name:find("Arrow") then
                                                                        child.Transparency = 1;
                                                                    end;
                                                                end;
                                                            end;

                                                            task.wait(v290);
                                                            v358 = v280.BoltAnimSpeed or 1;

                                                            if not u23.Local.Bolt then
                                                      
                                                            end;

                                                            v359 = u10;
                                                            v360 = u149("Bolt", v358);

                                                            if v360 then
                                                                script:SetAttribute("CanUse", true);
                                                                task.wait(v360.Length);
                                                                script:SetAttribute("CanUse", nil);

                                                                if v359 and v359.Parent then
                                                                    u155("Bolt");
                                                                 
                                                                end;
                                                            end;
                                                        else
                                                            u155("Inspect", 0);
                                                            u155("Hit", 0.1);
                                                            u155("Miss", 0.1);
                                                            u73 = tick();
                                                            v366, v367 = pcall(function() -- Line: 1322
                                                                return workspace:GetServerTimeNow();
                                                            end);

                                                            if v366 then
                                                                if v363 then
                                                                    v368 = v363.Logic;
                                                                else
                                                                    v368 = v363;
                                                                end;

                                                                if v363 and (v368 ~= "Normal" or u45 == "Holding") then
                                                                    u155("ThrowHold");
                                                                    u155("Aim");
                                                                    v369 = u10;

                                                                    if u23.Local.Light then
                                                                        v370 = u149("Light");

                                                                        if not v370 then
                                                                            script:SetAttribute("Using", false);

                                                                            return;
                                                                        end;

                                                                        u371 = u16:FindFirstChild("Effect");

                                                                        if u371 then
                                                                            task.delay(0.5, function() -- Line: 1340
                                                                                -- upvalues: u371 (copy), u16 (ref)
                                                                                if not (u371 and u371.Parent) then
                                                                                    return;
                                                                                end;

                                                                                for _, child in pairs(u371:GetChildren()) do
                                                                                    child.Enabled = true;
                                                                                end;

                                                                                u16.Fuse:Play();
                                                                            end);
                                                                        end;

                                                                        task.wait(v370.Length);

                                                                        if not (v369 and v369.Parent) then
                                                                            script:SetAttribute("Using", false);

                                                                            return;
                                                                        end;

                                                                        u155("Light");
                                                                    end;

                                                                    v372 = (v368 == "Grenade" or v368 == "PlaceableGrenade") and ({ "ThrowStart", u271 and "UnderHandThrow" or "OverHandThrow" } or { "Throw" }) or { "Throw" };
                                                                    v373 = nil;
                                                                    v374 = nil;

                                                                    for i, v in pairs(v372) do
                                                                        v375 = v363.AnimSpeed or 1;
                                                                        v373 = u149(v, v375);

                                                                        if not v373 then
                                                                            return;
                                                                        end;

                                                                        if i == #v372 then
                                                                            if v368 ~= "Normal" then
                                                                                v374 = tick();
                                                                                task.wait(0.3);

                                                                                if not (v369 and v369.Parent) then
                                                                                    break;
                                                                                end;

                                                                                for _, child in pairs(u13:GetChildren()) do
                                                                                    child.Transparency = 1;
                                                                                    v376 = child:FindFirstChild("Effect");

                                                                                    if v376 then
                                                                                        v376:ClearAllChildren();
                                                                                        v377 = child:FindFirstChild("Fuse");

                                                                                        if v377 then
                                                                                            v377:Stop();
                                                                                        end;
                                                                                    end;
                                                                                end;
                                                                            end;
                                                                        else
                                                                            task.wait(v373.Length / v375);
                                                                            u155(v);
                                                                        end;
                                                                    end;

                                                                    v378 = { v367, Name, (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame) * CFrame.new(0.5, 0, 0) * CFrame.Angles(v363.Offset or 0, 0, 0) };

                                                                    if v368 == "PlaceableGrenade" and u271 then
                                                                        v379, v380 = RaycastUtil:MouseRaycast(u5, {
                                                                            VFX_PARTS,
                                                                            script_Parent,
                                                                            Drops,
                                                                            Plants
                                                                        }, 4);

                                                                        if v380 then
                                                                            v378[4] = v380.CFrame:PointToObjectSpace(v379);
                                                                            v378[5] = v380;
                                                                        else
                                                                            v378[4] = 0;
                                                                        end;
                                                                    elseif v368 == "Grenade" and u271 then
                                                                        v378[4] = 0;
                                                                    end;

                                                                    u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", unpack(v378));
                                                                    task.spawn(u226, {
                                                                        Strength = Vector3.new(4, 4, 4),
                                                                        Speed = 0.25,
                                                                        SnapBack = true,
                                                                        Angles = { -179, 180 }
                                                                    });

                                                                    if v368 == "Normal" then
                                                                        v374 = tick();

                                                                        while tick() - v374 < v373.Length and (v373.IsPlaying and u10 == v369) do
                                                                            task.wait();
                                                                        end;
                                                                    end;

                                                                    u45 = "None";

                                                                    if v368 == "Normal" then
                                                                        script:SetAttribute("Using", false);
                                                                        u30 = false;

                                                                        return;
                                                                    end;

                                                                    u266(math.max(v373.Length, 0.46), u275, 3, v374);
                                                                end;

                                                                u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v367, v277.Name);
                                                                task.spawn(u226, v282);
                                                                v381 = v280.Cooldown;

                                                                if v280.KeycardColor then
                                                                    u155("Use");
                                                                    u149("Use", 1);
                                                                    task.wait(v381);
                                                                elseif Name == "Lighter" then
                                                                    v382 = u10;
                                                                    u155("Use");
                                                                    u149("Use", 1);
                                                                    task.wait(0.5);

                                                                    if not (v382 and v382.Parent) then
                                                                        script:SetAttribute("Using", false);

                                                                        return;
                                                                    end;

                                                                    for _, child in u13.LightPart:GetChildren() do
                                                                        child.Enabled = not child.Enabled;
                                                                    end;

                                                                    task.wait((math.max(v381 - 0.5, 0)));
                                                                else
                                                                    if v280.HealthItem then
                                                                        v383 = v280.AnimationTimeScale;
                                                                        u155("Use");
                                                                        u149("Use", v383);
                                                                        u266(v381, u275, 1);
                                                                    end;

                                                                    v384 = v280.SwingAnimSpeed or 1;
                                                                    u155("Swing", 0);
                                                                    u149("Swing", v384);
                                                                    v385 = u23.Local.WindupLoop ~= nil;
                                                                    v386 = u149(v385 and "WindupLoop" or "Windup", v384, v385 and 0.15 or 0);

                                                                    if v386 then
                                                                        v387 = v385 and v381 and v381 or v386.Length / v384;
                                                                        v388 = tick();
                                                                        v389 = Melee.MeleeChecks;
                                                                        v390 = u10;
                                                                        v391 = 0;
                                                                        v392 = 0;
                                                                        v393 = (1 / 0);
                                                                        u394 = nil;
                                                                        v395 = nil;
                                                                        u396 = 0;
                                                                        u397 = nil;
                                                                        u398 = nil;
                                                                        u399 = nil;
                                                                        u400 = nil;
                                                                        v401 = nil;

                                                                        while Run.Heartbeat:Wait() do
                                                                            if u10 ~= v390 then
                                                                                script:SetAttribute("Using", false);
                                                                                break;
                                                                            end;

                                                                            v402 = (tick() - v388) / v387;
                                                                            v403 = math.clamp(v402, 0, 1);
                                                                            v404 = 0;

                                                                            for i, v in pairs(v389) do
                                                                                v404 = v[1] <= v403 and i or v404;
                                                                            end;

                                                                            if v391 ~= v404 then
                                                                                v405 = CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame;

                                                                                for _, v in pairs(v389[v404][2]) do
                                                                                    v406 = (v405 * v.Offset).Position;
                                                                                    v407 = v405.LookVector * v.Range;
                                                                                    v408, v409, v410, v411, v412 = RaycastUtil:Raycast(v406, v407, "Blacklist", {
                                                                                        script_Parent,
                                                                                        VFX_PARTS,
                                                                                        Drops,
                                                                                        Plants
                                                                                    }, script:GetAttribute("DebugShowRays"), u7, true);

                                                                                    if v412 then
                                                                                        Debris:AddItem(v412, 3);
                                                                                    end;

                                                                                    if v408 and v408.Parent then
                                                                                        v413 = v408.Name;
                                                                                        v414 = v408.Parent;

                                                                                        if v414:FindFirstChild("Humanoid") or v414.Parent:FindFirstChild("Humanoid") then
                                                                                            v415 = v413 == "Head" and 7 or (v413:find("Torso") and 6 or (v413:find("Arm") and 5 or 4));
                                                                                        else
                                                                                            v415 = (v414.Name == "NodeSpark" or v414.Name == "TreeX") and 3 or (v408:IsA("Terrain") and 1 or 2);
                                                                                        end;

                                                                                        v416 = (v409 - v406).Magnitude;
                                                                                    else
                                                                                        v415 = 0;
                                                                                        v416 = (1 / 0);
                                                                                    end;

                                                                                    if v392 < v415 or v415 == v392 and v416 < v393 then
                                                                                        u397 = v408.CFrame:PointToObjectSpace(v409);
                                                                                        v401 = v405;
                                                                                        u400 = v408;
                                                                                        u399 = v410;
                                                                                        u398 = v409;
                                                                                        u396 = v404;
                                                                                        v395 = v407;
                                                                                        u394 = v411;
                                                                                        v393 = v416;
                                                                                        v392 = v415;
                                                                                    end;
                                                                                end;
                                                                            end;

                                                                            if v403 >= 1 then
                                                                                break;
                                                                            end;

                                                                            v391 = v404;
                                                                        end;

                                                                        if script:GetAttribute("Using") then
                                                                            if not v385 then
                                                                                u155("Windup", 0);
                                                                            end;

                                                                            v417 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Swing");

                                                                            if v417 then
                                                                                if v385 then
                                                                                    v417:Play();
                                                                                else
                                                                                    SoundModule:PlayDuplicateSound(v417, nil, nil, true, u275.Skin);
                                                                                end;
                                                                            end;

                                                                            v418 = math.round(v367 * 10000);
                                                                            u419 = Random.new(v418):NextInteger(1, 1000000000);
                                                                            u420 = Random.new(v418):NextInteger(1, 10000000000);
                                                                            u421 = v401 or (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame);

                                                                            if v395 then
                                                                                u422, u423, u424, u425 = RaycastUtil:Raycast(u421.Position, v395 * 1.5, "Blacklist", {
                                                                                    script_Parent,
                                                                                    VFX_PARTS,
                                                                                    Drops,
                                                                                    Plants
                                                                                }, script:GetAttribute("DebugShowRays"), u8, true);
                                                                            else
                                                                                u424 = nil;
                                                                                u425 = nil;
                                                                                u422 = nil;
                                                                                u423 = nil;
                                                                            end;

                                                                            if u400 and u400.Parent then
                                                                                v426 = u103;
                                                                                v427 = math.random(-15, 15) / 100;
                                                                                v428 = math.random(-15, 15) / 100;
                                                                                v426.Target = Vector3.new(v427, v428, 0.5) * (Melee.BounceMult or 1);
                                                                            end;

                                                                            task.spawn(function() -- Line: 1537
                                                                                -- upvalues: u257 (ref), u400 (ref), u397 (ref), u398 (ref), u399 (ref), u394 (ref), u419 (copy), u420 (copy), u421 (ref), u396 (ref), u422 (ref), u423 (ref), u424 (ref), u425 (ref), u275 (copy)
                                                                                local v451 = {};
                                                                                local v452;

                                                                                if u397 and (u400 and u400.Parent) then
                                                                                    v452 = u400.CFrame * u397;
                                                                                else
                                                                                    v452 = u398;
                                                                                end;

                                                                                v451[1], v451[2], v451[3], v451[4], v451[5], v451[6], v451[7], v451[8], v451[9] = u400, v452, u399, u394, u419, u420, nil, u421, u396;
                                                                                u257(v451, {
                                                                                    u422,
                                                                                    u423,
                                                                                    u424,
                                                                                    u425
                                                                                }, true, u275.ID == 31);
                                                                            end);
                                                                            v429 = u400 and "Hit" or "Miss";
                                                                            u149(v429, v384, v429 == "Hit" and 0.1 or 0.4, 10);

                                                                            if not v385 then
                                                                                task.wait(v381 - v387);
                                                                            end;
                                                                        end;
                                                                    else
                                                                        Run.Heartbeat:Wait();
                                                                    end;
                                                                end;

                                                       
                                                            end;

                                                            warn("MELEE SYNCHRONIZATION INTERNAL ERROR: ", v367);
                                                        end;
                                                    end;
                                                elseif Type == "Gun" then
                                                    v283 = v279.Spread;
                                                    v284 = v279.Bullet;
                                                    v285 = v279.Casing;
                                                    v286 = v279.Recoil;
                                                    u287 = v286.VM;
                                                    u288 = v286.Camera;
                                                    v289 = 1 - (u41.FireRateMult or 0);
                                                    v290 = 60 / v280.RPM * v289;
                                                    v291 = 60 / v280.BurstRPM * v289;

                                                    for i = 1, v280.Burst do
                                                        u155("Inspect", 0);
                                                        u155("Shoot", 0);
                                                        u149("Shoot", 1, 0);

                                                        if v285 and not v285.IgnoreShoot then
                                                            u118(v285);
                                                        end;

                                                        v292 = script:GetAttribute("Aiming");
                                                        v293 = u44 or u20;

                                                        if not (u41.Scope and v292) then
                                                            VFXModule:FlashPart(v293);
                                                        end;

                                                        v294 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Shoot");

                                                        if v294 then
                                                            SoundModule:PlayDuplicateSound(v294, nil, nil, true, u275.Skin);
                                                        end;

                                                        u73 = tick();
                                                        v295 = u275.Skin == "Hot Rod" and 0.75 or 1;
                                                        v296 = 1 + (v292 and u41.GunRecoilAimMult or 0);
                                                        v297 = v283[v292 and "Aiming" or "Hip"].ShootingExtra * (1 + (u41[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 0)) * (u75 < 0.001 and 0 or u75) * (u276[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 1);
                                                        u75 = math.min(u75 + 1 / v283.Shooting.BulletsForMax, 1);
                                                        v298 = u74 < 0.001 and 0 or math.floor(u74 * 100) / 100;
                                                        v299 = v297 < 0.001 and 0 or math.floor(v297 * 100) / 100;
                                                        v300 = v298 + v299;
                                                        v301 = CFrame.Angles(v284.Offset or 0, 0, 0);
                                                        v302 = Camera.CFrame;
                                                        v303 = workspace:GetServerTimeNow();
                                                        v304 = math.round(v303 * 10000);
                                                        v305 = Random.new(v304);
                                                        u306 = v305.NextInteger(v305, 1, 1000000000);
                                                        v307 = Random.new(v304);
                                                        v308 = i;
                                                        v309 = {};

                                                        for i2 = 1, u276.Bullets or 1 do
                                                            v310 = {
                                                                Radius = v307:NextNumber(0, math.floor(v300 * 100) / 100) / 500,
                                                                Degree = v307:NextNumber(0, 6.283185307179586)
                                                            };
                                                            v311 = math.floor(v300 * 100) / 100;
                                                            v312 = math.max(1, v311) * 1000000000;
                                                            v310.ID = v307:NextInteger(1, (math.ceil(v312)));
                                                            table.insert(v309, v310);
                                                            v313 = i2;
                                                        end;

                                                        v314 = v293.Position;
                                                        v315 = script_Parent.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0);
                                                        u316 = {};
                                                        v317, v318 = RaycastUtil:MouseRaycast(u6, VFXModule.WithSeatedVehicles({ script_Parent, VFX_PARTS }));

                                                        if u41.HideTracer then
                                                            v319 = "";
                                                        elseif table.find(VFXModule.TracerSkins, u275.Skin) then
                                                            v319 = u275.Skin .. "Bullet";
                                                        else
                                                            v319 = u276.TracerName;
                                                        end;

                                                        for _, v in pairs(v309) do
                                                            v320 = v301 * CFrame.Angles(math.sin(v.Degree) * v.Radius, math.cos(v.Degree) * v.Radius, 0);
                                                            u321 = v.ID;
                                                            v322 = VFXModule;
                                                            v323 = {
                                                                FilterType = "Blacklist",
                                                                Position = v314,
                                                                Direction = (CFrame.new(v314, v317) * v320).LookVector,
                                                                PositionFirst = v315.p
                                                            };
                                                            v324 = RaycastParams.new();
                                                            v324.FilterType = Enum.RaycastFilterType.Include;
                                                            v324.FilterDescendantsInstances = { workspace.Terrain };
                                                            v324.IgnoreWater = true;

                                                            if workspace:Raycast(v315.p, v314 - v315.p, v324) then
                                                                v325 = (v314 - v315.p).Unit;
                                                            else
                                                                v325 = (v302 * v320).LookVector;
                                                            end;

                                                            v323.DirectionFirst = v325;
                                                            v323.Filters = {
                                                                script_Parent,
                                                                VFX_PARTS,
                                                                Drops,
                                                                Plants
                                                            };
                                                            v323.FilterFunction = u276.FilterType or "Hit";
                                                            v323.VisualizeRay = script:GetAttribute("DebugShowRays");
                                                            v323.Speed = v284.Speed * (1 + (u41.SpeedMult or 0)) * (u276.SpeedMult or 1);
                                                            v323.Gravity = v284.Gravity * (u276.GravityMult or 1);
                                                            v323.MaxRange = v284.MaxRange * (1 + (u41.RangeMult or 0)) * (u276.RangeMult or 1);
                                                            v323.Size = u276.BulletSize;
                                                            v323.TracerName = v319;

                                                            function v323.HitFunction(...) -- Line: 1191
                                                                -- upvalues: u257 (ref), u306 (copy), u321 (copy), u316 (copy), u276 (ref)
                                                                local v438 = { ... };
                                                                u257({
                                                                    v438[1],
                                                                    v438[2],
                                                                    v438[3],
                                                                    v438[4],
                                                                    u306,
                                                                    u321,
                                                                    u316
                                                                }, nil, u276.Impact);
                                                            end;

                                                            function v323.MissFunction() -- Line: 1195
                                                                -- upvalues: u4 (ref), u321 (copy), u306 (copy)
                                                                u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\194\163\239\191\189\048\195\161\239\191\189\104\239\191\189\122\239\191\189\075\239\191\189\082\056\098\239\191\189\102\239\191\189", u321, u306);
                                                            end;

                                                            v322:CreateProjectile(v323);
                                                        end;

                                                        v278 = v278 - 1;
                                                        script:SetAttribute("LocalAmmo", v278);
                                                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v303, v277.Name, v302, v315:PointToObjectSpace(v314), v315, v298, v299, v317);
                                                        v326 = TableUtil:TableRandom(u287.Pos.X);
                                                        v327 = TableUtil:TableRandom(u287.Pos.Y);
                                                        v328 = Vector3.new(v326, v327, TableUtil:TableRandom(u287.Pos.Z)) * v295;
                                                        v329 = TableUtil:TableRandom(u287.Rot.Y);
                                                        v330 = math.rad(v329);
                                                        v331 = TableUtil:TableRandom(u287.Rot.X);
                                                        v332 = math.rad(v331) * v296;
                                                        v333 = TableUtil:TableRandom(u287.Rot.Z);
                                                        v334 = math.rad(v333) * v296;
                                                        v335 = Vector3.new(v330, v332, v334) * v295;
                                                        v336 = u287.StartTime;
                                                        u80.Code = math.random(1, 100000000);
                                                        u80.X = 0;
                                                        u80.Increment = 1.5 / v336;
                                                        u80.PrevPos = u80.Pos;
                                                        u80.PrevRot = u80.Rot;
                                                        u80.NewPos = v328;
                                                        u80.NewRot = v335;
                                                        u337 = u80.Code;
                                                        u78 = 0;
                                                        u79 = u79 + 1;
                                                        u81 = tick();
                                                        v338, v339 = u288.RecoilStart(u79);
                                                        v340, v341 = u288.RecoilFinish(u79);
                                                        v342 = v338 + TableUtil:TableRandom(u288.Shake.Y);
                                                        v343 = v339 + TableUtil:TableRandom(u288.Shake.X);
                                                        v344 = -math.rad(v343);
                                                        u345 = math.rad(v342);
                                                        u346 = v344;
                                                        v347 = -math.rad(v341);
                                                        u348 = math.rad(v340);
                                                        u349 = v347;
                                                        u350 = tick();
                                                        u351 = 0;
                                                        u352 = 0;
                                                        u353 = 0;
                                                        u354 = u288.Duration - u288.FinishStart;
                                                        task.spawn(function() -- Line: 1238
                                                            -- upvalues: u41 (ref), PreferredInputController (ref), u351 (ref), u288 (copy), u345 (ref), u346 (ref), CFrame_new_ret6 (ref), u353 (ref), u352 (ref), u354 (copy), u348 (ref), u349 (ref), u350 (copy), u287 (copy), u80 (ref), u337 (copy)
                                                            local v439 = true;
                                                            local v440 = false;

                                                            while v439 or not v440 do
                                                                local Attribute = script:GetAttribute("DebugFrameworkSpeed");
                                                                local v441 = Run.Heartbeat:Wait() * Attribute;

                                                                if v439 then
                                                                    local v442 = (script:GetAttribute("Aiming") and 0.7 or 1.2) * (StateController:GetAttribute("IsCrouch") and 0.75 or 1) * (1 + (u41.RecoilMult or 0));
                                                                    local v443 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Touch";
                                                                    local v444;

                                                                    if v443 then
                                                                        v444 = 0.55;
                                                                    else
                                                                        local v445 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
                                                                        v444 = v445 and 0.65 or 1;
                                                                    end;

                                                                    local v446 = v442 * v444;
                                                                    local v447 = u351;
                                                                    u351 = math.min(u351 + v441, u288.FinishStart);
                                                                    local v448 = (u351 - v447) / u288.FinishStart * v446;
                                                                    local CFrame_Angles_ret = CFrame.Angles(u345 * v448, u346 * v448, 0);
                                                                    CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret;
                                                                    Camera.CFrame = Camera.CFrame * CFrame_Angles_ret;
                                                                    local v449 = u353;
                                                                    u352 = math.min(u352 + v441, u288.Duration);
                                                                    u353 = math.clamp(u352 - u288.FinishStart, 0, u354);
                                                                    local v450 = (u353 - v449) / u354 * v446;
                                                                    local CFrame_Angles_ret2 = CFrame.Angles(u348 * v450, u349 * v450, 0);
                                                                    CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret2;
                                                                    Camera.CFrame = Camera.CFrame * CFrame_Angles_ret2;

                                                                    if tick() - u350 >= u288.Duration / Attribute then
                                                                        v439 = false;
                                                                    end;
                                                                end;

                                                                if tick() - u350 >= u287.StartTime / Attribute and not v440 then
                                                                    v440 = true;

                                                                    if u80.Code == u337 or not u80.Code then
                                                                        local Vector3_new_ret2 = Vector3.new();
                                                                        local Vector3_new_ret3 = Vector3.new();
                                                                        local EndTime = u287.EndTime;
                                                                        u80.Code = math.random(1, 100000000);
                                                                        u80.X = 0;
                                                                        u80.Increment = 1.5 / EndTime;
                                                                        u80.PrevPos = u80.Pos;
                                                                        u80.PrevRot = u80.Rot;
                                                                        u80.NewPos = Vector3_new_ret2;
                                                                        u80.NewRot = Vector3_new_ret3;
                                                                    end;
                                                                end;
                                                            end;
                                                        end);
                                                        task.defer(u226, v282, v292 and 0.4 or 1);

                                                        if v280.BurstRPM > 0 then
                                                            task.wait(v291);

                                                            if v278 <= 0 or (u139("Equip") or (InventoryController:GetAttribute("Open") or (CameraController:GetAttribute("ViewmodelCFrame") or tick() - u64 < 0.1))) then
                                                                script:SetAttribute("Using", false);

                                                                if not u275 then
                                                                    return;
                                                                end;

                                                                break;
                                                            else
                                                                v355 = InventoryController.Fetch:Invoke();

                                                                if v355 then
                                                                    v356 = v355.Toolbar;

                                                                    if v356 then
                                                                        v357 = v356[script:GetAttribute("Equipped")];

                                                                        if v357 == nil then
                                                                            v357 = false;
                                                                        elseif v357 == 0 then
                                                                            v357 = false;
                                                                        end;
                                                                    else
                                                                        v357 = nil;
                                                                    end;
                                                                else
                                                                    v357 = nil;
                                                                end;

                                                                if v357 and (u275.Durability ~= nil and u275.Durability > 0) then
                                                                    continue;
                                                                else
                                                                    break;
                                                                end;
                                                            end;
                                                        end;
                                                    end;

                                                    if v281 then
                                                        u155("AimStart");
                                                        u155("AimHold");
                                                        u46 = "None";
                                                        u49 = false;

                                                        for _, child in pairs(u13:GetChildren()) do
                                                            if child:IsA("BasePart") and child.Name:find("Arrow") then
                                                                child.Transparency = 1;
                                                            end;
                                                        end;
                                                    end;

                                                    task.wait(v290);
                                                    v358 = v280.BoltAnimSpeed or 1;

                                                    if u23.Local.Bolt then
                                                        v359 = u10;
                                                        v360 = u149("Bolt", v358);

                                                        if v360 then
                                                            script:SetAttribute("CanUse", true);
                                                            task.wait(v360.Length);
                                                            script:SetAttribute("CanUse", nil);

                                                            if v359 and v359.Parent then
                                                                u155("Bolt");
                                                            
                                                            end;
                                                        end;
                                                    else
                                                        if script:GetAttribute("Using") and (not v280.Auto and tick() - u33 > 0.2) then
                                                            script:SetAttribute("Using", false);

                                                            return;
                                                        end;

                                                        v274 = false;

                                                        if u23.Local.WindupLoop and u23.Local.WindupLoop.IsPlaying then
                                                            u155("WindupLoop", 0.15);
                                                        end;
                                                    end;
                                                else
                                                    u155("Inspect", 0);
                                                    u155("Hit", 0.1);
                                                    u155("Miss", 0.1);
                                                    u73 = tick();
                                                    v366, v367 = pcall(function() -- Line: 1322
                                                        return workspace:GetServerTimeNow();
                                                    end);

                                                    if v366 then
                                                        if v363 then
                                                            v368 = v363.Logic;
                                                        else
                                                            v368 = v363;
                                                        end;

                                                        if v363 and (v368 ~= "Normal" or u45 == "Holding") then
                                                            u155("ThrowHold");
                                                            u155("Aim");
                                                            v369 = u10;

                                                            if u23.Local.Light then
                                                                v370 = u149("Light");

                                                                if not v370 then
                                                                    script:SetAttribute("Using", false);

                                                                    return;
                                                                end;

                                                                u371 = u16:FindFirstChild("Effect");

                                                                if u371 then
                                                                    task.delay(0.5, function() -- Line: 1340
                                                                        -- upvalues: u371 (copy), u16 (ref)
                                                                        if not (u371 and u371.Parent) then
                                                                            return;
                                                                        end;

                                                                        for _, child in pairs(u371:GetChildren()) do
                                                                            child.Enabled = true;
                                                                        end;

                                                                        u16.Fuse:Play();
                                                                    end);
                                                                end;

                                                                task.wait(v370.Length);

                                                                if not (v369 and v369.Parent) then
                                                                    script:SetAttribute("Using", false);

                                                                    return;
                                                                end;

                                                                u155("Light");
                                                            end;

                                                            v372 = (v368 == "Grenade" or v368 == "PlaceableGrenade") and ({ "ThrowStart", u271 and "UnderHandThrow" or "OverHandThrow" } or { "Throw" }) or { "Throw" };
                                                            v373 = nil;
                                                            v374 = nil;

                                                            for i, v in pairs(v372) do
                                                                v375 = v363.AnimSpeed or 1;
                                                                v373 = u149(v, v375);

                                                                if not v373 then
                                                                    return;
                                                                end;

                                                                if i == #v372 then
                                                                    if v368 ~= "Normal" then
                                                                        v374 = tick();
                                                                        task.wait(0.3);

                                                                        if not (v369 and v369.Parent) then
                                                                            break;
                                                                        end;

                                                                        for _, child in pairs(u13:GetChildren()) do
                                                                            child.Transparency = 1;
                                                                            v376 = child:FindFirstChild("Effect");

                                                                            if v376 then
                                                                                v376:ClearAllChildren();
                                                                                v377 = child:FindFirstChild("Fuse");

                                                                                if v377 then
                                                                                    v377:Stop();
                                                                                end;
                                                                            end;
                                                                        end;
                                                                    end;
                                                                else
                                                                    task.wait(v373.Length / v375);
                                                                    u155(v);
                                                                end;
                                                            end;

                                                            v378 = { v367, Name, (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame) * CFrame.new(0.5, 0, 0) * CFrame.Angles(v363.Offset or 0, 0, 0) };

                                                            if v368 == "PlaceableGrenade" and u271 then
                                                                v379, v380 = RaycastUtil:MouseRaycast(u5, {
                                                                    VFX_PARTS,
                                                                    script_Parent,
                                                                    Drops,
                                                                    Plants
                                                                }, 4);

                                                                if v380 then
                                                                    v378[4] = v380.CFrame:PointToObjectSpace(v379);
                                                                    v378[5] = v380;
                                                                else
                                                                    v378[4] = 0;
                                                                end;
                                                            elseif v368 == "Grenade" and u271 then
                                                                v378[4] = 0;
                                                            end;

                                                            u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", unpack(v378));
                                                            task.spawn(u226, {
                                                                Strength = Vector3.new(4, 4, 4),
                                                                Speed = 0.25,
                                                                SnapBack = true,
                                                                Angles = { -179, 180 }
                                                            });

                                                            if v368 == "Normal" then
                                                                v374 = tick();

                                                                while tick() - v374 < v373.Length and (v373.IsPlaying and u10 == v369) do
                                                                    task.wait();
                                                                end;
                                                            end;

                                                            u45 = "None";

                                                            if v368 == "Normal" then
                                                                script:SetAttribute("Using", false);
                                                                u30 = false;

                                                                return;
                                                            end;

                                                            u266(math.max(v373.Length, 0.46), u275, 3, v374);
                                                        end;

                                                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v367, v277.Name);
                                                        task.spawn(u226, v282);
                                                        v381 = v280.Cooldown;

                                                        if v280.KeycardColor then
                                                            u155("Use");
                                                            u149("Use", 1);
                                                            task.wait(v381);
                                                        elseif Name == "Lighter" then
                                                            v382 = u10;
                                                            u155("Use");
                                                            u149("Use", 1);
                                                            task.wait(0.5);

                                                            if not (v382 and v382.Parent) then
                                                                script:SetAttribute("Using", false);

                                                                return;
                                                            end;

                                                            for _, child in u13.LightPart:GetChildren() do
                                                                child.Enabled = not child.Enabled;
                                                            end;

                                                            task.wait((math.max(v381 - 0.5, 0)));
                                                        else
                                                            if v280.HealthItem then
                                                                v383 = v280.AnimationTimeScale;
                                                                u155("Use");
                                                                u149("Use", v383);
                                                                u266(v381, u275, 1);
                                                            end;

                                                            v384 = v280.SwingAnimSpeed or 1;
                                                            u155("Swing", 0);
                                                            u149("Swing", v384);
                                                            v385 = u23.Local.WindupLoop ~= nil;
                                                            v386 = u149(v385 and "WindupLoop" or "Windup", v384, v385 and 0.15 or 0);

                                                            if v386 then
                                                                v387 = v385 and v381 and v381 or v386.Length / v384;
                                                                v388 = tick();
                                                                v389 = Melee.MeleeChecks;
                                                                v390 = u10;
                                                                v391 = 0;
                                                                v392 = 0;
                                                                v393 = (1 / 0);
                                                                u394 = nil;
                                                                v395 = nil;
                                                                u396 = 0;
                                                                u397 = nil;
                                                                u398 = nil;
                                                                u399 = nil;
                                                                u400 = nil;
                                                                v401 = nil;

                                                                while Run.Heartbeat:Wait() do
                                                                    if u10 ~= v390 then
                                                                        script:SetAttribute("Using", false);
                                                                        break;
                                                                    end;

                                                                    v402 = (tick() - v388) / v387;
                                                                    v403 = math.clamp(v402, 0, 1);
                                                                    v404 = 0;

                                                                    for i, v in pairs(v389) do
                                                                        v404 = v[1] <= v403 and i or v404;
                                                                    end;

                                                                    if v391 ~= v404 then
                                                                        v405 = CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame;

                                                                        for _, v in pairs(v389[v404][2]) do
                                                                            v406 = (v405 * v.Offset).Position;
                                                                            v407 = v405.LookVector * v.Range;
                                                                            v408, v409, v410, v411, v412 = RaycastUtil:Raycast(v406, v407, "Blacklist", {
                                                                                script_Parent,
                                                                                VFX_PARTS,
                                                                                Drops,
                                                                                Plants
                                                                            }, script:GetAttribute("DebugShowRays"), u7, true);

                                                                            if v412 then
                                                                                Debris:AddItem(v412, 3);
                                                                            end;

                                                                            if v408 and v408.Parent then
                                                                                v413 = v408.Name;
                                                                                v414 = v408.Parent;

                                                                                if v414:FindFirstChild("Humanoid") or v414.Parent:FindFirstChild("Humanoid") then
                                                                                    v415 = v413 == "Head" and 7 or (v413:find("Torso") and 6 or (v413:find("Arm") and 5 or 4));
                                                                                else
                                                                                    v415 = (v414.Name == "NodeSpark" or v414.Name == "TreeX") and 3 or (v408:IsA("Terrain") and 1 or 2);
                                                                                end;

                                                                                v416 = (v409 - v406).Magnitude;
                                                                            else
                                                                                v415 = 0;
                                                                                v416 = (1 / 0);
                                                                            end;

                                                                            if v392 < v415 or v415 == v392 and v416 < v393 then
                                                                                u397 = v408.CFrame:PointToObjectSpace(v409);
                                                                                v401 = v405;
                                                                                u400 = v408;
                                                                                u399 = v410;
                                                                                u398 = v409;
                                                                                u396 = v404;
                                                                                v395 = v407;
                                                                                u394 = v411;
                                                                                v393 = v416;
                                                                                v392 = v415;
                                                                            end;
                                                                        end;
                                                                    end;

                                                                    if v403 >= 1 then
                                                                        break;
                                                                    end;

                                                                    v391 = v404;
                                                                end;

                                                                if script:GetAttribute("Using") then
                                                                    if not v385 then
                                                                        u155("Windup", 0);
                                                                    end;

                                                                    v417 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Swing");

                                                                    if v417 then
                                                                        if v385 then
                                                                            v417:Play();
                                                                        else
                                                                            SoundModule:PlayDuplicateSound(v417, nil, nil, true, u275.Skin);
                                                                        end;
                                                                    end;

                                                                    v418 = math.round(v367 * 10000);
                                                                    u419 = Random.new(v418):NextInteger(1, 1000000000);
                                                                    u420 = Random.new(v418):NextInteger(1, 10000000000);
                                                                    u421 = v401 or (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame);

                                                                    if v395 then
                                                                        u422, u423, u424, u425 = RaycastUtil:Raycast(u421.Position, v395 * 1.5, "Blacklist", {
                                                                            script_Parent,
                                                                            VFX_PARTS,
                                                                            Drops,
                                                                            Plants
                                                                        }, script:GetAttribute("DebugShowRays"), u8, true);
                                                                    else
                                                                        u424 = nil;
                                                                        u425 = nil;
                                                                        u422 = nil;
                                                                        u423 = nil;
                                                                    end;

                                                                    if u400 and u400.Parent then
                                                                        v426 = u103;
                                                                        v427 = math.random(-15, 15) / 100;
                                                                        v428 = math.random(-15, 15) / 100;
                                                                        v426.Target = Vector3.new(v427, v428, 0.5) * (Melee.BounceMult or 1);
                                                                    end;

                                                                    task.spawn(function() -- Line: 1537
                                                                        -- upvalues: u257 (ref), u400 (ref), u397 (ref), u398 (ref), u399 (ref), u394 (ref), u419 (copy), u420 (copy), u421 (ref), u396 (ref), u422 (ref), u423 (ref), u424 (ref), u425 (ref), u275 (copy)
                                                                        local v451 = {};
                                                                        local v452;

                                                                        if u397 and (u400 and u400.Parent) then
                                                                            v452 = u400.CFrame * u397;
                                                                        else
                                                                            v452 = u398;
                                                                        end;

                                                                        v451[1], v451[2], v451[3], v451[4], v451[5], v451[6], v451[7], v451[8], v451[9] = u400, v452, u399, u394, u419, u420, nil, u421, u396;
                                                                        u257(v451, {
                                                                            u422,
                                                                            u423,
                                                                            u424,
                                                                            u425
                                                                        }, true, u275.ID == 31);
                                                                    end);
                                                                    v429 = u400 and "Hit" or "Miss";
                                                                    u149(v429, v384, v429 == "Hit" and 0.1 or 0.4, 10);

                                                                    if not v385 then
                                                                        task.wait(v381 - v387);
                                                                    end;
                                                                end;
                                                            else
                                                                Run.Heartbeat:Wait();
                                                            end;
                                                        end;

                                                       
                                                    end;

                                                    warn("MELEE SYNCHRONIZATION INTERNAL ERROR: ", v367);
                                                end;
                                            end;
                                        end;
                                    end;
                                elseif Type == "Gun" then
                                    v283 = v279.Spread;
                                    v284 = v279.Bullet;
                                    v285 = v279.Casing;
                                    v286 = v279.Recoil;
                                    u287 = v286.VM;
                                    u288 = v286.Camera;
                                    v289 = 1 - (u41.FireRateMult or 0);
                                    v290 = 60 / v280.RPM * v289;
                                    v291 = 60 / v280.BurstRPM * v289;

                                    for i = 1, v280.Burst do
                                        u155("Inspect", 0);
                                        u155("Shoot", 0);
                                        u149("Shoot", 1, 0);

                                        if v285 and not v285.IgnoreShoot then
                                            u118(v285);
                                        end;

                                        v292 = script:GetAttribute("Aiming");
                                        v293 = u44 or u20;

                                        if not (u41.Scope and v292) then
                                            VFXModule:FlashPart(v293);
                                        end;

                                        v294 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Shoot");

                                        if v294 then
                                            SoundModule:PlayDuplicateSound(v294, nil, nil, true, u275.Skin);
                                        end;

                                        u73 = tick();
                                        v295 = u275.Skin == "Hot Rod" and 0.75 or 1;
                                        v296 = 1 + (v292 and u41.GunRecoilAimMult or 0);
                                        v297 = v283[v292 and "Aiming" or "Hip"].ShootingExtra * (1 + (u41[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 0)) * (u75 < 0.001 and 0 or u75) * (u276[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 1);
                                        u75 = math.min(u75 + 1 / v283.Shooting.BulletsForMax, 1);
                                        v298 = u74 < 0.001 and 0 or math.floor(u74 * 100) / 100;
                                        v299 = v297 < 0.001 and 0 or math.floor(v297 * 100) / 100;
                                        v300 = v298 + v299;
                                        v301 = CFrame.Angles(v284.Offset or 0, 0, 0);
                                        v302 = Camera.CFrame;
                                        v303 = workspace:GetServerTimeNow();
                                        v304 = math.round(v303 * 10000);
                                        v305 = Random.new(v304);
                                        u306 = v305.NextInteger(v305, 1, 1000000000);
                                        v307 = Random.new(v304);
                                        v308 = i;
                                        v309 = {};

                                        for i2 = 1, u276.Bullets or 1 do
                                            v310 = {
                                                Radius = v307:NextNumber(0, math.floor(v300 * 100) / 100) / 500,
                                                Degree = v307:NextNumber(0, 6.283185307179586)
                                            };
                                            v311 = math.floor(v300 * 100) / 100;
                                            v312 = math.max(1, v311) * 1000000000;
                                            v310.ID = v307:NextInteger(1, (math.ceil(v312)));
                                            table.insert(v309, v310);
                                            v313 = i2;
                                        end;

                                        v314 = v293.Position;
                                        v315 = script_Parent.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0);
                                        u316 = {};
                                        v317, v318 = RaycastUtil:MouseRaycast(u6, VFXModule.WithSeatedVehicles({ script_Parent, VFX_PARTS }));

                                        if u41.HideTracer then
                                            v319 = "";
                                        elseif table.find(VFXModule.TracerSkins, u275.Skin) then
                                            v319 = u275.Skin .. "Bullet";
                                        else
                                            v319 = u276.TracerName;
                                        end;

                                        for _, v in pairs(v309) do
                                            v320 = v301 * CFrame.Angles(math.sin(v.Degree) * v.Radius, math.cos(v.Degree) * v.Radius, 0);
                                            u321 = v.ID;
                                            v322 = VFXModule;
                                            v323 = {
                                                FilterType = "Blacklist",
                                                Position = v314,
                                                Direction = (CFrame.new(v314, v317) * v320).LookVector,
                                                PositionFirst = v315.p
                                            };
                                            v324 = RaycastParams.new();
                                            v324.FilterType = Enum.RaycastFilterType.Include;
                                            v324.FilterDescendantsInstances = { workspace.Terrain };
                                            v324.IgnoreWater = true;

                                            if workspace:Raycast(v315.p, v314 - v315.p, v324) then
                                                v325 = (v314 - v315.p).Unit;
                                            else
                                                v325 = (v302 * v320).LookVector;
                                            end;

                                            v323.DirectionFirst = v325;
                                            v323.Filters = {
                                                script_Parent,
                                                VFX_PARTS,
                                                Drops,
                                                Plants
                                            };
                                            v323.FilterFunction = u276.FilterType or "Hit";
                                            v323.VisualizeRay = script:GetAttribute("DebugShowRays");
                                            v323.Speed = v284.Speed * (1 + (u41.SpeedMult or 0)) * (u276.SpeedMult or 1);
                                            v323.Gravity = v284.Gravity * (u276.GravityMult or 1);
                                            v323.MaxRange = v284.MaxRange * (1 + (u41.RangeMult or 0)) * (u276.RangeMult or 1);
                                            v323.Size = u276.BulletSize;
                                            v323.TracerName = v319;

                                            function v323.HitFunction(...) -- Line: 1191
                                                -- upvalues: u257 (ref), u306 (copy), u321 (copy), u316 (copy), u276 (ref)
                                                local v438 = { ... };
                                                u257({
                                                    v438[1],
                                                    v438[2],
                                                    v438[3],
                                                    v438[4],
                                                    u306,
                                                    u321,
                                                    u316
                                                }, nil, u276.Impact);
                                            end;

                                            function v323.MissFunction() -- Line: 1195
                                                -- upvalues: u4 (ref), u321 (copy), u306 (copy)
                                                u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\194\163\239\191\189\048\195\161\239\191\189\104\239\191\189\122\239\191\189\075\239\191\189\082\056\098\239\191\189\102\239\191\189", u321, u306);
                                            end;

                                            v322:CreateProjectile(v323);
                                        end;

                                        v278 = v278 - 1;
                                        script:SetAttribute("LocalAmmo", v278);
                                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v303, v277.Name, v302, v315:PointToObjectSpace(v314), v315, v298, v299, v317);
                                        v326 = TableUtil:TableRandom(u287.Pos.X);
                                        v327 = TableUtil:TableRandom(u287.Pos.Y);
                                        v328 = Vector3.new(v326, v327, TableUtil:TableRandom(u287.Pos.Z)) * v295;
                                        v329 = TableUtil:TableRandom(u287.Rot.Y);
                                        v330 = math.rad(v329);
                                        v331 = TableUtil:TableRandom(u287.Rot.X);
                                        v332 = math.rad(v331) * v296;
                                        v333 = TableUtil:TableRandom(u287.Rot.Z);
                                        v334 = math.rad(v333) * v296;
                                        v335 = Vector3.new(v330, v332, v334) * v295;
                                        v336 = u287.StartTime;
                                        u80.Code = math.random(1, 100000000);
                                        u80.X = 0;
                                        u80.Increment = 1.5 / v336;
                                        u80.PrevPos = u80.Pos;
                                        u80.PrevRot = u80.Rot;
                                        u80.NewPos = v328;
                                        u80.NewRot = v335;
                                        u337 = u80.Code;
                                        u78 = 0;
                                        u79 = u79 + 1;
                                        u81 = tick();
                                        v338, v339 = u288.RecoilStart(u79);
                                        v340, v341 = u288.RecoilFinish(u79);
                                        v342 = v338 + TableUtil:TableRandom(u288.Shake.Y);
                                        v343 = v339 + TableUtil:TableRandom(u288.Shake.X);
                                        v344 = -math.rad(v343);
                                        u345 = math.rad(v342);
                                        u346 = v344;
                                        v347 = -math.rad(v341);
                                        u348 = math.rad(v340);
                                        u349 = v347;
                                        u350 = tick();
                                        u351 = 0;
                                        u352 = 0;
                                        u353 = 0;
                                        u354 = u288.Duration - u288.FinishStart;
                                        task.spawn(function() -- Line: 1238
                                            -- upvalues: u41 (ref), PreferredInputController (ref), u351 (ref), u288 (copy), u345 (ref), u346 (ref), CFrame_new_ret6 (ref), u353 (ref), u352 (ref), u354 (copy), u348 (ref), u349 (ref), u350 (copy), u287 (copy), u80 (ref), u337 (copy)
                                            local v439 = true;
                                            local v440 = false;

                                            while v439 or not v440 do
                                                local Attribute = script:GetAttribute("DebugFrameworkSpeed");
                                                local v441 = Run.Heartbeat:Wait() * Attribute;

                                                if v439 then
                                                    local v442 = (script:GetAttribute("Aiming") and 0.7 or 1.2) * (StateController:GetAttribute("IsCrouch") and 0.75 or 1) * (1 + (u41.RecoilMult or 0));
                                                    local v443 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Touch";
                                                    local v444;

                                                    if v443 then
                                                        v444 = 0.55;
                                                    else
                                                        local v445 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
                                                        v444 = v445 and 0.65 or 1;
                                                    end;

                                                    local v446 = v442 * v444;
                                                    local v447 = u351;
                                                    u351 = math.min(u351 + v441, u288.FinishStart);
                                                    local v448 = (u351 - v447) / u288.FinishStart * v446;
                                                    local CFrame_Angles_ret = CFrame.Angles(u345 * v448, u346 * v448, 0);
                                                    CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret;
                                                    Camera.CFrame = Camera.CFrame * CFrame_Angles_ret;
                                                    local v449 = u353;
                                                    u352 = math.min(u352 + v441, u288.Duration);
                                                    u353 = math.clamp(u352 - u288.FinishStart, 0, u354);
                                                    local v450 = (u353 - v449) / u354 * v446;
                                                    local CFrame_Angles_ret2 = CFrame.Angles(u348 * v450, u349 * v450, 0);
                                                    CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret2;
                                                    Camera.CFrame = Camera.CFrame * CFrame_Angles_ret2;

                                                    if tick() - u350 >= u288.Duration / Attribute then
                                                        v439 = false;
                                                    end;
                                                end;

                                                if tick() - u350 >= u287.StartTime / Attribute and not v440 then
                                                    v440 = true;

                                                    if u80.Code == u337 or not u80.Code then
                                                        local Vector3_new_ret2 = Vector3.new();
                                                        local Vector3_new_ret3 = Vector3.new();
                                                        local EndTime = u287.EndTime;
                                                        u80.Code = math.random(1, 100000000);
                                                        u80.X = 0;
                                                        u80.Increment = 1.5 / EndTime;
                                                        u80.PrevPos = u80.Pos;
                                                        u80.PrevRot = u80.Rot;
                                                        u80.NewPos = Vector3_new_ret2;
                                                        u80.NewRot = Vector3_new_ret3;
                                                    end;
                                                end;
                                            end;
                                        end);
                                        task.defer(u226, v282, v292 and 0.4 or 1);

                                        if v280.BurstRPM > 0 then
                                            task.wait(v291);

                                            if v278 <= 0 or (u139("Equip") or (InventoryController:GetAttribute("Open") or (CameraController:GetAttribute("ViewmodelCFrame") or tick() - u64 < 0.1))) then
                                                script:SetAttribute("Using", false);

                                                if not u275 then
                                                    return;
                                                end;

                                                break;
                                            else
                                                v355 = InventoryController.Fetch:Invoke();

                                                if v355 then
                                                    v356 = v355.Toolbar;

                                                    if v356 then
                                                        v357 = v356[script:GetAttribute("Equipped")];

                                                        if v357 == nil then
                                                            v357 = false;
                                                        elseif v357 == 0 then
                                                            v357 = false;
                                                        end;
                                                    else
                                                        v357 = nil;
                                                    end;
                                                else
                                                    v357 = nil;
                                                end;

                                                if v357 and (u275.Durability ~= nil and u275.Durability > 0) then
                                                    continue;
                                                else
                                                    break;
                                                end;
                                            end;
                                        end;
                                    end;

                                    if v281 then
                                        u155("AimStart");
                                        u155("AimHold");
                                        u46 = "None";
                                        u49 = false;

                                        for _, child in pairs(u13:GetChildren()) do
                                            if child:IsA("BasePart") and child.Name:find("Arrow") then
                                                child.Transparency = 1;
                                            end;
                                        end;
                                    end;

                                    task.wait(v290);
                                    v358 = v280.BoltAnimSpeed or 1;

                                    if not u23.Local.Bolt then
                                       
                                    end;

                                    v359 = u10;
                                    v360 = u149("Bolt", v358);

                                    if v360 then
                                        script:SetAttribute("CanUse", true);
                                        task.wait(v360.Length);
                                        script:SetAttribute("CanUse", nil);

                                        if v359 and v359.Parent then
                                            u155("Bolt");
                                         
                                        end;
                                    end;
                                else
                                    u155("Inspect", 0);
                                    u155("Hit", 0.1);
                                    u155("Miss", 0.1);
                                    u73 = tick();
                                    v366, v367 = pcall(function() -- Line: 1322
                                        return workspace:GetServerTimeNow();
                                    end);

                                    if v366 then
                                        if v363 then
                                            v368 = v363.Logic;
                                        else
                                            v368 = v363;
                                        end;

                                        if v363 and (v368 ~= "Normal" or u45 == "Holding") then
                                            u155("ThrowHold");
                                            u155("Aim");
                                            v369 = u10;

                                            if u23.Local.Light then
                                                v370 = u149("Light");

                                                if not v370 then
                                                    script:SetAttribute("Using", false);

                                                    return;
                                                end;

                                                u371 = u16:FindFirstChild("Effect");

                                                if u371 then
                                                    task.delay(0.5, function() -- Line: 1340
                                                        -- upvalues: u371 (copy), u16 (ref)
                                                        if not (u371 and u371.Parent) then
                                                            return;
                                                        end;

                                                        for _, child in pairs(u371:GetChildren()) do
                                                            child.Enabled = true;
                                                        end;

                                                        u16.Fuse:Play();
                                                    end);
                                                end;

                                                task.wait(v370.Length);

                                                if not (v369 and v369.Parent) then
                                                    script:SetAttribute("Using", false);

                                                    return;
                                                end;

                                                u155("Light");
                                            end;

                                            v372 = (v368 == "Grenade" or v368 == "PlaceableGrenade") and ({ "ThrowStart", u271 and "UnderHandThrow" or "OverHandThrow" } or { "Throw" }) or { "Throw" };
                                            v373 = nil;
                                            v374 = nil;

                                            for i, v in pairs(v372) do
                                                v375 = v363.AnimSpeed or 1;
                                                v373 = u149(v, v375);

                                                if not v373 then
                                                    return;
                                                end;

                                                if i == #v372 then
                                                    if v368 ~= "Normal" then
                                                        v374 = tick();
                                                        task.wait(0.3);

                                                        if not (v369 and v369.Parent) then
                                                            break;
                                                        end;

                                                        for _, child in pairs(u13:GetChildren()) do
                                                            child.Transparency = 1;
                                                            v376 = child:FindFirstChild("Effect");

                                                            if v376 then
                                                                v376:ClearAllChildren();
                                                                v377 = child:FindFirstChild("Fuse");

                                                                if v377 then
                                                                    v377:Stop();
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                else
                                                    task.wait(v373.Length / v375);
                                                    u155(v);
                                                end;
                                            end;

                                            v378 = { v367, Name, (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame) * CFrame.new(0.5, 0, 0) * CFrame.Angles(v363.Offset or 0, 0, 0) };

                                            if v368 == "PlaceableGrenade" and u271 then
                                                v379, v380 = RaycastUtil:MouseRaycast(u5, {
                                                    VFX_PARTS,
                                                    script_Parent,
                                                    Drops,
                                                    Plants
                                                }, 4);

                                                if v380 then
                                                    v378[4] = v380.CFrame:PointToObjectSpace(v379);
                                                    v378[5] = v380;
                                                else
                                                    v378[4] = 0;
                                                end;
                                            elseif v368 == "Grenade" and u271 then
                                                v378[4] = 0;
                                            end;

                                            u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", unpack(v378));
                                            task.spawn(u226, {
                                                Strength = Vector3.new(4, 4, 4),
                                                Speed = 0.25,
                                                SnapBack = true,
                                                Angles = { -179, 180 }
                                            });

                                            if v368 == "Normal" then
                                                v374 = tick();

                                                while tick() - v374 < v373.Length and (v373.IsPlaying and u10 == v369) do
                                                    task.wait();
                                                end;
                                            end;

                                            u45 = "None";

                                            if v368 == "Normal" then
                                                script:SetAttribute("Using", false);
                                                u30 = false;

                                                return;
                                            end;

                                            u266(math.max(v373.Length, 0.46), u275, 3, v374);
                                        end;

                                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v367, v277.Name);
                                        task.spawn(u226, v282);
                                        v381 = v280.Cooldown;

                                        if v280.KeycardColor then
                                            u155("Use");
                                            u149("Use", 1);
                                            task.wait(v381);
                                        elseif Name == "Lighter" then
                                            v382 = u10;
                                            u155("Use");
                                            u149("Use", 1);
                                            task.wait(0.5);

                                            if not (v382 and v382.Parent) then
                                                script:SetAttribute("Using", false);

                                                return;
                                            end;

                                            for _, child in u13.LightPart:GetChildren() do
                                                child.Enabled = not child.Enabled;
                                            end;

                                            task.wait((math.max(v381 - 0.5, 0)));
                                        else
                                            if v280.HealthItem then
                                                v383 = v280.AnimationTimeScale;
                                                u155("Use");
                                                u149("Use", v383);
                                                u266(v381, u275, 1);
                                            end;

                                            v384 = v280.SwingAnimSpeed or 1;
                                            u155("Swing", 0);
                                            u149("Swing", v384);
                                            v385 = u23.Local.WindupLoop ~= nil;
                                            v386 = u149(v385 and "WindupLoop" or "Windup", v384, v385 and 0.15 or 0);

                                            if v386 then
                                                v387 = v385 and v381 and v381 or v386.Length / v384;
                                                v388 = tick();
                                                v389 = Melee.MeleeChecks;
                                                v390 = u10;
                                                v391 = 0;
                                                v392 = 0;
                                                v393 = (1 / 0);
                                                u394 = nil;
                                                v395 = nil;
                                                u396 = 0;
                                                u397 = nil;
                                                u398 = nil;
                                                u399 = nil;
                                                u400 = nil;
                                                v401 = nil;

                                                while Run.Heartbeat:Wait() do
                                                    if u10 ~= v390 then
                                                        script:SetAttribute("Using", false);
                                                        break;
                                                    end;

                                                    v402 = (tick() - v388) / v387;
                                                    v403 = math.clamp(v402, 0, 1);
                                                    v404 = 0;

                                                    for i, v in pairs(v389) do
                                                        v404 = v[1] <= v403 and i or v404;
                                                    end;

                                                    if v391 ~= v404 then
                                                        v405 = CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame;

                                                        for _, v in pairs(v389[v404][2]) do
                                                            v406 = (v405 * v.Offset).Position;
                                                            v407 = v405.LookVector * v.Range;
                                                            v408, v409, v410, v411, v412 = RaycastUtil:Raycast(v406, v407, "Blacklist", {
                                                                script_Parent,
                                                                VFX_PARTS,
                                                                Drops,
                                                                Plants
                                                            }, script:GetAttribute("DebugShowRays"), u7, true);

                                                            if v412 then
                                                                Debris:AddItem(v412, 3);
                                                            end;

                                                            if v408 and v408.Parent then
                                                                v413 = v408.Name;
                                                                v414 = v408.Parent;

                                                                if v414:FindFirstChild("Humanoid") or v414.Parent:FindFirstChild("Humanoid") then
                                                                    v415 = v413 == "Head" and 7 or (v413:find("Torso") and 6 or (v413:find("Arm") and 5 or 4));
                                                                else
                                                                    v415 = (v414.Name == "NodeSpark" or v414.Name == "TreeX") and 3 or (v408:IsA("Terrain") and 1 or 2);
                                                                end;

                                                                v416 = (v409 - v406).Magnitude;
                                                            else
                                                                v415 = 0;
                                                                v416 = (1 / 0);
                                                            end;

                                                            if v392 < v415 or v415 == v392 and v416 < v393 then
                                                                u397 = v408.CFrame:PointToObjectSpace(v409);
                                                                v401 = v405;
                                                                u400 = v408;
                                                                u399 = v410;
                                                                u398 = v409;
                                                                u396 = v404;
                                                                v395 = v407;
                                                                u394 = v411;
                                                                v393 = v416;
                                                                v392 = v415;
                                                            end;
                                                        end;
                                                    end;

                                                    if v403 >= 1 then
                                                        break;
                                                    end;

                                                    v391 = v404;
                                                end;

                                                if script:GetAttribute("Using") then
                                                    if not v385 then
                                                        u155("Windup", 0);
                                                    end;

                                                    v417 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Swing");

                                                    if v417 then
                                                        if v385 then
                                                            v417:Play();
                                                        else
                                                            SoundModule:PlayDuplicateSound(v417, nil, nil, true, u275.Skin);
                                                        end;
                                                    end;

                                                    v418 = math.round(v367 * 10000);
                                                    u419 = Random.new(v418):NextInteger(1, 1000000000);
                                                    u420 = Random.new(v418):NextInteger(1, 10000000000);
                                                    u421 = v401 or (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame);

                                                    if v395 then
                                                        u422, u423, u424, u425 = RaycastUtil:Raycast(u421.Position, v395 * 1.5, "Blacklist", {
                                                            script_Parent,
                                                            VFX_PARTS,
                                                            Drops,
                                                            Plants
                                                        }, script:GetAttribute("DebugShowRays"), u8, true);
                                                    else
                                                        u424 = nil;
                                                        u425 = nil;
                                                        u422 = nil;
                                                        u423 = nil;
                                                    end;

                                                    if u400 and u400.Parent then
                                                        v426 = u103;
                                                        v427 = math.random(-15, 15) / 100;
                                                        v428 = math.random(-15, 15) / 100;
                                                        v426.Target = Vector3.new(v427, v428, 0.5) * (Melee.BounceMult or 1);
                                                    end;

                                                    task.spawn(function() -- Line: 1537
                                                        -- upvalues: u257 (ref), u400 (ref), u397 (ref), u398 (ref), u399 (ref), u394 (ref), u419 (copy), u420 (copy), u421 (ref), u396 (ref), u422 (ref), u423 (ref), u424 (ref), u425 (ref), u275 (copy)
                                                        local v451 = {};
                                                        local v452;

                                                        if u397 and (u400 and u400.Parent) then
                                                            v452 = u400.CFrame * u397;
                                                        else
                                                            v452 = u398;
                                                        end;

                                                        v451[1], v451[2], v451[3], v451[4], v451[5], v451[6], v451[7], v451[8], v451[9] = u400, v452, u399, u394, u419, u420, nil, u421, u396;
                                                        u257(v451, {
                                                            u422,
                                                            u423,
                                                            u424,
                                                            u425
                                                        }, true, u275.ID == 31);
                                                    end);
                                                    v429 = u400 and "Hit" or "Miss";
                                                    u149(v429, v384, v429 == "Hit" and 0.1 or 0.4, 10);

                                                    if not v385 then
                                                        task.wait(v381 - v387);
                                                    end;
                                                end;
                                            else
                                                Run.Heartbeat:Wait();
                                            end;
                                        end;

                                      
                                    end;

                                    warn("MELEE SYNCHRONIZATION INTERNAL ERROR: ", v367);
                                end;

                                break;
                            else
                                break;
                            end;
                        end;
                    end;
                else
                    Run.Heartbeat:Wait();
                    v272 = false;
                end;
            end;

            v283 = v279.Spread;
            v284 = v279.Bullet;
            v285 = v279.Casing;
            v286 = v279.Recoil;
            u287 = v286.VM;
            u288 = v286.Camera;
            v289 = 1 - (u41.FireRateMult or 0);
            v290 = 60 / v280.RPM * v289;
            v291 = 60 / v280.BurstRPM * v289;

            for i = 1, v280.Burst do
                u155("Inspect", 0);
                u155("Shoot", 0);
                u149("Shoot", 1, 0);

                if v285 and not v285.IgnoreShoot then
                    u118(v285);
                end;

                v292 = script:GetAttribute("Aiming");
                v293 = u44 or u20;

                if not (u41.Scope and v292) then
                    VFXModule:FlashPart(v293);
                end;

                v294 = script_Parent.PrimaryPart:FindFirstChild(v277.Name .. "Shoot");

                if v294 then
                    SoundModule:PlayDuplicateSound(v294, nil, nil, true, u275.Skin);
                end;

                u73 = tick();
                v295 = u275.Skin == "Hot Rod" and 0.75 or 1;
                v296 = 1 + (v292 and u41.GunRecoilAimMult or 0);
                v297 = v283[v292 and "Aiming" or "Hip"].ShootingExtra * (1 + (u41[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 0)) * (u75 < 0.001 and 0 or u75) * (u276[(v292 and "Aim" or "Hip") .. "SpreadMult"] or 1);
                u75 = math.min(u75 + 1 / v283.Shooting.BulletsForMax, 1);
                v298 = u74 < 0.001 and 0 or math.floor(u74 * 100) / 100;
                v299 = v297 < 0.001 and 0 or math.floor(v297 * 100) / 100;
                v300 = v298 + v299;
                v301 = CFrame.Angles(v284.Offset or 0, 0, 0);
                v302 = Camera.CFrame;
                v303 = workspace:GetServerTimeNow();
                v304 = math.round(v303 * 10000);
                v305 = Random.new(v304);
                u306 = v305.NextInteger(v305, 1, 1000000000);
                v307 = Random.new(v304);
                v308 = i;
                v309 = {};

                for i2 = 1, u276.Bullets or 1 do
                    v310 = {
                        Radius = v307:NextNumber(0, math.floor(v300 * 100) / 100) / 500,
                        Degree = v307:NextNumber(0, 6.283185307179586)
                    };
                    v311 = math.floor(v300 * 100) / 100;
                    v312 = math.max(1, v311) * 1000000000;
                    v310.ID = v307:NextInteger(1, (math.ceil(v312)));
                    table.insert(v309, v310);
                    v313 = i2;
                end;

                v314 = v293.Position;
                v315 = script_Parent.PrimaryPart.CFrame * CFrame.new(0, 1.5, 0);
                u316 = {};
                v317, v318 = RaycastUtil:MouseRaycast(u6, VFXModule.WithSeatedVehicles({ script_Parent, VFX_PARTS }));

                if u41.HideTracer then
                    v319 = "";
                elseif table.find(VFXModule.TracerSkins, u275.Skin) then
                    v319 = u275.Skin .. "Bullet";
                else
                    v319 = u276.TracerName;
                end;

                for _, v in pairs(v309) do
                    v320 = v301 * CFrame.Angles(math.sin(v.Degree) * v.Radius, math.cos(v.Degree) * v.Radius, 0);
                    u321 = v.ID;
                    v322 = VFXModule;
                    v323 = {
                        FilterType = "Blacklist",
                        Position = v314,
                        Direction = (CFrame.new(v314, v317) * v320).LookVector,
                        PositionFirst = v315.p
                    };
                    v324 = RaycastParams.new();
                    v324.FilterType = Enum.RaycastFilterType.Include;
                    v324.FilterDescendantsInstances = { workspace.Terrain };
                    v324.IgnoreWater = true;

                    if workspace:Raycast(v315.p, v314 - v315.p, v324) then
                        v325 = (v314 - v315.p).Unit;
                    else
                        v325 = (v302 * v320).LookVector;
                    end;

                    v323.DirectionFirst = v325;
                    v323.Filters = {
                        script_Parent,
                        VFX_PARTS,
                        Drops,
                        Plants
                    };
                    v323.FilterFunction = u276.FilterType or "Hit";
                    v323.VisualizeRay = script:GetAttribute("DebugShowRays");
                    v323.Speed = v284.Speed * (1 + (u41.SpeedMult or 0)) * (u276.SpeedMult or 1);
                    v323.Gravity = v284.Gravity * (u276.GravityMult or 1);
                    v323.MaxRange = v284.MaxRange * (1 + (u41.RangeMult or 0)) * (u276.RangeMult or 1);
                    v323.Size = u276.BulletSize;
                    v323.TracerName = v319;

                    function v323.HitFunction(...) -- Line: 1191
                        -- upvalues: u257 (ref), u306 (copy), u321 (copy), u316 (copy), u276 (ref)
                        local v438 = { ... };
                        u257({
                            v438[1],
                            v438[2],
                            v438[3],
                            v438[4],
                            u306,
                            u321,
                            u316
                        }, nil, u276.Impact);
                    end;

                    function v323.MissFunction() -- Line: 1195
                        -- upvalues: u4 (ref), u321 (copy), u306 (copy)
                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\194\163\239\191\189\048\195\161\239\191\189\104\239\191\189\122\239\191\189\075\239\191\189\082\056\098\239\191\189\102\239\191\189", u321, u306);
                    end;

                    v322:CreateProjectile(v323);
                end;

                v278 = v278 - 1;
                script:SetAttribute("LocalAmmo", v278);
                u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\077\038\116\239\191\189\239\191\189\239\191\189\073\100\239\191\189\195\168\239\191\189\239\191\189\066\239\191\189\239\191\189\239\191\189\239\191\189\195\188\239\191\189\239\191\189", v303, v277.Name, v302, v315:PointToObjectSpace(v314), v315, v298, v299, v317);
                v326 = TableUtil:TableRandom(u287.Pos.X);
                v327 = TableUtil:TableRandom(u287.Pos.Y);
                v328 = Vector3.new(v326, v327, TableUtil:TableRandom(u287.Pos.Z)) * v295;
                v329 = TableUtil:TableRandom(u287.Rot.Y);
                v330 = math.rad(v329);
                v331 = TableUtil:TableRandom(u287.Rot.X);
                v332 = math.rad(v331) * v296;
                v333 = TableUtil:TableRandom(u287.Rot.Z);
                v334 = math.rad(v333) * v296;
                v335 = Vector3.new(v330, v332, v334) * v295;
                v336 = u287.StartTime;
                u80.Code = math.random(1, 100000000);
                u80.X = 0;
                u80.Increment = 1.5 / v336;
                u80.PrevPos = u80.Pos;
                u80.PrevRot = u80.Rot;
                u80.NewPos = v328;
                u80.NewRot = v335;
                u337 = u80.Code;
                u78 = 0;
                u79 = u79 + 1;
                u81 = tick();
                v338, v339 = u288.RecoilStart(u79);
                v340, v341 = u288.RecoilFinish(u79);
                v342 = v338 + TableUtil:TableRandom(u288.Shake.Y);
                v343 = v339 + TableUtil:TableRandom(u288.Shake.X);
                v344 = -math.rad(v343);
                u345 = math.rad(v342);
                u346 = v344;
                v347 = -math.rad(v341);
                u348 = math.rad(v340);
                u349 = v347;
                u350 = tick();
                u351 = 0;
                u352 = 0;
                u353 = 0;
                u354 = u288.Duration - u288.FinishStart;
                task.spawn(function() -- Line: 1238
                    -- upvalues: u41 (ref), PreferredInputController (ref), u351 (ref), u288 (copy), u345 (ref), u346 (ref), CFrame_new_ret6 (ref), u353 (ref), u352 (ref), u354 (copy), u348 (ref), u349 (ref), u350 (copy), u287 (copy), u80 (ref), u337 (copy)
                    local v439 = true;
                    local v440 = false;

                    while v439 or not v440 do
                        local Attribute = script:GetAttribute("DebugFrameworkSpeed");
                        local v441 = Run.Heartbeat:Wait() * Attribute;

                        if v439 then
                            local v442 = (script:GetAttribute("Aiming") and 0.7 or 1.2) * (StateController:GetAttribute("IsCrouch") and 0.75 or 1) * (1 + (u41.RecoilMult or 0));
                            local v443 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Touch";
                            local v444;

                            if v443 then
                                v444 = 0.55;
                            else
                                local v445 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
                                v444 = v445 and 0.65 or 1;
                            end;

                            local v446 = v442 * v444;
                            local v447 = u351;
                            u351 = math.min(u351 + v441, u288.FinishStart);
                            local v448 = (u351 - v447) / u288.FinishStart * v446;
                            local CFrame_Angles_ret = CFrame.Angles(u345 * v448, u346 * v448, 0);
                            CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret;
                            Camera.CFrame = Camera.CFrame * CFrame_Angles_ret;
                            local v449 = u353;
                            u352 = math.min(u352 + v441, u288.Duration);
                            u353 = math.clamp(u352 - u288.FinishStart, 0, u354);
                            local v450 = (u353 - v449) / u354 * v446;
                            local CFrame_Angles_ret2 = CFrame.Angles(u348 * v450, u349 * v450, 0);
                            CFrame_new_ret6 = CFrame_new_ret6 * CFrame_Angles_ret2;
                            Camera.CFrame = Camera.CFrame * CFrame_Angles_ret2;

                            if tick() - u350 >= u288.Duration / Attribute then
                                v439 = false;
                            end;
                        end;

                        if tick() - u350 >= u287.StartTime / Attribute and not v440 then
                            v440 = true;

                            if u80.Code == u337 or not u80.Code then
                                local Vector3_new_ret2 = Vector3.new();
                                local Vector3_new_ret3 = Vector3.new();
                                local EndTime = u287.EndTime;
                                u80.Code = math.random(1, 100000000);
                                u80.X = 0;
                                u80.Increment = 1.5 / EndTime;
                                u80.PrevPos = u80.Pos;
                                u80.PrevRot = u80.Rot;
                                u80.NewPos = Vector3_new_ret2;
                                u80.NewRot = Vector3_new_ret3;
                            end;
                        end;
                    end;
                end);
                task.defer(u226, v282, v292 and 0.4 or 1);

                if v280.BurstRPM > 0 then
                    task.wait(v291);

                    if v278 <= 0 or (u139("Equip") or (InventoryController:GetAttribute("Open") or (CameraController:GetAttribute("ViewmodelCFrame") or tick() - u64 < 0.1))) then
                        script:SetAttribute("Using", false);

                        if not u275 then
                            return;
                        end;

                        break;
                    else
                        v355 = InventoryController.Fetch:Invoke();

                        if v355 then
                            v356 = v355.Toolbar;

                            if v356 then
                                v357 = v356[script:GetAttribute("Equipped")];

                                if v357 == nil then
                                    v357 = false;
                                elseif v357 == 0 then
                                    v357 = false;
                                end;
                            else
                                v357 = nil;
                            end;
                        else
                            v357 = nil;
                        end;

                        if v357 and (u275.Durability ~= nil and u275.Durability > 0) then
                            continue;
                        else
                            break;
                        end;
                    end;
                end;
            end;

            if v281 then
                u155("AimStart");
                u155("AimHold");
                u46 = "None";
                u49 = false;

                for _, child in pairs(u13:GetChildren()) do
                    if child:IsA("BasePart") and child.Name:find("Arrow") then
                        child.Transparency = 1;
                    end;
                end;
            end;

            task.wait(v290);
            v358 = v280.BoltAnimSpeed or 1;

            if not u23.Local.Bolt then
      
            end;

            v359 = u10;
            v360 = u149("Bolt", v358);

            if v360 then
                script:SetAttribute("CanUse", true);
                task.wait(v360.Length);
                script:SetAttribute("CanUse", nil);

                if v359 and v359.Parent then
                    u155("Bolt");
                  
                end;
            end;
        end;
    end);
end;

local function u454() -- Line: 1580
    -- upvalues: u30 (ref)
    u30 = false;
end;

u269 = function(p455) -- Line: 1584
    -- upvalues: u31 (ref), u47 (ref), u270 (ref), Items (copy), ToolInfo (copy), u453 (ref), u48 (ref), u139 (copy), u84 (ref), u64 (ref), u149 (copy), u155 (copy), u41 (ref), ItemClass (copy), u34 (ref)
    local v456 = u31;

    if p455 then
        u31 = p455;
    else
        u31 = true;
    end;

    if p455 == nil and v456 == "Auto" then
        return;
    end;

    while u31 ~= false do
        u47 = false;
        local Attribute = script:GetAttribute("Using");

        if u31 == "Auto" and not Attribute then
            u270();
        end;

        local Attribute2 = script:GetAttribute("Aiming");
        local v457 = InventoryController.Fetch:Invoke();
        local v458;

        if v457 then
            local Toolbar2 = v457.Toolbar;

            if Toolbar2 then
                v458 = Toolbar2[script:GetAttribute("Equipped")];

                if v458 == nil then
                    v458 = false;
                elseif v458 == 0 then
                    v458 = false;
                end;
            else
                v458 = nil;
            end;
        else
            v458 = nil;
        end;

        local v459;

        if v458 then
            v459 = Items[v458.ID];
        else
            v459 = v458;
        end;

        local v460;

        if v459 then
            v460 = ToolInfo[v459.Name];
        else
            v460 = v459;
        end;

        if v460 then
            v460 = v460.Weapon;
        end;

        local v461;

        if v460 then
            v461 = v460.ThrowInfo;
        else
            v461 = v460;
        end;

        if v461 and (v461.Logic == "Grenade" or v461.Logic == "PlaceableGrenade") then
            return u453(true);
        end;

        local v462 = true;

        if v459 and (v459.Type ~= "Bench" and (v459.Name ~= "Blueprint" and not (u48 or (u139("Equip") or (u84 or (u139("Bolt") or (u139("Throw") or (InventoryController:GetAttribute("Open") or (CameraController:GetAttribute("FreeLooking") or (tick() - u64 < 0.1 or not v458)))))))))) then
            if v459.Type == "Tool" and (v460.AimDownSpeed == nil or Attribute) then
                v462 = false;
            end;
        else
            v462 = false;
        end;

        if v462 then
            if not Attribute2 then
                script:SetAttribute("Aiming", true);
                u149("Aim");
                u155("Inspect");

                if type(v458) == "table" then
                    u41 = ItemClass.AttachmentStats(v458, script:GetAttribute("Aiming"));
                end;
            end;

            u47 = u34 >= 1;
        elseif Attribute2 then
            script:SetAttribute("Aiming", false);
            u155("Aim");

            if type(v458) == "table" then
                u41 = ItemClass.AttachmentStats(v458, script:GetAttribute("Aiming"));
            end;
        end;

        Run.Heartbeat:Wait();
    end;

    script:SetAttribute("Aiming", false);
    u155("Aim");
end;

u270 = function() -- Line: 1632
    -- upvalues: u31 (ref)
    u31 = false;
end;

local function u500(p463) -- Line: 1636
    -- upvalues: u83 (ref), u23 (copy), u139 (copy), u84 (ref), Items (copy), u41 (ref), NumberUtil (copy), ToolInfo (copy), u4 (copy), u13 (ref), WeldModule (copy), u10 (ref), u49 (ref), u155 (copy), u85 (ref), u149 (copy)
    u83 = true;
    local v464 = 0;
    local v465 = true;
    local v466 = {};
    local v467 = nil;
    local v468 = nil;
    local v469 = false;
    local v470 = nil;

    while true do
        if v464 >= 0.5 or p463 and not v465 then
            if v464 <= 0 or not (v466 and (v464 >= 0.5 or not (v467 and (v468 and v468 <= v467.Amount)))) then
                return false;
            end;

            local v471 = nil;

            if v464 >= 0.5 then
                local v472 = {};

                for _, v in pairs(v466) do
                    local v473 = Items[v.ID];
                    local v474 = {
                        Selectable = true,
                        Image = v473.AmmoWheelImage,
                        Name = v473.Name,
                        Description = v473.Description,
                        Cost = NumberUtil:FormatNumber(v.Amount) .. " Left",
                        SelectFirst = v.IsEquipped
                    };
                    table.insert(v472, v474);
                end;

                local v475 = WheelController.Open:Invoke(v472, "Reload", true);

                if not v475 then
                    return;
                end;

                local v476 = v466[v475];

                if not v476 or v467 and (v467.ID == v476.ID and (v468 and v468 <= v467.Amount)) then
                    return;
                end;

                v471 = v476.ID;
            elseif v469 and not p463 then
                return;
            end;

            if v470 ~= script:GetAttribute("Equipped") then
                return;
            end;

            local v477 = InventoryController.Fetch:Invoke();
            local u478;

            if v477 then
                local Toolbar2 = v477.Toolbar;

                if Toolbar2 then
                    u478 = Toolbar2[script:GetAttribute("Equipped")];

                    if u478 == nil then
                        u478 = false;
                    elseif u478 == 0 then
                        u478 = false;
                    end;
                else
                    u478 = nil;
                end;
            else
                u478 = nil;
            end;

            local Weapon = ToolInfo[Items[u478.ID].Name].Weapon;
            u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\194\184\080\239\191\189\195\137\239\191\189\239\191\189\108\239\191\189\239\191\189\239\191\189\239\191\189\195\181\060\195\173\195\156\195\174\239\191\189\239\191\189\239\191\189", workspace:GetServerTimeNow(), v471 or "None");

            if not v471 then
                for _, v in pairs(v466) do
                    if v.IsEquipped then
                        v471 = v.ID;
                        break;
                    end;
                end;
            end;

            local u479 = v471 or v466[1].ID;

            if p463 then
                return true, u479;
            end;

            local Attribute = script:GetAttribute("Aiming");
            task.delay(v469 and Attribute and 1 or 0.1, function() -- Line: 1749
                -- upvalues: u13 (ref), WeldModule (ref), u478 (copy), u479 (copy), u10 (ref)
                if not (u13 and u13.Parent) then
                    return;
                end;

                WeldModule:WeldAttachments(u13, u478, nil, nil, u479, u10:GetScale());
            end);

            if v469 then
                if Attribute then
                    u49 = true;
                end;

                return;
            end;

            u155("Inspect");
            u84 = true;
            local BoltFed = Weapon.BoltFed;
            local ReloadAnimSpeed = Weapon.ReloadAnimSpeed;

            if type(ReloadAnimSpeed) == "table" then
                ReloadAnimSpeed = ReloadAnimSpeed[u478.Skin or "Default"] or (ReloadAnimSpeed.Default or ReloadAnimSpeed);
            end;

            local u480 = u10;
            local u481 = u85;
            task.delay(0.1, function() -- Line: 1768
                -- upvalues: u480 (copy), u155 (ref)
                if not (u480 and u480.Parent) then
                    return;
                end;

                u155("Unloaded", 0);
                u155("Loaded", 0);
            end);

            if BoltFed then
                local v482 = ReloadAnimSpeed or {};
                local v483 = u149("Reload1", v482[1]);

                if not v483 then
                    return;
                end;

                task.wait(v483.Length / v482[1]);

                if not (u480 and u480.Parent) then
                    return;
                end;

                local u484 = nil;
                u484 = InputService.InputBegan:Connect(function(p485, p486) -- Line: 1780
                    -- upvalues: u481 (ref), u85 (ref), u4 (ref), u484 (ref)
                    local UserInputType = p485.UserInputType;

                    if InputService:GetFocusedTextBox() or (p486 or UserInputType ~= Enum.UserInputType.MouseButton1) then
                        return;
                    end;

                    if u481 == u85 then
                        u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\194\184\080\239\191\189\195\137\239\191\189\239\191\189\108\239\191\189\239\191\189\239\191\189\239\191\189\195\181\060\195\173\195\156\195\174\239\191\189\239\191\189\239\191\189", workspace:GetServerTimeNow(), "Cancel");
                    end;

                    u481 = nil;
                    u484:Disconnect();
                end);

                while u481 == u85 do
                    u155("Reload2", 0);
                    local v487 = u149("Reload2", v482[2], 0);

                    if not v487 then
                        return;
                    end;

                    task.wait(v487.Length / v482[2]);

                    if not (u480 and u480.Parent) then
                        return;
                    end;
                end;

                local v488 = u149("Reload3", v482[3]);

                if not v488 then
                    return;
                end;

                task.wait(Weapon.ReloadAnimTime or v488.Length / v482[3]);
            else
                local v489 = u149("Reload", ReloadAnimSpeed);

                if not v489 then
                    return;
                end;

                local os_clock_ret = os.clock();
                local v490 = Weapon.ReloadAnimTime or v489.Length / ReloadAnimSpeed;

                while os.clock() - os_clock_ret < v490 do
                    if not u84 then
                        u155("Reload");

                        return;
                    end;

                    task.wait();
                end;
            end;

            u84 = false;

            return;
        end;

        v465 = false;
        local v491 = p463 and 0.1 or Run.Heartbeat:Wait();
        local v492 = InventoryController.Fetch:Invoke();
        local v493;

        if v492 then
            local Toolbar2 = v492.Toolbar;

            if Toolbar2 then
                v493 = Toolbar2[script:GetAttribute("Equipped")];

                if v493 == nil or v493 == 0 then
                    v493 = false;
                end;
            else
                v493 = nil;
            end;
        else
            v493 = nil;
        end;

        v470 = script:GetAttribute("Equipped");
        v469 = (u23.Local.Reload or u23.Local.Reload1) == nil;

        if u139("Equip") or (u84 or (u139("Reload") or (u139("Bolt") or (InventoryController:GetAttribute("Open") or (script:GetAttribute("Using") or not v493))))) then
            break;
        end;

        if not u83 then
            break;
        end;

        local v494 = Items[v493.ID];
        local AmmoType = v494.AmmoType;
        v467 = v493.Ammo;

        if v494 == nil or v494.BaseMaxAmmo == nil then
            v468 = false;
        else
            v468 = math.round(v494.BaseMaxAmmo * (1 + (u41 and u41.MaxAmmoMult or 0)));
        end;

        if AmmoType then
            local v495 = InventoryController.Fetch:Invoke();
            v466 = {};

            for _, v in pairs({ "Inventory", "Toolbar" }) do
                for _, v2 in pairs(v495[v]) do
                    if v2 ~= 0 and v2.Amount > 0 then
                        local ID = v2.ID;
                        local Amount = v2.Amount;
                        local v496 = Items[ID];
                        local AmmoType2 = v496.AmmoType;

                        if v496.Type:find("Ammo") and AmmoType == AmmoType2 then
                            local v497 = false;

                            for _, v3 in pairs(v466) do
                                if v3.ID == ID then
                                    v3.Amount = v3.Amount + Amount;
                                    v497 = true;
                                    break;
                                end;
                            end;

                            if not v497 then
                                local v498 = {
                                    ID = ID,
                                    Amount = Amount
                                };
                                local v499;

                                if v467 == nil then
                                    v499 = false;
                                else
                                    v499 = v467.ID == ID;
                                end;

                                v498.IsEquipped = v499;
                                table.insert(v466, v498);
                            end;
                        end;
                    end;
                end;
            end;

            if #v466 > 0 then
                v464 = v464 + v491;

                if p463 then
                    break;
                end;
            end;
        end;
    end;

    v464 = 0;

    if not u83 then
        --break;
    end;

    if p463 then
        --break;
    end;
end;

local function _() -- Line: 1830
    -- upvalues: u83 (ref)
    u83 = false;
    WheelController.Close:Invoke("Reload");
end;

local function u501() -- Line: 1835
    -- upvalues: u9 (ref), u139 (copy), u84 (ref), u155 (copy), u149 (copy)
    if u9 == nil or (u139("Equip") or (u84 or (script:GetAttribute("Using") or script:GetAttribute("Aiming")))) then
        return;
    end;

    u155("Inspect");
    u149("Inspect");
end;

local function u506() -- Line: 1841
    -- upvalues: u10 (ref), u88 (ref), Items (copy), u4 (copy), u170 (copy)
    local v502 = InventoryController.Fetch:Invoke();
    local v503;

    if v502 then
        local Toolbar2 = v502.Toolbar;

        if Toolbar2 then
            v503 = Toolbar2[script:GetAttribute("Equipped")];

            if v503 == nil then
                v503 = false;
            elseif v503 == 0 then
                v503 = false;
            end;
        else
            v503 = nil;
        end;
    else
        v503 = nil;
    end;

    if not (v503 and u10) then
        return;
    end;

    local Attachments = v503.Attachments;

    if not Attachments then
        return;
    end;

    local v504 = tick();

    if v504 - u88 < 0.15 then
        return;
    end;

    u88 = v504;
    local v505 = nil;

    for _, v in pairs(Attachments) do
        local AttachmentStats = Items[v.ID].AttachmentStats;

        if AttachmentStats and AttachmentStats.Toggle then
            v.On = not v.On;
            v505 = v.ID;
        end;
    end;

    if not v505 then
        return;
    end;

    script.AttachmentToggle.PlaybackSpeed = math.random(95, 105) / 100;
    Sound:PlayLocalSound(script.AttachmentToggle);
    u4("Fire", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\194\167\239\191\189\110\239\191\189\239\191\189\078\087\123\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\177\077\239\191\189\239\191\189", v505);
    u170(v503);
end;

local function u508() -- Line: 1869
    -- upvalues: Codelock (copy), PreferredInputController (copy), Humanoid (copy), u68 (ref), u67 (ref)
    if WheelController:GetAttribute("Open") or (InteractController:GetAttribute("Dialog") or Codelock.Visible) then
        local v507 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v507 then
            return;
        end;
    end;

    if not Humanoid.Parent then
        return;
    end;

    if Humanoid.SeatPart then
        Humanoid.Sit = false;
    end;

    if tick() - u68 < 0.25 or u67 then
        return;
    end;

    Humanoid.Jump = true;
end;

local function u512(u509) -- Line: 1878
    if u509.Name == "Reticle" then
        task.spawn(function() -- Line: 1880
            -- upvalues: u509 (copy)
            if not (u509 and u509.Parent) then
                return;
            end;

            local ReticleFront = u509:WaitForChild("ReticleFront", 5);

            if not ReticleFront then
                return;
            end;

            ReticleFront.Enabled = false;
        end);
        local ReticleBack = u509:WaitForChild("ReticleBack", 5);

        if not ReticleBack then
            return;
        end;

        ReticleBack.Enabled = false;
    end;

    for i = 1, 2 do
        local v510;

        if u509.Name == (i == 1 and "Base" or "Laser") then
            v510 = i;

            for i2 = 1, 2 do
                local u511 = u509:WaitForChild(v510 == 1 and (i2 == 1 and "Light" or "Extender") or "Laser", 5);

                if not u511 then
                    break;
                end;

                if i2 == 2 then
                    u511 = u511:FindFirstChild("Light");

                    if not u511 then
                        break;
                    end;
                end;

                u511.Enabled = false;
                u511:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 1901
                    -- upvalues: u511 (ref)
                    u511.Enabled = false;
                end);

                if v510 == 2 then
                    break;
                end;

                local _ = i2;
            end;
        else
            v510 = i;
        end;
    end;
end;

local function u514(p513) -- Line: 1910
    -- upvalues: u512 (copy)
    if not (p513 and p513.Parent) then
        return;
    end;

    p513.ChildAdded:Connect(u512);

    for _, child in pairs(p513:GetChildren()) do
        u512(child);
    end;
end;

local function u518(p515) -- Line: 1919
    if p515.Name == "Bolt" then
        for _, child in pairs(p515:GetChildren()) do
            if child:IsA("Beam") then
                child.Enabled = false;
            end;
        end;

        p515.ChildAdded:Connect(function(p516) -- Line: 1925
            if not p516:IsA("Beam") then
                return;
            end;

            p516.Enabled = false;
        end);

        return;
    end;

    if p515:IsA("Beam") then
        p515.Enabled = false;

        return;
    end;

    if p515.Name == "LightPart" then
        for _, child in pairs(p515:GetChildren()) do
            child.Enabled = false;
            child:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 1934
                -- upvalues: child (copy)
                child.Enabled = false;
            end);
        end;

        p515.ChildAdded:Connect(function(u517) -- Line: 1938
            u517.Enabled = false;
            u517:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 1940
                -- upvalues: u517 (copy)
                u517.Enabled = false;
            end);
        end);
    end;
end;

local function u521(u519) -- Line: 1947
    -- upvalues: u518 (copy), u514 (copy)
    if not (u519 and (u519.Parent and u519:IsA("Model"))) then
        return;
    end;

    if u519.Name == "HolsterModel" or (u519.Name == "Crossbow" or (u519.Name == "Wooden Bow" or u519.Name == "Lighter")) then
        u519.ChildAdded:Connect(u518);

        for _, child in pairs(u519:GetChildren()) do
            u518(child);
        end;
    end;

    task.defer(function() -- Line: 1955
        -- upvalues: u519 (copy), u514 (ref)
        local Attachments = u519:WaitForChild("Attachments", 5);

        if not Attachments then
            return;
        end;

        Attachments.ChildAdded:Connect(function(p520) -- Line: 1958
            -- upvalues: u514 (ref)
            u514(p520);
        end);

        for _, child in pairs(Attachments:GetChildren()) do
            u514(child);
        end;
    end);
end;

local u522 = nil;

local function u526(p523: boolean?) -- Line: 1969
    -- upvalues: u522 (ref), Main (copy)
    local v524 = p523 == true;

    if v524 and not Player:GetAttribute("Armor_NVG") then
        u522 = false;
        script:SetAttribute("NVGOn", false);

        return;
    end;

    if v524 == u522 then
        return;
    end;

    local NVGFilmGrain = Main:FindFirstChild("NVGFilmGrain");

    if not NVGFilmGrain then
        return;
    end;

    u522 = v524;
    script:SetAttribute("NVGOn", u522);
    Main.NVGVignette.Visible = u522;
    NVGFilmGrain.Visible = u522;
    Lighting.NVG.Enabled = u522;
    Lighting.ExposureCompensation = u522 and 3.5 or 0.1;
    Lighting.Atmosphere.Glare = u522 and 1.5 or 0.82;
    Lighting.Atmosphere.Haze = u522 and 0.5 or 2.08;

    if u522 then
        local u525 = 0;
        Run:BindToRenderStep("NVG", Enum.RenderPriority.Last.Value + 1, function() -- Line: 1989
            -- upvalues: u525 (ref), NVGFilmGrain (copy)
            local os_clock_ret = os.clock();
            Lighting.Atmosphere.Density = Lighting.Atmosphere:GetAttribute("Density") * 0.7;

            if os_clock_ret - u525 < 0.020833333333333332 then
                return;
            end;

            u525 = os_clock_ret;

            if NVGFilmGrain.Parent then
                NVGFilmGrain.TileSize = UDim2.new(math.random(214, 266) / 1000, 0, math.random(214, 266) / 1000, 0);

                return;
            end;

            Lighting.Atmosphere.Density = Lighting.Atmosphere:GetAttribute("Density");
            Run:UnbindFromRenderStep("NVG");
        end);

        return;
    end;

    Lighting.Atmosphere.Density = Lighting.Atmosphere:GetAttribute("Density");
    pcall(Run.UnbindFromRenderStep, Run, "NVG");
end;

InputService.InputBegan:Connect(function(p527, p528) -- Line: 2010
    -- upvalues: SettingsModule (copy), PreferredInputController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), u453 (ref), u269 (ref), u500 (copy), u506 (copy), u501 (copy), u508 (copy), u526 (copy), u522 (ref), Items (copy), ToolInfo (copy), CFrame_new_ret2 (ref), CFrame_new_ret (ref)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    local UserInputType = p527.UserInputType;

    if InputService:GetFocusedTextBox() then
        return;
    end;

    if WheelController:GetAttribute("Open") or TeamNavigationController:GetAttribute("MapOpen") then
        local v529 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v529 then
            return;
        end;
    end;

    if UserInputType == Enum.UserInputType.MouseButton1 and not (p528 or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible))) then
        u453();

        return;
    end;

    if UserInputType == Enum.UserInputType.MouseButton2 and (SettingsModule.GetSetting("Controls", "Aim Down Sight") == "MB2" and not p528) then
        u269();

        return;
    end;

    if UserInputType == Enum.UserInputType.Keyboard or UserInputType == Enum.UserInputType.Gamepad1 then
        local KeyCode = p527.KeyCode;
        local Attribute = script:GetAttribute("DebugEnableVMMovement");

        if not (KeyCode.Name ~= SettingsModule.GetSetting("Controls", "Reload") and KeyCode.Name ~= SettingsModule.GetSetting("Gamepad", "Interact/Reload") or p528) then
            u500();

            return;
        end;

        if KeyCode.Name == SettingsModule.GetSetting("Controls", "Use Attachment") then
            if not p528 then
                u506();

                return;
            end;
        elseif KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Use Attachment") then
            local v530 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

            if not v530 then
                if not p528 then
                    u506();

                    return;
                end;
            end;
        end;

        if not (KeyCode.Name ~= SettingsModule.GetSetting("Controls", "Inspect") and KeyCode.Name ~= SettingsModule.GetSetting("Gamepad", "Inspect") or p528) then
            u501();

            return;
        end;

        if not (KeyCode.Name ~= SettingsModule.GetSetting("Controls", "Aim Down Sight") and KeyCode.Name ~= SettingsModule.GetSetting("Gamepad", "Aim Down Sight") or p528) then
            u269();

            return;
        end;

        if not (KeyCode.Name ~= SettingsModule.GetSetting("Controls", "Jump") and KeyCode.Name ~= SettingsModule.GetSetting("Gamepad", "Jump") or p528) then
            u508();

            return;
        end;

        if not (KeyCode.Name ~= SettingsModule.GetSetting("Controls", "Use Armor Mod") and KeyCode.Name ~= SettingsModule.GetSetting("Gamepad", "Use Armor Mod") or p528) then
            u526(not u522);

            return;
        end;

        if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Fire") and not (p528 or TeamNavigationController:GetAttribute("MapOpen")) then
            u453();

            return;
        end;

        if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Aim Down Sight") and not (p528 or TeamNavigationController:GetAttribute("MapOpen")) then
            u269();

            return;
        end;

        if (KeyCode == Enum.KeyCode.J or (KeyCode == Enum.KeyCode.U or (KeyCode == Enum.KeyCode.K or (KeyCode == Enum.KeyCode.I or (KeyCode == Enum.KeyCode.L or KeyCode == Enum.KeyCode.O))))) and Attribute then
            local v531 = InventoryController.Fetch:Invoke();
            local v532;

            if v531 then
                local Toolbar2 = v531.Toolbar;

                if Toolbar2 then
                    v532 = Toolbar2[script:GetAttribute("Equipped")];

                    if v532 == nil then
                        v532 = false;
                    elseif v532 == 0 then
                        v532 = false;
                    end;
                else
                    v532 = nil;
                end;
            else
                v532 = nil;
            end;

            if not v532 then
                return;
            end;

            local v533 = ToolInfo[Items[v532.ID].Name];

            if v533 and (v533.Offsets and v533.Offsets.Local) then
                local Attribute2 = script:GetAttribute("DebugVMMovementAmount");
                local v534 = {
                    J = { CFrame.new(-Attribute2, 0, 0), CFrame.Angles(0, Attribute2, 0) },
                    U = { CFrame.new(Attribute2, 0, 0), CFrame.Angles(0, -Attribute2, 0) },
                    K = { CFrame.new(0, -Attribute2, 0), CFrame.Angles(Attribute2, 0, 0) },
                    I = { CFrame.new(0, Attribute2, 0), CFrame.Angles(-Attribute2, 0, 0) },
                    L = { CFrame.new(0, 0, -Attribute2), CFrame.Angles(0, 0, Attribute2) },
                    O = { CFrame.new(0, 0, Attribute2), CFrame.Angles(0, 0, -Attribute2) }
                };
                local v535 = script:GetAttribute("DebugVMRotating") and 2 or 1;

                if v534[KeyCode.Name] then
                    CFrame_new_ret2 = CFrame_new_ret2 * v534[KeyCode.Name][v535];
                    task.wait(0.25);

                    while InputService:IsKeyDown(KeyCode) do
                        CFrame_new_ret2 = CFrame_new_ret2 * v534[KeyCode.Name][v535];
                        task.wait();
                    end;
                end;
            end;
        elseif KeyCode == Enum.KeyCode.P and Attribute then
            local v536 = InventoryController.Fetch:Invoke();
            local v537;

            if v536 then
                local Toolbar2 = v536.Toolbar;

                if Toolbar2 then
                    v537 = Toolbar2[script:GetAttribute("Equipped")];

                    if v537 == nil then
                        v537 = false;
                    elseif v537 == 0 then
                        v537 = false;
                    end;
                else
                    v537 = nil;
                end;
            else
                v537 = nil;
            end;

            if not v537 then
                return;
            end;

            local v538 = ToolInfo[Items[v537.ID].Name];

            if v538 and (v538.Offsets and v538.Offsets.Local) then
                local Attribute2 = script:GetAttribute("DebugPrintRoundedDecimalPoints");
                local v539 = {};

                for i, v in pairs({ (CFrame_new_ret * CFrame_new_ret2):GetComponents() }) do
                    v539[i] = math.ceil(v * 10 ^ Attribute2) / 10 ^ Attribute2;
                end;

                print("CFrame.new(" .. table.concat(v539, ", ") .. ");");
            end;
        elseif not (KeyCode ~= Enum.KeyCode.H or not (Attribute or Run:IsStudio()) or p528) then
            Player.CameraMode = Enum.CameraMode.Classic;
            Player.CameraMaxZoomDistance = 10;
        end;
    end;
end);
InputService.InputEnded:Connect(function(p540, p541) -- Line: 2090
    -- upvalues: u454 (ref), SettingsModule (copy), u270 (ref), u83 (ref), PreferredInputController (copy), u506 (copy)
    local UserInputType = p540.UserInputType;

    if UserInputType == Enum.UserInputType.MouseButton1 then
        u454();

        return;
    end;

    if UserInputType == Enum.UserInputType.MouseButton2 and SettingsModule.GetSetting("Controls", "Aim Down Sight") == "MB2" then
        u270();

        return;
    end;

    if UserInputType == Enum.UserInputType.Keyboard or UserInputType == Enum.UserInputType.Gamepad1 then
        local Name = p540.KeyCode.Name;

        if Name == SettingsModule.GetSetting("Controls", "Aim Down Sight") or Name == SettingsModule.GetSetting("Gamepad", "Aim Down Sight") then
            u270();

            return;
        end;

        if Name == SettingsModule.GetSetting("Controls", "Reload") or Name == SettingsModule.GetSetting("Gamepad", "Interact/Reload") then
            u83 = false;
            WheelController.Close:Invoke("Reload");

            return;
        end;

        if Name == SettingsModule.GetSetting("Gamepad", "Fire") then
            u454();

            return;
        end;

        local v542 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v542 and (Name == SettingsModule.GetSetting("Gamepad", "Use Attachment") and not SettingsModule.MainMenuOpen()) then
            u506();
        end;
    end;
end);
script:WaitForChild("MobileUse").Event:Connect(function(p543) -- Line: 2111
    -- upvalues: SettingsModule (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), u269 (ref), u46 (ref), u453 (ref), u454 (ref), u270 (ref), Items (copy), ToolInfo (copy), u41 (ref), u31 (ref), u47 (ref)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if TeamNavigationController:GetAttribute("MapOpen") then
        return;
    end;

    if Codelock.Visible or (GiveBed.Visible or RenameBed.Visible) then
        return;
    end;

    if script:GetAttribute("IsBow") then
        if p543 then
            u269();

            return;
        end;

        if u46 == "Holding" or u46 == "NoneJump" then
            task.spawn(u453);
            u454();
        end;

        u270();

        return;
    end;

    if script:GetAttribute("EquippedType") ~= "Gun" or SettingsModule.GetSetting("Mobile", "Aim When Firing") == false then
        if p543 then
            u453();

            return;
        end;

        u454();

        return;
    end;

    local v544 = InventoryController.Fetch:Invoke();
    local v545;

    if v544 then
        local Toolbar2 = v544.Toolbar;

        if Toolbar2 then
            v545 = Toolbar2[script:GetAttribute("Equipped")];

            if v545 == nil then
                v545 = false;
            elseif v545 == 0 then
                v545 = false;
            end;
        else
            v545 = nil;
        end;
    else
        v545 = nil;
    end;

    if v545 then
        v545 = Items[v545.ID];
    end;

    if v545 then
        v545 = ToolInfo[v545.Name];
    end;

    if v545 then
        v545 = v545.Weapon;
    end;

    local v546;

    if type(v545) == "table" and v545.FireOnRelease == true then
        v546 = true;
    elseif type(u41) == "table" then
        v546 = u41.Scope ~= nil;
    else
        v546 = false;
    end;

    if not p543 then
        if not (v546 or mobileAimFire.Firing) then
            mobileAimFire.Tap = true;

            return;
        end;

        local v547 = mobileAimFire;
        v547.Hold = v547.Hold + 1;

        if v546 and u47 then
            task.spawn(u453);
        end;

        u454();

        if mobileAimFire.Raised then
            mobileAimFire.Raised = false;
            u270();
        end;

        return;
    end;

    local v548 = mobileAimFire;
    v548.Hold = v548.Hold + 1;
    mobileAimFire.Tap = false;
    mobileAimFire.Firing = false;
    local mobileAimFire_Hold = mobileAimFire.Hold;

    if u31 == false then
        mobileAimFire.Raised = true;
        task.spawn(u269);
    end;

    if v546 then
        return;
    end;

    task.spawn(function() -- Line: 2154
        -- upvalues: mobileAimFire_Hold (copy), u47 (ref), u453 (ref), u454 (ref), u270 (ref)
        local os_clock_ret = os.clock();

        while mobileAimFire.Hold == mobileAimFire_Hold and (not u47 and os.clock() - os_clock_ret < 0.4) do
            Run.Heartbeat:Wait();
        end;

        if mobileAimFire.Hold ~= mobileAimFire_Hold then
            return;
        end;

        mobileAimFire.Firing = true;
        u453();

        if mobileAimFire.Tap then
            mobileAimFire.Tap = false;
            u454();

            if mobileAimFire.Raised then
                mobileAimFire.Raised = false;
                u270();
            end;
        end;
    end);
end);
script:WaitForChild("MobileADS").Event:Connect(function(p549) -- Line: 2201
    -- upvalues: SettingsModule (copy), Codelock (copy), u270 (ref), u269 (ref)
    if not p549 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if Codelock.Visible or InventoryController:GetAttribute("Open") then
        return;
    end;

    if mobileADSToggled then
        mobileADSToggled = false;
        u270();

        return;
    end;

    mobileADSToggled = true;
    u269();
end);
script:WaitForChild("MobileReload").Event:Connect(function(p550) -- Line: 2217
    -- upvalues: SettingsModule (copy), Codelock (copy), u500 (copy), u83 (ref)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if Codelock.Visible or InventoryController:GetAttribute("Open") then
        return;
    end;

    if p550 then
        u500();

        return;
    end;

    if not WheelController:GetAttribute("Open") then
        u83 = false;
        WheelController.Close:Invoke("Reload");
    end;
end);
script:WaitForChild("MobileJump").Event:Connect(function(p551) -- Line: 2231
    -- upvalues: SettingsModule (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), u508 (copy)
    if not p551 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if TeamNavigationController:GetAttribute("MapOpen") then
        return;
    end;

    if Codelock.Visible or (GiveBed.Visible or RenameBed.Visible) then
        return;
    end;

    u508();
end);
script:WaitForChild("MobileInspect").Event:Connect(function(p552) -- Line: 2241
    -- upvalues: SettingsModule (copy), Codelock (copy), u501 (copy)
    if not p552 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if Codelock.Visible or InventoryController:GetAttribute("Open") then
        return;
    end;

    u501();
end);
PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(function() -- Line: 2249
    -- upvalues: u10 (ref), u71 (ref)
    if isCrosshairAlwaysOn() and (u10 and u10.Parent) then
        u71 = 0.3;
    end;
end);
InputService.InputChanged:Connect(function(p553) -- Line: 2254
    -- upvalues: u52 (ref), u53 (ref), u32 (ref), SettingsModule (copy), PreferredInputController (copy)
    local UserInputType = p553.UserInputType;

    if UserInputType ~= Enum.UserInputType.MouseMovement then
        if UserInputType == Enum.UserInputType.Gamepad1 and p553.KeyCode == Enum.KeyCode.Thumbstick2 then
            if not InventoryController:GetAttribute("Open") then
                local Setting = SettingsModule.GetSetting("Gamepad", "Mouse Sensitivity");

                if script:GetAttribute("Aiming") then
                    Setting = SettingsModule.GetSetting("Gamepad", "Aiming Sensitivty");
                end;

                local v554 = PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225;
                local v555 = p553.Position.Y < v554 and p553.Position.Y > -v554 and 0 or p553.Position.Y;
                local math_max_ret = math.max((p553.Position.X < v554 and p553.Position.X > -v554 and 0 or p553.Position.X) * 50 * Setting, -150);
                u52 = math.min(math_max_ret, 150);
                local math_max_ret2 = math.max(v555 * 50 * Setting, -150);
                u53 = math.min(math_max_ret2, 150);
                u32 = tick();

                return;
            end;
        elseif UserInputType == Enum.UserInputType.Touch then
            if CameraInputModule.getPanTouch() ~= p553 then
                return;
            end;

            if InventoryController:GetAttribute("Open") then
                return;
            end;

            local math_max_ret = math.max(p553.Delta.X * 1.5, -150);
            u52 = math.min(math_max_ret, 150);
            local math_max_ret2 = math.max(p553.Delta.Y * 1.5, -150);
            u53 = math.min(math_max_ret2, 150);
            u32 = tick();
        end;

        return;
    end;

    local math_max_ret = math.max(p553.Delta.x * 1.5, -150);
    u52 = math.min(math_max_ret, 150);
    local math_max_ret2 = math.max(p553.Delta.y * 1.5, -150);
    u53 = math.min(math_max_ret2, 150);
    u32 = tick();
end);
Humanoid.StateChanged:Connect(function(p556, p557) -- Line: 2300
    -- upvalues: u63 (ref), script_Parent (copy), Humanoid (copy), u67 (ref), NumberUtil (copy), u68 (ref), u101 (copy)
    local v558 = p557 == Enum.HumanoidStateType.Landed;

    if p557 == Enum.HumanoidStateType.Jumping then
        u63 = 2;

        if not (script_Parent and (script_Parent.Parent and (Humanoid and Humanoid.Health > 0))) then
            return;
        end;

        local PrimaryPart = script_Parent.PrimaryPart;

        if not PrimaryPart then
            return;
        end;

        local Velocity = PrimaryPart.Velocity;
        local MoveDirection = Humanoid.MoveDirection;
        local Magnitude = Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude;
        local v559 = Humanoid.WalkSpeed / 3 <= Magnitude and Vector3.new(MoveDirection.X, 0, MoveDirection.Z) or Vector3.new();

        if u67 and u67.Parent then
            u67:Destroy();
        end;

        u67 = Instance.new("BodyVelocity");
        u67.MaxForce = Vector3.new(20000, 0, 20000);
        u67.Velocity = v559 * math.clamp(Magnitude, 6, 18);
        local v560 = u67.Velocity.Magnitude <= 0.01;
        u67.Name = "JumpForce";
        u67.Parent = PrimaryPart;
        local os_clock_ret = os.clock();
        local v561 = 1;

        while v561 >= 0 do
            local v562 = Run.Heartbeat:Wait();

            if not (u67 and u67.Parent) then
                break;
            end;

            if os.clock() - os_clock_ret >= (v560 and 0.1 or 0.15) then
                local v563 = NumberUtil:Lerp(v561, 0, v562 * 1.15);
                v561 = v563 <= 0.01 and 0 or v563;
                u67.MaxForce = u67.MaxForce:Lerp(Vector3.new(), v561);
            end;
        end;
    else
        if v558 or p557 == Enum.HumanoidStateType.Running then
            u63 = 0;

            if u67 and u67.Parent then
                u68 = tick();
                u67:Destroy();
            end;

            u67 = nil;

            if v558 == false or StateController:GetAttribute("IsCrouch") then
                return;
            end;

            u101.Target = u101.Target + Vector3.new(0, -1, 0);

            return;
        end;

        if p557 == Enum.HumanoidStateType.Freefall or p556 == Enum.HumanoidStateType.Freefall then
            u63 = 1;
        end;
    end;
end);
Humanoid.Died:Connect(function() -- Line: 2348
    -- upvalues: u89 (ref), u160 (copy)
    u89:Disconnect();
    u160();
end);
Humanoid:GetAttributeChangedSignal("Downed"):Connect(u160);
script_Parent.ChildAdded:Connect(function(p564) -- Line: 2355
    -- upvalues: u521 (copy)
    task.wait();
    u521(p564);
end);

for _, child in pairs(script_Parent:GetChildren()) do
    task.defer(u521, child);
end;

Player:GetAttributeChangedSignal("ArmorSleeves"):Connect(v181);
Player:GetAttributeChangedSignal("Armor_NVG"):Connect(function() -- Line: 2365
    -- upvalues: u526 (copy)
    if not Player:GetAttribute("Armor_NVG") then
        u526(false);
    end;
end);
u526(false);
u4("Setup", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\194\163\239\191\189\048\195\161\239\191\189\104\239\191\189\122\239\191\189\075\239\191\189\082\056\098\239\191\189\102\239\191\189", function(p565, ...) -- Line: 2373
    -- upvalues: u229 (copy)
    local v566 = { ... };

    if p565 ~= "HitMarker" then
        return;
    end;

    if v566[2] then
        local os_clock_ret = os.clock();

        if os_clock_ret - npcMarker.ConfirmAt < 0.05 then
            return;
        end;

        npcMarker.ConfirmAt = os_clock_ret;

        if npcMarker.Count > 0 and os_clock_ret - npcMarker.At < 1 then
            local v567 = npcMarker;
            v567.Count = v567.Count - 1;

            return;
        end;
    end;

    u229(v566[1]);
end);
u4("Setup", "\239\191\189\105\117\041\239\191\189\239\191\189\239\191\189\054\049\125\106\194\176\239\191\189\239\191\189\053\107\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\194\184\080\239\191\189\195\137\239\191\189\239\191\189\108\239\191\189\239\191\189\239\191\189\239\191\189\195\181\060\195\173\195\156\195\174\239\191\189\239\191\189\239\191\189", function(p568: boolean) -- Line: 2381
    -- upvalues: u85 (ref), u84 (ref)
    u85 = u85 + 1;

    if not p568 then
        return;
    end;

    u84 = false;
end);
EquipVM.Event:Connect(function(...) -- Line: 2389
    -- upvalues: u209 (copy), u160 (copy)
    local v569 = ({ ... })[1];

    if v569 and v569 > 0 then
        u209(...);

        return;
    end;

    u160();
end);
UpdateVM.Event:Connect(u170);
script:WaitForChild("MobileAttachment").Event:Connect(function(p570) -- Line: 2404
    -- upvalues: u506 (copy)
    if not p570 then
        return;
    end;

    u506();
end);
script:WaitForChild("MobileNVG").Event:Connect(function(p571) -- Line: 2410
    -- upvalues: SettingsModule (copy), u526 (copy), u522 (ref)
    if not p571 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    u526(not u522);
end);
PlayVMAnimation.Event:Connect(u149);
Mouse.TargetFilter = VFX_PARTS;
Crosshair.Up.Size = UDim2.new(0, 2, 0, 8);
Crosshair.Down.Size = UDim2.new(0, 2, 0, 8);
Crosshair.Right.Size = UDim2.new(0, 8, 0, 2);
Crosshair.Left.Size = UDim2.new(0, 8, 0, 2);
pcall(function() -- Line: 2426
    Run:UnbindFromRenderStep("ViewmodelController");
    Run:UnbindFromRenderStep("HumCamOffset");
end);
u89 = Run.Heartbeat:Connect(function(p572) -- Line: 2431
    -- upvalues: ChatController (copy), PreferredInputController (copy), u55 (ref), NumberUtil (copy), u72 (ref), HitMarker (copy), u70 (ref), u69 (ref), Items (copy), ToolInfo (copy), Humanoid (copy), Codelock (copy), SettingsModule (copy), u60 (ref), u56 (ref), u59 (ref), u101 (copy), u102 (ref), u103 (copy), u104 (ref), u95 (copy), u96 (ref), u97 (copy), Vector3_new_ret (ref), CFrame_new_ret12 (ref), u98 (ref), u100 (ref), u99 (ref), CFrame_new_ret13 (ref), u80 (copy), u92 (ref), u180 (copy), u10 (ref), u12 (ref), u71 (ref), Crosshair (copy), u76 (ref), u73 (ref), u139 (copy), u46 (ref), CFrame_new_ret3 (ref), u86 (ref), u41 (ref), u26 (ref), u28 (ref), u27 (ref), u29 (ref), u24 (ref), u25 (ref), u32 (ref), u52 (ref), u53 (ref), u93 (copy), u50 (ref), u51 (ref), u54 (ref), u39 (ref), u40 (ref), u34 (ref), u38 (ref), u35 (ref), u43 (ref), u18 (ref), CFrame_new_ret4 (ref), u45 (ref), u149 (copy), u155 (copy), u23 (copy), u49 (ref), u500 (copy), WeldModule (copy), u13 (ref), u65 (ref), u19 (ref), u36 (ref), u37 (ref), u63 (ref), u64 (ref), u58 (ref), u57 (ref), u74 (ref), u75 (ref), u94 (copy), u78 (ref), u79 (ref), u81 (ref), CFrame_new_ret7 (ref), CFrame_new_ret6 (ref), u84 (ref), u87 (ref), u77 (ref), Scope (copy), Size (copy), u212 (copy), Toolbar (copy), Stats (copy), GamepadControls (copy), CFrame_new_ret (ref), u90 (ref), CFrame_new_ret8 (ref), CFrame_new_ret2 (ref), u62 (ref), u82 (ref), u66 (ref), CFrame_new_ret9 (ref), CFrame_new_ret10 (ref), u61 (ref), CFrame_new_ret11 (ref)
    local v573 = script:GetAttribute("DebugDisableScriptAnims") or (WheelController:GetAttribute("Open") or InventoryController:GetAttribute("Open") or ChatController:GetAttribute("Typing")) and PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    local Attribute = script:GetAttribute("Aiming");
    local Attribute2 = script:GetAttribute("Using");
    local Attribute3 = StateController:GetAttribute("Direction");
    local Attribute4 = StateController:GetAttribute("IsSprint");
    local Attribute5 = StateController:GetAttribute("IsCrouch");
    local Attribute6 = script:GetAttribute("DebugFrameworkSpeed");
    local Attribute7 = CameraController:GetAttribute("UI");
    local Attribute8 = script:GetAttribute("CanUse");
    local v574 = p572 * Attribute6;
    local v575 = v574 / 0.016666666666666666;
    local math_clamp_ret = math.clamp(0.016666666666666666 / v574, 0.001, 100);

    if u55 then
        u55 = math.abs(u55 - math_clamp_ret) <= 0.001 and math_clamp_ret and math_clamp_ret or NumberUtil:Lerp(u55, math_clamp_ret, (math.clamp(0.25 * v575, 0, 1)));
    else
        u55 = math_clamp_ret;
    end;

    local v576;

    if u72 < 1 then
        v576 = Attribute7;
    else
        v576 = false;
    end;

    if v576 then
        u72 = math.min(u72 + v574 * 5, 1);
        local v577 = u72 < 0.1 and u72 * -8 + 1 or (u72 <= 0.75 and 0.2 or (u72 * 4 - 3) * 0.8 + 0.2);

        for _, child in pairs(HitMarker:GetChildren()) do
            child.BackgroundTransparency = v577;
        end;

        local v578 = (u72 - 1) ^ 3 * -15 + 8;
        HitMarker.Up.Position = UDim2.new(0, 0, 0, -v578);
        HitMarker.Left.Position = UDim2.new(0, -v578, 0, 0);
        HitMarker.Down.Position = UDim2.new(0, 0, 0, v578 + 2);
        HitMarker.Right.Position = UDim2.new(0, v578 + 2, 0, 0);
    end;

    HitMarker.Visible = v576;
    local v579 = Attribute4 and 5 or 0;
    u70 = math.abs(u70 - v579) <= 0.01 and v579 and v579 or NumberUtil:Lerp(u70, v579, (math.clamp(0.15 * v575, 0, 1)));
    Camera.FieldOfView = u69 + u70;
    local v580 = InventoryController.Fetch:Invoke();
    local v581;

    if v580 then
        local Toolbar2 = v580.Toolbar;

        if Toolbar2 then
            v581 = Toolbar2[script:GetAttribute("Equipped")];

            if v581 == nil then
                v581 = false;
            elseif v581 == 0 then
                v581 = false;
            end;
        else
            v581 = nil;
        end;
    else
        v581 = nil;
    end;

    local v582;

    if v581 then
        v582 = Items[v581.ID];
    else
        v582 = v581;
    end;

    local v583;

    if v582 then
        v583 = ToolInfo[v582.Name];
    else
        v583 = v582;
    end;

    local v584;

    if v583 then
        v584 = v583.Weapon;
    else
        v584 = v583;
    end;

    local v585 = v584 and (v584.VMMovementMults or {}) or {};
    local v586 = Humanoid.WalkSpeed / 10;
    local v587 = Attribute3 == "" and 0 or math.max(v586, 0.5);
    local v588 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    local v589 = v588 and (InventoryController:GetAttribute("Open") or (Codelock.Visible or (SettingsModule.MainMenuOpen() or ChatController:GetAttribute("Typing")))) and 0 or v587;
    u60 = math.abs(v589 - u60) <= 0.01 and v589 and v589 or NumberUtil:Lerp(u60, v589, (math.clamp(0.15 * v575, 0, 1)));
    u56 = math.abs(u56 - v586) <= 0.01 and v586 and v586 or NumberUtil:Lerp(u56, v586, (math.clamp(0.12 * v575, 0, 1)));
    u59 = u59 + v574 * 6.5 * v586;
    local v590 = v585.Bobbing or 1;
    local v591 = (math.sin(u59) * 0.05 + math.sin(u59 * 1.6) * 0.007) * u60;
    local v592 = (math.cos(u59 * 2) * 0.0225 + math.cos(u59 * 2.2) * 0.007) * 0.9 * u60;
    local Target = u101.Target;

    if Target ~= Vector3.new() then
        u101.Target = Target.X ^ 2 + Target.Y ^ 2 + Target.Z ^ 2 <= 0.01 and Vector3.new() or Target:Lerp(Vector3.new(), (math.clamp(0.2 * v575, 0, 1)));
    end;

    u102 = u101.Position;
    local Target2 = u103.Target;

    if Target2 ~= Vector3.new() then
        u103.Target = Target2.X ^ 2 + Target2.Y ^ 2 + Target2.Z ^ 2 <= 0.01 and Vector3.new() or Target2:Lerp(Vector3.new(), (math.clamp(0.3 * v575, 0, 1)));
    end;

    u104 = u103.Position;
    u95.Target = Attribute3 == "" and Vector3.new() or Vector3.new(v591, v592 * 1.5, 0) * -2;
    u96 = u95.Position;
    u97.Target = Vector3_new_ret * v575;
    local Position = u97.Position;
    CFrame_new_ret12 = CFrame.Angles(Position.Y, Position.X, Position.Z);
    u98 = u97.Target == Vector3.new() and (u98 + v574 or 0) or 0;

    if u100 <= u98 then
        local math_clamp_ret2 = math.clamp(u99 + 0.1 * v575, 0, 1);
        CFrame_new_ret12 = CFrame_new_ret13:Lerp(CFrame.new(), 1 - (math_clamp_ret2 - u99)):inverse();
        u99 = math_clamp_ret2;
    else
        local v593, v594, v595 = CFrame_new_ret12:ToEulerAnglesXYZ();
        CFrame_new_ret12 = CFrame.Angles(v593, v594, v595);
    end;

    CFrame_new_ret13 = CFrame_new_ret13 * CFrame_new_ret12;

    if u80.Code then
        u80.X = math.min(u80.X + u80.Increment * v575, 90);
        local PrevPos = u80.PrevPos;
        local NewPos = u80.NewPos;
        local math_rad_ret = math.rad(u80.X);
        u80.Pos = PrevPos:Lerp(NewPos, (math.sin(math_rad_ret)));
        local PrevRot = u80.PrevRot;
        local NewRot = u80.NewRot;
        local math_rad_ret2 = math.rad(u80.X);
        u80.Rot = PrevRot:Lerp(NewRot, (math.sin(math_rad_ret2)));

        if u80.X >= 90 then
            u80.Code = nil;
        end;
    end;

    if u92 then
        u92 = false;
        u180();
    end;

    local v596;

    if Humanoid.SeatPart == nil then
        v596 = false;
    else
        v596 = Humanoid.SeatPart.Name == "VehicleSeat";
    end;

    if not (v581 and (u10 and (u10.Parent == VM_PARTS and (type(v583) == "table" and u12)))) then
        u69 = SettingsModule.GetSetting("General", "Field Of View");

        if isCrosshairAlwaysOn() then
            u71 = NumberUtil:Lerp(u71, 0.3, (math.clamp(0.4 * v575, 0, 1)));
            local v597;

            if u71 < 1 then
                v597 = SettingsModule.GetSetting("Graphics", "Toggle Crosshair") == true;
            else
                v597 = false;
            end;

            Crosshair.Visible = v597;

            if Crosshair.Visible then
                for _, v in pairs({ Crosshair, unpack(Crosshair:GetChildren()) }) do
                    v.BackgroundTransparency = u71;
                end;

                u76 = Attribute3 == "" and 12 or 18;
                Crosshair.Up.Position = UDim2.new(0, 0, 0, -u76);
                Crosshair.Left.Position = UDim2.new(0, -u76, 0, 0);
                Crosshair.Down.Position = UDim2.new(0, 0, 0, u76 + 2);
                Crosshair.Right.Position = UDim2.new(0, u76 + 2, 0, 0);

                return;
            end;
        else
            Crosshair.Visible = false;
        end;

        return;
    end;

    local Type = v582.Type;
    local Melee = v583.Melee;
    local Spread = v583.Spread;
    local Recoil = v583.Recoil;
    local Offsets = v583.Offsets;
    local v598;

    if v584 then
        v598 = v584.UsePositionTimes;
    else
        v598 = v584;
    end;

    local v599 = tick() - u73;
    local v600 = v598 and (v598.Start <= v599 and (v599 <= v598.End and (v573 == false and (v598.PlayOnMiss or not u139("Miss"))))) and "LocalUse" or "Local";

    if v600 == "Local" and Offsets[`Local{v581.Skin}`] then
        v600 = `Local{v581.Skin}`;
    end;

    local v601;

    if v584 == nil then
        v601 = false;
    else
        v601 = v584.AimDownSpeed ~= nil;
    end;

    local v602;

    if v584 == nil then
        v602 = false;
    else
        v602 = v584.IsBow;
    end;

    if Attribute then
        Attribute = (v602 ~= true or u46 == "AimingIn2") and true or u46 == "Holding";
    end;

    CFrame_new_ret3 = CFrame_new_ret3:Lerp(Offsets[v600], (math.clamp((v598 and v598.Alpha or 0.1) * v575, 0, 1)));
    u86 = NumberUtil:Lerp(u86, Attribute and 1 + (u41.SwayMult or 0) or 1, (math.clamp(0.1 * v575, 0, 1)));
    u26 = NumberUtil:Lerp(u26, 0.0135, 0.01);
    u28 = NumberUtil:Lerp(u28, 0.015, 0.01);
    u27 = NumberUtil:Lerp(u27, 0.0025, 0.01);
    u29 = NumberUtil:Lerp(u29, 0.006, 0.01);
    local v603 = u60 * 2 + 1;
    u24 = (u24 + u26 * v603 * v575) % 6.283185307179586;
    u25 = (u25 + u28 * v603 * v575) % 6.283185307179586;
    local v604 = math.sin(u25) * (u29 * u56 * u86);
    local v605 = math.sin(u24) * (u27 * u56 * u86);

    if tick() - u32 >= 0.15 / Attribute6 then
        u52 = NumberUtil:Lerp(u52, 0, (math.clamp(0.1 * v575, 0, 1)));
        u53 = NumberUtil:Lerp(u53, 0, (math.clamp(0.1 * v575, 0, 1)));
    end;

    u93.Target = CameraController:GetAttribute("FreeLooking") and Vector3.new() or Vector3.new(u52, u53, 0);
    local v606 = u93.Position * u55;
    u50 = v606.X / 16.666666666666668;
    u51 = v606.Y / 16.666666666666668;
    u54 = NumberUtil:Lerp(u54, Attribute and 15 or 1, (math.clamp(0.1 * v575, 0, 1)));
    local v607 = (v584 == nil or not v584.AimDownSpeed) and 1 or v584.AimDownSpeed[Attribute and "In" or "Out"];

    if Attribute ~= u39 then
        u40 = math.clamp(Attribute and 1 - u34 / 1.1 or u34 / 1.1, 0, 1);
        u39 = Attribute;
    end;

    u38 = NumberUtil:Lerp(u38, (Attribute3 == "" and 7 or 5) / (Attribute5 and 0.9 or (Attribute4 and Attribute3 ~= "" and 1.25 or 1)), (math.clamp((Attribute3 == "" and 0.01 or 0.15) * v575, 0, 1)));
    local v608 = Attribute and (v602 ~= true or u46 ~= "Started" and not u46:find("None")) and v574 and v574 or -v574;
    local math_min_ret = math.min(u34 + v608 * u40 / v607, 1.1);
    u34 = math.max(0, math_min_ret);
    local math_min_ret2 = math.min(u34, 1);
    u35 = u34 >= 1 and (u35 + v574 * 1.5 or 1) or 1;
    local v609 = Attribute and (v601 and not (Melee or Offsets.Aim)) and (u43 or u18);

    if v609 then
        CFrame_new_ret4 = u12.CFrame:ToObjectSpace(v609.CFrame):inverse();
    end;

    if v601 then
        if Melee then
            if Attribute then
                if u45 == "None" then
                    u45 = "Started";
                    u149("ThrowWindup");
                elseif u45 == "Started" and not u139("ThrowWindup") then
                    u45 = "Holding";
                    u149("ThrowHold");
                end;
            elseif u139("ThrowHold") or u139("ThrowWindup") then
                u45 = "None";
                u155("ThrowWindup");
                u155("ThrowHold");
            end;
        elseif v602 then
            local AimStart = u23.Local.AimStart;

            if script:GetAttribute("Aiming") and not u49 then
                if u46 == "None" then
                    local Ammo = v581.Ammo;
                    local v610 = nil;

                    if not (u139("AimStop") or Attribute2) then
                        if Ammo == nil or Ammo.Amount <= 0 then
                            local v611;
                            v611, v610 = u500(true);

                            if v611 then
                                u46 = "Started";
                                u149("AimStart", 0.9);

                                if v610 then
                                    WeldModule:WeldAttachments(u13, v581, nil, nil, v610, u10:GetScale());
                                end;
                            end;
                        else
                            u46 = "Started";
                            u149("AimStart", 0.9);

                            if v610 then
                                WeldModule:WeldAttachments(u13, v581, nil, nil, v610, u10:GetScale());
                            end;
                        end;
                    end;
                elseif u139("AimStart") and AimStart.TimePosition >= 0.85 then
                    u46 = "AimingIn2";
                elseif u139("AimStart") and AimStart.TimePosition >= 0.7 then
                    u46 = "AimingIn1";
                elseif not u139("AimStart") then
                    u46 = "Holding";
                    u149("AimHold");
                end;
            elseif u46 == "Holding" or not (u46:find("None") or u139("AimStart")) then
                local v612 = tick() - u65;
                u46 = v612 >= 0.25 and v612 <= 0.45 and "NoneJump" or "None";

                if u46 == "NoneJump" then
                    task.delay(0.3, function() -- Line: 2660
                        -- upvalues: u46 (ref)
                        if u46 ~= "NoneJump" then
                            return;
                        end;

                        u46 = "None";
                    end);
                else
                    u155("AimStart");
                    u155("AimHold");
                    u149("AimStop", -1);
                end;

                u49 = false;
            end;
        end;
    end;

    local v613 = u19 and (u19:FindFirstChild("Military ACOG Sight") or u19:FindFirstChild("Bruno\'s ACOG Sight"));

    if v613 then
        local v614 = math_min_ret2 >= 0.5;
        v613.ADS.Transparency = v614 and 0 or 1;
        v613.Front.Transparency = v614 and 1 or 0;
        v613.Middle.Transparency = v614 and 1 or 0;
        v613.Red.Transparency = v614 and 1 or 0;
        v613.Vignette.Transparency = v614 and 1 or 0.95;
    end;

    local v615 = math_min_ret2 <= 0.5 and math_min_ret2 ^ 3 * 4 or (math_min_ret2 - 1) ^ 3 * 4 + 1;
    u36 = u35 > 1 and 2 ^ (-u38 * u35) * math.sin(u35 * 12.566370614359172) or NumberUtil:Lerp(u36, 0, (math.clamp(0.5 * v575, 0, 1)));
    u37 = NumberUtil:Lerp(u37, Attribute and 0.1 or 1, (math.clamp(0.2 * v575, 0, 1))) * u86;

    if Attribute4 then
        Attribute4 = not (Attribute8 and Attribute2);
    end;

    local v616 = u63 >= 1 and true or (WaterController:GetAttribute("IsSwim") or v596);
    local v617;

    if v616 then
        v617 = Type ~= "Tool" and true or not Attribute2;
    else
        v617 = v616;
    end;

    local v618 = Attribute4 and (v585.SprintTilt or 1) or 1;
    local Setting = SettingsModule.GetSetting("General", "Field Of View");
    u69 = NumberUtil:Lerp(Setting, Setting / (u41.ZoomLevel or (v584 == nil and 1 or (v584.DefaultZoomLevel or 1))), (math.min(v615 * 1.2, 1)));
    u64 = v616 and Type ~= "Tool" and tick() or u64;
    u65 = u63 >= 1 and u65 or tick();
    local v619;

    if Attribute3:find("Forward") then
        v619 = Attribute4 and -15 * v618 or -2;
    else
        v619 = Attribute3:find("Backward") and 2 or 0;
    end;

    u58 = NumberUtil:Lerp(u58, math.rad((v617 and ((Attribute4 and -5 or -15) * v618 or 0) or 0) + v619) / (v602 and (u139("AimStart") and v617) and 10 or 1), (math.clamp((v617 and 0.25 or 0.15) * v575, 0, 1)));
    local v620 = Attribute3:find("Right") and 1 or (Attribute3:find("Left") and -1 or 0);
    u57 = NumberUtil:Lerp(u57, math.rad(4 * v620), (math.clamp(0.1 * v575, 0, 1)));
    local v621 = nil;
    local v622 = 1;
    local Ammo = v581.Ammo;

    if Ammo then
        Ammo = Items[Ammo.ID];
    end;

    local v623 = (Ammo and Ammo.AmmoStats or {})[(Attribute and "Aim" or "Hip") .. "SpreadMult"] or 1;

    if Spread then
        v621 = Spread[Attribute and "Aiming" or "Hip"];
        v622 = 1 + (u41[(Attribute and "Aim" or "Hip") .. "SpreadMult"] or 0);
        local v624 = NumberUtil:Lerp(u74, (v621 or Spread.Hip)[Attribute3 == "" and "Idle" or "Moving"] * v622 * v623, (math.clamp(0.2 * v575, 0, 1)));
        u74 = math.max(v624, 0);
        local Shooting = Spread.Shooting;

        if Shooting then
            if tick() - u73 >= Shooting.DecayStart / Attribute6 then
                u75 = math.max(u75 - v574 * (1 / (Shooting.DecayEnd - Shooting.DecayStart)), 0);
            end;
        else
            u75 = 0;
        end;

        u94.Target = u80.Rot;

        if Recoil then
            Recoil = Recoil.Camera;
        end;

        if Recoil and (u78 < 1 or u79 > 0) then
            local v625 = tick() - u73;

            if Recoil.Decay.Start / Attribute6 <= v625 then
                u78 = math.min(u78 + Recoil.Decay.Rate / (u79 * Recoil.Decay.Multiplier) * v575, 1);

                if Recoil.Decay.Bullet <= v625 then
                    local v626 = tick() - u81;
                    local v627 = 0.016666666666666666 / Attribute6;

                    if u79 > 0 and v627 <= v626 then
                        for i = 1, math.floor(v626 / v627) do
                            u79 = math.max(u79 - 1, 0);
                            local _ = i;
                        end;

                        u81 = tick();
                    end;
                end;
            else
                u81 = tick();
                CFrame_new_ret7 = CFrame_new_ret6;
            end;
        end;
    end;

    for _, v in pairs({ Crosshair, unpack(Crosshair:GetChildren()) }) do
        v.BackgroundTransparency = u71;
    end;

    if isCrosshairAlwaysOn() and Type ~= "Gun" then
        u71 = NumberUtil:Lerp(u71, Attribute4 and 0.5 or 0.3, (math.clamp(0.4 * v575, 0, 1)));
        local v628;

        if u71 < 1 then
            v628 = SettingsModule.GetSetting("Graphics", "Toggle Crosshair") == true;
        else
            v628 = false;
        end;

        Crosshair.Visible = v628;

        if Crosshair.Visible then
            for _, v in pairs({ Crosshair, unpack(Crosshair:GetChildren()) }) do
                v.BackgroundTransparency = u71;
            end;

            u76 = Attribute3 == "" and 12 or 18;
            Crosshair.Up.Position = UDim2.new(0, 0, 0, -u76);
            Crosshair.Left.Position = UDim2.new(0, -u76, 0, 0);
            Crosshair.Down.Position = UDim2.new(0, 0, 0, u76 + 2);
            Crosshair.Right.Position = UDim2.new(0, u76 + 2, 0, 0);
        end;
    else
        local v629;

        if v621 == nil then
            v629 = isCrosshairAlwaysOn() and (Attribute4 and 0.5 or 0.3) or 1;
        elseif Attribute4 or (u139("Equip") or (u84 or (u139("Inspect") or CameraController:GetAttribute("FreeLooking")))) then
            v629 = 1;
        else
            local v630 = Attribute or math_min_ret2 >= 0.8;
            v629 = v630 and Spread.Aiming.Hide and 1 or (v630 == false and Spread.Hip.Hide and 1 or 0.2);
        end;

        u71 = NumberUtil:Lerp(u71, v629, (math.clamp(0.4 * v575, 0, 1)));

        if v629 >= 1 and u71 > 0.95 then
            u71 = 1;
        end;

        local v631;

        if u71 < 1 then
            if Type == "Gun" or (isCrosshairAlwaysOn() or Attribute) then
                v631 = (u87 or isCrosshairAlwaysOn()) and (Attribute7 or isCrosshairAlwaysOn()) and SettingsModule.GetSetting("Graphics", "Toggle Crosshair") == true;
            else
                v631 = Attribute;
            end;
        else
            v631 = false;
        end;

        Crosshair.Visible = v631;

        if Crosshair.Visible and v621 then
            local v632 = v621.ShootingExtra * v622 * u75 * v623;
            u77 = v621[Attribute3 == "" and "IdleExtra" or "MovingExtra"] or 0;
            u76 = math.abs(u76 - v589) <= 0.01 and u77 or NumberUtil:Lerp(u76, u77, (math.clamp(0.16 * v575, 0, 1)));
            local v633 = u74 + v632 + u76;
            Crosshair.Up.Position = UDim2.new(0, 0, 0, -v633);
            Crosshair.Left.Position = UDim2.new(0, -v633, 0, 0);
            Crosshair.Down.Position = UDim2.new(0, 0, 0, v633 + 2);
            Crosshair.Right.Position = UDim2.new(0, v633 + 2, 0, 0);
        end;
    end;

    local Scope2 = u41.Scope;
    local v634 = Scope2 and (math.clamp(1 - v615 * 1.2, 0, 1) or 1) or 1;

    if Scope2 then
        Scope.Size = NumberUtil:MultUDim2ByNum(Size, Scope2);

        for _, v in pairs({ Scope, Scope.Frame, unpack(Scope.Frame:GetChildren()) }) do
            local v635 = (v:IsA("Frame") and "Background" or "Image") .. "Transparency";
            local v636;

            if v.Name == "Grain" then
                v636 = v634 * 0.1 + 0.9 or v634;
            else
                v636 = v634;
            end;

            v[v635] = v636;
        end;
    end;

    Scope.Visible = Scope2 ~= nil;
    Scope.Position = UDim2.new(0.55, 0, 0.55, 0):Lerp(UDim2.new(0.5, 0, 0.5, 0), v615 + u36 * 15 * u86);

    if u212(v634 >= 0.8) and Scope2 then
        local v637 = u87 and CameraController:GetAttribute("UI");
        Toolbar.Visible = v637;
        local v638 = u87 and CameraController:GetAttribute("UI");
        Stats.Visible = v638;
        local v639 = u87 and (CameraController:GetAttribute("UI") and PreferredInputController) and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
        GamepadControls.Visible = v639;
    end;

    local v640 = Camera;
    v640.CFrame = v640.CFrame * (u87 and CFrame.new() or CFrame.Angles(v604 * 0.08 * (u60 * 2 + 1), v605 * 0.16 * (u60 * 2 + 1), 0));
    CFrame_new_ret = CFrame_new_ret4 and CFrame_new_ret3:Lerp(CFrame_new_ret4, Scope2 and 1 - v634 or v615 + u36 * u86) or CFrame_new_ret3;
    u90 = u34 >= 0.85;
    CFrame_new_ret8 = CFrame_new_ret * CFrame_new_ret2 * (v573 and CFrame.new() or CFrame.Angles(v604 * u37, v605 * (u37 * 3), 0)) + (u102 or u101.Position) / -4;
    local v641;

    if Attribute then
        v641 = u90 and 0.2 or 0.1;
    else
        v641 = u90 and 0.1 or 0.2;
    end;

    local math_clamp_ret2 = math.clamp(v641 * v575, 0, 1);
    u62 = NumberUtil:Lerp(u62, u90 and 0 or 1, math_clamp_ret2);
    u82 = NumberUtil:Lerp(u82, Attribute and 0 or 1, (math.clamp(0.25 * v575, 0, 1)));
    local v642 = u94.Position * (u82 * 0.8 + 0.2);
    local v643 = u80.Pos * (u82 * 0.5 + 0.5);
    u66 = NumberUtil:Lerp(u66, Attribute4 and 1 or 0, (math.clamp(0.25 * v575, 0, 1)));
    local v644 = (v585.SprintMoveDown or 0) * u66;
    local v645 = (v585.SprintMoveBackward or 0) * u66;
    CFrame_new_ret9 = v573 and CFrame.new() or CFrame.new(v591 * v590 * u62, v592 * v590 * u62 + u58 * v644, u58 * -v645);
    CFrame_new_ret10 = v573 and CFrame.new() or CFrame.Angles(u58 * u62 + v642.X, u57 * u62 + v642.Y, -u57 * u62 + v642.Z) * CFrame.new(v643.X, v643.Y, v643.Z);
    u61 = NumberUtil:Lerp(u61, u90 and u35 >= 1.5 and 1 or 0, math_clamp_ret2);
    local v646 = v585.MouseSway or 1;
    CFrame_new_ret11 = v573 and CFrame.new() or CFrame.Angles(math.rad(u51) * v646 / u54 + (math.rad(v592 * v590 * 3 * v586) + u58 / 30) * u61, math.rad(u50) * v646 / u54 + (math.rad(v591 * v590 * 3 * v586) + u57 / 30) * u61, 0);
end);
Run:BindToRenderStep("HumCamOffset", Enum.RenderPriority.Camera.Value - 1, function(p647) -- Line: 2867
    -- upvalues: Humanoid (copy), u96 (ref), u95 (copy), u104 (ref), u103 (copy), CFrame_new_ret12 (ref)
    Humanoid.CameraOffset = Vector3.new(0, -0.25, 0) + (u96 or u95.Position) + (u104 or u103.Position);
    local v648 = Camera;
    v648.CFrame = v648.CFrame * CFrame_new_ret12;
end);
Run:BindToRenderStep("ViewmodelController", Enum.RenderPriority.Camera.Value + 2, function(p649) -- Line: 2872
    -- upvalues: u102 (ref), u101 (copy), u11 (ref), u23 (copy), CFrame_new_ret5 (ref), u10 (ref), u42 (ref), u17 (ref), CFrame_new_ret8 (ref), u12 (ref), u22 (ref), CFrame_new_ret9 (ref), CFrame_new_ret10 (ref), u15 (ref), u90 (ref), u16 (ref), CFrame_new_ret11 (ref)
    Camera.CFrame = Camera.CFrame + (u102 or u101.Position);
    local CFrame_new_ret14 = CFrame.new();

    if u11 then
        local Reload = u23.Local.Reload;
        local CFrame2 = u11.Root.CFrame;

        if not (Reload and (Reload.IsPlaying and CFrame2)) then
            CFrame2 = CFrame2:Lerp(CFrame.new(CFrame2.Position), 0.5);
        end;

        local v650 = Camera;
        v650.CFrame = v650.CFrame * CFrame_new_ret5:ToObjectSpace(CFrame2);
        CFrame_new_ret5 = CFrame2;
        CFrame_new_ret14 = CFrame2:ToObjectSpace(CFrame.new(CFrame2.Position));
    end;

    if not u10 or u10.Parent ~= VM_PARTS then
        return;
    end;

    local v651 = (CameraController:GetAttribute("ViewmodelCFrame") or Camera.CFrame) * CFrame_new_ret14;
    local v652 = u42 or u17;
    local v653 = v651 * CFrame_new_ret8;
    u10.WorldPivot = u12.CFrame;

    if u22 then
        u10:PivotTo(v653 * CFrame_new_ret9 * CFrame_new_ret10);
    else
        u10:PivotTo(v653);
        local v654, v655, v656 = v653:ToEulerAnglesXYZ();
        local CFrame2 = u15.CFrame;
        local v657 = CFrame.new(CFrame2.Position) * CFrame.Angles(v654, v655, v656);
        local v658 = v657:ToObjectSpace(CFrame2);
        u10.WorldPivot = CFrame2;
        u10:PivotTo(v657 * CFrame_new_ret9 * CFrame_new_ret10 * v658);
    end;

    local v659 = u90 and v652 and v652 or u16;
    u10.WorldPivot = v659.CFrame;
    u10:PivotTo(v659.CFrame * CFrame_new_ret11);
end);
InteractController:GetAttributeChangedSignal("Digging"):Connect(function() -- Line: 2907
    -- upvalues: u23 (copy), script_Parent (copy), u139 (copy), u149 (copy), SoundModule (copy), u155 (copy)
    local Dig = u23.Local.Dig;
    local PrimaryPart = script_Parent.PrimaryPart;
    local v660;

    if PrimaryPart then
        v660 = PrimaryPart:FindFirstChild(Dig and "DigWithShovel" or "DigWithHand");
    else
        v660 = nil;
    end;

    if InteractController:GetAttribute("Digging") then
        if Dig and not u139("Dig") then
            u149("Dig");
        end;

        if v660 then
            SoundModule:PlaySound(v660);
        end;

        return;
    end;

    u155("Dig");

    if v660 then
        SoundModule:StopSound(v660);
    end;
end);
u11 = workspace:FindFirstChild("CameraRoot");

if not u11 then
    u11 = CameraRoot:Clone();
    u11.Parent = workspace;
end;

VM_PARTS:ClearAllChildren();

for _, child in Camera:GetChildren() do
    if child:GetAttribute("_") == true then
        child:Destroy();
    end;
end;