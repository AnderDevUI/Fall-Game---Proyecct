-- [PATH] ReplicatedStorage / Modules / MobileAimAssist @Type ModuleScript


local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local Modules = ReplicatedStorage:WaitForChild("Modules");
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local MilitaryState = require(Modules:WaitForChild("MilitaryState"));
local Animals = workspace:WaitForChild("Animals");
local u1 = {
    workspace:WaitForChild("VFX"),
    workspace:WaitForChild("Drops"),
    workspace:WaitForChild("Plants"),
    Animals
};
local u2 = RaycastUtil:FilterFunction("View");
local u3 = {
    Friction = 1,
    Pull = Vector2.zero
};
local u4 = nil;
local u5 = 0;

local function _(p6: string, p7: number) -- Line: 45
    local Attribute = script:GetAttribute(p6);

    if type(Attribute) == "number" then
        return Attribute;
    end;

    return p7;
end;

local function u12(p8, p9: vector) -- Line: 51
    local v10 = p8:PointToObjectSpace(p9);
    local math_sqrt_ret = math.sqrt(v10.X * v10.X + v10.Z * v10.Z);
    local math_atan2_ret = math.atan2(v10.X, -v10.Z);
    local math_atan2_ret2 = math.atan2(v10.Y, math_sqrt_ret);
    local v11 = p8.LookVector:Dot((p9 - p8.Position).Unit);
    local math_clamp_ret = math.clamp(v11, -1, 1);

    return math.acos(math_clamp_ret), math_atan2_ret, math_atan2_ret2;
end;

local function _(p13: userdata?) -- Line: 60
    local v14;

    if p13 == nil or p13.Health <= 0 then
        v14 = false;
    else
        v14 = not p13:GetAttribute("Downed");
    end;

    return v14;
end;

local function _(p15: any, p16: userdata) -- Line: 65
    -- upvalues: MilitaryState (copy)
    local v17;

    if MilitaryState.Entries[p15.Id] == p15 then
        v17 = p15.Visual == p16;
    else
        v17 = false;
    end;

    return v17;
end;

local function u21(p18: userdata?, p19: userdata?) -- Line: 71
    -- upvalues: MobileModule (copy), SettingsModule (copy)
    if not (p18 and p19) then
        return false;
    end;

    if not MobileModule.IsTouchOnly() then
        return false;
    end;

    if SettingsModule.GetSetting("Mobile", "Mobile Aim Assist") ~= true then
        return false;
    end;

    if SettingsModule.MainMenuOpen() then
        return false;
    end;

    local Humanoid = p18:FindFirstChild("Humanoid");
    local v20;

    if Humanoid == nil or Humanoid.Health <= 0 then
        v20 = false;
    else
        v20 = not Humanoid:GetAttribute("Downed");
    end;

    if not v20 then
        return false;
    end;

    if p19:GetAttribute("EquippedType") ~= "Gun" then
        return false;
    end;

    local InventoryController = p18:FindFirstChild("InventoryController");
    local WheelController = p18:FindFirstChild("WheelController");
    local TeamNavigationController = p18:FindFirstChild("TeamNavigationController");

    return not (InventoryController and InventoryController:GetAttribute("Open") or (WheelController and WheelController:GetAttribute("Open") or TeamNavigationController and TeamNavigationController:GetAttribute("MapOpen")));
end;

local function u25(p22: userdata) -- Line: 87
    local v23 = {};
    local TeamNavigationController = p22:FindFirstChild("TeamNavigationController");

    if TeamNavigationController then
        TeamNavigationController = TeamNavigationController:FindFirstChild("FetchTeam");
    end;

    if TeamNavigationController then
        TeamNavigationController = TeamNavigationController:Invoke();
    end;

    for _, v in type(TeamNavigationController) == "table" and TeamNavigationController and TeamNavigationController or {} do
        local v24 = tonumber(v);

        if v24 then
            v23[v24] = true;
        end;
    end;

    return v23;
end;

local function _(u26: userdata?) -- Line: 99
    return function() -- Line: 100
        -- upvalues: u26 (copy)
        return u26 and (u26.Parent and u26.Position) or nil;
    end;
end;

