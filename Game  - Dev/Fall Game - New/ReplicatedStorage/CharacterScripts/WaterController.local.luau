-- [PATH] ReplicatedStorage / CharacterScripts / WaterController @Type LocalScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local SoundService = game:GetService("SoundService");
local Players = game:GetService("Players");
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local u1 = require(Modules:WaitForChild("AssetContainer"))();
local VFX = ReplicatedStorage:WaitForChild("VFX");
local script_Parent = script.Parent;
local u2 = nil;
local u3 = nil;
local u4 = nil;

while true do
    u2 = u2 or script_Parent:FindFirstChild("Humanoid");
    u3 = u3 or script_Parent:FindFirstChild("HumanoidRootPart");
    u4 = u4 or script_Parent:FindFirstChild("Head");

    if u2 and (u3 and u4) then
        break;
    end;

    task.wait(0.1);
end;

local LocalPlayer = Players.LocalPlayer;
local Main = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main");
local Stats = Main:WaitForChild("Stats");
local DivingGoggles = Main:WaitForChild("DivingGoggles");
local WaterBlur = Lighting:WaitForChild("WaterBlur");
local WaterColorCorrection = Lighting:WaitForChild("WaterColorCorrection");
local Bubbles = VFX:WaitForChild("Bubbles");
local u5 = 0.9;
local u6 = tick();
local u7 = tick();
local u8 = false;

local function _(p9) -- Line: 78
    -- upvalues: u6 (ref), u1 (copy)
    if tick() - u6 >= 1 then
        u6 = tick();
        u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\126\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\049\045\194\183\239\191\189\195\179\194\171\239\191\189\239\191\189\239\191\189\239\191\189", p9);
    end;
end;

local function _(p10) -- Line: 87
    -- upvalues: NumberUtil (copy)
    local v11 = NumberUtil:Lerp(90, 10, p10 / 4);

    return math.ceil(v11);
end;

local function v19() -- Line: 95
    -- upvalues: u3 (ref), RaycastUtil (copy), NumberUtil (copy), u4 (ref), Stats (copy), u6 (ref), u1 (copy)
    local Vector3_new_ret = Vector3.new(u3.Position.X, u3.Position.Y + 1.5, u3.Position.Z);
    local _, v12, _, v13 = RaycastUtil:Raycast(Vector3_new_ret, Vector3.new(0, -5, 0), "Whitelist", workspace.Terrain);
    local v14 = 0;

    if v13 == Enum.Material.Water then
        local Magnitude = (Vector3_new_ret - v12).Magnitude;

        if Magnitude <= 0.35 then
            script:SetAttribute("IsSwim", true);
            v14 = 100;
        else
            script:SetAttribute("InWater", true);
            local v15 = NumberUtil:Lerp(90, 10, Magnitude / 4);
            v14 = math.ceil(v15);
        end;

        script:SetAttribute("IsUnder", false);
    else
        local v16 = Region3.new(u4.Position - u4.Size / 2, u4.Position + u4.Size / 2):ExpandToGrid(4);
        local u17, _ = workspace.Terrain:ReadVoxels(v16, 4);
        local u18 = nil;

        if pcall(function() -- Line: 120
            -- upvalues: u18 (ref), u17 (copy)
            u18 = u17[1][1][1];
        end) and u18 == Enum.Material.Water then
            script:SetAttribute("IsSwim", true);
            script:SetAttribute("IsUnder", true);
            v14 = 100;
        else
            script:SetAttribute("InWater", false);
            script:SetAttribute("IsSwim", false);
            script:SetAttribute("IsUnder", false);
        end;
    end;

    local Wet = Stats:FindFirstChild("Wet");

    if Wet and (Wet:GetAttribute("Reach") and v14 > 0) then
        if Wet:GetAttribute("Reach") < v14 and tick() - u6 >= 1 then
            u6 = tick();
            u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\126\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\049\045\194\183\239\191\189\195\179\194\171\239\191\189\239\191\189\239\191\189\239\191\189", v14);
        end;
    elseif Wet == nil and (v14 > 0 and tick() - u6 >= 1) then
        u6 = tick();
        u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\126\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\049\045\194\183\239\191\189\195\179\194\171\239\191\189\239\191\189\239\191\189\239\191\189", v14);
    end;
end;

local function u22(p20) -- Line: 147
    -- upvalues: u3 (ref), script_Parent (copy), u2 (ref)
    u3.CustomPhysicalProperties = PhysicalProperties.new(p20, 0.3, 0.5);

    if not script_Parent.Parent or u2.SeatPart then
        return;
    end;

    local v21 = p20 == 0.2;

    for _, child in pairs(script_Parent:GetChildren()) do
        if child ~= u3 and not (child.Name:find("Torso") or (child.Name == "Head" or not child:IsA("BasePart"))) then
            child.Massless = v21;
        end;
    end;
end;

local function u23() -- Line: 157
    -- upvalues: u8 (ref), u5 (ref), u22 (copy)
    if u8 and script:GetAttribute("IsSwim") then
        u5 = 0.2;
        u22(u5);

        return;
    end;

    if not script:GetAttribute("InWater") then
        if u5 ~= 0.9 then
            u5 = 0.9;
            u22(u5);
        end;

        return;
    end;

    u5 = 0.6;
    u22(u5);
