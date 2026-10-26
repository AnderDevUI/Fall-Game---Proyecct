-- [PATH] ReplicatedStorage / CharacterScripts / NoclipController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Values = ReplicatedStorage:WaitForChild("Values");
local Modules = ReplicatedStorage:WaitForChild("Modules");

if Values:WaitForChild("ServerType").Value ~= "Build" then
    return;
end;

local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local HumanoidRootPart = script_Parent:WaitForChild("HumanoidRootPart");
local ChatController = PlayerScripts:WaitForChild("ChatController");
local ControlModule = require(PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"));
local v1;

while true do
    v1 = ReplicatedStorage:FindFirstChild("CombatServerRemote");

    if v1 then
        break;
    end;

    task.wait();
end;

local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Terrain };
RaycastParams_new_ret.IgnoreWater = true;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = 0;
local u8 = 0;
local u9 = nil;
local u10 = false;

local function u13(p11: string, p12: string) -- Line: 62
    -- upvalues: SettingsModule (copy), UserInputService (copy)
    local Setting = SettingsModule.GetSetting(p11, p12);

    if type(Setting) ~= "string" then
        return false;
    end;

    local success, result = pcall(function() -- Line: 65
        -- upvalues: Setting (copy)
        return Enum.KeyCode[Setting];
    end);

    if not (success and result) then
        return false;
    end;

    if p11 == "Gamepad" then
        return UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, result);
    end;

    return UserInputService:IsKeyDown(result);
end;

local function u17() -- Line: 75
    -- upvalues: UserInputService (copy), ChatController (copy), SettingsModule (copy), u13 (copy)
    if UserInputService:GetFocusedTextBox() or ChatController:GetAttribute("Typing") then
        return 0;
    end;

    local v14 = 0;
    local Setting = SettingsModule.GetSetting("Controls", "Jump");
    local v15;

    if type(Setting) == "string" then
        local success, result = pcall(function() -- Line: 65
            -- upvalues: Setting (copy)
            return Enum.KeyCode[Setting];
        end);

        if success and result then
            v15 = UserInputService:IsKeyDown(result);
        else
            v15 = false;
        end;
    else
        v15 = false;
    end;

    if v15 or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA) then
        v14 = v14 + 1;
    end;

    local Setting2 = SettingsModule.GetSetting("Controls", "Crouch");
    local v16;

    if type(Setting2) == "string" then
        local success, result = pcall(function() -- Line: 65
            -- upvalues: Setting2 (copy)
            return Enum.KeyCode[Setting2];
        end);

        if success and result then
            v16 = UserInputService:IsKeyDown(result);
        else
            v16 = false;
        end;
    else
        v16 = false;
    end;

    if v16 or u13("Gamepad", "Crouch") then
        v14 = v14 - 1;
    end;

    return v14;
end;

local function u24(p18: vector) -- Line: 87
    -- upvalues: u9 (ref), RaycastParams_new_ret (copy)
    if not u9 then
        return p18;
    end;

    local CFrame2 = u9.CFrame;
    local v19 = u9.Size / 2;
    local v20 = CFrame2:PointToObjectSpace(p18);
    local math_clamp_ret = math.clamp(v20.X, -v19.X, v19.X);
    local math_clamp_ret2 = math.clamp(v20.Y, -v19.Y, v19.Y);
    local math_clamp_ret3 = math.clamp(v20.Z, -v19.Z, v19.Z);
    local v21 = CFrame2:PointToWorldSpace((Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3)));
    local v22 = CFrame2.Position.Y + v19.Y;
    local v23 = workspace:Raycast(Vector3.new(v21.X, v22, v21.Z), Vector3.new(0, -u9.Size.Y, 0), RaycastParams_new_ret);

    if v23 then
        local math_min_ret = math.min(v23.Position.Y + u9.TerrainHeight, v22);

        if v21.Y < math_min_ret then
            v21 = Vector3.new(v21.X, math_min_ret, v21.Z);
        end;
    end;

    return v21;
end;