local function _(u27: userdata?) -- Line: 106
    return function() -- Line: 107
        -- upvalues: u27 (copy)
        if u27 and u27.Parent then
            return u27:GetBoundingBox().Position;
        end;

        return nil;
    end;
end;

local function u37(p28: userdata) -- Line: 113
    -- upvalues: u25 (copy), Players (copy), LocalPlayer (copy), MilitaryState (copy), Animals (copy)
    local v29 = u25(p28);
    local v30 = {};
    local v31 = {};

    for _, v in Players:GetPlayers() do
        if not (v == LocalPlayer or (v29[v.UserId] or v.Team ~= nil and v.Team == LocalPlayer.Team) or (v:GetAttribute("SafeZone") or v:GetAttribute("DamageDisabled"))) then
            local Character = v.Character;
            local v32;

            if Character then
                v32 = Character:FindFirstChild("Humanoid");
            else
                v32 = Character;
            end;

            local u33;

            if Character then
                u33 = Character:FindFirstChild("UpperTorso");
            else
                u33 = Character;
            end;

            local v34;

            if v32 == nil or v32.Health <= 0 then
                v34 = false;
            else
                v34 = not v32:GetAttribute("Downed");
            end;

            if v34 and u33 then
                table.insert(v30, {
                    Model = Character,
                    Humanoid = v32,

                    Point = function() -- Line: 100
                        -- upvalues: u33 (copy)
                        return u33 and (u33.Parent and u33.Position) or nil;
                    end
                });
            end;
        end;
    end;

    for _, v in MilitaryState.Entries do
        local Visual = v.Visual;
        local u35;

        if Visual then
            u35 = Visual:FindFirstChild("UpperTorso");
        else
            u35 = Visual;
        end;

        if u35 then
            table.insert(v31, {
                Model = Visual,
                Soldier = v,

                Point = function() -- Line: 100
                    -- upvalues: u35 (copy)
                    return u35 and (u35.Parent and u35.Position) or nil;
                end
            });
        end;
    end;

    for _, child in Animals:GetChildren() do
        local Humanoid = child:FindFirstChild("Humanoid");
        local Detail = child:FindFirstChild("Detail");
        local v36;

        if Humanoid == nil or Humanoid.Health <= 0 then
            v36 = false;
        else
            v36 = not Humanoid:GetAttribute("Downed");
        end;

        if v36 and Detail then
            table.insert(v31, {
                Model = child,
                Humanoid = Humanoid,

                Point = function() -- Line: 107
                    -- upvalues: Detail (copy)
                    if Detail and Detail.Parent then
                        return Detail:GetBoundingBox().Position;
                    end;

                    return nil;
                end
            });
        end;
    end;

    return v30, v31;
end;

local function u43(p38: userdata, p39, p40: any, p41: vector) -- Line: 141
    -- upvalues: u1 (copy), RaycastUtil (copy), u2 (copy)
    local v42 = { p38, p40.Model };

    for _, v in u1 do
        table.insert(v42, v);
    end;

    return RaycastUtil:Raycast(p39.Position, p41 - p39.Position, "Blacklist", v42, false, u2, true) == nil;
end;