end;

local function u27(p24) -- Line: 171
    -- upvalues: WaterBlur (copy), LocalPlayer (copy), WaterColorCorrection (copy), SoundService (copy), script_Parent (copy), Bubbles (copy)
    local v25;

    if p24 then
        v25 = not LocalPlayer:GetAttribute("Armor_HasGoggles");
    else
        v25 = p24;
    end;

    WaterBlur.Enabled = v25;
    WaterColorCorrection.Enabled = p24;
    script.Ambient.Volume = p24 and 0.2 or 0;
    SoundService.AmbientReverb = p24 and Enum.ReverbType.UnderWater or Enum.ReverbType.NoReverb;
    workspace.Terrain.WaterTransparency = p24 and 0.03 or 0.04;
    local Head = script_Parent:FindFirstChild("Head");

    if not Head then
        return;
    end;

    local Bubbles2 = Head:FindFirstChild("Bubbles");

    if not p24 or Bubbles2 then
        if not p24 and Bubbles2 then
            Bubbles2:Destroy();
        end;

        return;
    end;

    local v26 = Bubbles:Clone();
    v26.Name = "Bubbles";
    v26.Parent = Head;
end;

u2:SetStateEnabled(Enum.HumanoidStateType.Swimming, false);
u2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
script:GetAttributeChangedSignal("IsSwim"):Connect(function() -- Line: 193
    -- upvalues: u3 (ref), u23 (copy)
    if not script:GetAttribute("IsSwim") then
        u23();

        return;
    end;

    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.Name = "WaterForce";
    BodyVelocity.Parent = u3;
    u23();
    task.wait(0.03333333333333333);
    BodyVelocity:Destroy();
end);
script:GetAttributeChangedSignal("IsUnder"):Connect(function() -- Line: 214
    -- upvalues: u27 (copy), u7 (ref), u1 (copy)
    local Attribute = script:GetAttribute("IsUnder");
    u27(Attribute);

    if not Attribute and tick() - u7 >= 1 then
        u7 = tick();
        u1(
            "Fire",
            "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033",
            "\104\239\191\189\043\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\169\239\191\189\195\156\046\239\191\189\239\191\189\195\165\239\191\189\239\191\189\239\191\189\046\195\145"
        );
    end;
end);
UserInputService.InputBegan:Connect(function(p28) -- Line: 224
    -- upvalues: SettingsModule (copy), u8 (ref), u23 (copy), script_Parent (copy)
    if p28.UserInputType == Enum.UserInputType.Keyboard then
        if p28.KeyCode.Name == SettingsModule.GetSetting("Controls", "Jump") then
            u8 = true;
            u23();
        end;
    elseif p28.UserInputType == Enum.UserInputType.Gamepad1 then
        local TeamNavigationController = script_Parent:FindFirstChild("TeamNavigationController");

        if TeamNavigationController and TeamNavigationController:GetAttribute("MapOpen") then
            return;
        end;

        if p28.KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Jump") then
            u8 = true;
            u23();
        end;
    end;
end);
UserInputService.InputEnded:Connect(function(p29) -- Line: 242
    -- upvalues: SettingsModule (copy), u8 (ref), u23 (copy)
    if p29.UserInputType == Enum.UserInputType.Keyboard then
        if p29.KeyCode.Name == SettingsModule.GetSetting("Controls", "Jump") then
            u8 = false;
            u23();
        end;
    elseif p29.UserInputType == Enum.UserInputType.Gamepad1 and p29.KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Jump") then
        u8 = false;
        u23();
    end;
end);
script:WaitForChild("MobileJump").Event:Connect(function(p30) -- Line: 260
    -- upvalues: u8 (ref), u23 (copy)
    u8 = p30;
    u23();
end);
LocalPlayer:GetAttributeChangedSignal("Armor_HasGoggles"):Connect(function() -- Line: 265
    -- upvalues: LocalPlayer (copy), DivingGoggles (copy), u27 (copy)
    DivingGoggles.Visible = LocalPlayer:GetAttribute("Armor_HasGoggles");
    u27(script:GetAttribute("IsUnder"));
end);
WaterBlur.Enabled = false;
WaterColorCorrection.Enabled = false;
script.Ambient.Volume = 0;
SoundService.AmbientReverb = Enum.ReverbType.NoReverb;
workspace.Terrain.WaterTransparency = 0.04;
local Head = script_Parent:FindFirstChild("Head");

if Head then
    local Bubbles2 = Head:FindFirstChild("Bubbles");

    if Bubbles2 then
        Bubbles2:Destroy();
    end;
end;

while u2.Health > 0 do
    v19();
    task.wait(0.2);
end;

WaterBlur.Enabled = false;
WaterColorCorrection.Enabled = false;
script.Ambient.Volume = 0;
SoundService.AmbientReverb = Enum.ReverbType.NoReverb;
workspace.Terrain.WaterTransparency = 0.04;
local Head2 = script_Parent:FindFirstChild("Head");
local v31 = Head2 and Head2:FindFirstChild("Bubbles");

if v31 then
    v31:Destroy();
end;