local function u36(p25: number) -- Line: 109
    -- upvalues: HumanoidRootPart (copy), Humanoid (copy), u4 (ref), workspace_CurrentCamera (copy), ControlModule (copy), u17 (copy), SettingsModule (copy), UserInputService (copy), u13 (copy), u10 (ref), u8 (ref), u7 (ref), u24 (copy), u5 (ref), u6 (ref)
    if not (HumanoidRootPart.Parent and (Humanoid.Parent and Humanoid.Health > 0)) then
        return;
    end;

    if Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
    end;

    if (HumanoidRootPart.Position - u4).Magnitude > 4 then
        u4 = HumanoidRootPart.Position;
    end;

    local CFrame2 = workspace_CurrentCamera.CFrame;
    local MoveVector = ControlModule:GetMoveVector();
    local v26 = CFrame2:VectorToWorldSpace((Vector3.new(MoveVector.X, 0, MoveVector.Z)));
    local v27 = u17();
    local v28 = v26 + Vector3.new(0, v27, 0);

    if v28.Magnitude > 1 then
        v28 = v28.Unit;
    end;

    local Setting = SettingsModule.GetSetting("Controls", "Sprint");
    local v29;

    if type(Setting) == "string" then
        local success, result = pcall(function() -- Line: 65
            -- upvalues: Setting (copy)
            return Enum.KeyCode[Setting];
        end);

        if success and result then
            v29 = UserInputService:IsKeyDown(result);
        else
            v29 = false;
        end;
    else
        v29 = false;
    end;

    local v30 = v29 or u13("Gamepad", "Sprint");
    local v31;

    if u10 then
        v31 = Vector3.new(0, 0, 0);
    else
        local v32;

        if v30 then
            v32 = u8;
        else
            v32 = u7;
        end;

        v31 = v28 * v32;
    end;

    local v33 = u24(u4 + v31 * p25);
    local v34 = (v33 - u4) / p25;
    u4 = v33;
    local Vector3_new_ret = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);
    local v35;

    if Vector3_new_ret.Magnitude > 0.01 then
        v35 = CFrame.lookAt(Vector3.new(0, 0, 0), Vector3_new_ret);
    else
        v35 = HumanoidRootPart.CFrame.Rotation;
    end;

    u5 = CFrame.new(u4) * v35;
    u6 = v34;
    HumanoidRootPart.CFrame = u5;
    HumanoidRootPart.AssemblyLinearVelocity = v34;
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

local function u38(p37: number) -- Line: 139
    -- upvalues: u5 (ref), HumanoidRootPart (copy), Humanoid (copy), u4 (ref), u6 (ref)
    if not (u5 and (HumanoidRootPart.Parent and (Humanoid.Parent and Humanoid.Health > 0))) then
        return;
    end;

    if (HumanoidRootPart.Position - u4).Magnitude > 4 + u6.Magnitude * p37 then
        return;
    end;

    HumanoidRootPart.CFrame = u5;
    HumanoidRootPart.AssemblyLinearVelocity = u6;
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

local function u39() -- Line: 148
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u10 (ref), HumanoidRootPart (copy), Humanoid (copy)
    if u2 then
        u2:Disconnect();
        u2 = nil;
    end;

    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u5 = nil;
    u10 = false;

    if not (HumanoidRootPart.Parent and (Humanoid.Parent and Humanoid.Health > 0)) then
        return;
    end;

    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    Humanoid:ChangeState(Enum.HumanoidStateType.Freefall);
end;

local function u43(p40: number, p41: number, p42: any) -- Line: 165
    -- upvalues: u7 (ref), u8 (ref), u9 (ref), u10 (ref), u4 (ref), u24 (copy), HumanoidRootPart (copy), u2 (ref), Humanoid (copy), RunService (copy), u36 (copy), u3 (ref), u38 (copy)
    u7 = p40;
    u8 = p41;
    u9 = p42;
    u10 = false;
    u4 = u24(HumanoidRootPart.Position);

    if u2 then
        return;
    end;

    Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
    u2 = RunService.PreSimulation:Connect(u36);
    u3 = RunService.PostSimulation:Connect(u38);
end;

v1.OnClientEvent:Connect(function(p44, ...) -- Line: 178
    -- upvalues: u43 (copy), u39 (copy), u10 (ref)
    if p44 ~= "Noclip" then
        if p44 == "NoclipFreeze" then
            u10 = ... == true;
        end;

        return;
    end;

    local v45, v46, v47, v48 = ...;

    if v45 == true and (type(v46) == "number" and (type(v47) == "number" and type(v48) == "table")) then
        u43(v46, v47, v48);

        return;
    end;

    u39();
end);
Humanoid.Died:Connect(u39);