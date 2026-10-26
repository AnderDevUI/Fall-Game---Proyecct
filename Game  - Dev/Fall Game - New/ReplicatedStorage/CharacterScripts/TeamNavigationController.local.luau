-- [PATH] ReplicatedStorage / CharacterScripts / TeamNavigationController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Values = ReplicatedStorage:WaitForChild("Values");
local GuiUtil = require(Modules:WaitForChild("GuiUtil"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
require(Modules:WaitForChild("NumberUtil"));
require(Modules:WaitForChild("TweenUtil"));
require(Modules:WaitForChild("Items"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
require(Modules:WaitForChild("ActiveBenchModule"));
local MapTools = require(ReplicatedStorage:WaitForChild("MapRender"):WaitForChild("MapTools"));
local u1 = require(Modules:WaitForChild("AssetContainer"))();
local LocalPlayer = Players.LocalPlayer;
local PlayerScripts = LocalPlayer.PlayerScripts;
local v2 = LocalPlayer.Character or script.Parent;
local Humanoid = v2:WaitForChild("Humanoid");
local HumanoidRootPart = v2:WaitForChild("HumanoidRootPart");
local workspace_CurrentCamera = workspace.CurrentCamera;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Main = PlayerGui:WaitForChild("Main");
local Compass = Main:WaitForChild("Compass");
local Map = Main:WaitForChild("Map");
local Map2 = Map:WaitForChild("Frame"):WaitForChild("Map");
local PlayerCursor = Map2:WaitForChild("PlayerCursor");
local Team = Main:WaitForChild("Team");
local u3 = { Team:WaitForChild("Accept"), Team:WaitForChild("Decline"), Team:WaitForChild("Inviter") };
local CreateLeaveTeam = Team:WaitForChild("CreateLeaveTeam");
local TeamList = Team:WaitForChild("TeamList");
local c = TeamList:WaitForChild("c");
local TeamHighlight = script:WaitForChild("TeamHighlight");
local InventoryController = v2:WaitForChild("InventoryController");
local ChatController = PlayerScripts:WaitForChild("ChatController");
local PreferredInputController = PlayerScripts:WaitForChild("PreferredInputController");
local UpdateChannel = ChatController:WaitForChild("UpdateChannel");
local Vector2_new_ret = Vector2.new(0, 0);
local v4 = tick();
local v5 = tick();
local v6 = tick();
local Attribute = InventoryController:GetAttribute("CurOpen");
shared.cachedTeamModels = {};
shared.YourTeam = nil;
local v7 = {
    MaxDistance = {
        Default = 20,
        Team = 750
    },
    TextColor3 = {
        Default = Color3.fromRGB(255, 255, 255),
        Team = Color3.fromRGB(30, 158, 255)
    }
};
local v8 = RaycastUtil:FilterFunction("View");
local v9 = {
    [0] = "N",
    [45] = "NE",
    [90] = "E",
    [135] = "SE",
    [180] = "S",
    [225] = "SW",
    [270] = "W",
    [315] = "NW"
};
local u10 = {};
local u11 = nil;
local u12 = {};
local u13 = { 0, -360, 360 };
local u14 = false;
local u15 = false;

for i = 0, 355, 5 do
    local v16 = i - 90 - (i - 90 > 180 and 360 or 0);
    local v17 = v9[i];
    local v18 = v17 and (v17:len() > 1 and "TemplateMedium" or "TemplateLarge") or nil or (i % 10 == 0 and "TemplateMedium" or (i % 5 == 0 and "TemplateSmall" or false));
    local v19;

    if v18 then
        local v20 = Compass:FindFirstChild(v18):Clone();
        local v21 = v20:FindFirstChildOfClass("TextLabel");

        if v21 then
            v21.Text = v17 or tostring(i);
            v21.TextTransparency = v17 and 0 or v21.TextTransparency;
            v21.TextStrokeTransparency = v17 and 0.7 or v21.TextStrokeTransparency;
        end;

        v20.Name = "Angle" .. v16;
        v20.BackgroundTransparency = v17 and 0 or v20.BackgroundTransparency;
        v20.BorderColor3 = v17 and v20.BorderColor3 or Color3.fromRGB(132, 132, 132);
        v20.Parent = Compass;
        table.insert(u10, v20);
        v19 = i;
    else
        v19 = i;
    end;
end;

local u22 = #u10 - 18;

local function _() -- Line: 159
    -- upvalues: Humanoid (copy)
    return Humanoid and Humanoid.Parent and Humanoid.Health > 0;
end;

local function u31() -- Line: 163
    -- upvalues: workspace_CurrentCamera (copy), u11 (ref), MapTools (copy), Compass (copy), u10 (copy), u13 (copy), u22 (copy)
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Position = CFrame2.Position;
    local LookVector = CFrame2.LookVector;
    local CFrame_new_ret = CFrame.new(Position, Position + Vector3.new(LookVector.X, 0, LookVector.Z));
    local LookVector2 = CFrame_new_ret.LookVector;
    local math_atan2_ret = math.atan2(LookVector2.Z, LookVector2.X);
    local math_deg_ret = math.deg(math_atan2_ret);
    MapTools.CompassStep(Compass, Position, math_deg_ret, 45);

    if u11 == LookVector2 then
        return;
    end;

    u11 = LookVector2;
    local v23 = 0;
    local v24 = nil;
    local v25 = false;
    local v26 = false;

    for i, v in pairs(u10) do
        local v27, v28;

        if v23 < 18 then
            if v24 and v24 > 0 then
                v24 = v24 - 1;
                v.Visible = false;
            else
                local v29 = tonumber(v.Name:sub(6));
                v27 = v25;
                v28 = v;

                for _, v3 in pairs(u13) do
                    if v25 ~= false or math.abs(math_deg_ret + v3 - v29) <= 45 then
                        v28.Visible = true;
                        local LookVector3 = (CFrame_new_ret * CFrame.Angles(0, math.rad(v29), 0)).LookVector;
                        local math_atan2_ret2 = math.atan2(LookVector3.Z, LookVector3.X);
                        local v30 = math.deg(math_atan2_ret2) * -1;
                        v28.Position = UDim2.new(v30 / 90 + 0.5, 0, v28:FindFirstChild("Label") and 0.25 or 0.125, 0);
                        v23 = v23 + 1;
                        v25 = true;
                        break;
                    end;
                end;

                if not v25 then
                    v28.Visible = false;

                    if v26 and not v24 then
                        v24 = u22 - 1;
                        v25 = v27;
                    else
                        v25 = v27;
                    end;
                end;

                if i == 1 then
                    v25 = v27;
                    v26 = true;
                elseif v26 then
                    v25 = v27;
                else
                    v25 = true;
                end;
            end;
        else
            v27 = v25;
            v28 = v;
            v28.Visible = false;

            if v26 and not v24 then
                v24 = u22 - 1;
                v25 = v27;
            else
                v25 = v27;
            end;
        end;
    end;
end;

local function u44(p32, p33) -- Line: 217
    -- upvalues: u12 (ref), Values (copy), TeamList (copy), Players (copy), c (copy), LocalPlayer (copy), InventoryController (copy)
    local v34 = false;

    if #p32 == #u12 then
        for i, v in pairs(p32) do
            if u12[i] ~= v then
                v34 = true;
                break;
            end;
        end;
    else
        v34 = true;
    end;

    u12 = p32;

    if not (v34 or p33) then
        return;
    end;

    local v35 = #u12 > 0;
    script:SetAttribute("InTeam", v35);
    local v36;

    if #u12 < Values.TeamSize.Value then
        v36 = u12[1] ~= "CantLeave";
    else
        v36 = false;
    end;

    script:SetAttribute("CanInvite", v36);

    for _, child in pairs(TeamList:GetChildren()) do
        if child.Name:find("Member") then
            child:Destroy();
        end;
    end;

    local v37 = 0;

    for _, v in pairs(u12) do
        if v ~= "CantLeave" then
            v37 = v37 + 1;
            local v38 = v37 == 9;
            local v39;

            if typeof(v) == "string" then
                v39 = not v38;
            else
                v39 = false;
            end;

            local u40 = nil;
            local u41;

            if v38 then
                u41 = v;
                u40 = "...";
            else
                u41 = tonumber(v);
                pcall(function() -- Line: 252
                    -- upvalues: u40 (ref), Players (ref), u41 (ref)
                    u40 = Players:GetNameFromUserIdAsync(u41);
                end);
                u40 = u40 or u41 .. "_ERROR";
            end;

            local v42 = c:Clone();
            v42.Name = "Member" .. v37;
            v42.Position = UDim2.new(v42.Position.X.Scale, 0, v42.Position.Y.Scale + (v37 - 1) * 0.03);
            v42.Text = u40;
            local v43;

            if v39 then
                v43 = v42.TextColor3;
            elseif u41 == LocalPlayer.UserId then
                v43 = Color3.fromRGB(119, 255, 221);
            else
                v43 = Color3.fromRGB(255, 255, 255);
            end;

            v42.TextColor3 = v43;
            v42.Parent = TeamList;
            v42.Visible = true;

            if v38 then
                break;
            end;
        end;
    end;

    if v35 then
        v35 = InventoryController:GetAttribute("CurOpen") ~= "Crafting";
    end;

    TeamList.Visible = v35;
end;

local function _(p45) -- Line: 271
    -- upvalues: Vector2_new_ret (copy)
    local v46 = 0.5 + (p45.X - Vector2_new_ret.X) / 12800;
    local v47 = typeof(p45) == "Vector3" and p45.Z or p45.Y;

    return UDim2.new(v46, 0, 0.5 + (v47 - Vector2_new_ret.Y) / 12800, 0);
end;

local function _(p48) -- Line: 278
    -- upvalues: Vector2_new_ret (copy)
    return Vector2.new((p48.X.Scale - 0.5) * 12800, (p48.Y.Scale - 0.5) * 12800) + Vector2_new_ret;
end;

local u49 = {};

local function u61(p50: table, p51: table) -- Line: 285
    -- upvalues: Players (copy), u49 (copy), Map2 (copy), Vector2_new_ret (copy), HumanoidRootPart (copy), PlayerCursor (copy), Humanoid (copy)
    if p50 then
        local v52 = {};

        for i, v in pairs(p51) do
            local v53 = tonumber(v);

            if v53 then
                local PlayerByUserId = Players:GetPlayerByUserId(v53);

                if PlayerByUserId then
                    v52[v53] = true;
                    local Name = PlayerByUserId.Name;
                    local v54 = u49[v53];
                    local v55 = p50[tostring(i)];

                    if v55 and not v54 then
                        v54 = Map2.TeamCursor:Clone();
                        v54.Name = Name;
                        v54.Parent = Map2;
                        v54.Visible = true;
                        u49[v53] = v54;
                    end;

                    if v54 then
                        v54.PlayerName.Text = Name;

                        if v55 then
                            local v56 = 0.5 + (v55.X - Vector2_new_ret.X) / 12800;
                            local v57 = typeof(v55) == "Vector3" and v55.Z or v55.Y;
                            v54.Position = UDim2.new(v56, 0, 0.5 + (v57 - Vector2_new_ret.Y) / 12800, 0);
                        end;
                    end;
                end;
            end;
        end;

        for i, v in pairs(u49) do
            if not v52[i] then
                v:Destroy();
                u49[i] = nil;
            end;
        end;
    end;

    if HumanoidRootPart and HumanoidRootPart.Parent then
        local CFrame2 = HumanoidRootPart.CFrame;
        local LookVector = CFrame2.LookVector;
        local math_atan2_ret = math.atan2(-LookVector.Z, LookVector.X);
        local v58 = math.deg(math_atan2_ret) * -1;
        local Position = CFrame2.Position;
        local v59 = 0.5 + (Position.X - Vector2_new_ret.X) / 12800;
        local v60 = typeof(Position) == "Vector3" and Position.Z or Position.Y;
        PlayerCursor.Position = UDim2.new(v59, 0, 0.5 + (v60 - Vector2_new_ret.Y) / 12800, 0);
        PlayerCursor.Rotator.Rotation = v58;
    end;

    PlayerCursor.Visible = Humanoid and Humanoid.Parent and Humanoid.Health > 0;
end;

local function _(p62: boolean) -- Line: 329
    -- upvalues: u3 (copy)
    for _, v in pairs(u3) do
        v.Visible = p62;
    end;
end;

local GamepadService = game:GetService("GamepadService");
local MapGamepad = require(ReplicatedStorage:WaitForChild("MapRender"):WaitForChild("MapGamepad"));
local u63 = {
    KeptOpen = false,
    Closing = false
};

local function u65(p64: boolean) -- Line: 340
    -- upvalues: Map (copy), Values (copy), u63 (copy), InventoryController (copy), UserInputService (copy), GamepadService (copy)
    if Map:GetAttribute("Locked") or p64 and not Values.MapEnabled.Value then
        return;
    end;

    Map.Visible = p64;

    if not p64 then
        u63.KeptOpen = false;
    end;

    if not InventoryController:GetAttribute("Open") or p64 then
        UserInputService.MouseBehavior = Enum.MouseBehavior[p64 and "Default" or "LockCenter"];
        UserInputService.MouseIconEnabled = p64;
    end;

    if p64 and not InventoryController:GetAttribute("Open") then
        pcall(function() -- Line: 352
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
    end;

    script:SetAttribute("MapOpen", p64);

    if not p64 then
        script:SetAttribute("MapClosedTick", tick());
    end;
end;

GuiUtil:AddScrollToFrame(Map, 2, 16, 0.15, 5);
local ZoomInfo = GuiUtil:GetZoomInfo(Map);
ZoomInfo.RightDrag = true;
ZoomInfo.Blocked = MapTools.BlocksPan;
ZoomInfo.WheelFactor = 1.25;
ZoomInfo.ZoomAboutCursor = true;

function ZoomInfo.Clamp(p66: number, p67: number, p68: number) -- Line: 373
    -- upvalues: Map (copy)
    local AbsoluteSize = Map.AbsoluteSize;
    local v69 = p68 * math.min(AbsoluteSize.X, AbsoluteSize.Y);
    local v70 = v69 / math.max(AbsoluteSize.X, 1);
    local math_max_ret = math.max(v70, 0);
    local v71 = v69 / math.max(AbsoluteSize.Y, 1);
    local math_max_ret2 = math.max(v71, 0);

    return math.clamp(p66, 0.5 - math_max_ret, math_max_ret + 0.5), math.clamp(p67, 0.5 - math_max_ret2, math_max_ret2 + 0.5);
end;

Humanoid:GetAttributeChangedSignal("Downed"):Connect(function() -- Line: 386
    -- upvalues: Map (copy), u63 (copy), InventoryController (copy), UserInputService (copy)
    if not Map:GetAttribute("Locked") then
        Map.Visible = false;
        u63.KeptOpen = false;

        if not InventoryController:GetAttribute("Open") then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
            UserInputService.MouseIconEnabled = false;
        end;

        script:SetAttribute("MapOpen", false);
        script:SetAttribute("MapClosedTick", tick());
    end;
end);
Humanoid.Died:Connect(function() -- Line: 389
    -- upvalues: HumanoidRootPart (copy), PlayerGui (copy), Map (copy), Vector2_new_ret (copy)
    if not HumanoidRootPart.Parent then
        return;
    end;

    local Position = HumanoidRootPart.Position;
    local Vector2_new_ret2 = Vector2.new(Position.X, Position.Z);
    PlayerGui:SetAttribute("LastDeathPin", Vector2_new_ret2);
    PlayerGui:SetAttribute("LastDeathAt", os.clock());
    local DeathMarker = Map.Frame.Map.DeathMarker;
    local v72 = 0.5 + (Vector2_new_ret2.X - Vector2_new_ret.X) / 12800;
    local v73 = typeof(Vector2_new_ret2) == "Vector3" and Vector2_new_ret2.Z or Vector2_new_ret2.Y;
    DeathMarker.Position = UDim2.new(v72, 0, 0.5 + (v73 - Vector2_new_ret.Y) / 12800, 0);
    DeathMarker.Visible = true;
end);
UserInputService.InputBegan:Connect(function(p74, p75) -- Line: 400
    -- upvalues: SettingsModule (copy), UserInputService (copy), Humanoid (copy), u63 (copy), Map (copy), InventoryController (copy), Values (copy), GamepadService (copy), MapTools (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    local UserInputType = p74.UserInputType;

    if UserInputType == Enum.UserInputType.Gamepad1 then
        return;
    end;

    if not p75 then
        if UserInputService:GetFocusedTextBox() or Humanoid:GetAttribute("Downed") then
            return;
        end;

        if not (Humanoid and Humanoid.Parent and Humanoid.Health > 0) then
            return;
        end;

        if UserInputType == Enum.UserInputType.Keyboard and p74.KeyCode.Name == SettingsModule.GetSetting("Controls", "Open Map") then
            if script:GetAttribute("MapOpen") and u63.KeptOpen then
                u63.Closing = true;

                if not Map:GetAttribute("Locked") then
                    Map.Visible = false;
                    u63.KeptOpen = false;

                    if not InventoryController:GetAttribute("Open") then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                        UserInputService.MouseIconEnabled = false;
                    end;

                    script:SetAttribute("MapOpen", false);
                    script:SetAttribute("MapClosedTick", tick());
                end;
            else
                if not Map:GetAttribute("Locked") and Values.MapEnabled.Value then
                    Map.Visible = true;
                    InventoryController:GetAttribute("Open");
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
                    UserInputService.MouseIconEnabled = true;

                    if not InventoryController:GetAttribute("Open") then
                        pcall(function() -- Line: 352
                            -- upvalues: GamepadService (ref)
                            GamepadService:DisableGamepadCursor();
                        end);
                    end;

                    script:SetAttribute("MapOpen", true);
                end;

                MapTools.KeyDown();
            end;
        end;
    end;
end);
UserInputService.InputEnded:Connect(function(p76, p77) -- Line: 421
    -- upvalues: UserInputService (copy), SettingsModule (copy), u63 (copy), MapTools (copy), Map (copy), InventoryController (copy), ChatController (copy), Humanoid (copy), u65 (copy)
    local UserInputType = p76.UserInputType;

    if UserInputService:GetFocusedTextBox() then
        return;
    end;

    if UserInputType == Enum.UserInputType.Keyboard then
        if p76.KeyCode.Name == SettingsModule.GetSetting("Controls", "Open Map") then
            if u63.Closing then
                u63.Closing = false;

                return;
            end;

            if MapTools.KeyUp() and script:GetAttribute("MapOpen") then
                u63.KeptOpen = true;

                return;
            end;

            if not Map:GetAttribute("Locked") then
                Map.Visible = false;
                u63.KeptOpen = false;

                if not InventoryController:GetAttribute("Open") then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                    UserInputService.MouseIconEnabled = false;
                end;

                script:SetAttribute("MapOpen", false);
                script:SetAttribute("MapClosedTick", tick());
            end;
        end;
    elseif UserInputType == Enum.UserInputType.Gamepad1 and (p76.KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Open Map") and not (ChatController:GetAttribute("Typing") or (UserInputService:GetFocusedTextBox() or Humanoid:GetAttribute("Downed")))) then
        if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
            u65(not script:GetAttribute("MapOpen"));
        end;
    end;
end);

if not Map:GetAttribute("Locked") then
    Map.Visible = false;
    u63.KeptOpen = false;

    if not InventoryController:GetAttribute("Open") then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
    end;

    script:SetAttribute("MapOpen", false);
    script:SetAttribute("MapClosedTick", tick());
end;

function MapGamepad.Closer() -- Line: 444
    -- upvalues: Map (copy), u63 (copy), InventoryController (copy), UserInputService (copy)
    if not Map:GetAttribute("Locked") then
        Map.Visible = false;
        u63.KeptOpen = false;

        if not InventoryController:GetAttribute("Open") then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
            UserInputService.MouseIconEnabled = false;
        end;

        script:SetAttribute("MapOpen", false);
        script:SetAttribute("MapClosedTick", tick());
    end;
end;

local MobileModule = require(Modules:WaitForChild("MobileModule"));
script:WaitForChild("MobileMap").Event:Connect(function(p78) -- Line: 452
    -- upvalues: SettingsModule (copy), ChatController (copy), Humanoid (copy), u65 (copy)
    if not p78 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if not (ChatController:GetAttribute("Typing") or Humanoid:GetAttribute("Downed")) then
        if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
            u65(not script:GetAttribute("MapOpen"));
        end;
    end;
end);
local CloseMap = Main:WaitForChild("CloseMap");

local function v80() -- Line: 462
    -- upvalues: CloseMap (copy), MobileModule (copy)
    local v79;

    if script:GetAttribute("MapOpen") == true then
        v79 = MobileModule.IsTouch();
    else
        v79 = false;
    end;

    CloseMap.Visible = v79;
end;

CloseMap.Activated:Connect(function() -- Line: 466
    -- upvalues: Map (copy), u63 (copy), InventoryController (copy), UserInputService (copy)
    if not Map:GetAttribute("Locked") then
        Map.Visible = false;
        u63.KeptOpen = false;

        if not InventoryController:GetAttribute("Open") then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
            UserInputService.MouseIconEnabled = false;
        end;

        script:SetAttribute("MapOpen", false);
        script:SetAttribute("MapClosedTick", tick());
    end;
end);
script:GetAttributeChangedSignal("MapOpen"):Connect(v80);
PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(v80);
local v81;

if script:GetAttribute("MapOpen") == true then
    v81 = MobileModule.IsTouch();
else
    v81 = false;
end;

CloseMap.Visible = v81;
local u82 = nil;
local u83 = nil;
local u84 = false;
local u85 = nil;

local function _() -- Line: 481
    -- upvalues: MobileModule (copy)
    local v86;

    if script:GetAttribute("MapOpen") == true then
        v86 = MobileModule.IsTouch();
    else
        v86 = false;
    end;

    return v86;
end;

local function _() -- Line: 485
    -- upvalues: u82 (ref), u83 (ref), GuiUtil (copy), Map (copy)
    u82 = nil;
    u83 = nil;
    local ZoomInfo2 = GuiUtil:GetZoomInfo(Map);

    if not ZoomInfo2 then
        return;
    end;

    ZoomInfo2.Held = false;
    ZoomInfo2.Delta = Vector3.new();
end;

UserInputService.TouchStarted:Connect(function(p87) -- Line: 493
    -- upvalues: MobileModule (copy), u84 (ref), u82 (ref), MapTools (copy), GuiUtil (copy), Map (copy), u83 (ref)
    local v88;

    if script:GetAttribute("MapOpen") == true then
        v88 = MobileModule.IsTouch();
    else
        v88 = false;
    end;

    if not v88 or (u84 or u82) then
        return;
    end;

    if MapTools.BlocksPan(p87) then
        return;
    end;

    local ZoomInfo2 = GuiUtil:GetZoomInfo(Map);

    if not ZoomInfo2 then
        return;
    end;

    u82 = p87;
    u83 = p87.Position;
    ZoomInfo2.Held = true;
    GuiUtil:StartZoomLoop(Map);
end);
UserInputService.TouchMoved:Connect(function(p89) -- Line: 503
    -- upvalues: MobileModule (copy), u84 (ref), u82 (ref), u83 (ref), GuiUtil (copy), Map (copy)
    local v90;

    if script:GetAttribute("MapOpen") == true then
        v90 = MobileModule.IsTouch();
    else
        v90 = false;
    end;

    if not v90 or (u84 or (p89 ~= u82 or not u83)) then
        return;
    end;

    local ZoomInfo2 = GuiUtil:GetZoomInfo(Map);

    if not ZoomInfo2 then
        return;
    end;

    ZoomInfo2.Delta = p89.Position - u83;
    u83 = p89.Position;
end);
UserInputService.TouchEnded:Connect(function(p91) -- Line: 511
    -- upvalues: u82 (ref), u83 (ref), GuiUtil (copy), Map (copy)
    if p91 ~= u82 then
        return;
    end;

    u82 = nil;
    u83 = nil;
    local ZoomInfo2 = GuiUtil:GetZoomInfo(Map);

    if not ZoomInfo2 then
        return;
    end;

    ZoomInfo2.Held = false;
    ZoomInfo2.Delta = Vector3.new();
end);
UserInputService.TouchPinch:Connect(function(p92, p93, p94, p95) -- Line: 518
    -- upvalues: MobileModule (copy), GuiUtil (copy), Map (copy), u84 (ref), u85 (ref), u82 (ref), u83 (ref)
    local v96;

    if script:GetAttribute("MapOpen") == true then
        v96 = MobileModule.IsTouch();
    else
        v96 = false;
    end;

    if not v96 then
        return;
    end;

    local ZoomInfo2 = GuiUtil:GetZoomInfo(Map);

    if not ZoomInfo2 then
        return;
    end;

    if p95 ~= Enum.UserInputState.Begin then
        if p95 ~= Enum.UserInputState.Change then
            u84 = false;
            u85 = nil;

            return;
        end;

        if not u85 then
            return;
        end;

        ZoomInfo2.TargetScale = math.clamp(u85 * p93, ZoomInfo2.MinZoom, ZoomInfo2.MaxZoom);
        GuiUtil:StartZoomLoop(Map);

        return;
    end;

    u84 = true;
    u85 = ZoomInfo2.TargetScale;
    ZoomInfo2.ZoomAnchor = nil;
    u82 = nil;
    u83 = nil;
    local ZoomInfo3 = GuiUtil:GetZoomInfo(Map);

    if not ZoomInfo3 then
        return;
    end;

    ZoomInfo3.Held = false;
    ZoomInfo3.Delta = Vector3.new();
end);
InventoryController:GetAttributeChangedSignal("CurOpen"):Connect(function() -- Line: 538
    -- upvalues: InventoryController (copy), Attribute (ref), TeamList (copy), CreateLeaveTeam (copy), u15 (ref), u14 (ref), u3 (copy)
    local Attribute2 = InventoryController:GetAttribute("CurOpen");

    if Attribute2 == Attribute then
        return;
    end;

    Attribute = Attribute2;
    local v97 = Attribute2 == "Inventory";
    local Attribute3 = script:GetAttribute("InTeam");
    local v98;

    if Attribute3 then
        v98 = Attribute2 ~= "Crafting";
    else
        v98 = Attribute3;
    end;

    TeamList.Visible = v98;
    TeamList.Position = UDim2.new(0, 0, v97 and 0.04 or 0, 0);
    CreateLeaveTeam.Label.Text = Attribute3 and "LEAVE TEAM" or "CREATE TEAM";
    CreateLeaveTeam.Visible = not u15 and v97;

    if not u14 and v97 then
        return;
    end;

    for _, v in pairs(u3) do
        v.Visible = v97;
    end;
end);

script:WaitForChild("FetchTeam").OnInvoke = function() -- Line: 555
    -- upvalues: u12 (ref)
    return u12;
end;

local u99 = 0;
u1("Setup", "\194\185\194\175\112\194\185\239\191\189\077\195\165\066\239\191\189\239\191\189\239\191\189\074\239\191\189\239\191\189\239\191\189\082\195\132\239\191\189\239\191\189\239\191\189", "\195\164\093\239\191\189\099\239\191\189\239\191\189\194\175\239\191\189\057\239\191\189\053\239\191\189\239\191\189\103\069\239\191\189\125\239\191\189\239\191\189\239\191\189", function(p100: string, p101: table, p102: table, p103: boolean, p104: number) -- Line: 561
    -- upvalues: u44 (copy), u61 (copy), UpdateChannel (copy), u14 (ref), Players (copy), u99 (ref), u3 (copy), InventoryController (copy)
    if p100 ~= "Update" then
        if p100 == "Invite" then
            u14 = p101[1];
            local u105 = nil;
            pcall(function() -- Line: 574
                -- upvalues: u105 (ref), Players (ref), u14 (ref)
                u105 = Players:GetNameFromUserIdAsync(u14);
            end);
            u105 = u105 or u14 .. "_ERROR";
            local v106 = "Join " .. u105 .. "\'s Team";

            if os.clock() - u99 >= (v106 == u3[3].Text and 30 or 8) then
                u99 = os.clock();
                script.InviteNotification:Play();
            end;

            u3[3].Text = v106;

            if InventoryController:GetAttribute("CurOpen") ~= "Inventory" then
                return;
            end;

            for _, v in pairs(u3) do
                v.Visible = true;
            end;
        end;

        return;
    end;

    u44(p101, p103);

    if p102 then
        u61(p102, p101);
    end;

    shared.YourTeam = p104;
    UpdateChannel:Fire("Team");
end);
u3[1].MouseButton1Click:Connect(function() -- Line: 591
    -- upvalues: u14 (ref), u3 (copy), u1 (copy)
    if not u14 then
        return;
    end;

    for _, v in pairs(u3) do
        v.Visible = false;
    end;

    u1("Fire", "\194\185\194\175\112\194\185\239\191\189\077\195\165\066\239\191\189\239\191\189\239\191\189\074\239\191\189\239\191\189\239\191\189\082\195\132\239\191\189\239\191\189\239\191\189", "\195\164\093\239\191\189\099\239\191\189\239\191\189\194\175\239\191\189\057\239\191\189\053\239\191\189\239\191\189\103\069\239\191\189\125\239\191\189\239\191\189\239\191\189", "Join", u14);
    u14 = false;
end);
u3[2].MouseButton1Click:Connect(function() -- Line: 603
    -- upvalues: u14 (ref), u3 (copy)
    u14 = false;

    for _, v in pairs(u3) do
        v.Visible = false;
    end;
end);
CreateLeaveTeam.MouseButton1Click:Connect(function() -- Line: 609
    -- upvalues: u15 (ref), CreateLeaveTeam (copy), u1 (copy), InventoryController (copy), u12 (ref)
    u15 = true;
    CreateLeaveTeam.Visible = false;
    u1(
        "Fire",
        "\194\185\194\175\112\194\185\239\191\189\077\195\165\066\239\191\189\239\191\189\239\191\189\074\239\191\189\239\191\189\239\191\189\082\195\132\239\191\189\239\191\189\239\191\189",
        "\195\164\093\239\191\189\099\239\191\189\239\191\189\194\175\239\191\189\057\239\191\189\053\239\191\189\239\191\189\103\069\239\191\189\125\239\191\189\239\191\189\239\191\189",
        "Create/Leave"
    );
    task.delay(2, function() -- Line: 617
        -- upvalues: u15 (ref), InventoryController (ref), CreateLeaveTeam (ref), u12 (ref)
        u15 = false;

        if InventoryController:GetAttribute("CurOpen") ~= "Inventory" then
            return;
        end;

        CreateLeaveTeam.Label.Text = #u12 > 0 and "LEAVE TEAM" or "CREATE TEAM";
        CreateLeaveTeam.Visible = true;
    end);
end);
PlayerGui:GetAttributeChangedSignal("PlayerMapPin"):Connect(function() -- Line: 626
    -- upvalues: Compass (copy), PlayerGui (copy), u31 (copy)
    Compass.Pin.Visible = false;

    if not PlayerGui:GetAttribute("PlayerMapPin") then
        Compass.Pin.Visible = false;
    end;

    u31();
end);
local Attribute2 = PlayerGui:GetAttribute("LastDeathPin");

if Attribute2 then
    local DeathMarker = Map.Frame.Map.DeathMarker;
    local v107 = 0.5 + (Attribute2.X - Vector2_new_ret.X) / 12800;
    local v108 = typeof(Attribute2) == "Vector3" and Attribute2.Z or Attribute2.Y;
    DeathMarker.Position = UDim2.new(v107, 0, 0.5 + (v108 - Vector2_new_ret.Y) / 12800, 0);
    DeathMarker.Visible = true;
end;

workspace_CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(u31);
u31();
PlayerCursor.PlayerName.Text = LocalPlayer.Name;

while true do
    local v109, v110, v111;
    local v112 = 0;

    while true do
        if v112 == 0 then
            v112 = -1;

            while true do
                if tick() - v5 >= 0.2 then
                    v5 = tick();
                    checkRay = tick() - v4 >= 0.4;
                    TeamList.DetailLabel.TextColor3 = LocalPlayer.Team and LocalPlayer.Team.TeamColor.Color or Color3.new(1, 1, 1);

                    for _, v in pairs(u12) do
                        if v ~= "CantLeave" then
                            local v113 = tonumber(v);

                            if v113 ~= LocalPlayer.UserId then
                                local PlayerByUserId = Players:GetPlayerByUserId(v113);
                                local v114;

                                if PlayerByUserId then
                                    v114 = PlayerByUserId.Character;
                                else
                                    v114 = PlayerByUserId;
                                end;

                                local v115 = shared.cachedTeamModels[v113];
                                local v116, v117, v118, v119, v120;

                                if v115 and v115.Parent ~= nil then
                                    v116 = v114:FindFirstChild("NameTag");
                                    v117 = v114:FindFirstChild("TeamHighlight");

                                    if not v117 then
                                        v117 = TeamHighlight:Clone();
                                        v117.Parent = v114;
                                    end;

                                    if PlayerByUserId then
                                        PlayerByUserId = PlayerByUserId.Team;
                                    end;

                                    if PlayerByUserId then
                                        PlayerByUserId = PlayerByUserId.TeamColor.Color;
                                    end;

                                    if PlayerByUserId then
                                        v117.FillColor = PlayerByUserId;
                                        v117.OutlineColor = PlayerByUserId;
                                    end;

                                    if v116 and v116:FindFirstChild("Label") then
                                        v116.MaxDistance = v7.MaxDistance.Team;
                                        v116.AlwaysOnTop = true;
                                        v116.Label.TextColor3 = PlayerByUserId or v7.TextColor3.Team;
                                    end;

                                    if checkRay then
                                        v4 = tick();
                                        v118 = v2:FindFirstChild("Head");
                                        v119 = v114:FindFirstChild("Head");

                                        if v118 and v119 then
                                            v120 = RaycastUtil:Raycast(v118.Position, v119.Position - v118.Position, "Blacklist", {
                                                v2,
                                                v114,
                                                workspace.VFX,
                                                workspace.Animals,
                                                workspace.Drops,
                                                workspace.Plants
                                            }, false, v8, true);
                                            v117.FillTransparency = v120 and 0.5 or 1;
                                            v117.OutlineTransparency = v120 and 0 or 0.5;
                                            v117.Enabled = true;
                                        end;
                                    end;
                                elseif PlayerByUserId and v114 then
                                    shared.cachedTeamModels[v113] = v114;
                                    v116 = v114:FindFirstChild("NameTag");
                                    v117 = v114:FindFirstChild("TeamHighlight");

                                    if not v117 then
                                        v117 = TeamHighlight:Clone();
                                        v117.Parent = v114;
                                    end;

                                    if PlayerByUserId then
                                        PlayerByUserId = PlayerByUserId.Team;
                                    end;

                                    if PlayerByUserId then
                                        PlayerByUserId = PlayerByUserId.TeamColor.Color;
                                    end;

                                    if PlayerByUserId then
                                        v117.FillColor = PlayerByUserId;
                                        v117.OutlineColor = PlayerByUserId;
                                    end;

                                    if v116 and v116:FindFirstChild("Label") then
                                        v116.MaxDistance = v7.MaxDistance.Team;
                                        v116.AlwaysOnTop = true;
                                        v116.Label.TextColor3 = PlayerByUserId or v7.TextColor3.Team;
                                    end;

                                    if checkRay then
                                        v4 = tick();
                                        v118 = v2:FindFirstChild("Head");
                                        v119 = v114:FindFirstChild("Head");

                                        if v118 and v119 then
                                            v120 = RaycastUtil:Raycast(v118.Position, v119.Position - v118.Position, "Blacklist", {
                                                v2,
                                                v114,
                                                workspace.VFX,
                                                workspace.Animals,
                                                workspace.Drops,
                                                workspace.Plants
                                            }, false, v8, true);
                                            v117.FillTransparency = v120 and 0.5 or 1;
                                            v117.OutlineTransparency = v120 and 0 or 0.5;
                                            v117.Enabled = true;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;

                    if tick() - v6 >= 1 then
                        v6 = tick();
                        v110, v109, v111 = pairs(shared.cachedTeamModels);
                        break;
                    end;

                    u61();
                    task.wait(0.1);
                else
                    if tick() - v6 >= 1 then
                        v6 = tick();
                        v110, v109, v111 = pairs(shared.cachedTeamModels);
                        break;
                    end;

                    u61();
                    task.wait(0.1);
                end;
            end;

            v112 = 1;
            continue;
        elseif v112 == 1 then
            v112 = -1;
            local v121, v122;

            if type(v110) == "function" then
                v121, v122 = v110(v109, v111);
            else
                v121, v122 = next(v110, v111);
            end;

            if v121 ~= nil then
                v111 = v121;
                local v123, v124;

                if v123 == tonumber(v124) then
                    if false then
                        shared.cachedTeamModels[v123] = nil;
                        local v125;
                        local NameTag = v125:FindFirstChild("NameTag");

                        if NameTag then
                            NameTag.MaxDistance = v7.MaxDistance.Default;
                            NameTag.AlwaysOnTop = false;

                            if NameTag:FindFirstChild("Label") then
                                NameTag.Label.TextColor3 = v7.TextColor3.Default;
                            end;
                        end;

                        local TeamHighlight2 = v125:FindFirstChild("TeamHighlight");

                        if TeamHighlight2 then
                            TeamHighlight2:Destroy();
                        end;
                    end;

                    v112 = 1;
                    continue;
                end;

                local v126, v127, v128;

                if type(v126) == "function" then
                    local v129;
                    v127, v124 = v126(v129, v128);
                else
                    v127, v124 = next(v126, v128);
                end;

                v128 = v127;
                u61();
                task.wait(0.1);
                break;
            else
                break;
            end;
        else
            break;
        end;
    end;
end;