local function u55(p44: userdata, p45, p46: table, p47: number, p48: number) -- Line: 149
    -- upvalues: u12 (copy), u43 (copy)
    local v49 = {};

    for _, v in p46 do
        local v50 = v.Point();

        if v50 and p48 >= (v50 - p45.Position).Magnitude then
            local v51 = u12(p45, v50);

            if p47 >= v51 then
                v.Angle = v51;
                table.insert(v49, v);
            end;
        end;
    end;

    table.sort(v49, function(p52, p53) -- Line: 159
        return p52.Angle < p53.Angle;
    end);

    for i = 1, math.min(#v49, 4) do
        local v54 = v49[i];

        if u43(p44, p45, v54, v54.Point()) then
            return v54;
        end;

        local _ = i;
    end;

    return nil;
end;

local function _() -- Line: 167
    -- upvalues: u4 (ref), u3 (copy)
    u4 = nil;
    u3.Friction = 1;
    u3.Pull = Vector2.zero;
end;

RunService:BindToRenderStep("MobileAimAssist", Enum.RenderPriority.Camera.Value - 1, function(p56) -- Line: 173
    -- upvalues: LocalPlayer (copy), u21 (copy), u4 (ref), u3 (copy), u5 (ref), u37 (copy), u55 (copy), MilitaryState (copy), u12 (copy)
    local Character = LocalPlayer.Character;
    local v57;

    if Character then
        v57 = Character:FindFirstChild("ViewmodelController");
    else
        v57 = Character;
    end;

    if not u21(Character, v57) then
        if u4 then
            u4 = nil;
            u3.Friction = 1;
            u3.Pull = Vector2.zero;
        end;

        return;
    end;

    local CFrame = workspace.CurrentCamera.CFrame;
    local v58 = v57:GetAttribute("Aiming") == true;
    local v59, v60;

    if v58 then
        local Attribute = script:GetAttribute("AdsCone");
        v59 = type(Attribute) ~= "number" and 5 or Attribute;

        if not v59 then
            v60 = script:GetAttribute("HipCone");
            v59 = type(v60) ~= "number" and 4 or v60;
        end;
    else
        v60 = script:GetAttribute("HipCone");
        v59 = type(v60) ~= "number" and 4 or v60;
    end;

    local math_rad_ret = math.rad(v59);
    local Attribute = script:GetAttribute("MaxRange");
    local v61 = type(Attribute) ~= "number" and 300 or Attribute;
    local os_clock_ret = os.clock();

    if os_clock_ret - u5 >= 0.1 then
        u5 = os_clock_ret;
        local v62, v63 = u37(Character);
        u4 = u55(Character, CFrame, v62, math_rad_ret, v61) or u55(Character, CFrame, v63, math_rad_ret, v61);
    end;

    local v64 = u4;

    if v64 then
        if u4.Soldier then
            local Soldier = u4.Soldier;
            local Model = u4.Model;

            if MilitaryState.Entries[Soldier.Id] == Soldier then
                v64 = Soldier.Visual == Model;
            else
                v64 = false;
            end;
        else
            local Humanoid = u4.Humanoid;

            if Humanoid == nil or Humanoid.Health <= 0 then
                v64 = false;
            else
                v64 = not Humanoid:GetAttribute("Downed");
            end;
        end;

        if v64 then
            v64 = u4.Point();
        end;
    end;

    if not v64 then
        u4 = nil;
        u3.Friction = 1;
        u3.Pull = Vector2.zero;

        return;
    end;

    local v65, v66, v67 = u12(CFrame, v64);

    if math_rad_ret * 1.5 < v65 then
        u4 = nil;
        u3.Friction = 1;
        u3.Pull = Vector2.zero;

        return;
    end;

    local v68, v69;

    if v58 then
        local Attribute2 = script:GetAttribute("AdsFriction");
        v68 = type(Attribute2) ~= "number" and 0.75 or Attribute2;

        if not v68 then
            v69 = script:GetAttribute("HipFriction");
            v68 = type(v69) ~= "number" and 0.8 or v69;
        end;
    else
        v69 = script:GetAttribute("HipFriction");
        v68 = type(v69) ~= "number" and 0.8 or v69;
    end;

    u3.Friction = v68;
    local v70, v71;

    if v58 then
        local Attribute2 = script:GetAttribute("AdsPullRate");
        v70 = type(Attribute2) ~= "number" and 1.8 or Attribute2;

        if not v70 then
            v71 = script:GetAttribute("HipPullRate");
            v70 = type(v71) ~= "number" and 1.5 or v71;
        end;
    else
        v71 = script:GetAttribute("HipPullRate");
        v70 = type(v71) ~= "number" and 1.5 or v71;
    end;

    local v72, v73;

    if v58 then
        local Attribute2 = script:GetAttribute("AdsPullMax");
        v72 = type(Attribute2) ~= "number" and 7 or Attribute2;

        if not v72 then
            v73 = script:GetAttribute("HipPullMax");
            v72 = type(v73) ~= "number" and 6 or v73;
        end;
    else
        v73 = script:GetAttribute("HipPullMax");
        v72 = type(v73) ~= "number" and 6 or v73;
    end;

    local v74 = math.rad(v72) * p56;
    local math_min_ret = math.min(v70 * p56, 1);
    u3.Pull = Vector2.new(math.clamp(v66 * math_min_ret, -v74, v74), (math.clamp(-v67 * math_min_ret, -v74, v74)));
end);

return u3;