-- [PATH] ReplicatedStorage / CharacterScripts / StateController @Type LocalScript


local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Drops = workspace:WaitForChild("Drops");
local VFX = workspace:WaitForChild("VFX");
local Animals = workspace:WaitForChild("Animals");
local Plants = workspace:WaitForChild("Plants");
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local GamepadIconModule = require(Modules:WaitForChild("GamepadIconModule"));
local LocalPlayer = Players.LocalPlayer;
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local script_Parent = script.Parent;
local u1 = nil;
local u2 = nil;
local v3 = nil;

while true do
    u1 = u1 or script_Parent:FindFirstChild("Humanoid");
    u2 = u2 or script_Parent:FindFirstChild("HumanoidRootPart");
    v3 = v3 or script_Parent:FindFirstChild("Head");

    if u1 and (u2 and v3) then
        break;
    end;

    task.wait(0.1);
end;

local ViewmodelController = script_Parent:WaitForChild("ViewmodelController");
local InventoryController = script_Parent:WaitForChild("InventoryController");
local WaterController = script_Parent:WaitForChild("WaterController");
local WheelController = script_Parent:WaitForChild("WheelController");
local TeamNavigationController = script_Parent:WaitForChild("TeamNavigationController");
local WeatherController = PlayerScripts:WaitForChild("WeatherController");
local PreferredInputController = PlayerScripts:WaitForChild("PreferredInputController");
local ChatController = PlayerScripts:WaitForChild("ChatController");
local ControlModule = require(PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"));

local function getDeadzone() -- Line: 67
    -- upvalues: PreferredInputController (copy)
    return PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225;
end;

local function isTouch() -- Line: 68
    -- upvalues: PreferredInputController (copy)
    return PreferredInputController:GetAttribute("PreferredInput") == "Touch";
end;

local Main = PlayerGui:WaitForChild("Main");
local GamepadControls = Main:WaitForChild("GamepadControls");
local Codelock = Main:WaitForChild("Codelock");
local GamepadImage = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("Info"):WaitForChild("Action"):WaitForChild("GamepadImage");
local TopControls = GamepadControls:WaitForChild("TopControls");
local ToolTip = GamepadControls:WaitForChild("ToolTip");
GamepadControls:WaitForChild("Interaction");
local v4 = {};

for _, child in pairs(ToolTip:GetChildren()) do
    if child:IsA("TextLabel") then
        table.insert(v4, child);
    end;
end;

local v5 = tick();
local v6 = RaycastUtil:FilterFunction("View");
GamepadIconModule.RegisterSetting(TopControls.Inventory.ImageLabel, "Gamepad", "Open Inventory/Crafting");
GamepadIconModule.RegisterSetting(TopControls.Interact.ImageLabel, "Gamepad", "Jump");
GamepadIconModule.Register(TopControls.ToggleUINavigation.ImageLabel, "ButtonB");
GamepadIconModule.RegisterSetting(TopControls.OpenMap.ImageLabel, "Gamepad", "Open Map");
GamepadIconModule.RegisterSetting(TopControls.OpenChat.ImageLabel, "Gamepad", "Open Map");
local u7 = false;
local u8 = {
    Left = false,
    Right = false,
    Forward = false,
    Backward = false,
    Sprint = false,
    Crouch = false
};
local u9 = false;
local u10 = false;
local v11 = false;

for _, child in TopControls:GetChildren() do
    if child:IsA("TextLabel") and child.Text == " - Equip Items" then
        GamepadIconModule.RegisterSetting(child.ImageLabel, "Gamepad", "Toolbar Right");
    end;
end;

GamepadIconModule.RegisterSetting(GamepadControls.ToolbarRight.ImageLabel, "Gamepad", "Toolbar Right");
GamepadIconModule.RegisterSetting(GamepadControls.ToolbarLeft.ImageLabel, "Gamepad", "Toolbar Left");
GamepadIconModule.RegisterSetting(ToolTip.DragEntry.ImageLabel, "Gamepad", "Jump");
GamepadIconModule.RegisterSetting(ToolTip.MenuEntry.ImageLabel, "Gamepad", "Interact/Reload");
GamepadIconModule.RegisterSetting(GamepadImage, "Gamepad", "Interact/Reload");
local u12 = TopControls.ToggleUINavigation:Clone();
u12.Name = "Crouch";
u12.Text = " - Crouch";
u12.Parent = TopControls;
GamepadIconModule.RegisterSetting(u12.ImageLabel, "Gamepad", "Crouch");
local v13 = SettingsModule.GetSetting("Gamepad", "Crouch") == "ButtonB";
TopControls.ToggleUINavigation.Text = v13 and " - Crouch / Close Menu" or " - Close Menu";
u12.Visible = not v13;
ReplicatedStorage:GetAttributeChangedSignal("Settings"):Connect(function() -- Line: 127
    -- upvalues: SettingsModule (copy), TopControls (copy), u12 (copy)
    local v14 = SettingsModule.GetSetting("Gamepad", "Crouch") == "ButtonB";
    TopControls.ToggleUINavigation.Text = v14 and " - Crouch / Close Menu" or " - Close Menu";
    u12.Visible = not v14;
end);
task.spawn(function() -- Line: 134
    -- upvalues: SettingsModule (copy), TopControls (copy), u12 (copy)
    while not SettingsModule.Settings do
        task.wait(0.5);
    end;

    local v15 = SettingsModule.GetSetting("Gamepad", "Crouch") == "ButtonB";
    TopControls.ToggleUINavigation.Text = v15 and " - Crouch / Close Menu" or " - Close Menu";
    u12.Visible = not v15;
end);

local function v17() -- Line: 139
    -- upvalues: PreferredInputController (copy), GamepadControls (copy), TeamNavigationController (copy)
    local v16;

    if PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
        v16 = not TeamNavigationController:GetAttribute("MapOpen");
    else
        v16 = false;
    end;

    GamepadControls.Visible = v16;
end;

local function u33() -- Line: 145
    -- upvalues: u8 (copy), u1 (ref), PreferredInputController (copy), InventoryController (copy), WheelController (copy), TeamNavigationController (copy), Codelock (copy), SettingsModule (copy), ChatController (copy), u9 (ref), u7 (ref), ViewmodelController (copy), WaterController (copy), u10 (ref), LocalPlayer (copy), u2 (ref)
    local v18 = "";
    local Forward = u8.Forward;
    local Backward = u8.Backward;

    if Forward and not Backward then
        v18 = v18 .. "Forward";
    elseif Backward and not Forward then
        v18 = v18 .. "Backward";
    end;

    if u8.Left and not u8.Right then
        v18 = v18 .. "Left";
    elseif u8.Right and not u8.Left then
        v18 = v18 .. "Right";
    end;

    local v19 = u1.SeatPart ~= nil;
    local v20 = v19 and "" or v18;
    local v21 = PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    local v22 = InventoryController:GetAttribute("Open") and v21;
    local v23 = WheelController:GetAttribute("Open") and v21;
    local v24 = TeamNavigationController:GetAttribute("MapOpen") and v21;
    local v25 = Codelock.Visible and v21;
    local v26 = SettingsModule.MainMenuOpen() and v21;
    local v27 = ChatController:GetAttribute("Typing") and v21;
    local v28;

    if v21 or PreferredInputController:GetAttribute("PreferredInput") == "Touch" then
        v28 = u9;
    else
        v28 = v20 == "Forward";
    end;

    if u8.Sprint then
        u7 = true;
    elseif not v28 then
        u7 = false;
    end;

    local Attribute = ViewmodelController:GetAttribute("Aiming");
    local Attribute2 = ViewmodelController:GetAttribute("Using");
    local Attribute3 = WaterController:GetAttribute("IsSwim");
    local v29;

    if u10 then
        v29 = not v19;
    else
        v29 = u8.Crouch and not v19;
    end;

    local v30 = u7;

    if v30 then
        if v28 then
            local v31 = v19 or (v29 or (Attribute or (Attribute2 and not ViewmodelController:GetAttribute("CanUse") or (Attribute3 or script:GetAttribute("IsClimbing")))));
            v28 = not v31;
        end;
    else
        v28 = v30;
    end;

    local v32 = (u1:GetAttribute("DamageConnections") or 0) > 0;
    script:SetAttribute("Direction", v20);
    script:SetAttribute("IsSprint", v28);
    script:SetAttribute("IsCrouch", v29);
    script:SetAttribute("IsSlowed", v32);
    script:SetAttribute("SprintInput", u8.Sprint);
    script:SetAttribute("CrouchInput", u8.Crouch);
    u1.WalkSpeed = (v22 or (v23 or (v24 or (v25 or (v26 or v27))))) and 0 or (u1:GetAttribute("Downed") and 0 or (v29 and 6.5 or (v28 and 18 or 11)) * (Attribute and 0.8 or 1) * (v32 and 0.3 or 1)) * (ViewmodelController:GetAttribute("SReduction") or 1) * (LocalPlayer:GetAttribute("Armor_HasFlippers") and (Attribute3 and 1.5 or 0.5) or 1);
    u1.HipHeight = v29 and 1.1 or 1.6;
    u1.MaxSlopeAngle = Attribute3 and 80 or 60;
    u1.JumpHeight = v32 and 0 or 3.25;
    u2.Size = Vector3.new(2, v29 and 2.1 or 2.5, 2);
end;

local function u38() -- Line: 251
    -- upvalues: PreferredInputController (copy), ControlModule (copy), u8 (copy), u9 (ref), u33 (copy)
    if PreferredInputController:GetAttribute("PreferredInput") ~= "Touch" then
        return;
    end;

    local MoveVector = ControlModule:GetMoveVector();
    local X = MoveVector.X;
    local v34 = -MoveVector.Z;
    local v35 = PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225;
    local v36 = false;

    for i, v in {
        Forward = v35 < v34,
        Backward = v34 < -v35,
        Right = v35 < X,
        Left = X < -v35
    } do
        if u8[i] ~= v then
            u8[i] = v;
            v36 = true;
        end;
    end;

    local v37;

    if v35 < v34 then
        v37 = math.abs(X) <= math.max(v35, v34 * 0.6248693519093275);
    else
        v37 = false;
    end;

    if v37 ~= u9 then
        u9 = v37;
        v36 = true;
    end;

    if v36 then
        u33();
    end;
end;

UserInputService.InputChanged:Connect(function(p39: userdata) -- Line: 210
    -- upvalues: PreferredInputController (copy), u8 (copy), u9 (ref), u33 (copy)
    if PreferredInputController:GetAttribute("PreferredInput") ~= "Gamepad" then
        return;
    end;

    if p39.UserInputType ~= Enum.UserInputType.Gamepad1 then
        return;
    end;

    if p39.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return;
    end;

    local Position = p39.Position;
    local X = Position.X;
    local Y = Position.Y;
    local v40 = PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225;
    local v41 = false;

    for i, v in {
        Forward = v40 < Y,
        Backward = Y < -v40,
        Right = v40 < X,
        Left = X < -v40
    } do
        if u8[i] ~= v then
            u8[i] = v;
            v41 = true;
        end;
    end;

    local v42;

    if v40 < Y then
        v42 = math.abs(X) <= math.max(v40, Y * 0.4663076581549986);
    else
        v42 = false;
    end;

    if v42 ~= u9 then
        u9 = v42;
        v41 = true;
    end;

    if v41 then
        u33();
    end;
end);
UserInputService.InputBegan:Connect(function(p43) -- Line: 286
    -- upvalues: SettingsModule (copy), PreferredInputController (copy), TeamNavigationController (copy), Codelock (copy), InventoryController (copy), UserInputService (copy), u8 (copy), ChatController (copy), u33 (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
        local v44 = TeamNavigationController:GetAttribute("MapOpen") or tick() - (TeamNavigationController:GetAttribute("MapClosedTick") or 0) < 0.15;
        local v45 = Codelock and Codelock.Visible;

        if InventoryController:GetAttribute("Open") or (v44 or (v45 or tick() - (InventoryController:GetAttribute("ClosedTick") or 0) < 0.15)) then
            return;
        end;
    end;

    local UserInputType = p43.UserInputType;
    local FocusedTextBox = UserInputService:GetFocusedTextBox();

    if not (UserInputType ~= Enum.UserInputType.Keyboard and UserInputType ~= Enum.UserInputType.Gamepad1 or FocusedTextBox) then
        local Name = p43.KeyCode.Name;
        local v46 = false;

        if Name == SettingsModule.GetSetting("Controls", "Move Forward") then
            u8.Forward = true;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Backward") then
            u8.Backward = true;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Right") then
            u8.Right = true;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Left") then
            u8.Left = true;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Sprint") then
            u8.Sprint = not SettingsModule.GetSetting("Controls", "Toggle Sprint") and true or not u8.Sprint;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Crouch") then
            u8.Crouch = not SettingsModule.GetSetting("Controls", "Toggle Crouch") and true or not u8.Crouch;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Gamepad", "Sprint") then
            u8.Sprint = not SettingsModule.GetSetting("Gamepad", "Toggle Sprint") and true or not u8.Sprint;
            v46 = true;
        elseif Name == SettingsModule.GetSetting("Gamepad", "Crouch") and not ChatController:GetAttribute("Typing") then
            u8.Crouch = not SettingsModule.GetSetting("Gamepad", "Toggle Crouch") and true or not u8.Crouch;
            v46 = true;
        end;

        if not v46 then
            return;
        end;

        u33();
    end;
end);
UserInputService.InputEnded:Connect(function(p47) -- Line: 327
    -- upvalues: PreferredInputController (copy), TeamNavigationController (copy), Codelock (copy), InventoryController (copy), UserInputService (copy), u8 (copy), u9 (ref), SettingsModule (copy), u33 (copy)
    if PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
        local v48 = TeamNavigationController:GetAttribute("MapOpen") or tick() - (TeamNavigationController:GetAttribute("MapClosedTick") or 0) < 0.15;
        local v49 = Codelock and Codelock.Visible;

        if InventoryController:GetAttribute("Open") or (v48 or (v49 or tick() - (InventoryController:GetAttribute("ClosedTick") or 0) < 0.15)) then
            return;
        end;
    end;

    local UserInputType = p47.UserInputType;
    local FocusedTextBox = UserInputService:GetFocusedTextBox();

    if not (UserInputType ~= Enum.UserInputType.Keyboard and UserInputType ~= Enum.UserInputType.Gamepad1 or FocusedTextBox) then
        local Name = p47.KeyCode.Name;
        local v50 = false;

        if p47.KeyCode == Enum.KeyCode.Thumbstick1 and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
            u8.Forward = false;
            u8.Backward = false;
            u8.Right = false;
            u8.Left = false;
            u9 = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Forward") then
            u8.Forward = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Backward") then
            u8.Backward = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Right") then
            u8.Right = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Move Left") then
            u8.Left = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Sprint") and not SettingsModule.GetSetting("Controls", "Toggle Sprint") then
            u8.Sprint = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Controls", "Crouch") and not SettingsModule.GetSetting("Controls", "Toggle Crouch") then
            u8.Crouch = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Gamepad", "Sprint") and not SettingsModule.GetSetting("Gamepad", "Toggle Sprint") then
            u8.Sprint = false;
            v50 = true;
        elseif Name == SettingsModule.GetSetting("Gamepad", "Crouch") and not SettingsModule.GetSetting("Gamepad", "Toggle Crouch") then
            u8.Crouch = false;
            v50 = true;
        end;

        if not v50 then
            return;
        end;

        u33();
    end;
end);
ViewmodelController.AttributeChanged:Connect(function(p51) -- Line: 376
    -- upvalues: u33 (copy)
    if p51 ~= "Aiming" and (p51 ~= "Using" and (p51 ~= "SReduction" and p51 ~= "CanUse")) then
        return;
    end;

    u33();
end);
u1.AttributeChanged:Connect(function(p52) -- Line: 382
    -- upvalues: u33 (copy)
    if p52 ~= "DamageConnections" then
        return;
    end;

    u33();
end);
u1:GetPropertyChangedSignal("SeatPart"):Connect(u33);
u1.StateChanged:Connect(function(p53, p54) -- Line: 387
    -- upvalues: u33 (copy)
    local Attribute = script:GetAttribute("IsClimbing");

    if p53 == Enum.HumanoidStateType.Climbing or p54 ~= Enum.HumanoidStateType.Climbing then
        script:SetAttribute("IsClimbing", false);

        if Attribute then
            u33();
        end;

        return;
    end;

    script:SetAttribute("IsClimbing", true);

    if not Attribute then
        u33();
    end;
end);
UserInputService.TextBoxFocusReleased:Connect(function(p55) -- Line: 401
    -- upvalues: u8 (copy), PreferredInputController (copy), SettingsModule (copy), u33 (copy)
    task.wait();
    u8.Forward = false;
    u8.Backward = false;
    u8.Right = false;
    u8.Left = false;

    if PreferredInputController:GetAttribute("PreferredInput") ~= "Touch" and not SettingsModule.GetSetting("Controls", "Toggle Sprint") then
        u8.Sprint = false;
    end;

    if not SettingsModule.GetSetting("Controls", "Toggle Crouch") then
        u8.Crouch = false;
    end;

    u33();
end);
PreferredInputController.AttributeChanged:Connect(v17);

local function v56() -- Line: 423
    -- upvalues: RunService (copy), PreferredInputController (copy), u38 (copy)
    pcall(function() -- Line: 424
        -- upvalues: RunService (ref)
        RunService:UnbindFromRenderStep("StateControllerTouchMovement");
    end);

    if PreferredInputController:GetAttribute("PreferredInput") ~= "Touch" then
        return;
    end;

    RunService:BindToRenderStep("StateControllerTouchMovement", Enum.RenderPriority.Input.Value, u38);
end;

PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(v56);
v56();
script:WaitForChild("MobileSprint").Event:Connect(function(p57) -- Line: 434
    -- upvalues: SettingsModule (copy), u8 (copy), u7 (ref), u33 (copy)
    if SettingsModule.MainMenuOpen() or not p57 then
        return;
    end;

    u8.Sprint = not u8.Sprint;

    if not u8.Sprint then
        u7 = false;
    end;

    u33();
end);
script:WaitForChild("MobileCrouch").Event:Connect(function(p58) -- Line: 447
    -- upvalues: SettingsModule (copy), u8 (copy), u33 (copy)
    if SettingsModule.MainMenuOpen() or not p58 then
        return;
    end;

    u8.Crouch = not u8.Crouch;
    u33();
end);
TeamNavigationController:GetAttributeChangedSignal("MapOpen"):Connect(v17);
local u59 = nil;
u1.Seated:Connect(function(p60, u61) -- Line: 458
    -- upvalues: u59 (ref), RunService (copy), UserInputService (copy), PreferredInputController (copy)
    if u59 then
        u59:Disconnect();
        u59 = nil;
    end;

    if not (p60 and (u61 and u61:IsA("VehicleSeat"))) then
        return;
    end;

    local v62 = u61.Parent and u61.Parent:FindFirstChild("BoatController");

    if not v62 then
        return;
    end;

    u59 = RunService.Heartbeat:Connect(function() -- Line: 463
        -- upvalues: u61 (copy), u59 (ref), UserInputService (ref), PreferredInputController (ref)
        if not (u61 and (u61.Parent and u61.Occupant)) then
            u61:SetAttribute("GamepadSteer", nil);
            u61:SetAttribute("GamepadThrottle", nil);

            if u59 then
                u59:Disconnect();
                u59 = nil;
            end;

            return;
        end;

        local u63 = 0;
        local u64 = 0;
        pcall(function() -- Line: 471
            -- upvalues: UserInputService (ref), PreferredInputController (ref), u63 (ref), u64 (ref)
            for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
                if v.KeyCode == Enum.KeyCode.Thumbstick1 then
                    local X = v.Position.X;
                    local Y = v.Position.Y;

                    if math.abs(X) > (PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225) then
                        u63 = X;
                    end;

                    if math.abs(Y) > (PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225) then
                        u64 = Y;

                        return;
                    end;

                    break;
                end;
            end;
        end);
        u61:SetAttribute("GamepadSteer", u63);
        u61:SetAttribute("GamepadThrottle", u64);
    end);
end);

while task.wait(0.03333333333333333) and (u2 and u2.Parent) do
    local v65 = script:GetAttribute("IsCrouch") and 2.6 or 1.7;
    local Position = u2.Position;
    local v66, v67 = RaycastUtil:Raycast(Position, Vector3.new(0, 100, 0), "Exclude", {
        script_Parent,
        VFX,
        Drops,
        Animals,
        Plants
    }, false, v6, true);
    local v68;

    if v66 == nil or v66.Parent == nil then
        v68 = false;
    else
        v68 = v66.CanCollide or v66.Transparency < 1;
    end;

    if v68 ~= v11 then
        WeatherController:SetAttribute("BelowCeiling", v68);
        v11 = v68;
    end;

    if v68 then
        v68 = v67.Y - Position.Y <= v65;
    end;

    if v68 ~= u10 then
        u10 = v68;
        u33();
    end;

    if tick() - v5 >= 0.4 and (v3 and v3.Parent) then
        v5 = tick();
        local v69 = Region3.new(v3.Position - 0.5 * v3.Size - Vector3.new(0, 3, 0), v3.Position + 0.5 * v3.Size - Vector3.new(0, 3, 0)):ExpandToGrid(4);
        local v70, _ = workspace.Terrain:ReadVoxels(v69, 4);

        if v70[1][1][1] == Enum.Material.Water then
            script:SetAttribute("IsWater", true);
        else
            script:SetAttribute("IsWater", false);
        end;
    end;
end;