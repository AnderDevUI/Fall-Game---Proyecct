-- [PATH] ReplicatedStorage / CharacterScripts / InteractController @Type LocalScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local UserInputService = game:GetService("UserInputService");
local UserService = game:GetService("UserService");
local MarketplaceService = game:GetService("MarketplaceService");
local Drops = workspace:WaitForChild("Drops");
local Bases = workspace:WaitForChild("Bases");
local Animals = workspace:WaitForChild("Animals");
local Plants = workspace:WaitForChild("Plants");
local Vegetation = workspace:WaitForChild("Vegetation");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local VFX = workspace:WaitForChild("VFX");
local VFX2 = ReplicatedStorage:WaitForChild("VFX");
local Values = ReplicatedStorage:WaitForChild("Values");
local GamepadIconModule = require(Modules:WaitForChild("GamepadIconModule"));
local Items = require(Modules:WaitForChild("Items"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local TweenUtil = require(Modules:WaitForChild("TweenUtil"));
local BenchInfo = require(Modules:WaitForChild("BenchInfo"));
local ButtonClass = require(Modules:WaitForChild("ButtonClass"));
local VFXModule = require(Modules:WaitForChild("VFXModule"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local AssetContainer = require(Modules:WaitForChild("AssetContainer"));
local ActiveBenchModule = require(Modules:WaitForChild("ActiveBenchModule"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local u1 = AssetContainer();
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Humanoid = script_Parent:WaitForChild("Humanoid");
local HumanoidRootPart = script_Parent:WaitForChild("HumanoidRootPart");
LocalPlayer:GetMouse();
local workspace_CurrentCamera = workspace.CurrentCamera;
local InventoryController = script_Parent:WaitForChild("InventoryController");
local EquipController = script_Parent:WaitForChild("EquipController");
local WheelController = script_Parent:WaitForChild("WheelController");
local CameraController = script_Parent:WaitForChild("CameraController");
local TeamNavigationController = script_Parent:WaitForChild("TeamNavigationController");
local WaterController = script_Parent:WaitForChild("WaterController");
local ClanLeaderboardController = script_Parent:WaitForChild("ClanLeaderboardController");
local ElectricityController = script_Parent:WaitForChild("ElectricityController");
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local GetSelected = script:WaitForChild("GetSelected");
local Update = ClanLeaderboardController:WaitForChild("Update");
local FetchTeam = TeamNavigationController:WaitForChild("FetchTeam");
local OpenBench = ElectricityController:WaitForChild("OpenBench");
local Main = PlayerGui:WaitForChild("Main");
local Hover = Main:WaitForChild("Hover");
local Codelock = Main:WaitForChild("Codelock");
local Controls = Codelock:WaitForChild("Controls");
local Info = VFX2:WaitForChild("Info");
local Interaction = Main:WaitForChild("GamepadControls"):WaitForChild("Interaction");
local RenameBed = Main:WaitForChild("RenameBed");
local TextBox = RenameBed:WaitForChild("TextBox");
local GiveBed = Main:WaitForChild("GiveBed");
local TextBox2 = GiveBed:WaitForChild("TextBox");
local FoundUser = GiveBed:WaitForChild("FoundUser");
local EditSign = Main:WaitForChild("EditSign");
local NPCDialogue = Main:WaitForChild("NPCDialogue");
local v2 = {};

for i, v in pairs(BenchInfo) do
    if type(v) == "table" and v.Type == "NPC" then
        table.insert(v2, i);
    end;
end;

local UDim2_new_ret = UDim2.new(0.5, 0, 0.84, 0);
local UDim2_new_ret2 = UDim2.new(0.5, 0, 0.9, 0);
local u3 = {
    Token = 0,
    COLOR_YES = Color3.fromRGB(123, 255, 0),
    COLOR_NO = Color3.fromRGB(255, 55, 55)
};
local CFrame_new_ret = CFrame.new(5.5, 1.1, -7.5);
local PowerThroughput = Main:WaitForChild("WireCutterInfo"):WaitForChild("PowerThroughput");
local u4 = nil;
local u5 = nil;
local v6 = nil;
local u7 = nil;
local u8 = tick();
local u9 = false;
local v10 = {};
local u11 = "";
local u12 = {
    One = "1",
    Two = "2",
    Three = "3",
    Four = "4",
    Five = "5",
    Six = "6",
    Seven = "7",
    Eight = "8",
    Nine = "9",
    Zero = "0"
};
local u13 = "";
local u14 = 0;
local u15 = 0;
local u16 = nil;
local u17 = nil;
local u18 = {
    ENGINE_PAD = 0.5,
    FUEL_HEIGHT = 0.75,
    SEAT_AIM = 1.75,
    SEAT_BEYOND = 2.5,
    SEAT_RANGE = 7,
    HINT_FRESH = 0.03333333333333333,
    VEHICLES = {
        ["Wooden Boat"] = {
            frame = "BoatMain",
            toggle = true,
            box = {
                lo = Vector3.new(-1.53, -1.93, 7.98),
                hi = Vector3.new(1.53, 4.41, 12.84),
                prompt = Vector3.new(0, 2.57, 10.16),
                pad = 0
            },
            seatAim = {
                VehicleSeat = Vector3.new(0, 0, -0.64)
            }
        },
        ["Military Boat"] = {
            frame = "BoatMain",
            toggle = true,
            box = {
                lo = Vector3.new(-1.35, 0.4, -0.2),
                hi = Vector3.new(1.35, 3.6, 2.8),
                prompt = Vector3.new(0, 2.8, 2.75),
                pad = 0.25
            }
        },
        ["Salvaged Flycopter"] = {
            frame = "Main",
            anchor = "FuelTank",
            parts = {
                FuelTank = true,
                EngineGear = true,
                EngineConveyor = true,
                FanFrame = true,
                EngineLeftFan = true,
                EngineRightFan = true
            }
        }
    },
    engines = setmetatable({}, {
        __mode = "k"
    }),
    aimParams = RaycastParams.new(),
    cache = {
        boat = nil,
        part = nil,
        pos = nil,
        cam = nil,
        t = (-1 / 0),
        a = nil,
        b = nil,
        c = nil
    }
};
u18.aimParams.FilterType = Enum.RaycastFilterType.Exclude;

function u18.OnEngine(p19: userdata, p20: any, p21: vector) -- Line: 201
    -- upvalues: u18 (copy)
    local v22 = u18.engines[p19];
    local v23 = p19:FindFirstChild(p20.frame);

    if not (v23 and v23:IsA("BasePart")) then
        return nil;
    end;

    if p20.box then
        if not (v22 and (v22.hull == v23 and v22.anchor.Parent == v23)) then
            local Attachment = Instance.new("Attachment");
            Attachment.Name = "BoatPromptAnchor";
            Attachment.Position = p20.box.prompt;
            Attachment.Parent = v23;
            v22 = {
                hull = v23,
                parts = {},
                anchor = Attachment
            };
            u18.engines[p19] = v22;
        end;

        local v24 = v23.CFrame:PointToObjectSpace(p21);
        local v25 = p20.box.lo - Vector3.new(1, 1, 1) * p20.box.pad;
        local v26 = p20.box.hi + Vector3.new(1, 1, 1) * p20.box.pad;

        if v24.X >= v25.X and (v24.X <= v26.X and (v24.Y >= v25.Y and (v24.Y <= v26.Y and (v24.Z >= v25.Z and v24.Z <= v26.Z)))) then
            return v22.anchor;
        end;

        return nil;
    end;

    if not (v22 and (v22.hull == v23 and v22.anchor.Parent == v23)) then
        local v27 = {};

        for _, descendant in p19:GetDescendants() do
            if descendant:IsA("BasePart") then
                local v28;

                if p20.parts then
                    v28 = p20.parts[descendant.Name] == true;
                elseif descendant.Name:sub(1, 6) == "Engine" then
                    v28 = descendant.Transparency < 1;
                else
                    v28 = false;
                end;

                if v28 then
                    table.insert(v27, descendant);
                end;
            end;
        end;

        if #v27 == 0 then
            return nil;
        end;

        local Attachment = Instance.new("Attachment");
        Attachment.Name = "BoatPromptAnchor";
        Attachment.Parent = v23;
        v22 = {
            hull = v23,
            parts = v27,
            anchor = Attachment
        };

        for _, v in v27 do
            if v.Name == p20.anchor then
                v22.anchorPart = v;
                break;
            end;
        end;

        u18.engines[p19] = v22;
    end;

    local CFrame2 = v23.CFrame;
    local ENGINE_PAD = u18.ENGINE_PAD;

    if not p20.parts then
        local v29 = Vector3.new(inf, inf, inf);
        local v30 = Vector3.new(-inf, -inf, -inf);

        for _, v in v22.parts do
            if v.Parent then
                local v31 = CFrame2:ToObjectSpace(v.CFrame);
                local v32 = v.Size / 2;

                for _, v3 in { -1, 1 } do
                    local v33 = v3;

                    for _, v4 in { -1, 1 } do
                        local v34 = v4;

                        for _, v5 in { -1, 1 } do
                            local v35 = v31 * Vector3.new(v32.X * v33, v32.Y * v34, v32.Z * v5);
                            v29 = v29:Min(v35);
                            v30 = v30:Max(v35);
                        end;
                    end;
                end;
            end;
        end;

        if v29.X > v30.X then
            return nil;
        end;

        local v36 = CFrame2:PointToObjectSpace(p21);
        local v37 = v29 - Vector3.new(1, 1, 1) * ENGINE_PAD;
        local v38 = v30 + Vector3.new(1, 1, 1) * ENGINE_PAD;

        if v36.X < v37.X or (v36.X > v38.X or (v36.Y < v37.Y or (v36.Y > v38.Y or (v36.Z < v37.Z or v36.Z > v38.Z)))) then
            return nil;
        end;

        local v39 = (v29 + v30) / 2;
        v22.anchor.Position = Vector3.new(v39.X, v29.Y + (v30.Y - v29.Y) * u18.FUEL_HEIGHT, v39.Z);

        return v22.anchor;
    end;

    local v40 = false;

    for _, v in v22.parts do
        if v.Parent then
            local v41 = v.CFrame:PointToObjectSpace(p21);
            local v42 = v.Size / 2 + Vector3.new(1, 1, 1) * ENGINE_PAD;

            if math.abs(v41.X) <= v42.X and (math.abs(v41.Y) <= v42.Y and math.abs(v41.Z) <= v42.Z) then
                v40 = true;
                break;
            end;
        end;
    end;

    if not v40 then
        return nil;
    end;

    local anchorPart = v22.anchorPart;

    if not (anchorPart and anchorPart.Parent) then
        v22.anchor.Position = CFrame2:PointToObjectSpace(v22.parts[1].Position);

        return v22.anchor;
    end;

    local v43 = CFrame2:ToObjectSpace(anchorPart.CFrame);
    local v44 = anchorPart.Size / 2;
    local Position = v43.Position;
    local Position2 = v43.Position;

    for _, v in { -1, 1 } do
        local v45 = v;

        for _, v3 in { -1, 1 } do
            local v46 = v3;

            for _, v4 in { -1, 1 } do
                local v47 = v43 * Vector3.new(v44.X * v45, v44.Y * v46, v44.Z * v4);
                Position = Position:Min(v47);
                Position2 = Position2:Max(v47);
            end;
        end;
    end;

    local v48 = (Position + Position2) / 2;
    local v49;

    if v48.X >= 0 then
        v49 = Position2.X;
    else
        v49 = Position.X;
    end;

    v22.anchor.Position = Vector3.new(v49, v48.Y - 0.14, Position.Z + (Position2.Z - Position.Z) * 0.25);

    return v22.anchor;
end;

function u18.Compute(p50: userdata?) -- Line: 302
    -- upvalues: u18 (copy), u17 (ref), u16 (ref), workspace_CurrentCamera (copy), script_Parent (copy), VFX (copy), WaterController (copy)
    local v51;

    if p50 then
        v51 = u18.VEHICLES[p50.Name];
    else
        v51 = p50;
    end;

    if not (p50 and (v51 and (u17 and (u16 and u17:IsDescendantOf(p50))))) then
        return nil, nil, nil;
    end;

    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Position = CFrame2.Position;
    local LookVector = CFrame2.LookVector;
    local v52 = u16;

    if u17.Name == "FakeHull" then
        u18.aimParams.FilterDescendantsInstances = { script_Parent, VFX, u17 };
        local v53 = workspace:Raycast(Position, LookVector * 30, u18.aimParams);

        if not (v53 and v53.Instance:IsDescendantOf(p50)) then
            return nil, nil, nil;
        end;

        v52 = v53.Position;
    end;

    local v54 = u18.OnEngine(p50, v51, v52);

    if v54 then
        if v51.toggle then
            local VehicleSeat = p50:FindFirstChild("VehicleSeat");
            local v55 = VehicleSeat and VehicleSeat:IsA("VehicleSeat") and VehicleSeat.Occupant;
            local v56 = not v55 or v55.Parent == script_Parent;

            if p50:GetAttribute("HasFuel") == true and v56 then
                if p50:GetAttribute("EngineOn") == true then
                    return "Engine:Stop", "TURN OFF", v54;
                end;

                return "Engine:Start", "TURN ON", v54;
            end;
        end;

        return "Engine", "OPEN FUEL", v54;
    end;

    if v51.frame == "BoatMain" and WaterController:GetAttribute("IsSwim") then
        local PrimaryPart = script_Parent.PrimaryPart;
        local v57 = nil;
        local v58 = nil;

        for _, child in p50:GetChildren() do
            if (child:IsA("Seat") or child:IsA("VehicleSeat")) and not child.Occupant then
                local v59 = not PrimaryPart and 0 or (child.Position - PrimaryPart.Position).Magnitude;

                if not v57 or v59 < v57 then
                    v58 = child;
                    v57 = v59;
                end;
            end;
        end;

        if v58 then
            return "Seat:" .. v58.Name, "SIT", v58;
        end;

        return "Hull", "", nil;
    end;

    local Magnitude = (v52 - Position).Magnitude;
    local SEAT_AIM = u18.SEAT_AIM;
    local v60 = p50:FindFirstChild(v51.frame);
    local v61 = nil;
    local v62 = false;

    for _, child in p50:GetChildren() do
        if child:IsA("Seat") or child:IsA("VehicleSeat") then
            if child.Occupant then
                v62 = true;
            else
                local v63 = v51.seatAim and v51.seatAim[child.Name];
                local v64 = child.Position - Position;

                if v63 and (v60 and v60:IsA("BasePart")) then
                    v64 = v64 + v60.CFrame:VectorToWorldSpace(v63);
                end;

                if v64.Magnitude <= u18.SEAT_RANGE then
                    local v65 = v64:Dot(LookVector);

                    if v65 > 0 and Magnitude + u18.SEAT_BEYOND >= v65 then
                        local Magnitude2 = (v64 - LookVector * v65).Magnitude;

                        if Magnitude2 < SEAT_AIM then
                            v61 = child;
                            SEAT_AIM = Magnitude2;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if v61 then
        return "Seat:" .. v61.Name, "SIT", v61;
    end;

    if v62 or p50:GetAttribute("EngineOn") == true then
        return "Hull", "", nil;
    end;

    return "Hull", "PUSH", nil;
end;

local function u70(p66: userdata?) -- Line: 385
    -- upvalues: u18 (copy), workspace_CurrentCamera (copy), u17 (ref), u16 (ref)
    local cache = u18.cache;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local os_clock_ret = os.clock();

    if cache.boat ~= p66 or (cache.part ~= u17 or (cache.pos ~= u16 or (cache.cam ~= CFrame2 or os_clock_ret - cache.t > u18.HINT_FRESH))) then
        cache.boat = p66;
        cache.part = u17;
        cache.pos = u16;
        cache.cam = CFrame2;
        cache.t = os_clock_ret;
        local v67, v68, v69 = u18.Compute(p66);
        cache.a = v67;
        cache.b = v68;
        cache.c = v69;
    end;

    return cache.a, cache.b, cache.c;
end;

local u71 = nil;
local u72 = 1;
local u73 = 1;
local u74 = false;
local u75 = 0;
local u76 = { { "1", "2", "3" }, { "4", "5", "6" }, { "7", "8", "9" }, { "Last", "0", "Clear" } };
local u77 = nil;
local u78 = nil;
local u79 = {};
local u80 = 0;
local u81 = 0;
local u82 = 0;
local u83 = 0;
local u84 = 0;
local u85 = 0;
local u86 = nil;
local u87 = nil;
local u88 = false;

local function _(p89) -- Line: 422
    -- upvalues: InventoryController (copy), EquipController (copy)
    local v90 = InventoryController.Fetch:Invoke();

    if not v90 then
        return;
    end;

    local Toolbar = v90.Toolbar;

    if Toolbar then
        local v91 = Toolbar[p89 or EquipController:GetAttribute("Equipped")];

        if v91 == nil then
            v91 = false;
        elseif v91 == 0 then
            v91 = false;
        end;

        return v91;
    end;
end;

local u92 = nil;

local function UpdateCodelockHighlight() -- Line: 433
    -- upvalues: u77 (ref), u76 (copy), u72 (ref), u73 (ref), Controls (copy), GamepadIconModule (copy)
    if not u77 then
        return;
    end;

    local v93 = u76[u72] and u76[u72][u73];

    if not v93 then
        return;
    end;

    local v94 = Controls.Keys:FindFirstChild(v93);

    if v94 then
        u77.Parent = v94;
        u77.Visible = true;
        u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");
    end;
end;

local function ClearCodelockHighlight() -- Line: 445
    -- upvalues: u77 (ref)
    if u77 then
        u77.Visible = false;
    end;
end;

local function u96() -- Line: 451
    -- upvalues: u11 (ref), Controls (copy), ReplicatedStorage (copy), u92 (ref)
    local v95 = u11:len();
    local string_rep_ret = string.rep("* ", (math.min(v95, 5)));
    Controls.Display.Code.Text = string_rep_ret:sub(1, string_rep_ret:len() - 1);

    if v95 >= 5 then
        ReplicatedStorage:SetAttribute("LastCode", u11:sub(1, 5));
        task.delay(0.1, u92, false);
    end;
end;

u92 = function(p97) -- Line: 461
    -- upvalues: u11 (ref), u96 (ref), u72 (ref), u73 (ref), u74 (ref), u77 (ref), Controls (copy), GamepadIconModule (copy), Codelock (copy), PreferredInputController (copy), u76 (copy), UserInputService (copy), u71 (ref)
    if p97 then
        u11 = "";
        u96();
        u72 = 1;
        u73 = 1;
        u74 = false;

        if not u77 then
            local v98 = Controls.Keys:FindFirstChild("0") and Controls.Keys["0"]:FindFirstChild("GamepadSelected");
            u77 = v98;

            if u77 then
                GamepadIconModule.Register(u77.ImageLabel, "ButtonA");
            end;

            GamepadIconModule.Register(Codelock.GamepadControls.CloseButton, "ButtonB");
        end;

        local v99 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v99 and u77 then
            local v100 = u76[u72] and u76[u72][u73];
            local v101 = v100 and Controls.Keys:FindFirstChild(v100);

            if v101 then
                u77.Parent = v101;
                u77.Visible = true;
                u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");
            end;
        end;

        Codelock.GamepadControls.Visible = v99;
    else
        if u77 then
            u77.Visible = false;
        end;

        Codelock.GamepadControls.Visible = false;
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior[p97 and "Default" or "LockCenter"];
    UserInputService.MouseIconEnabled = p97;
    Codelock.Visible = p97;

    if u71 then
        task.cancel(u71);
    end;
end;

local function u103(p102) -- Line: 492
    -- upvalues: u71 (ref), u11 (ref), ReplicatedStorage (copy), u96 (ref)
    if p102 == "Clear" then
        if u71 then
            task.cancel(u71);
        end;

        u11 = "";
    elseif p102 == "Last" then
        local Attribute = ReplicatedStorage:GetAttribute("LastCode");

        if Attribute then
            if u71 then
                task.cancel(u71);
            end;

            u11 = "";
            u71 = task.spawn(function() -- Line: 505
                -- upvalues: u11 (ref), Attribute (copy), u96 (ref), u71 (ref)
                for i = 1, 5 do
                    u11 = Attribute:sub(1, i);
                    u96();
                    task.wait(0.4);
                    local _ = i;
                end;

                u71 = nil;
            end);
        end;
    else
        if u71 then
            task.cancel(u71);
        end;

        if u11:len() < 5 then
            u11 = u11 .. p102;
        end;
    end;

    u96();
end;

local function u107() -- Line: 528
    -- upvalues: ReplicatedStorage (copy), MarketplaceService (copy), LocalPlayer (copy), EditSign (copy)
    local Attribute = ReplicatedStorage:GetAttribute("LabelsOwned");
    local v104 = false;
    local v105;

    if Attribute and os.time() - Attribute < 30 then
        v105 = true;
    else
        local v106;
        v106, v105 = pcall(function() -- Line: 535
            -- upvalues: MarketplaceService (ref), LocalPlayer (ref)
            return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, 667425168);
        end);

        if not v106 then
            v105 = v104;
        end;
    end;

    EditSign.Locked.Visible = not v105;
    EditSign.Unlocked.Visible = v105;
    EditSign.ConfirmImage.Visible = v105;
end;

local function u142(p108) -- Line: 547
    -- upvalues: Codelock (copy), u4 (ref), InventoryController (copy), u86 (ref), Vegetation (copy), u15 (ref), u1 (copy), u16 (ref), Bases (copy), BenchInfo (copy), u84 (ref), Update (copy), u9 (ref), u82 (ref), u5 (ref), EquipController (copy), Items (copy), script_Parent (copy), RunService (copy), Humanoid (copy), NumberUtil (copy), Hover (copy), TweenUtil (copy), VFXModule (copy), u70 (copy), Values (copy), RaycastUtil (copy), ActiveBenchModule (copy), WheelController (copy), u92 (ref), u11 (ref), u7 (ref), RenameBed (copy), u13 (ref), TextBox (copy), UserInputService (copy), FoundUser (copy), GiveBed (copy), TextBox2 (copy), u78 (ref), EditSign (copy), u107 (copy), Players (copy), u81 (ref), u8 (ref), u80 (ref)
    if Codelock.Visible or not (u4 and (u4.Parent and not (InventoryController:GetAttribute("Open") or script:GetAttribute("Dialog") and u86 == u4))) then
        return;
    end;

    local v109;

    if u4.Name == "DigPile" then
        v109 = u4.Parent == Vegetation;
    else
        v109 = false;
    end;

    if u4:IsA("Terrain") then
        if tick() - u15 < 2 then
            return;
        end;

        u15 = tick();
        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\094\194\187\077\120\101\195\190\088\074\239\191\189\195\164\239\191\189\239\191\189\093\239\191\189\105\239\191\189\239\191\189\239\191\189\239\191\189\195\154", u4, u16);

        return;
    end;

    if v109 or u4:IsDescendantOf(Bases) then
        local v110 = BenchInfo[u4.Name];

        if v110 and (v110.Type == "ClanTable" and os.clock() - u84 >= 6) then
            u84 = os.clock();
            Update:Fire(u4);
        end;

        if u9 or not (v110 or v109) then
            return;
        end;

        local v111 = tick();

        if v111 - u82 < 0.125 then
            return;
        end;

        u82 = v111;
        local u112 = v109 and 10 or (v110.InteractDistance or script:GetAttribute("DefaultDistance"));
        u9 = true;
        local u113 = u4;
        u5 = u113;
        local v114;

        if v109 then
            v114 = u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\239\191\189\195\171\239\191\189\194\170\059\195\182\239\191\189\195\157\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\170\068\239\191\189\239\191\189\239\191\189\086\063", "Start", u113);

            if not v114 then
                u9 = false;
                u5 = nil;

                return;
            end;
        else
            v114 = nil;
        end;

        local v115 = 0;
        local v116 = true;
        local v117 = nil;
        local v118 = InventoryController.Fetch:Invoke();
        local v119;

        if v118 then
            local Toolbar = v118.Toolbar;

            if Toolbar then
                v119 = Toolbar[EquipController:GetAttribute("Equipped")];

                if v119 == nil then
                    v119 = false;
                elseif v119 == 0 then
                    v119 = false;
                end;
            else
                v119 = nil;
            end;
        else
            v119 = nil;
        end;

        local v120 = false;

        if v119 and v119 ~= 0 then
            local v121 = Items[v119.ID];

            if v121 and (v121.MaxDurability == nil or v119.Durability and v119.Durability > 0) then
                local Name = v121.Name;

                if Name == "Steel Shovel" or Name == "Salvaged Shovel" then
                    v120 = script_Parent:FindFirstChild(Name);
                end;
            end;
        end;

        local v122 = nil;
        local v123 = 0;

        while v115 < (v114 or 0.4) do
            local v124 = RunService.Heartbeat:Wait();
            local v125 = u9 and (script_Parent and script_Parent.Parent and (script_Parent.PrimaryPart and Humanoid));

            if v125 then
                if Humanoid.Health > 0 then
                    v125 = u113 and u113.Parent and (v120 and v120.Parent or v120 == false);
                else
                    v125 = false;
                end;
            end;

            v122 = not v125;

            if v122 then
                break;
            end;

            local PrimaryPart = script_Parent.PrimaryPart;
            local PrimaryPart2 = u113.PrimaryPart;

            if InventoryController:GetAttribute("Open") or not NumberUtil:IsWithin(PrimaryPart.Position, PrimaryPart2.Position, u112) then
                v115 = 0;

                if v109 then
                    break;
                end;
            else
                v115 = v115 + v124;
            end;

            if v109 then
                if v116 then
                    Hover.Bar.Fill.Size = UDim2.new(0, 0, 1, 0);
                    TweenUtil:Tween(Hover.Bar.Fill, "Size", UDim2.new(1, 0, 1, 0), v114, "Sine", "In");
                    local Pivot = u113:GetPivot();
                    script.Value.Value = Pivot;
                    v117 = TweenUtil:Tween(script.Value, "Value", Pivot * CFrame.new(0, -0.75, 0), v114, "Quart", "In");
                    Hover.Bar.Visible = true;
                    PrimaryPart2.Smoke.Enabled = true;
                    script:SetAttribute("Digging", true);
                elseif v117 then
                    local Value = script.Value.Value;
                    u113:PivotTo(Value * CFrame.new(math.random(-10, 10) / 7 * v124, 0, math.random(-10, 10) / 7 * v124));

                    if v123 <= v115 then
                        v123 = v123 + 0.25;
                        task.defer(VFXModule.CreateGibs, VFXModule, "DigGibs", Value * CFrame.Angles(1.5707963267948966, 0, 0), 3, 3, 0.25, 60, 60, 60, 20, 25, true);
                    end;
                end;
            end;

            v116 = false;
        end;

        if v109 then
            u9 = false;
            u5 = nil;
            Hover.Bar.Visible = false;
            script:SetAttribute("Digging", false);

            if u113.Parent then
                u113.Dirt.Smoke.Enabled = false;

                if v117 then
                    v117:Cancel();
                end;

                if v122 or v115 == 0 then
                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\239\191\189\195\171\239\191\189\194\170\059\195\182\239\191\189\195\157\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\170\068\239\191\189\239\191\189\239\191\189\086\063", "Cancel", u113);
                end;
            end;

            return;
        end;

        local v126;

        if v115 < 0.4 then
            v126 = u70(u113);
        else
            v126 = nil;
        end;

        local v127 = u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u113, v115 >= 0.4 and 0 or 1, v126);
        local v128 = v127 == "Rename Bed";
        local v129 = v127 == "Give To Friend";
        local v130 = v127 == "Edit Sign";
        local DemolishTimerMult = v110.DemolishTimerMult;

        if DemolishTimerMult and (u4 and (u4.PrimaryPart and v115 >= 0.4)) then
            local Value = Values.ServerTick.Value;
            local BaseCabinetUnder = RaycastUtil:GetBaseCabinetUnder(u4.PrimaryPart.Position);

            if not (BaseCabinetUnder and BaseCabinetUnder:GetAttribute("Monument")) then
                local ClientInfo = ActiveBenchModule.GetClientInfo(BaseCabinetUnder);

                if not ClientInfo or ClientInfo.Access ~= false then
                    v127 = v127 or {};
                    local v131;

                    if Value - (u4:GetAttribute("Placed") or Value - 0.01) < Values.DemolishTimer.Value * DemolishTimerMult then
                        v131 = Values.SimpleDemolish.Value;

                        if not v131 then
                            if ClientInfo == nil then
                                v131 = false;
                            else
                                v131 = ClientInfo.Access;
                            end;
                        end;
                    else
                        v131 = false;
                    end;

                    local v132 = v131 and true or false;

                    if v131 then
                        for _, v in v127 do
                            if type(v) == "table" and v.SelectFirst then
                                v132 = false;
                                break;
                            end;
                        end;
                    end;

                    table.insert(v127, {
                        Image = "rbxassetid://13002666332",
                        Name = "Demolish",
                        Description = "Get rid of selected deployable.",
                        Selectable = v131,
                        SelectFirst = v132
                    });
                end;
            end;
        end;

        if type(v127) == "table" then
            task.defer(function() -- Line: 701
                -- upvalues: u9 (ref), Codelock (ref), u113 (copy), script_Parent (ref), Humanoid (ref), NumberUtil (ref), u112 (copy), WheelController (ref), u5 (ref), u92 (ref)
                while u9 or Codelock.Visible do
                    if not (u113 and (u113.Parent and (script_Parent and (script_Parent.Parent and (script_Parent.PrimaryPart and (Humanoid and (Humanoid.Health > 0 and NumberUtil:IsWithin(script_Parent.PrimaryPart.Position, u113.PrimaryPart.Position, u112)))))))) then
                        WheelController.Close:Invoke("Bench");
                        u5 = nil;
                        break;
                    end;

                    task.wait();
                end;

                u92(false);
            end);
            local u133 = WheelController.Open:Invoke(v127, "Bench", true);
            local u134 = v127[u133];

            if u134 and u134.Name == "Rename Bed" then
                v128 = true;
                u9 = false;
                u5 = nil;
            elseif u134 and u134.Name == "Give To Friend" then
                v129 = true;
                u9 = false;
                u5 = nil;
            elseif u134 and u134.Name == "Edit Sign" then
                v130 = true;
                u9 = false;
                u5 = nil;
            elseif u134 and u134.Name == "Demolish" then
                u9 = false;
                u5 = nil;
                u1("Fire", "\239\191\189\107\239\191\189\052\111\239\191\189\239\191\189\239\191\189\239\191\189\195\135\239\191\189\239\191\189\048\239\191\189\195\149\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\046\239\191\189\115\239\191\189\239\191\189\239\191\189\095\239\191\189\194\179\108\195\153\239\191\189\081\056", u113, 6);
            else
                task.defer(function() -- Line: 738
                    -- upvalues: u134 (copy), u113 (copy), u92 (ref), Codelock (ref), u9 (ref), u5 (ref), u133 (copy), u11 (ref), u1 (ref)
                    local v135;

                    if u134 and u134.Name:find("Combination") then
                        if not (u113 and u113.Parent) then
                            return;
                        end;

                        u92(true);
                        v135 = true;

                        while Codelock.Visible do
                            task.wait();
                        end;
                    else
                        v135 = false;
                    end;

                    local v136 = u9;
                    u9 = false;
                    u5 = nil;

                    if not (u133 and (u113 and u113.Parent)) then
                        return;
                    end;

                    if v135 and u11:len() == 5 then
                        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u113, u133, u11);

                        return;
                    end;

                    if v136 then
                        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u113, u133);
                    end;
                end);
            end;
        else
            u9 = false;
            u5 = nil;
        end;

        if v128 then
            u7 = u113;
            RenameBed.Rename.Visible = false;
            u13 = u113:GetAttribute("BedName") or "";
            TextBox.Text = u13;
            RenameBed.Visible = true;

            while UserInputService:IsKeyDown(p108) and RenameBed.Visible do
                task.wait();
            end;

            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
            UserInputService.MouseIconEnabled = true;
            TextBox:CaptureFocus();

            return;
        end;

        if v129 then
            u7 = u113;
            FoundUser.Visible = false;
            GiveBed.Give.Visible = false;
            GiveBed.TextBox.Text = "";
            GiveBed.Visible = true;

            while UserInputService:IsKeyDown(p108) and GiveBed.Visible do
                task.wait();
            end;

            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
            UserInputService.MouseIconEnabled = true;
            TextBox2:CaptureFocus();

            return;
        end;

        if v130 then
            local GuiReference = u113:FindFirstChild("GuiReference");
            local v137;

            if GuiReference == nil then
                v137 = false;
            else
                v137 = GuiReference.Value;
            end;

            u78 = u113:GetAttribute("MaxCharacters");

            if typeof(v137) == "Instance" and (v137.Parent and u78) then
                u7 = u113;

                if v137.TextLabel.Visible then
                    EditSign.TextBox.Text = v137.TextLabel.Text;
                    EditSign.Unlocked.Selected.Image = "";
                    EditSign.Unlocked.TextBox.Text = "";
                else
                    EditSign.TextBox.Text = "";
                    local v138 = v137.ImageLabel.Image:gsub("%D", "");
                    local v139 = tonumber(v138);
                    EditSign.Unlocked.Selected.Image = v139 and ("rbxassetid://" .. v139 or "") or "";
                    EditSign.Unlocked.TextBox.Text = v139 and tostring(v139) or "";
                end;

                u107();
                EditSign.Visible = true;

                while UserInputService:IsKeyDown(p108) and EditSign.Visible do
                    task.wait();
                end;

                UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
                UserInputService.MouseIconEnabled = true;
            end;
        end;
    else
        if Players:FindFirstChild(u4.Name) then
            local Character = Players[u4.Name].Character;

            if not (Character or (Character.Humanoid or Character.Humanoid.Health > 0)) then
                return;
            end;

            if not Character.Humanoid:GetAttribute("Downed") then
                if tick() - u8 <= 2 then
                    return;
                end;

                u8 = tick();
                u1("Fire", "\194\185\194\175\112\194\185\239\191\189\077\195\165\066\239\191\189\239\191\189\239\191\189\074\239\191\189\239\191\189\239\191\189\082\195\132\239\191\189\239\191\189\239\191\189", "\195\164\093\239\191\189\099\239\191\189\239\191\189\194\175\239\191\189\057\239\191\189\053\239\191\189\239\191\189\103\069\239\191\189\125\239\191\189\239\191\189\239\191\189", "Invite", Players[u4.Name].UserId);

                return;
            end;

            local v140 = tick();

            if v140 - u81 < 0.2 then
                return;
            end;

            u81 = v140;
            script:SetAttribute("Reviving", true);
            script:SetAttribute("ReviveStart", v140);
            u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\125\239\191\189\038\086\239\191\189\239\191\189\066\038\195\178\080\239\191\189\049\239\191\189\118\239\191\189", Character);
            task.delay(4, function() -- Line: 839
                if script:GetAttribute("Reviving") then
                    if tick() - script:GetAttribute("ReviveStart") < 4 then
                        return;
                    end;

                    script:SetAttribute("Reviving", false);
                end;
            end);

            return;
        end;

        local v141 = tick();

        if v141 - u80 < 0.15 then
            return;
        end;

        u80 = v141;
        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\239\191\189\239\191\189\195\137\239\191\189\239\191\189\195\172\239\191\189\239\191\189\239\191\189\239\191\189\105\239\191\189\239\191\189\122\194\188\194\162\195\155\077\239\191\189\239\191\189", u4);
    end;
end;

local function u143() -- Line: 866
    -- upvalues: u9 (ref), WheelController (copy), u1 (copy)
    u9 = false;
    WheelController.Close:Invoke("Bench");

    if script:GetAttribute("Reviving") then
        script:SetAttribute("Reviving", false);
        u1(
            "Fire",
            "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033",
            "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\125\239\191\189\038\086\239\191\189\239\191\189\066\038\195\178\080\239\191\189\049\239\191\189\118\239\191\189",
            false
        );
    end;
end;

local function u147() -- Line: 880
    -- upvalues: EquipController (copy), InventoryController (copy), u4 (ref), Items (copy)
    local Attribute = EquipController:GetAttribute("Equipped");
    local v144 = InventoryController.Fetch:Invoke();
    local v145;

    if v144 then
        local Toolbar = v144.Toolbar;

        if Toolbar then
            v145 = Toolbar[Attribute or EquipController:GetAttribute("Equipped")];

            if v145 == nil then
                v145 = false;
            elseif v145 == 0 then
                v145 = false;
            end;
        else
            v145 = nil;
        end;
    else
        v145 = nil;
    end;

    if not (u4 and (u4.Parent and (v145 and v145.Amount > 0))) then
        return;
    end;

    local v146 = Items[v145.ID];

    if not v146 then
        return;
    end;

    local Type = v146.Type;

    if Type == "Lock" then
        return "Lock", Attribute;
    end;

    if Type == "Tool" and (v145.ID == 326 and shared.CachedConnections[u4] ~= nil) then
        return "Bench", Attribute;
    end;
end;

local function _() -- Line: 894
    -- upvalues: u147 (copy), u1 (copy), u4 (ref), OpenBench (copy)
    local v148, v149 = u147();

    if v148 == "Lock" then
        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\033\239\191\189\239\191\189\239\191\189\045\195\160\195\161\239\191\189\194\177\239\191\189\085\103\239\191\189\123\239\191\189\239\191\189\053\239\191\189\239\191\189\073", u4, v149);

        return;
    end;

    if v148 == "Bench" then
        OpenBench:Fire(u4);
    end;
end;

local function v155(p150: string, p151: userdata, p152: string?) -- Line: 906
    local Lock = p151:FindFirstChild("Lock", true);

    if not Lock then
        return;
    end;

    local v153 = false;

    for _, child in pairs(Lock:GetChildren()) do
        if child:GetAttribute("On") then
            v153 = true;
            break;
        end;
    end;

    if v153 then
        return;
    end;

    for _, child in pairs(Lock:GetChildren()) do
        local v154 = child;

        for _, child2 in pairs(child:GetChildren()) do
            if child2:IsA("BasePart") then
                child2.Color = Color3.fromRGB(0, 113, 165);
                child2.Transparency = v154.Name == p152 and 0 or 1;
            end;
        end;
    end;
end;

local function u157(...) -- Line: 925
    -- upvalues: u83 (ref), u1 (copy)
    local v156 = tick();

    if v156 - u83 >= 0.2 then
        u83 = v156;
        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", ...);

        return true;
    end;
end;

local u158 = {
    { Enum.KeyCode.ButtonB },
    { Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonB },
    { Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonB }
};

local function _(p159: number) -- Line: 941
    -- upvalues: u158 (copy)
    return u158[math.clamp(p159, 1, 3)];
end;

local function u167(u160) -- Line: 953
    -- upvalues: NPCDialogue (copy), CFrame_new_ret (copy)
    local Portrait = NPCDialogue.PortraitCanvas.Portrait;
    local v161;

    if u160 then
        v161 = u160:GetFullName() or nil;
    else
        v161 = nil;
    end;

    if Portrait:GetAttribute("Showing") == v161 then
        return;
    end;

    Portrait:ClearAllChildren();
    Portrait:SetAttribute("Showing", nil);

    if not (u160 and u160.Parent) then
        return;
    end;

    if pcall(function() -- Line: 960
        -- upvalues: u160 (copy), Portrait (copy), CFrame_new_ret (ref)
        local v162 = u160:Clone();

        for _, descendant in ipairs(v162:GetDescendants()) do
            if descendant:IsA("BillboardGui") or (descendant:IsA("SurfaceGui") or (descendant:IsA("ProximityPrompt") or descendant:IsA("LuaSourceContainer"))) then
                descendant:Destroy();
            end;
        end;

        local v163 = v162:FindFirstChild("HumanoidRootPart") or (v162:FindFirstChild("RootPart") or v162:FindFirstChild("UpperTorso") or (v162:FindFirstChild("LowerTorso") or v162.PrimaryPart));

        if not v163 then
            v162:Destroy();

            return;
        end;

        for _, descendant in ipairs(v162:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Anchored = descendant == v163;
            end;
        end;

        local WorldModel = Instance.new("WorldModel");
        v162.Parent = WorldModel;
        WorldModel.Parent = Portrait;
        local Camera = Instance.new("Camera");
        Camera.FieldOfView = 30;
        Camera.CFrame = CFrame.lookAt((v163.CFrame * CFrame_new_ret).Position, v163.Position + Vector3.new(0.3, 0.5, -0.6));
        Camera.Parent = Portrait;
        Portrait.CurrentCamera = Camera;
        local v164 = v162:FindFirstChildOfClass("Humanoid") or v162:FindFirstChildOfClass("AnimationController");

        if not v164 then
            v164 = Instance.new("AnimationController");
            v164.Parent = v162;
        end;

        local v165 = v164:FindFirstChildOfClass("Animator");

        if not v165 then
            v165 = Instance.new("Animator");
            v165.Parent = v164;
        end;

        local IdleAnim = v162:FindFirstChild("IdleAnim");

        if not IdleAnim then
            IdleAnim = Instance.new("Animation");
            IdleAnim.AnimationId = "rbxassetid://106473400142459";
            IdleAnim.Parent = v162;
        end;

        local v166 = v165:LoadAnimation(IdleAnim);
        v166.Looped = true;
        v166:Play();
        Portrait:SetAttribute("Animating", v166.IsPlaying);
    end) and Portrait:FindFirstChildOfClass("WorldModel") then
        Portrait:SetAttribute("Showing", v161);
    end;
end;

u3.FadeValue = Instance.new("NumberValue");

function u3.FadeTo(p168: number, p169: number) -- Line: 1023
    -- upvalues: u3 (copy), NPCDialogue (copy), TweenUtil (copy)
    if not u3.FadeParts then
        local u170 = {};

        for _, descendant in NPCDialogue:GetDescendants() do
            if not descendant:FindFirstAncestorWhichIsA("CanvasGroup") then
                local v171 = descendant;

                for _, v in (descendant:IsA("TextLabel") or descendant:IsA("TextButton")) and { "TextTransparency", "BackgroundTransparency" } or (descendant:IsA("CanvasGroup") and { "GroupTransparency", "BackgroundTransparency" } or (descendant:IsA("GuiObject") and { "BackgroundTransparency" } or (descendant:IsA("UIStroke") and { "Transparency" } or nil))) or {} do
                    table.insert(u170, { v171, v, v171[v] });
                end;
            end;
        end;

        u3.FadeParts = u170;
        u3.FadeValue.Value = 1;
        u3.FadeValue.Changed:Connect(function(p172: number) -- Line: 1039
            -- upvalues: u170 (copy)
            for _, v in u170 do
                v[1][v[2]] = 1 - (1 - v[3]) * p172;
            end;
        end);
    end;

    if p169 <= 0 then
        u3.FadeValue.Value = p168;

        return;
    end;

    TweenUtil:Tween(u3.FadeValue, "Value", p168, p169, "Quad", p168 > 0 and "Out" or "In");
end;

function u3.ScaleText() -- Line: 1055
    -- upvalues: NPCDialogue (copy)
    local u173 = NPCDialogue.AbsoluteSize.Y / 230;

    if u173 <= 0 then
        return;
    end;

    local function cap(p174: userdata, p175: number, p176: number) -- Line: 1058
        -- upvalues: u173 (copy)
        local v177 = p174:FindFirstChildOfClass("UITextSizeConstraint");

        if not v177 then
            return;
        end;

        local math_round_ret = math.round(p175 * u173);
        local math_max_ret = math.max(math_round_ret, 1);
        v177.MinTextSize = math.min(p176, math_max_ret);
        v177.MaxTextSize = math_max_ret;
    end;

    local v178 = NPCDialogue.Box.Text:FindFirstChildOfClass("UITextSizeConstraint");

    if v178 then
        local math_round_ret = math.round(18 * u173);
        local math_max_ret = math.max(math_round_ret, 1);
        v178.MinTextSize = math.min(10, math_max_ret);
        v178.MaxTextSize = math_max_ret;
    end;

    local v179 = NPCDialogue.SpeakerName:FindFirstChildOfClass("UITextSizeConstraint");

    if v179 then
        local math_round_ret = math.round(34 * u173);
        local math_max_ret = math.max(math_round_ret, 1);
        v179.MinTextSize = math.min(1, math_max_ret);
        v179.MaxTextSize = math_max_ret;
    end;

    for _, child in NPCDialogue.Box.Options:GetChildren() do
        if child:IsA("TextButton") then
            child.TextScaled = true;
            local v180 = child:FindFirstChildOfClass("UITextSizeConstraint");

            if v180 then
                local math_round_ret = math.round(16 * u173);
                local math_max_ret = math.max(math_round_ret, 1);
                v180.MinTextSize = math.min(8, math_max_ret);
                v180.MaxTextSize = math_max_ret;
            end;
        end;
    end;
end;

NPCDialogue:GetPropertyChangedSignal("AbsoluteSize"):Connect(u3.ScaleText);
u3.ScaleText();

local function u185() -- Line: 1079
    -- upvalues: u87 (ref), u88 (ref), u158 (copy), NPCDialogue (copy), GamepadIconModule (copy)
    if not u87 then
        return;
    end;

    local Options = u87.Options;
    local v181;

    if u88 then
        v181 = u158[math.clamp(#Options, 1, 3)] or nil;
    else
        v181 = nil;
    end;

    for i, v in Options do
        local v182 = NPCDialogue.Box.Options:FindFirstChild((`Option{i}`));

        if v182 then
            local v183;

            if v181 then
                v183 = v181[i];
            else
                v183 = v181;
            end;

            local v184;

            if v183 then
                v184 = GamepadIconModule.GetText(v183.Name) or i;
            else
                v184 = i;
            end;

            v182.Text = `[{v184}] {v.Text}`;
        end;
    end;
end;

local function u198(p186, p187, p188, p189) -- Line: 1092
    -- upvalues: u87 (ref), u85 (ref), u86 (ref), HumanoidRootPart (copy), script_Parent (copy), NumberUtil (copy), u198 (ref), u3 (copy), NPCDialogue (copy), UDim2_new_ret2 (copy), u167 (copy), u185 (copy), UDim2_new_ret (copy)
    u87 = p187;
    u85 = p188;
    u86 = p189;
    task.defer(function() -- Line: 1096
        -- upvalues: u87 (ref), u86 (ref), HumanoidRootPart (ref), script_Parent (ref), NumberUtil (ref), u198 (ref)
        script:SetAttribute("Dialog", u87 ~= nil);
        script:SetAttribute("DialogOptions", u87 and #u87.Options or 0);

        if not u86 then
            return;
        end;

        local v190 = u86;

        while true do
            local v191 = v190.Parent and (v190 == u86 and HumanoidRootPart.Parent) and (u86:FindFirstChild("Head") or u86:FindFirstChild("UpperTorso") or (u86:FindFirstChild("RootPart") or u86.PrimaryPart));

            if not v191 then
                break;
            end;

            if not NumberUtil:IsWithin((script_Parent:FindFirstChild("Head") or HumanoidRootPart).Position, v191.Position, 10) then
                u198();

                return;
            end;

            task.wait(0.1);
        end;
    end);

    if not u87 then
        u3.Show();
        local Portrait = NPCDialogue.PortraitCanvas.Portrait;

        if Portrait:GetAttribute("Showing") ~= nil then
            Portrait:ClearAllChildren();
            Portrait:SetAttribute("Showing", nil);
        end;

        u3.FadeTo(0, 0.25);
        NPCDialogue:TweenPosition(UDim2_new_ret2, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true);
        task.wait(0.41);

        if NPCDialogue.Position ~= UDim2_new_ret2 then
            return;
        end;

        NPCDialogue.Visible = false;

        return;
    end;

    local Text = p187.Text;
    local Options = p187.Options;
    u167(p189);
    NPCDialogue.SpeakerName.Text = p186:upper();
    local Options2 = NPCDialogue.Box.Options;
    local v192 = 0;

    while true do
        v192 = v192 + 1;
        local v193 = Options2:FindFirstChild((`Option{v192}`));

        if not v193 then
            break;
        end;

        v193.Visible = false;
    end;

    for i, v in Options do
        local v194 = Options2[`Option{i}`];
        local v195;

        if v.Color == 1 then
            v195 = u3.COLOR_YES;
        else
            v195 = u3.COLOR_NO;
        end;

        v194.TextColor3 = v195;
        v194.Visible = true;
    end;

    u185();
    u3.Show();
    local Text2 = NPCDialogue.Box.Text;
    Text2.Text = "";

    if not NPCDialogue.Visible then
        NPCDialogue.Position = UDim2_new_ret2;
        u3.FadeTo(0, 0);
        NPCDialogue.Visible = true;
    end;

    u3.FadeTo(1, 0.25);
    NPCDialogue:TweenPosition(UDim2_new_ret, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true);
    task.wait(0.3);
    local v196 = "";

    for i = 1, Text:len() do
        if Text2.Text ~= v196 or not u87 then
            break;
        end;

        local v197 = Text:sub(i, i);
        v196 = v196 .. v197;
        Text2.Text = v196;
        task.wait(v197 == "," and 0.2 or ((v197 == "!" or (v197 == "?" or v197 == ".")) and 0.25 or 0.016666666666666666));
        local _ = i;
    end;
end;

local function _(p199: number) -- Line: 1171
    -- upvalues: u87 (ref), u86 (ref), u198 (ref), u1 (copy), u85 (ref)
    if not (u87 and (u86 and u86.Parent)) then
        return false;
    end;

    local v200 = u87.Options[p199];

    if not v200 then
        return false;
    end;

    if v200.Action == "Close" then
        u198();
    else
        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\097\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\164\055\195\186\123\239\191\189\239\191\189\239\191\189\239\191\189", u86, u85, p199);
    end;

    return true;
end;

function u3.Show() -- Line: 1190
    -- upvalues: u3 (copy), WheelController (copy), u87 (ref), MobileModule (copy), u86 (ref), u198 (ref), u1 (copy), u85 (ref)
    local v201 = u3;
    v201.Token = v201.Token + 1;
    local Token = u3.Token;
    WheelController.Close:Invoke("Dialog");

    if not (u87 and MobileModule.IsTouch()) then
        return;
    end;

    local u202 = {};

    for _, v in u87.Options do
        local v203 = {
            Selectable = true,
            Name = v.Text
        };
        local v204;

        if v.Color == 1 then
            v204 = u3.COLOR_YES;
        else
            v204 = u3.COLOR_NO;
        end;

        v203.Color = v204;
        table.insert(u202, v203);
    end;

    task.spawn(function() -- Line: 1203
        -- upvalues: WheelController (ref), u202 (copy), Token (copy), u3 (ref), u87 (ref), u86 (ref), u198 (ref), u1 (ref), u85 (ref)
        local v205 = WheelController.Open:Invoke(u202, "Dialog");

        if Token ~= u3.Token or not v205 then
            return;
        end;

        if u87 and u86 then
            if not u86.Parent then
                return;
            end;

            local v206 = u87.Options[v205];

            if not v206 then
                return;
            end;

            if v206.Action == "Close" then
                u198();

                return;
            end;

            u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\097\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\164\055\195\186\123\239\191\189\239\191\189\239\191\189\239\191\189", u86, u85, v205);
        end;
    end);
end;

local u207 = 0;

while true do
    u207 = u207 + 1;
    local v208 = NPCDialogue.Box.Options:FindFirstChild((`Option{u207}`));

    if not v208 then
        break;
    end;

    if v208:IsA("TextButton") then
        v208.MouseButton1Click:Connect(function() -- Line: 1221
            -- upvalues: u207 (copy), u87 (ref), u86 (ref), u198 (ref), u1 (copy), u85 (ref)
            local v209 = u207;

            if u87 and u86 then
                if not u86.Parent then
                    return;
                end;

                local v210 = u87.Options[v209];

                if not v210 then
                    return;
                end;

                if v210.Action == "Close" then
                    u198();

                    return;
                end;

                u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\097\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\164\055\195\186\123\239\191\189\239\191\189\239\191\189\239\191\189", u86, u85, v209);
            end;
        end);
    end;
end;

UserInputService.InputBegan:Connect(function(p211, p212) -- Line: 1229
    -- upvalues: SettingsModule (copy), UserInputService (copy), u142 (copy), Codelock (copy), u92 (ref), u12 (copy), u103 (copy), u87 (ref), u86 (ref), u198 (ref), u1 (copy), u85 (ref), u147 (copy), u4 (ref), OpenBench (copy), TeamNavigationController (copy), InventoryController (copy), u158 (copy), u76 (copy), u72 (ref), u73 (ref), u75 (ref), u77 (ref), Controls (copy), GamepadIconModule (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    local UserInputType = p211.UserInputType;

    if UserInputService:GetFocusedTextBox() then
        return;
    end;

    if UserInputType == Enum.UserInputType.Keyboard then
        local KeyCode = p211.KeyCode;

        if KeyCode.Name == SettingsModule.GetSetting("Controls", "Interact") and not p212 then
            u142(KeyCode);

            return;
        end;

        if KeyCode.Name == SettingsModule.GetSetting("Controls", "Open Inventory") and Codelock.Visible then
            u92(false);

            return;
        end;

        if Codelock.Visible then
            local v213 = u12[KeyCode.Name];

            if not v213 then
                return;
            end;

            u103(v213);

            return;
        end;

        if KeyCode == Enum.KeyCode.One or (KeyCode == Enum.KeyCode.Two or KeyCode == Enum.KeyCode.Three) then
            local v214 = KeyCode == Enum.KeyCode.One and 1 or (KeyCode == Enum.KeyCode.Two and 2 or 3);

            if u87 and u86 then
                if not u86.Parent then
                    return;
                end;

                local v215 = u87.Options[v214];

                if not v215 then
                    return;
                end;

                if v215.Action == "Close" then
                    u198();

                    return;
                end;

                u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\097\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\164\055\195\186\123\239\191\189\239\191\189\239\191\189\239\191\189", u86, u85, v214);
            end;
        end;
    elseif UserInputType == Enum.UserInputType.MouseButton1 and not p212 then
        local v216, v217 = u147();

        if v216 == "Lock" then
            u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\033\239\191\189\239\191\189\239\191\189\045\195\160\195\161\239\191\189\194\177\239\191\189\085\103\239\191\189\123\239\191\189\239\191\189\053\239\191\189\239\191\189\073", u4, v217);

            return;
        end;

        if v216 == "Bench" then
            OpenBench:Fire(u4);
        end;
    elseif UserInputType == Enum.UserInputType.Gamepad1 then
        if TeamNavigationController:GetAttribute("MapOpen") then
            return;
        end;

        local KeyCode = p211.KeyCode;
        local Attribute = InventoryController:GetAttribute("Open");

        if u87 and (u86 and u86.Parent) then
            local v218 = nil;

            for i, v in u158[math.clamp(#u87.Options, 1, 3)] do
                if KeyCode == v then
                    v218 = i;
                    break;
                end;
            end;

            if v218 then
                if u87 and u86 then
                    if not u86.Parent then
                        return;
                    end;

                    local v219 = u87.Options[v218];

                    if not v219 then
                        return;
                    end;

                    if v219.Action == "Close" then
                        u198();

                        return;
                    end;

                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\097\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\164\055\195\186\123\239\191\189\239\191\189\239\191\189\239\191\189", u86, u85, v218);
                end;

                return;
            end;
        end;

        if Codelock.Visible then
            if KeyCode == Enum.KeyCode.ButtonB then
                u92(false);

                return;
            end;

            if KeyCode == Enum.KeyCode.ButtonA then
                local v220 = u76[u72] and u76[u72][u73];

                if v220 then
                    u103(v220);

                    return;
                end;
            elseif KeyCode == Enum.KeyCode.DPadRight then
                if os.clock() - u75 < 0.15 then
                    return;
                end;

                u75 = os.clock();
                u73 = u73 % 3 + 1;

                if not u77 then
                    return;
                end;

                local v221 = u76[u72] and u76[u72][u73];

                if not v221 then
                    return;
                end;

                local v222 = Controls.Keys:FindFirstChild(v221);

                if v222 then
                    u77.Parent = v222;
                    u77.Visible = true;
                    u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");

                    return;
                end;
            elseif KeyCode == Enum.KeyCode.DPadLeft then
                if os.clock() - u75 < 0.15 then
                    return;
                end;

                u75 = os.clock();
                u73 = (u73 - 2) % 3 + 1;

                if not u77 then
                    return;
                end;

                local v223 = u76[u72] and u76[u72][u73];

                if not v223 then
                    return;
                end;

                local v224 = Controls.Keys:FindFirstChild(v223);

                if v224 then
                    u77.Parent = v224;
                    u77.Visible = true;
                    u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");

                    return;
                end;
            elseif KeyCode == Enum.KeyCode.DPadDown then
                if os.clock() - u75 < 0.15 then
                    return;
                end;

                u75 = os.clock();
                u72 = u72 % 4 + 1;

                if not u77 then
                    return;
                end;

                local v225 = u76[u72] and u76[u72][u73];

                if not v225 then
                    return;
                end;

                local v226 = Controls.Keys:FindFirstChild(v225);

                if v226 then
                    u77.Parent = v226;
                    u77.Visible = true;
                    u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");

                    return;
                end;
            elseif KeyCode == Enum.KeyCode.DPadUp then
                if os.clock() - u75 < 0.15 then
                    return;
                end;

                u75 = os.clock();
                u72 = (u72 - 2) % 4 + 1;

                if not u77 then
                    return;
                end;

                local v227 = u76[u72] and u76[u72][u73];

                if not v227 then
                    return;
                end;

                local v228 = Controls.Keys:FindFirstChild(v227);

                if v228 then
                    u77.Parent = v228;
                    u77.Visible = true;
                    u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");
                end;
            end;

            return;
        end;

        if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Interact/Reload") and not (p212 or Attribute) then
            u142(KeyCode);

            return;
        end;

        if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Fire") and not Attribute then
            local v229, v230 = u147();

            if v229 == "Lock" then
                u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\033\239\191\189\239\191\189\239\191\189\045\195\160\195\161\239\191\189\194\177\239\191\189\085\103\239\191\189\123\239\191\189\239\191\189\053\239\191\189\239\191\189\073", u4, v230);

                return;
            end;

            if v229 == "Bench" then
                OpenBench:Fire(u4);
            end;
        end;
    end;
end);
script:WaitForChild("MobileUse").Event:Connect(function(p231) -- Line: 1307
    -- upvalues: SettingsModule (copy), InventoryController (copy), u147 (copy), u1 (copy), u4 (ref), OpenBench (copy)
    if not p231 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if InventoryController:GetAttribute("Open") then
        return;
    end;

    local v232, v233 = u147();

    if v232 == "Lock" then
        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\033\239\191\189\239\191\189\239\191\189\045\195\160\195\161\239\191\189\194\177\239\191\189\085\103\239\191\189\123\239\191\189\239\191\189\053\239\191\189\239\191\189\073", u4, v233);

        return;
    end;

    if v232 == "Bench" then
        OpenBench:Fire(u4);
    end;
end);
script:WaitForChild("MobileInteract").Event:Connect(function(p234) -- Line: 1316
    -- upvalues: SettingsModule (copy), u142 (copy), WheelController (copy), u143 (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if p234 then
        u142(Enum.KeyCode.Unknown);

        return;
    end;

    if not WheelController:GetAttribute("Open") then
        u143();
    end;
end);
script:WaitForChild("MobileCodelockClose").Event:Connect(function(p235) -- Line: 1328
    -- upvalues: Codelock (copy), u92 (ref)
    if not p235 then
        return;
    end;

    if not Codelock.Visible then
        return;
    end;

    u92(false);
end);
EquipController:GetAttributeChangedSignal("Equipped"):Connect(function() -- Line: 1335
    -- upvalues: u147 (copy)
    script:SetAttribute("HasInteractAction", u147() ~= nil);
end);
UserInputService.InputChanged:Connect(function(p236) -- Line: 1339
    -- upvalues: Codelock (copy), PreferredInputController (copy), u74 (ref), u73 (ref), u72 (ref), u77 (ref), u76 (copy), Controls (copy), GamepadIconModule (copy)
    if not Codelock.Visible then
        return;
    end;

    if p236.UserInputType ~= Enum.UserInputType.Gamepad1 then
        return;
    end;

    if p236.KeyCode ~= Enum.KeyCode.Thumbstick1 then
        return;
    end;

    local X = p236.Position.X;
    local Y = p236.Position.Y;
    local v237 = PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225;

    if v237 < math.abs(X) or v237 < math.abs(Y) then
        if not u74 then
            u74 = true;

            if v237 < X then
                u73 = u73 % 3 + 1;
            elseif X < -v237 then
                u73 = (u73 - 2) % 3 + 1;
            end;

            if Y < -v237 then
                u72 = u72 % 4 + 1;
            elseif v237 < Y then
                u72 = (u72 - 2) % 4 + 1;
            end;

            if not u77 then
                return;
            end;

            local v238 = u76[u72] and u76[u72][u73];

            if not v238 then
                return;
            end;

            local v239 = Controls.Keys:FindFirstChild(v238);

            if v239 then
                u77.Parent = v239;
                u77.Visible = true;
                u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");
            end;
        end;
    else
        u74 = false;
    end;
end);
PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(function() -- Line: 1369
    -- upvalues: PreferredInputController (copy), u88 (ref), u185 (copy), u3 (copy), Codelock (copy), u77 (ref), u76 (copy), u72 (ref), u73 (ref), Controls (copy), GamepadIconModule (copy)
    local v240 = PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    u88 = v240;
    u185();
    u3.Show();

    if not Codelock.Visible then
        return;
    end;

    Codelock.GamepadControls.Visible = v240;

    if v240 then
        if not u77 then
            return;
        end;

        local v241 = u76[u72] and u76[u72][u73];

        if not v241 then
            return;
        end;

        local v242 = Controls.Keys:FindFirstChild(v241);

        if v242 then
            u77.Parent = v242;
            u77.Visible = true;
            u77.ImageLabel.Image = GamepadIconModule.GetIcon("ButtonA");
        end;
    elseif u77 then
        u77.Visible = false;
    end;
end);
PreferredInputController:GetAttributeChangedSignal("IsPlayStation"):Connect(u185);
UserInputService.InputEnded:Connect(function(p243, p244) -- Line: 1384
    -- upvalues: UserInputService (copy), SettingsModule (copy), u143 (copy), InventoryController (copy)
    local UserInputType = p243.UserInputType;

    if UserInputService:GetFocusedTextBox() or p244 then
        return;
    end;

    if UserInputType == Enum.UserInputType.Keyboard then
        if p243.KeyCode.Name == SettingsModule.GetSetting("Controls", "Interact") then
            u143();
        end;
    elseif UserInputType == Enum.UserInputType.Gamepad1 then
        local Name = p243.KeyCode.Name;
        local Attribute = InventoryController:GetAttribute("Open");

        if Name == SettingsModule.GetSetting("Gamepad", "Interact/Reload") and not Attribute then
            u143();
        end;
    end;
end);
TextBox.FocusLost:Connect(function() -- Line: 1402
    -- upvalues: u1 (copy), TextBox (copy), u13 (ref), RenameBed (copy), UserInputService (copy)
    shared.LastTextBoxFocused = tick();
    local v245 = u1("Fire", "\239\191\189\057\195\183\239\191\189\239\191\189\239\191\189\239\191\189\071\239\191\189\239\191\189\239\191\189\194\167\239\191\189\239\191\189\038\239\191\189\106\239\191\189\239\191\189\239\191\189", "\239\191\189\194\163\048\239\191\189\088\239\191\189\052\239\191\189\114\239\191\189\086\078\239\191\189\239\191\189\194\161\239\191\189\239\191\189\065\239\191\189\239\191\189", TextBox.Text:sub(1, 20)) or "";
    u13 = v245;
    TextBox.Text = v245;
    RenameBed.Rename.Visible = true;
    task.wait();

    if not RenameBed.Visible then
        return;
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    UserInputService.MouseIconEnabled = true;
end);
TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1416
    -- upvalues: TextBox (copy), u13 (ref), RenameBed (copy)
    TextBox.Text = TextBox.Text:sub(1, 20):gsub("/", ""):gsub("`", ""):gsub("\\", "");
    local Text = TextBox.Text;

    if Text:len() <= 0 or Text ~= u13 then
        RenameBed.Rename.Visible = false;
        TextBox.Text = Text;
        u13 = Text;
    end;
end);

if MobileModule.IsTouchDevice() then
    for _, v in {
        { GiveBed.Give, GiveBed.Cancel, 0.7166 },
        { RenameBed.Rename, RenameBed.Cancel, 0.4305 }
    } do
        local v246 = v[1];
        local v247 = v[2];
        local v248 = v[3];
        local UDim2_fromScale_ret = UDim2.fromScale(0.12016021361815754, 0.08174386920980926);
        local UDim2_fromScale_ret2 = UDim2.fromScale(0.12016021361815754, 0.08174386920980926);
        v246.Size = UDim2_fromScale_ret;
        v247.Size = UDim2_fromScale_ret2;
        local UDim2_fromScale_ret3 = UDim2.fromScale(0.4333, v248);
        local UDim2_fromScale_ret4 = UDim2.fromScale(0.5668, v248);
        v246.Position = UDim2_fromScale_ret3;
        v247.Position = UDim2_fromScale_ret4;
    end;

    GiveBed.Give.TextScaled = true;
end;

ButtonClass.new(RenameBed.Cancel, "BackgroundColor3", function() -- Line: 1448
    -- upvalues: u7 (ref), UserInputService (copy), RenameBed (copy)
    task.wait();
    u7 = nil;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    RenameBed.Visible = false;
end, 1.5);
ButtonClass.new(RenameBed.Rename, "BackgroundColor3", function() -- Line: 1455
    -- upvalues: UserInputService (copy), RenameBed (copy), u7 (ref), u157 (copy), TextBox (copy)
    task.wait();
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    RenameBed.Visible = false;

    if u7 and u7.Parent then
        u157(u7, "Rename Bed", TextBox.Text);

        return;
    end;

    u7 = nil;
end, 1.5);
TextBox2.FocusLost:Connect(function() -- Line: 1471
    -- upvalues: FoundUser (copy), GiveBed (copy), TextBox2 (copy), Players (copy), u14 (ref), UserService (copy), LocalPlayer (copy), UserInputService (copy)
    shared.LastTextBoxFocused = tick();
    FoundUser.Visible = false;
    GiveBed.Give.Visible = false;
    local Text = TextBox2.Text;
    local u249 = tonumber(Text);

    if not u249 then
        local success, _ = pcall(function() -- Line: 1478
            -- upvalues: u249 (ref), Players (ref), Text (copy)
            u249 = Players:GetUserIdFromNameAsync(Text);
        end);

        if not (success and u249) then
            return;
        end;
    end;

    if u249 == u14 then
        FoundUser.Visible = true;
        GiveBed.Give.Visible = true;

        return;
    end;

    local success, result = pcall(function() -- Line: 1489
        -- upvalues: UserService (ref), u249 (ref)
        return UserService:GetUserInfosByUserIdsAsync({ u249 });
    end);

    if not success then
        return;
    end;

    for _, v in pairs(result) do
        u14 = v.Id;
        FoundUser.DispName.Text = `{v.DisplayName}{not v.HasVerifiedBadge and "" or utf8.char(57344)}`;
        FoundUser.UserName.Text = "@" .. v.Username;
        FoundUser.UserID.Text = "ID: " .. v.Id;
        local v250 = LocalPlayer:IsFriendsWith(v.Id);
        FoundUser.IsFriend.Text = v250 and "YES" or "NO";
        FoundUser.IsFriend.TextColor3 = FoundUser.IsFriend:GetAttribute("Color" .. (v250 and "Yes" or "No"));
        FoundUser.Visible = true;
        GiveBed.Give.Visible = true;
        local success2, result2 = pcall(function() -- Line: 1503
            -- upvalues: Players (ref), v (copy)
            return Players:GetUserThumbnailAsync(v.Id, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420);
        end);
        FoundUser.Avatar.Image = success2 and result2 and result2 or "";
        break;
    end;

    if not GiveBed.Visible then
        return;
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    UserInputService.MouseIconEnabled = true;
end);
TextBox2:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1514
    -- upvalues: TextBox2 (copy)
    local Text = TextBox2.Text;
    local v251 = "";

    for i = 1, Text:len() do
        local v252 = Text:sub(i, i);
        local v253 = v252:byte();
        local v254;

        if v253 == 32 or v253 >= 48 and v253 <= 57 or (v253 >= 65 and v253 <= 90 or (v253 == 95 or v253 >= 97 and v253 <= 122)) then
            v251 = v251 .. v252;
            v254 = i;
        else
            v254 = i;
        end;
    end;

    TextBox2.Text = v251;
end);
ButtonClass.new(GiveBed.Cancel, "BackgroundColor3", function() -- Line: 1526
    -- upvalues: u7 (ref), UserInputService (copy), GiveBed (copy)
    task.wait();
    u7 = nil;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    GiveBed.Visible = false;
end, 1.5);
ButtonClass.new(GiveBed.Give, "BackgroundColor3", function() -- Line: 1533
    -- upvalues: UserInputService (copy), GiveBed (copy), u7 (ref), u157 (copy), u14 (ref)
    task.wait();
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    GiveBed.Visible = false;

    if u7 and u7.Parent then
        u157(u7, "Give To Friend", u14);

        return;
    end;

    u7 = nil;
end, 1.5);
ButtonClass.new(EditSign.Cancel, "BackgroundColor3", function() -- Line: 1549
    -- upvalues: u7 (ref), UserInputService (copy), EditSign (copy)
    u7 = nil;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    EditSign.Visible = false;
end, 1.5);
EditSign.TextBox.FocusLost:Connect(function() -- Line: 1556
    -- upvalues: u1 (copy), EditSign (copy), u78 (ref)
    shared.LastTextBoxFocused = tick();
    local v255 = u1("Fire", "\239\191\189\057\195\183\239\191\189\239\191\189\239\191\189\239\191\189\071\239\191\189\239\191\189\239\191\189\194\167\239\191\189\239\191\189\038\239\191\189\106\239\191\189\239\191\189\239\191\189", "\239\191\189\194\163\048\239\191\189\088\239\191\189\052\239\191\189\114\239\191\189\086\078\239\191\189\239\191\189\194\161\239\191\189\239\191\189\065\239\191\189\239\191\189", EditSign.TextBox.Text:sub(1, u78));
    EditSign.TextBox.Text = v255 or "";
end);
EditSign.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1563
    -- upvalues: u78 (ref), EditSign (copy)
    if not u78 then
        return;
    end;

    local v256 = EditSign.TextBox.Text:sub(1, u78):gsub("`", "");
    EditSign.TextBox.Text = v256;
    EditSign.CharLimit.Text = #v256 .. "/" .. u78;
end);
EditSign.Unlocked.TextBox.FocusLost:Connect(function() -- Line: 1569
    -- upvalues: EditSign (copy), u79 (copy), ReplicatedStorage (copy)
    shared.LastTextBoxFocused = tick();

    if EditSign.Unlocked.Applying.Visible then
        return;
    end;

    EditSign.Unlocked.Applying.Visible = true;
    local Text = EditSign.Unlocked.TextBox.Text;
    local v257 = u79[Text];

    if not v257 then
        local v258 = ReplicatedStorage.Ping:InvokeServer("Image", Text);
        v257 = (v258 == 0 or v258 == "0") and "nil" or v258;

        if v257 then
            if v257 == "nil" then
                u79[Text] = Text;
                v257 = Text;
            else
                u79[Text] = tostring(v257);
            end;
        end;
    end;

    if v257 then
        local v259 = tostring(v257);
        Text = v259 == "0" and "" or v259;
        EditSign.Unlocked.TextBox.Text = Text;
    end;

    EditSign.Unlocked.Selected.Image = Text == "" and "" or ("rbxassetid://" .. Text or "");
    EditSign.Unlocked.Applying.Visible = false;
end);
EditSign.Unlocked.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1598
    -- upvalues: u78 (ref), EditSign (copy)
    if not u78 then
        return;
    end;

    EditSign.Unlocked.TextBox.Text = EditSign.Unlocked.TextBox.Text:sub(1, 30):gsub("%D", "");
end);
ButtonClass.new(EditSign.Locked.Buy, "BackgroundColor3", function() -- Line: 1602
    -- upvalues: MarketplaceService (copy), LocalPlayer (copy)
    local success, result = pcall(function() -- Line: 1603
        -- upvalues: MarketplaceService (ref), LocalPlayer (ref)
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, 667425168);
    end);

    if not success then
        warn(result);
    end;
end, 1.5);
ButtonClass.new(EditSign.ConfirmText, "BackgroundColor3", function() -- Line: 1610
    -- upvalues: UserInputService (copy), EditSign (copy), u7 (ref), u157 (copy)
    task.wait();
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    EditSign.Visible = false;

    if u7 and u7.Parent then
        u157(u7, "Edit Sign", EditSign.TextBox.Text);

        return;
    end;

    u7 = nil;
end, 1.5);
ButtonClass.new(EditSign.ConfirmImage, "BackgroundColor3", function() -- Line: 1625
    -- upvalues: UserInputService (copy), EditSign (copy), u7 (ref), u157 (copy)
    task.wait();
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    EditSign.Visible = false;

    if u7 and u7.Parent then
        u157(u7, "Edit Sign", tonumber(EditSign.Unlocked.TextBox.Text) or 0);

        return;
    end;

    u7 = nil;
end, 1.5);
ReplicatedStorage:GetAttributeChangedSignal("LabelsOwned"):Connect(u107);
u1("Setup", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\097\239\191\189\239\191\189\239\191\189\239\191\189\075\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\194\164\055\195\186\123\239\191\189\239\191\189\239\191\189\239\191\189", u198);

function GetSelected.OnInvoke() -- Line: 1646
    -- upvalues: u4 (ref)
    return u4;
end;

for _, descendant in pairs(Info:GetDescendants()) do
    if descendant:IsA("GuiObject") then
        local v260 = descendant:IsA("Frame") and { "BackgroundTransparency" } or (descendant:IsA("ImageLabel") and { "ImageTransparency" } or { "TextTransparency", "TextStrokeTransparency" });
        local v261 = descendant;
        local v262 = {};

        for i, v in pairs(v260) do
            v262[i] = v261[v];
        end;

        v10[v261.Name] = {
            Properties = v260,
            Values = v262
        };
    end;
end;

for _, child in pairs(Controls.Keys:GetChildren()) do
    local Name = child.Name;
    ButtonClass.new(child, "BackgroundColor3", function() -- Line: 1666
        -- upvalues: u103 (copy), Name (copy)
        u103(Name);
    end, 1.3, 1.3);
end;

local v263 = 0;
local v264 = "MB2";
local v265 = "E";

while true do
    local v266, v267;

    if true then
        v266 = task.wait(0.05);

        if PreferredInputController then
            v267 = PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
        else
            v267 = PreferredInputController;
        end;
    end;

    u88 = v267;
    v263 = v263 - v266;

    if v263 <= 0 then
        v265 = SettingsModule.GetSetting("Controls", "Interact");
        v264 = SettingsModule.GetSetting("Controls", "Change Building");
        v263 = 5;
    end;

    local v268 = InventoryController.Fetch:Invoke();
    local v269;

    if v268 then
        local Toolbar = v268.Toolbar;

        if Toolbar then
            v269 = Toolbar[EquipController:GetAttribute("Equipped")];

            if v269 == nil then
                v269 = false;
            elseif v269 == 0 then
                v269 = false;
            end;
        else
            v269 = nil;
        end;
    else
        v269 = nil;
    end;

    local v270;

    if v269 then
        v270 = Items[v269.ID];
    else
        v270 = v269;
    end;

    local v271;

    if v270 then
        v271 = v270.Name;
    else
        v271 = v270;
    end;

    if v270 then
        v270 = v270.Type;
    end;

    if v269 then
        v269 = v269.ID == 31;
    end;

    local v272 = false;
    local v273 = u4;
    local v274 = nil;
    local v275 = false;
    local v276 = false;
    local v277;

    if script_Parent and (script_Parent.Parent and (script_Parent.PrimaryPart and (Humanoid and (Humanoid.Parent and Humanoid.Health > 0)))) then
        local SeatPart = Humanoid.SeatPart;

        if SeatPart and (SeatPart.Parent and (SeatPart.Name == "VehicleSeat" and (not CameraController:GetAttribute("ViewmodelCFrame") and SeatPart:FindFirstAncestor("Salvaged Flycopter")))) then
            v277 = v274;
        else
            local CFrame2 = workspace_CurrentCamera.CFrame;
            local v278, v279, _, _ = RaycastUtil:Raycast(CFrame2.Position, CFrame2.LookVector * 30, "Blacklist", { VFX, script_Parent }, false, RaycastUtil:FilterFunction("HitNoMeleeMouse"), true);
            u16 = v279;
            u17 = v278;
            local v280 = nil;

            if v278 and v278.Parent then
                local Parent = v278.Parent;
                local v281 = (Parent.Parent == Drops or (Parent.Parent == Plants or Parent.Parent == game)) and Parent and Parent or Parent.Parent;
                local Attribute = Parent:GetAttribute("Health");

                if (v281.Parent == Drops or v281.Parent == Plants) and (v281:IsA("Model") and v281.PrimaryPart) then
                    v280 = v281.PrimaryPart;
                elseif Parent:IsDescendantOf(Bases) then
                    if not Attribute then
                        Parent = Parent.Parent;
                    end;

                    local Attribute2 = Parent:GetAttribute("Health");
                    local Attribute3 = Parent:GetAttribute("MaxHealth");
                    local v282 = BenchInfo[Parent.Name];

                    if Attribute2 and (Attribute3 and (v282 == nil or (v282.Type == "Vehicle" or (v282.DisplayHealthOnly == false or (v269 or Attribute2 <= Attribute3 * 0.75))))) then
                        v280 = Parent.PrimaryPart;
                    end;
                elseif Parent:IsDescendantOf(Animals) then
                    if Attribute then
                        v280 = Parent.PrimaryPart;
                    else
                        local Parent2 = Parent.Parent;

                        if Parent2:GetAttribute("Health") then
                            v280 = Parent2.PrimaryPart;
                        end;
                    end;
                elseif Parent.Name == "DigPile" and Parent.Parent == Vegetation then
                    v280 = Parent.PrimaryPart;
                    v276 = true;
                elseif Parent:FindFirstChild("Humanoid") and (Parent.Humanoid.Health > 0 and Parent.Humanoid:GetAttribute("Downed")) then
                    v280 = Parent.PrimaryPart;
                elseif TeamNavigationController:GetAttribute("InTeam") and (TeamNavigationController:GetAttribute("CanInvite") and (not Parent:FindFirstChild("Humanoid") or Parent.Humanoid.Health > 0)) then
                    local PlayerFromCharacter = Players:GetPlayerFromCharacter(Parent);

                    if PlayerFromCharacter and PlayerFromCharacter ~= LocalPlayer then
                        local v283 = false;

                        for _, v in FetchTeam:Invoke() or {} do
                            if v == PlayerFromCharacter.UserId or tonumber(v) == PlayerFromCharacter.UserId then
                                v283 = true;
                            end;
                        end;

                        if not v283 then
                            v280 = Parent.PrimaryPart;
                        end;
                    end;
                end;
            end;

            if v280 then
                v277 = v274;
            else
                local v284, v285, v286;
                v277, v284, v285, v286 = RaycastUtil:Raycast(CFrame2.Position, CFrame2.LookVector * 8, "Blacklist", { VFX, script_Parent }, false, RaycastUtil:FilterFunction("HitNoMeleeMouse"));
                u16 = v284;

                if v277 and (v277:IsA("Terrain") and (v286 == Enum.Material.Water and not WaterController:GetAttribute("IsSwim"))) then
                    if u16.Y <= 0.01 then
                        v275 = true;
                    else
                        v275 = false;
                    end;
                else
                    v277 = v274;
                end;
            end;

            if v280 then
                v277 = v280.Parent;
            end;
        end;
    else
        v277 = v274;
    end;

    local v287 = InventoryController.GetBench:Invoke();

    if v287 and v287.Parent then
        v277 = v287;
    else
        if v6 ~= v287 then
            u5 = nil;
        end;

        if InventoryController:GetAttribute("Open") then
            if v273 and v273.Parent then
                v277 = v273;
            else
                v277 = nil;
            end;
        elseif u5 and u5.Parent then
            v277 = u5;
        end;
    end;

    local v288;

    if v287 or InventoryController:GetAttribute("Open") then
        v288 = v277;
    else
        local v289 = script_Parent:FindFirstChild("Head") or script_Parent.PrimaryPart;
        local v290;

        if Bases then
            v290 = Bases:FindFirstChild("Loners");
        else
            v290 = Bases;
        end;

        if v289 and v290 then
            local v291 = nil;
            v288 = nil;

            for _, v in ipairs(v2) do
                local v292 = v290:FindFirstChild(v);
                local v293 = BenchInfo[v] and BenchInfo[v].InteractDistance;

                if v292 and v293 then
                    local v294 = v;

                    for _, child in ipairs(v292:GetChildren()) do
                        if child:IsA("Model") and child.Name == v294 then
                            local v295 = child:FindFirstChild("Head") or (child:FindFirstChild("UpperTorso") or child:FindFirstChild("RootPart"));

                            if v295 then
                                local Magnitude = (v295.Position - v289.Position).Magnitude;

                                if Magnitude <= v293 and (not v291 or Magnitude < v291) then
                                    v288 = child;
                                    v291 = Magnitude;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            if not v288 then
                v288 = v277;
            end;
        else
            v288 = v277;
        end;
    end;

    if v288 then
        local PrimaryPart = script_Parent.PrimaryPart;

        if PrimaryPart and (not v288:IsA("Model") or v288.PrimaryPart) then
            local v296 = BenchInfo[v288.Name];
            local v297 = v276 and 10 or (v296 and v288.Parent ~= Drops and v296.InteractDistance or script:GetAttribute((v288:IsDescendantOf(Animals) and "Animal" or "Default") .. "Distance"));
            local v298 = v288:IsA("Terrain") and u16 or v288.PrimaryPart.Position;
            local Position = PrimaryPart.Position;

            if v296 and v296.Type == "NPC" then
                local v299 = v288:FindFirstChild("Head") or (v288:FindFirstChild("UpperTorso") or v288:FindFirstChild("RootPart"));

                if v299 then
                    v298 = v299.Position;
                end;

                local Head = script_Parent:FindFirstChild("Head");

                if Head then
                    Position = Head.Position;
                end;
            end;

            v272 = NumberUtil:IsWithin(v298, Position, v297);
        end;
    end;

    if v272 then
        u4 = v288;
    else
        u4 = nil;
    end;

    if u4 ~= v273 then
        script:SetAttribute("HasInteractAction", u147() ~= nil);
        script:SetAttribute("InteractAction", "");
        script:SetAttribute("InteractKind", "");
        script:SetAttribute("InteractOptions", false);
        script:SetAttribute("HammerOptions", false);
        TweenUtil:Tween(Hover, "ImageTransparency", 1, 0.3, "Quart", "In");
        TweenUtil:Tween(Hover.Action, "TextTransparency", 1, 0.3, "Quart", "In");
        Interaction.Visible = false;

        if v273 and v273.Parent then
            local SelectedHighlight = v273:FindFirstChild("SelectedHighlight");
            v273:GetAttribute("Stability");

            if SelectedHighlight then
                SelectedHighlight.DepthMode = Enum.HighlightDepthMode.Occluded;
                SelectedHighlight:SetAttribute("Vis", false);
                TweenUtil:Tween(SelectedHighlight, { "FillTransparency", "OutlineTransparency" }, { 1, 1 }, 0.3, "Quart", "In");
                task.delay(0.31, function() -- Line: 1882
                    -- upvalues: SelectedHighlight (copy)
                    if not (SelectedHighlight and (SelectedHighlight.Parent and not SelectedHighlight:GetAttribute("Vis"))) then
                        return;
                    end;

                    SelectedHighlight:Destroy();
                end);
            end;

            local Info2 = v273:FindFirstChild("Info");

            if Info2 then
                for i, v in pairs(v10) do
                    local v300 = Info2:FindFirstChild(i, true);

                    if v300 then
                        TweenUtil:Tween(v300, v.Properties, table.create(#v.Values, 1), 0.3, "Quart", "In");
                    end;
                end;

                TweenUtil:Tween(Info2, "StudsOffset", Info2:GetAttribute("OrigOffset") or Vector3.new(), 0.3, "Quart", "In");
                task.delay(0.31, function() -- Line: 1895
                    -- upvalues: Info2 (copy)
                    if not (Info2 and (Info2.Parent and (Info2:FindFirstChild("NameLabel") and Info2.NameLabel.TextTransparency >= 0.99))) then
                        return;
                    end;

                    Info2:Destroy();
                end);
            end;

            v155(v270, v273);
        end;

        if not u4 then
            PowerThroughput.Visible = false;
        end;
    end;

    if u4 then
        if u4:IsA("Terrain") or v276 then
            local v301 = u88 and "   " or (MobileModule.IsTouch() and "" or "[E] ");
            local v302 = v276 and "DIG UP PILE" or "DRINK WATER";
            Hover.Action.Text = v275 and "SALT WATER" or v301 .. v302;
            script:SetAttribute("InteractAction", v275 and "" or v302);
            script:SetAttribute("InteractKind", v276 and "Dig" or "");
            script:SetAttribute("InteractOptions", false);
            script:SetAttribute("HammerOptions", false);
            Hover.Image = script:GetAttribute((v275 and "Unavailable" or "Default") .. "DotImage");
            local v303 = u88 and not v275 and not (InventoryController:GetAttribute("Open") or WheelController:GetAttribute("Open")) and not Codelock.Visible;
            Interaction.Visible = v303;

            if v303 then
                Interaction.xtra.ImageLabel.Image = GamepadIconModule.GetSettingIcon("Gamepad", "Interact/Reload");
                Interaction.xtra.Text = " - " .. v302;
            end;

            if v273 ~= u4 then
                TweenUtil:Tween(Hover, "ImageTransparency", 0, 0.2, "Quart", "Out");
                TweenUtil:Tween(Hover.Action, "TextTransparency", 0, 0.2, "Quart", "Out");
            end;
        else
            local v304 = BenchInfo[u4.Name];
            local v305;

            if u4 == nil then
                v305 = false;
            else
                v305 = u4.Parent == Drops;
            end;

            local v306;

            if u4 == nil then
                v306 = false;
            else
                v306 = u4.Parent == Plants;
            end;

            local v307;

            if u4 == nil then
                v307 = false;
            else
                v307 = u4.Parent == Animals;
            end;

            local v308;

            if u4 == nil then
                v308 = false;
            else
                v308 = Players:GetPlayerFromCharacter(u4) and not v307;
            end;

            local v309;

            if u4 == nil then
                v309 = false;
            else
                v309 = v305 and Vector3.new() or (v304 and v304.GuiOffset or Vector3.new());
            end;

            local Info2 = u4:FindFirstChild("Info");
            local Attribute = u4:GetAttribute("Health");
            local Attribute2 = u4:GetAttribute("MaxHealth");
            local Attribute3 = u4:GetAttribute("Stability");
            local Attribute4 = u4:GetAttribute("StabilityLoss");
            local SelectedHighlight = u4:FindFirstChild("SelectedHighlight");
            local Humanoid2 = u4:FindFirstChild("Humanoid");
            local v310 = not v308 and Humanoid2;
            local BaseCabinetUnder = RaycastUtil:GetBaseCabinetUnder(u4.PrimaryPart.Position);
            local v311;

            if BaseCabinetUnder then
                v311 = BaseCabinetUnder:GetAttribute("Monument");

                if not v311 then
                    local ClientInfo = ActiveBenchModule.GetClientInfo(BaseCabinetUnder);

                    if ClientInfo == nil then
                        v311 = false;
                    else
                        v311 = ClientInfo.Access == false;
                    end;
                end;
            else
                v311 = nil;
            end;

            if not v307 then
                if u4.Name == "Wall Block" then
                    v307 = true;
                elseif v304 then
                    v307 = v304.DisplayHealthOnly and not (v269 or v305);
                else
                    v307 = v304;
                end;
            end;

            local v312;

            if Attribute3 then
                if v269 then
                    if u4.Name == "Wall Block" then
                        v312 = false;
                    else
                        v312 = not v311;
                    end;
                else
                    v312 = v269;
                end;
            else
                v312 = Attribute3;
            end;

            local v313;

            if v304 then
                v313 = v304.Type == "BasePart";
            else
                v313 = v304;
            end;

            local v314;

            if v313 then
                if v312 then
                    v314 = u4:GetAttribute("DamageType") ~= "Steel";
                else
                    v314 = v312;
                end;
            else
                v314 = v313;
            end;

            if v273 ~= u4 then
                TweenUtil:Tween(Hover, "ImageTransparency", 0, 0.2, "Quart", "Out");
                TweenUtil:Tween(Hover.Action, "TextTransparency", 1, 0.3, "Quart", "In");

                if not SelectedHighlight then
                    SelectedHighlight = VFX2.Highlight:Clone();
                    SelectedHighlight.Name = "SelectedHighlight";
                    SelectedHighlight.OutlineColor = Color3.new(1, 1, 1);
                    SelectedHighlight.OutlineTransparency = 1;
                    SelectedHighlight.Parent = u4;
                end;

                if not Info2 then
                    Info2 = Info:Clone();

                    for i, v in pairs(v10) do
                        local v315 = Info2:FindFirstChild(i, true);

                        if v315 then
                            for _, v3 in pairs(v.Properties) do
                                v315[v3] = 1;
                            end;
                        end;
                    end;

                    Info2.StudsOffset = v309 - Vector3.new(0, 2, 0);
                    Info2:SetAttribute("OrigOffset", Info2.StudsOffset);
                    Info2.Parent = u4;
                end;

                if Info2 then
                    for i, v in pairs(v10) do
                        local v316 = Info2:FindFirstChild(i, true);

                        if v316 then
                            TweenUtil:Tween(v316, v.Properties, v.Values, 0.3, "Quart", "Out");
                        end;
                    end;

                    TweenUtil:Tween(Info2, "StudsOffset", v309, 0.2, "Quart", "Out");
                end;
            end;

            if SelectedHighlight then
                SelectedHighlight.Adornee = u4;
                SelectedHighlight.DepthMode = Enum.HighlightDepthMode[v305 and "AlwaysOnTop" or "Occluded"];
                local Attribute5 = SelectedHighlight:GetAttribute("Vis");

                if v307 or v308 then
                    if Attribute5 then
                        SelectedHighlight:SetAttribute("Vis", false);
                        TweenUtil:Tween(SelectedHighlight, { "FillTransparency", "OutlineTransparency" }, { 1, 1 }, 0.3, "Quart", "In");
                    end;
                elseif not Attribute5 then
                    SelectedHighlight:SetAttribute("Vis", true);
                    TweenUtil:Tween(SelectedHighlight, { "FillTransparency", "OutlineTransparency" }, { 0.7, 0 }, 0.2, "Quart", "Out");
                end;

                local Attribute6 = u4:GetAttribute("LastDamaged");
                local v317 = (Values.ServerTick.Value - (Attribute6 or 0) >= 60 or not v269) and Color3.new(1, 1, 1) or script:GetAttribute("DamagedBenchOutlineColor");

                if ElectricityController:GetAttribute("Placing") then
                    if shared.CachedElectricalBenchNames[u4.Name] then
                        v317 = Color3.fromRGB(63, 194, 46);
                    else
                        v317 = Color3.fromRGB(194, 40, 50);
                    end;
                end;

                SelectedHighlight.FillColor = v317;
                SelectedHighlight.OutlineColor = v317;
            end;

            if Info2 then
                Hover.Image = script:GetAttribute((u4:GetAttribute("Occupied") and "Unavailable" or "Default") .. "DotImage");
                local Attribute5 = u4:GetAttribute("BreakLocked");
                local v318, v319 = (v304 and (v304.ClientFunction or function() -- Line: 2022
                end) or function() -- Line: 2022
                end)(u4);
                local v320 = v318 or u4:GetAttribute("FirstAction");
                local v321 = v319 or (u4:GetAttribute("TotalActions") or 0);

                if v304 then
                    if v321 <= 0 and v304.Type ~= "BasePart" then
                        if v304.PickupBehavior == true then
                            v269 = true;
                        elseif v304.PickupBehavior ~= "HammerOnly" then
                            v269 = false;
                        end;
                    else
                        v269 = false;
                    end;
                else
                    v269 = v304;
                end;

                local v322 = v305 and u4:FindFirstChild("Item") and HttpService:JSONDecode(u4.Item.Value);
                local v323;

                if u4:GetAttribute("Armed") == true then
                    v323 = "";
                elseif v308 then
                    v323 = Humanoid2 and Humanoid2:GetAttribute("Downed") and "REVIVE" or "INVITE TO TEAM";
                else
                    v323 = v312 and "REPAIR" or ((v305 or v269) and "PICK UP" or (v306 and "HARVEST" or (v320 or ""):upper()));
                end;

                Info2.NameLabel.Text = (v307 or v308) and "" or (u4.Name:find(" Trophy") and "BONE TROPHY" or u4.Name:gsub("Locked ", Attribute5 == false and "Unlocked " or "Locked "):upper()) .. (v322 and (v322.Amount or 0) > 1 and (" x" .. NumberUtil:FormatNumber(v322.Amount) or "") or "");
                local _, v324 = u70(u4);
                local v325 = v324 or v323;
                local v326 = u88 and v314 and "UPGRADE" or v325;
                local v327 = u88 and "   " or (MobileModule.IsTouch() and not Attribute5 and "" or "<font color=\"rgb(176, 176, 176)\">" .. "[" .. (Attribute5 and "BREAK OPEN TO VIEW CONTENTS" or (Attribute3 and "MB1" or v265)) .. "]</font>");
                Info2.Action.Text = v327 .. (Attribute5 and "" or (v327 == "" and "" or " ") .. v326);
                local GamepadImage = Info2.Action:FindFirstChild("GamepadImage");

                if GamepadImage then
                    if v313 and u88 then
                        GamepadImage.Visible = v314;

                        if v314 then
                            GamepadImage.Image = GamepadIconModule.GetSettingIcon("Gamepad", "Change Building");
                        end;
                    else
                        GamepadImage.Visible = u88;
                    end;
                end;

                local v328;

                if v326 == "" then
                    v328 = false;
                else
                    local v329;

                    if v313 then
                        v329 = u88 and not v314;
                    else
                        v329 = v313;
                    end;

                    v328 = not v329;
                end;

                Info2.Action.Visible = v328;
                script:SetAttribute("InteractAction", (not Info2.Action.Visible or (Attribute5 or (Attribute3 or not v326))) and "" or v326);
                local v330;

                if v304 then
                    v330 = v304.Type;
                else
                    v330 = v304;
                end;

                script:SetAttribute("InteractKind", v330 == "Door" and "Door" or ((v330 == "Container" or v330 == "LockedContainer") and ((v305 or v269) and "" or "Crate") or ""));

                if u88 or MobileModule.IsTouch() then
                    Info2.Options.Text = v312 and not v313 and "HOLD FOR MORE OPTIONS" or (v321 > 1 and "HOLD FOR MORE OPTIONS" or "");
                else
                    Info2.Options.Text = v312 and `HOLD [{v264}] FOR MORE OPTIONS` or (v321 > 1 and (`HOLD [{v265}] FOR MORE OPTIONS` or "") or "");
                end;

                script:SetAttribute("InteractOptions", v321 > 1);
                script:SetAttribute("HammerOptions", v312 and v313 and true or false);
                local v331 = u88 and not (InventoryController:GetAttribute("Open") or WheelController:GetAttribute("Open") or (script:GetAttribute("Dialog") or Codelock.Visible));

                if v331 then
                    if not (v313 and v314) then
                        v314 = not v313 and v325 ~= "";
                    end;
                else
                    v314 = v331;
                end;

                Interaction.Visible = v314;

                if v314 then
                    Interaction.xtra.ImageLabel.Image = GamepadIconModule.GetSettingIcon("Gamepad", v313 and "Change Building" or "Interact/Reload");
                    Interaction.xtra.Text = " - " .. (v313 and "UPGRADE" or v325);
                end;

                local Bar = Info2.Bar;
                local v332;

                if (v310 == nil or (v310 == false or u4:GetAttribute("BenchName"))) and (Attribute == nil or (Attribute2 == nil or Attribute2 <= 0)) then
                    v332 = false;
                else
                    v332 = u4.Name ~= "Sleeper";
                end;

                Bar.Visible = v332;
                local v333, _, v334 = u70(u4);

                if v333 ~= nil and (v333:sub(1, 6) == "Engine" or v333:sub(1, 5) == "Seat:") then
                    Info2.Bar.Visible = false;
                end;

                Info2.Adornee = v334 or (u4:FindFirstChild("Door") and u4.Door.PrimaryPart or u4.PrimaryPart);

                if Info2.Bar.Visible then
                    local v335 = Attribute or (v310 and (v310.Health or 0) or 0);
                    local v336 = Attribute2 or (v310 and v310.MaxHealth or 0);

                    if v336 ~= 0 then
                        Info2.Bar.StatLabel.Text = NumberUtil:FormatNumber((math.ceil(v335))) .. "/" .. NumberUtil:FormatNumber((math.floor(v336)));
                        Info2.Bar.Fill.Size = UDim2.new(v335 / v336, 0, 1, 0);
                        local StabilityLabel = Info2.Bar.StabilityLabel;
                        local v337;

                        if Attribute3 and Attribute4 then
                            local v338 = math.clamp(Attribute3 - Attribute4, 0, 1) * 100;
                            v337 = math.ceil(v338) .. "% STABLE" or "";
                        else
                            v337 = "";
                        end;

                        StabilityLabel.Text = v337;
                    end;
                end;
            end;

            v155(v270, u4, not v311 and v271);

            if shared.CachedConnections[u4] and shared.CachedConnections[u4].PowerThroughput then
                PowerThroughput.Text = "POWER THROUGHPUT: " .. shared.CachedConnections[u4].PowerThroughput .. (not (v304 and v304.RequiredPower) and "" or "/" .. tostring(v304.RequiredPower));
                PowerThroughput.Visible = true;
            end;
        end;
    end;

    v6 = v287;
end;