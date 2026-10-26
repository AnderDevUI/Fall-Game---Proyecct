-- [PATH] ReplicatedStorage / CharacterScripts / MobileTouchController @Type LocalScript


local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local ViewmodelController = script_Parent:WaitForChild("ViewmodelController");
local BuildController = script_Parent:WaitForChild("BuildController");
local InteractController = script_Parent:WaitForChild("InteractController");
local InventoryController = script_Parent:WaitForChild("InventoryController");
local StateController = script_Parent:WaitForChild("StateController");
local WheelController = script_Parent:WaitForChild("WheelController");
local WaterController = script_Parent:WaitForChild("WaterController");
local TeamNavigationController = script_Parent:WaitForChild("TeamNavigationController");
local CameraController = script_Parent:WaitForChild("CameraController");
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local ChatController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("ChatController");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local MobileLayoutState = require(Modules:WaitForChild("MobileLayoutState"));
local Items = require(Modules:WaitForChild("Items"));
local Vector2_new_ret = Vector2.new(0.5, 0.5);
local Main = PlayerGui:WaitForChild("Main");
local MobileTouchButtons = Main:WaitForChild("MobileTouchButtons");
local Codelock = Main:WaitForChild("Codelock");
local GiveBed = Main:WaitForChild("GiveBed");
local RenameBed = Main:WaitForChild("RenameBed");
local MobileUse = ViewmodelController:WaitForChild("MobileUse");
local MobileUse2 = BuildController:WaitForChild("MobileUse");
local MobileUse3 = InteractController:WaitForChild("MobileUse");
local MobileSprint = StateController:WaitForChild("MobileSprint");
local MobileCrouch = StateController:WaitForChild("MobileCrouch");
local MobileToggle = InventoryController:WaitForChild("MobileToggle");
local MobileClose = InventoryController:WaitForChild("MobileClose");
local MobileInteract = InteractController:WaitForChild("MobileInteract");
local MobileChange = BuildController:WaitForChild("MobileChange");
local MobileUpgrade = BuildController:WaitForChild("MobileUpgrade");
local MobileRotate = BuildController:WaitForChild("MobileRotate");
local MobileCodelockClose = InteractController:WaitForChild("MobileCodelockClose");
local MobileReload = ViewmodelController:WaitForChild("MobileReload");
local MobileJump = ViewmodelController:WaitForChild("MobileJump");
local MobileJump2 = WaterController:WaitForChild("MobileJump");
local MobileMenu = PlayerGui:WaitForChild("MainMenu"):WaitForChild("MainMenuController"):WaitForChild("MobileMenu");
local MobileADS = ViewmodelController:WaitForChild("MobileADS");
local MobileChat = ChatController:WaitForChild("MobileChat");
local MobileChannel = ChatController:WaitForChild("MobileChannel");
local MobileMap = TeamNavigationController:WaitForChild("MobileMap");
local MobileAttachment = ViewmodelController:WaitForChild("MobileAttachment");
local MobileInspect = ViewmodelController:WaitForChild("MobileInspect");
local MobileNVG = ViewmodelController:WaitForChild("MobileNVG");
local MobileFreeLook = CameraController:WaitForChild("MobileFreeLook");
local Color3_new_ret = Color3.new(1, 1, 1);

local function _() -- Line: 109
    -- upvalues: BuildController (copy)
    return (BuildController:GetAttribute("Equipped") or 0) ~= 0;
end;

local function u4() -- Line: 118
    -- upvalues: ViewmodelController (copy), InventoryController (copy), Items (copy)
    local Attribute = ViewmodelController:GetAttribute("Equipped");

    if type(Attribute) ~= "number" or Attribute <= 0 then
        return "", false;
    end;

    local v1 = InventoryController.Fetch:Invoke();
    local v2 = v1 and v1.Toolbar and v1.Toolbar[Attribute];

    if type(v2) ~= "table" then
        return "", false;
    end;

    for _, v in pairs(v2.Attachments or {}) do
        local v3 = Items[v.ID];

        if v3 and (v3.AttachmentStats and v3.AttachmentStats.Toggle) then
            if v3.Name == "Weapon Flashlight" then
                return "Light", v.On == true;
            end;

            if v3.Name:find(" Lasersight") then
                return "Laser", v.On == true;
            end;
        end;
    end;

    return "", false;
end;

local u9 = {
    {
        Name = "Use",
        Targets = { MobileUse, MobileUse2, MobileUse3 },

        Label = function() -- Line: 138, Name: Label
            -- upvalues: BuildController (copy)
            return (BuildController:GetAttribute("Equipped") or 0) ~= 0 and "Place" or "Use";
        end,

        Icon = function() -- Line: 141, Name: Icon
            -- upvalues: BuildController (copy), ViewmodelController (copy)
            return ((BuildController:GetAttribute("Equipped") or 0) ~= 0 or BuildController:GetAttribute("PlacingBlueprint") == true) and "rbxassetid://106942318468584" or (ViewmodelController:GetAttribute("EquippedType") == "Gun" and "rbxassetid://111284835404355" or "rbxassetid://95640755973949");
        end,

        Visible = function() -- Line: 146, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), ViewmodelController (copy), BuildController (copy), InteractController (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            return ViewmodelController:GetAttribute("HasPrimaryAction") == true and true or ((BuildController:GetAttribute("Equipped") or 0) ~= 0 or InteractController:GetAttribute("HasInteractAction") == true);
        end,

        Watch = {
            { ViewmodelController, "HasPrimaryAction" },
            { ViewmodelController, "EquippedType" },
            { BuildController, "Equipped" },
            { BuildController, "PlacingBlueprint" },
            { InteractController, "HasInteractAction" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Sprint",
        Targets = { MobileSprint },

        Icon = function() -- Line: 165, Name: Icon
            return "rbxassetid://118484922483747";
        end,

        Visible = function() -- Line: 166, Name: Visible
            -- upvalues: InventoryController (copy)
            return not InventoryController:GetAttribute("Open");
        end,

        Active = function() -- Line: 169, Name: Active
            -- upvalues: StateController (copy)
            return StateController:GetAttribute("SprintInput") == true;
        end,

        Watch = {
            { InventoryController, "Open" },
            { StateController, "SprintInput" }
        }
    },
    {
        Name = "Inventory",
        Targets = { MobileToggle },

        Label = function() -- Line: 180, Name: Label
            -- upvalues: InventoryController (copy)
            return InventoryController:GetAttribute("CurOpen") == "Inventory" and "Craft" or "Inventory";
        end,

        Icon = function() -- Line: 183, Name: Icon
            -- upvalues: InventoryController (copy)
            return InventoryController:GetAttribute("CurOpen") == "Inventory" and "rbxassetid://90115352170078" or "rbxassetid://79726258868554";
        end,

        Count = function() -- Line: 186, Name: Count
            -- upvalues: InventoryController (copy)
            local v5 = InventoryController:GetAttribute("BackpackSize") or 0;

            return (v5 <= 0 or InventoryController:GetAttribute("Open")) and "" or `{InventoryController:GetAttribute("BackpackUsed") or 0}/{v5}`;
        end,

        Visible = function() -- Line: 191, Name: Visible
            return true;
        end,

        Watch = {
            { InventoryController, "CurOpen" },
            { InventoryController, "Open" },
            { InventoryController, "BackpackUsed" },
            { InventoryController, "BackpackSize" }
        }
    },
    {
        Name = "Close",
        Targets = { MobileClose },

        Icon = function() -- Line: 202, Name: Icon
            return "rbxassetid://91182229617087";
        end,

        Visible = function() -- Line: 203, Name: Visible
            -- upvalues: InventoryController (copy)
            return InventoryController:GetAttribute("Open") == true;
        end,

        Watch = {
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Menu",
        Targets = { MobileClose, MobileMenu },

        Icon = function() -- Line: 215, Name: Icon
            return "rbxassetid://84319774302467";
        end,

        Visible = function() -- Line: 216, Name: Visible
            -- upvalues: InventoryController (copy)
            return InventoryController:GetAttribute("Open") == true;
        end,

        Watch = {
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Open",
        Targets = { MobileInteract },

        Label = function() -- Line: 226, Name: Label
            -- upvalues: InteractController (copy)
            return InteractController:GetAttribute("InteractAction") or "";
        end,

        Icon = function() -- Line: 229, Name: Icon
            -- upvalues: InteractController (copy)
            local Attribute = InteractController:GetAttribute("InteractKind");

            return Attribute == "Door" and "rbxassetid://126565310672846" or (Attribute == "Crate" and "rbxassetid://116941354639594" or (Attribute == "Dig" and "rbxassetid://105346548288604" or "rbxassetid://95640755973949"));
        end,

        Visible = function() -- Line: 234, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), InteractController (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            return (InteractController:GetAttribute("InteractAction") or "") ~= "";
        end,

        Hint = function() -- Line: 239, Name: Hint
            -- upvalues: InteractController (copy)
            return InteractController:GetAttribute("InteractOptions") and "HOLD FOR MORE OPTIONS" or "";
        end,

        Watch = {
            { InteractController, "InteractAction" },
            { InteractController, "InteractKind" },
            { InteractController, "InteractOptions" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "CodelockClose",
        Targets = { MobileCodelockClose },

        Icon = function() -- Line: 252, Name: Icon
            return "rbxassetid://91182229617087";
        end,

        Visible = function() -- Line: 253, Name: Visible
            -- upvalues: Codelock (copy)
            return Codelock.Visible;
        end,

        Watch = {}
    },
    {
        Name = "Change",
        Targets = { MobileChange },

        Visible = function() -- Line: 262, Name: Visible
            -- upvalues: InventoryController (copy), BuildController (copy)
            if InventoryController:GetAttribute("Open") then
                return false;
            end;

            return BuildController:GetAttribute("PlacingBlueprint") == true;
        end,

        Watch = {
            { BuildController, "PlacingBlueprint" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Upgrade",
        Targets = { MobileUpgrade },

        Icon = function() -- Line: 274, Name: Icon
            return "rbxassetid://92574428563091";
        end,

        Visible = function() -- Line: 275, Name: Visible
            -- upvalues: InventoryController (copy), InteractController (copy)
            if InventoryController:GetAttribute("Open") then
                return false;
            end;

            return InteractController:GetAttribute("HammerOptions") == true;
        end,

        Watch = {
            { InteractController, "HammerOptions" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Rotate",
        Targets = { MobileRotate },

        Icon = function() -- Line: 287, Name: Icon
            return "rbxassetid://120649135312117";
        end,

        Visible = function() -- Line: 288, Name: Visible
            -- upvalues: InventoryController (copy), BuildController (copy)
            if InventoryController:GetAttribute("Open") then
                return false;
            end;

            return BuildController:GetAttribute("CanRotate") == true;
        end,

        Watch = {
            { BuildController, "CanRotate" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Reload",
        Targets = { MobileReload },

        Icon = function() -- Line: 300, Name: Icon
            return "rbxassetid://134346936666904";
        end,

        Visible = function() -- Line: 301, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), ViewmodelController (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            return ViewmodelController:GetAttribute("CanReload") == true;
        end,

        Watch = {
            { ViewmodelController, "CanReload" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Jump",
        Targets = { MobileJump, MobileJump2 },

        Icon = function() -- Line: 314, Name: Icon
            return "rbxassetid://81715793984695";
        end,

        Visible = function() -- Line: 315, Name: Visible
            -- upvalues: InventoryController (copy)
            return not InventoryController:GetAttribute("Open");
        end,

        Watch = {
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Crouch",
        Targets = { MobileCrouch },

        Icon = function() -- Line: 328, Name: Icon
            return "rbxassetid://78635573842416";
        end,

        Visible = function() -- Line: 329, Name: Visible
            -- upvalues: InventoryController (copy)
            return not InventoryController:GetAttribute("Open");
        end,

        Active = function() -- Line: 332, Name: Active
            -- upvalues: StateController (copy)
            return StateController:GetAttribute("CrouchInput") == true;
        end,

        Watch = {
            { InventoryController, "Open" },
            { StateController, "CrouchInput" }
        }
    },
    {
        Name = "ADS",
        Targets = { MobileADS },

        Icon = function() -- Line: 345, Name: Icon
            return "rbxassetid://104099062131726";
        end,

        Visible = function() -- Line: 346, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), ViewmodelController (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            local v6;

            if ViewmodelController:GetAttribute("EquippedType") == "Gun" then
                v6 = ViewmodelController:GetAttribute("IsBow") ~= true;
            else
                v6 = false;
            end;

            return v6;
        end,

        Active = function() -- Line: 352, Name: Active
            -- upvalues: ViewmodelController (copy)
            return ViewmodelController:GetAttribute("Aiming") == true;
        end,

        Watch = {
            { ViewmodelController, "EquippedType" },
            { ViewmodelController, "IsBow" },
            { ViewmodelController, "Aiming" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Inspect",
        Targets = { MobileInspect },

        Visible = function() -- Line: 367, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), ViewmodelController (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            local v7;

            if ViewmodelController:GetAttribute("CanInspect") == true then
                v7 = ViewmodelController:GetAttribute("Aiming") ~= true;
            else
                v7 = false;
            end;

            return v7;
        end,

        Watch = {
            { ViewmodelController, "CanInspect" },
            { ViewmodelController, "Aiming" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Attachment",
        Targets = { MobileAttachment },

        Label = function() -- Line: 384, Name: Label
            -- upvalues: u4 (copy)
            return u4();
        end,

        Icon = function() -- Line: 387, Name: Icon
            -- upvalues: u4 (copy)
            return u4() == "Laser" and "rbxassetid://114592221033529" or "";
        end,

        Visible = function() -- Line: 390, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), u4 (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            return u4() ~= "";
        end,

        Active = function() -- Line: 395, Name: Active
            -- upvalues: u4 (copy)
            local _, v8 = u4();

            return v8;
        end,

        Watch = {
            { ViewmodelController, "Equipped" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "FreeLook",
        Targets = { MobileFreeLook },

        Icon = function() -- Line: 409, Name: Icon
            return "rbxassetid://13321848320";
        end,

        Visible = function() -- Line: 410, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy)
            return not (InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)));
        end,

        Active = function() -- Line: 415, Name: Active
            -- upvalues: CameraController (copy)
            return CameraController:GetAttribute("FreeLooking") == true;
        end,

        Watch = {
            { CameraController, "FreeLooking" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "NVG",
        Targets = { MobileNVG },

        Icon = function() -- Line: 428, Name: Icon
            return "rbxassetid://96969433916230";
        end,

        Visible = function() -- Line: 429, Name: Visible
            -- upvalues: InventoryController (copy), Codelock (copy), GiveBed (copy), RenameBed (copy), LocalPlayer (copy)
            if InventoryController:GetAttribute("Open") or (Codelock.Visible or (GiveBed.Visible or RenameBed.Visible)) then
                return false;
            end;

            return LocalPlayer:GetAttribute("Armor_NVG") and true or false;
        end,

        Active = function() -- Line: 434, Name: Active
            -- upvalues: ViewmodelController (copy)
            return ViewmodelController:GetAttribute("NVGOn") == true;
        end,

        Watch = {
            { LocalPlayer, "Armor_NVG" },
            { ViewmodelController, "NVGOn" },
            { InventoryController, "Open" }
        }
    },
    {
        Name = "Chat",
        Targets = { MobileChat },

        Icon = function() -- Line: 448, Name: Icon
            return "rbxassetid://126449591926013";
        end,

        Visible = function() -- Line: 449, Name: Visible
            -- upvalues: InventoryController (copy)
            return not InventoryController:GetAttribute("Open");
        end,

        Watch = {
            { InventoryController, "Open" },
            { ChatController, "Typing" }
        }
    },
    {
        Name = "Channel",
        Targets = { MobileChannel },

        Label = function() -- Line: 463, Name: Label
            -- upvalues: ChatController (copy)
            return string.upper(ChatController:GetAttribute("Channel") or "GLOBAL");
        end,

        Visible = function() -- Line: 466, Name: Visible
            -- upvalues: ChatController (copy)
            return ChatController:GetAttribute("Typing") == true;
        end,

        Watch = {
            { ChatController, "Typing" },
            { ChatController, "Channel" }
        }
    },
    {
        Name = "Map",
        Targets = { MobileMap },

        Icon = function() -- Line: 479, Name: Icon
            return "rbxassetid://83654924384614";
        end,

        Visible = function() -- Line: 480, Name: Visible
            -- upvalues: InventoryController (copy)
            return not InventoryController:GetAttribute("Open");
        end,

        Watch = {
            { InventoryController, "Open" }
        }
    }
};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local Color3_fromRGB_ret = Color3.fromRGB(75, 123, 255);

local function _() -- Line: 499
    -- upvalues: Humanoid (copy)
    local v15 = Humanoid and Humanoid.Parent;

    if v15 then
        if Humanoid.Health > 0 then
            v15 = not Humanoid:GetAttribute("Downed");
        else
            v15 = false;
        end;
    end;

    return v15;
end;

local function _(p16, p17) -- Line: 503
    for _, v in p16.Targets do
        v:Fire(p17);
    end;
end;

local function _() -- Line: 511
    -- upvalues: MobileLayoutState (copy)
    return MobileLayoutState.FADE_DEFAULT;
end;

local function u23(p18, p19, p20) -- Line: 517
    -- upvalues: u12 (copy), MobileLayoutState (copy), u13 (copy), Color3_fromRGB_ret (copy), u14 (copy), Color3_new_ret (copy)
    local v21 = u12[p18];

    if not v21 then
        return;
    end;

    if p19 then
        v21 = v21:Lerp(Color3.new(), 0.7) or v21;
    end;

    p18.BackgroundColor3 = v21;
    local v22;

    if p19 then
        v22 = math.clamp(MobileLayoutState.FADE_DEFAULT - (MobileLayoutState.FADE_DEFAULT - 0.15), 0, 1);
    else
        v22 = u13[p18];
    end;

    p18.BackgroundTransparency = v22;

    if p20 ~= nil then
        MobileLayoutState.LabelOf(p18).TextColor3 = p20 and Color3_fromRGB_ret or u14[p18];
        local Icon = p18:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = p20 and Color3_fromRGB_ret or Color3_new_ret;
        end;
    end;
end;

local function _(p24) -- Line: 540
    -- upvalues: u11 (copy), u23 (copy), u10 (copy)
    local v25 = u11[p24];

    if not v25 then
        return;
    end;

    local v26;

    if p24.Active then
        v26 = p24.Active() == true;
    else
        v26 = nil;
    end;

    u23(v25, u10[v25] ~= nil and true or v26 == true, v26);
end;

local function u31() -- Line: 549
    -- upvalues: MobileLayoutState (copy), u9 (copy), u11 (copy), u13 (copy), u23 (copy), u10 (copy)
    local FADE_DEFAULT = MobileLayoutState.FADE_DEFAULT;

    for _, v in u9 do
        local v27 = u11[v];

        if v27 then
            local v28 = MobileLayoutState.ApplyFade(v27.Name, v27, FADE_DEFAULT);

            if v28 then
                u13[v27] = v28;
            end;

            local v29 = u11[v];

            if v29 then
                local v30;

                if v.Active then
                    v30 = v.Active() == true;
                else
                    v30 = nil;
                end;

                u23(v29, u10[v29] ~= nil and true or v30 == true, v30);
            end;
        end;
    end;
end;

local u32 = {};

local function u40(p33) -- Line: 568
    -- upvalues: u11 (copy), u32 (copy), MobileTouchButtons (copy), u9 (copy), u40 (ref), MobileLayoutState (copy)
    local v34 = u11[p33];
    local v35;

    if v34 then
        v35 = v34:FindFirstChild("Icon");
    else
        v35 = v34;
    end;

    if not v35 then
        return;
    end;

    local u36 = p33.Icon and (p33.Icon() or "") or "";

    if u36 ~= "" and u32[u36] == nil then
        u32[u36] = "loading";
        task.spawn(function() -- Line: 578
            -- upvalues: u36 (copy), MobileTouchButtons (ref), u32 (ref), u9 (ref), u40 (ref)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "IconLoadProbe";
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.ImageTransparency = 0.99;
            ImageLabel.Size = UDim2.fromOffset(2, 2);
            ImageLabel.Image = u36;
            ImageLabel.Parent = MobileTouchButtons;
            local os_clock_ret = os.clock();

            while not ImageLabel.IsLoaded and os.clock() - os_clock_ret < 15 do
                task.wait(0.25);
            end;

            local IsLoaded = ImageLabel.IsLoaded;
            ImageLabel:Destroy();
            u32[u36] = IsLoaded and "ok" or "failed";

            if not IsLoaded then
                task.delay(20, function() -- Line: 594
                    -- upvalues: u32 (ref), u36 (ref), u9 (ref), u40 (ref)
                    if u32[u36] == "failed" then
                        u32[u36] = nil;
                    end;

                    for _, v in u9 do
                        u40(v);
                    end;
                end);
            end;

            for _, v in u9 do
                u40(v);
            end;
        end);
    end;

    local v37;

    if u36 == "" then
        v37 = false;
    else
        v37 = u32[u36] == "ok";
    end;

    v35.Image = u36;
    v35.Visible = v37;
    local v38 = MobileLayoutState.LabelOf(v34);

    if v38 ~= v34 then
        v38.Visible = not v37;
    end;

    local Count = v34:FindFirstChild("Count");

    if Count then
        local v39 = p33.Count and p33.Count() or "";
        Count.Text = v39;
        Count.Visible = v39 ~= "";

        if v39 == "" then
            v37 = false;
        end;

        v35.Position = v37 and UDim2.fromScale(0.5, 0.42) or UDim2.fromScale(0.5, 0.5);
        v35.Size = v37 and UDim2.fromScale(0.48, 0.48) or UDim2.fromScale(0.58, 0.58);
    end;
end;

local function u52(p41) -- Line: 621
    -- upvalues: u11 (copy), MobileLayoutState (copy), u40 (ref), u23 (copy), u10 (copy), MobileModule (copy), Humanoid (copy), WheelController (copy), TeamNavigationController (copy)
    local v42 = u11[p41];

    if not v42 then
        return;
    end;

    if p41.Label then
        local v43 = MobileLayoutState.LabelOf(v42);

        if v43:IsA("TextLabel") or v43:IsA("TextButton") then
            v43.Text = p41.Label();
        end;
    end;

    u40(p41);
    local v44 = p41.Hint and v42:FindFirstChild("Hint");

    if v44 then
        local v45 = p41.Hint();
        v44.Text = v45;
        v44.Visible = v45 ~= "";
    end;

    local v46 = u11[p41];

    if v46 then
        local v47;

        if p41.Active then
            v47 = p41.Active() == true;
        else
            v47 = nil;
        end;

        u23(v46, u10[v46] ~= nil and true or v47 == true, v47);
    end;

    local v48 = MobileModule.IsTouch();

    if v48 then
        local v49 = Humanoid and Humanoid.Parent;

        if v49 then
            if Humanoid.Health > 0 then
                v49 = not Humanoid:GetAttribute("Downed");
            else
                v49 = false;
            end;
        end;

        v48 = v49 and not (WheelController:GetAttribute("Open") or TeamNavigationController:GetAttribute("MapOpen")) and p41.Visible() == true;
    end;

    if v42.Visible == v48 then
        return;
    end;

    v42.Visible = v48;

    if not v48 and u10[v42] then
        u10[v42] = nil;
        local v50 = u11[p41];

        if v50 then
            local v51;

            if p41.Active then
                v51 = p41.Active() == true;
            else
                v51 = nil;
            end;

            u23(v50, u10[v50] ~= nil and true or v51 == true, v51);
        end;

        for _, v in p41.Targets do
            v:Fire(false);
        end;
    end;
end;

local function u55(p53) -- Line: 666
    -- upvalues: MobileTouchButtons (copy), u9 (copy), u11 (copy)
    if not MobileTouchButtons.Visible then
        return;
    end;

    for _, v in u9 do
        local v54 = u11[v];

        if v54 and v54.Visible then
            local AbsolutePosition = v54.AbsolutePosition;
            local AbsoluteSize = v54.AbsoluteSize;

            if p53.X >= AbsolutePosition.X and (p53.X <= AbsolutePosition.X + AbsoluteSize.X and (p53.Y >= AbsolutePosition.Y and p53.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
                return v;
            end;
        end;
    end;
end;

local function v56() -- Line: 656
    -- upvalues: MobileTouchButtons (copy), MobileModule (copy), u9 (copy), u52 (copy)
    MobileTouchButtons.Visible = MobileModule.IsTouch();

    for _, v in u9 do
        u52(v);
    end;
end;

for _, v in u9 do
    local v57 = MobileTouchButtons:FindFirstChild(v.Name);

    if v57 then
        u11[v] = v57;
        v57.Active = false;
        CollectionService:AddTag(v57, "CameraPanIgnore");
        v57.AutoButtonColor = false;
        u12[v57] = v57.BackgroundColor3;
        u13[v57] = v57.BackgroundTransparency;
        MobileLayoutState.SetFadeDefault(v57.Name, v57);
        u14[v57] = MobileLayoutState.LabelOf(v57).TextColor3;
        local Size = v57.Size;

        if v57.AnchorPoint ~= Vector2_new_ret then
            local Position = v57.Position;
            v57.AnchorPoint = Vector2_new_ret;
            v57.Position = UDim2.fromScale(Position.X.Scale + Size.X.Scale / 2, Position.Y.Scale + Size.Y.Scale / 2);
        end;

        if MobileLayoutState.IsEditable(v.Name) then
            MobileLayoutState.SetDefault(v.Name, v57.Position.X.Scale, v57.Position.Y.Scale, Size.X.Scale, Size.Y.Scale);
        end;

        local u58 = v;

        for _, v2 in v.Watch do
            v2[1]:GetAttributeChangedSignal(v2[2]):Connect(function() -- Line: 718
                -- upvalues: u52 (copy), u58 (copy)
                u52(u58);
            end);
        end;
    end;
end;

local u59 = nil;

local function v63() -- Line: 730
    -- upvalues: MobileLayoutState (copy), MobileTouchButtons (copy), u59 (ref), u31 (copy)
    for _, v in MobileLayoutState.EDITABLE do
        local v60 = MobileTouchButtons:FindFirstChild(v);

        if v60 then
            local Centre, v61 = MobileLayoutState.GetCentre(v);
            local Size, v62 = MobileLayoutState.GetSize(v);

            if Centre and v61 then
                v60.Position = UDim2.fromScale(Centre, v61);
            end;

            if Size and v62 then
                v60.Size = UDim2.fromScale(Size, v62);
            end;
        end;
    end;

    if u59 then
        u59();
    end;

    u31();
end;

v63();
MobileLayoutState.Changed.Event:Connect(v63);
local GuiService = game:GetService("GuiService");
local u64 = { "Chat", "Map" };

local function v70() -- Line: 754
    -- upvalues: GuiService (copy), MobileTouchButtons (copy), Main (copy), u64 (copy)
    local TopbarInset = GuiService.TopbarInset;
    local AbsoluteSize = MobileTouchButtons.AbsoluteSize;

    if TopbarInset.Height <= 0 or (AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0) then
        return;
    end;

    local v65 = Main.IgnoreGuiInset and 0 or GuiService:GetGuiInset().Y;
    local v66 = TopbarInset.Height - 14;
    local v67 = TopbarInset.Min.Y + TopbarInset.Height / 2 - v65;
    local v68 = TopbarInset.Min.X + 12;

    for _, v in u64 do
        local v69 = MobileTouchButtons:FindFirstChild(v);

        if v69 then
            v69.Position = UDim2.fromScale((v68 + v66 / 2) / AbsoluteSize.X, v67 / AbsoluteSize.Y);
            v69.Size = UDim2.fromScale(v66 / AbsoluteSize.X, v66 / AbsoluteSize.Y);
            v68 = v68 + (v66 + 12);
        end;
    end;

    local Chat = MobileTouchButtons:FindFirstChild("Chat");
    local Channel = MobileTouchButtons:FindFirstChild("Channel");

    if Chat and Channel then
        Channel.Size = Chat.Size;
        Channel.Position = Chat.Position + UDim2.fromScale(0, (v66 + 12) / AbsoluteSize.Y);
    end;
end;

v70();
GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(v70);
MobileTouchButtons:GetPropertyChangedSignal("AbsoluteSize"):Connect(v70);
Main:GetPropertyChangedSignal("IgnoreGuiInset"):Connect(v70);
UserInputService.TouchStarted:Connect(function(p71) -- Line: 786
    -- upvalues: MobileModule (copy), SettingsModule (copy), Humanoid (copy), TeamNavigationController (copy), u55 (copy), u11 (copy), u10 (copy), u23 (copy)
    if not MobileModule.IsTouch() then
        return;
    end;

    if not SettingsModule.MainMenuOpen() then
        local v72 = Humanoid and Humanoid.Parent;

        if v72 then
            if Humanoid.Health > 0 then
                v72 = not Humanoid:GetAttribute("Downed");
            else
                v72 = false;
            end;
        end;

        if v72 then
            if TeamNavigationController:GetAttribute("MapOpen") then
                return;
            end;

            local v73 = u55(p71.Position);

            if not v73 then
                return;
            end;

            local v74 = u11[v73];

            if u10[v74] then
                return;
            end;

            u10[v74] = p71;
            local v75 = u11[v73];

            if v75 then
                local v76;

                if v73.Active then
                    v76 = v73.Active() == true;
                else
                    v76 = nil;
                end;

                u23(v75, u10[v75] ~= nil and true or v76 == true, v76);
            end;

            for _, v in v73.Targets do
                v:Fire(true);
            end;
        end;
    end;
end);
UserInputService.InputEnded:Connect(function(p77) -- Line: 801
    -- upvalues: u9 (copy), u11 (copy), u10 (copy), u23 (copy)
    for _, v in u9 do
        local v78 = u11[v];

        if v78 and u10[v78] == p77 then
            u10[v78] = nil;
            local v79 = u11[v];

            if v79 then
                local v80;

                if v.Active then
                    v80 = v.Active() == true;
                else
                    v80 = nil;
                end;

                u23(v79, u10[v79] ~= nil and true or v80 == true, v80);
            end;

            for _, v2 in v.Targets do
                v2:Fire(false);
            end;
        end;
    end;
end);
local Inventory = MobileTouchButtons:FindFirstChild("Inventory");

if Inventory then
    local Inventory2 = MobileLayoutState.Defaults.Inventory;
    local UDim2_fromScale_ret = UDim2.fromScale(0.9 + (Inventory2 and (Inventory2.W or 0) or 0) / 2, 0.02 + (Inventory2 and (Inventory2.H or 0) or 0) / 2);
    local Menu = MobileTouchButtons:FindFirstChild("Menu");
    local Close = MobileTouchButtons:FindFirstChild("Close");

    local function v81() -- Line: 829
        -- upvalues: Menu (copy), Close (copy), Inventory2 (copy), MobileTouchButtons (copy), UDim2_fromScale_ret (copy)
        if not (Menu and (Close and Inventory2)) then
            return;
        end;

        local AbsoluteSize = MobileTouchButtons.AbsoluteSize;

        if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
            return;
        end;

        local math_min_ret = math.min(Inventory2.W * AbsoluteSize.X, Inventory2.H * AbsoluteSize.Y);
        local math_max_ret = math.max((Close.Position.Y.Scale - UDim2_fromScale_ret.Y.Scale - Inventory2.H) * AbsoluteSize.Y, 0);
        Menu.Position = UDim2.fromScale(UDim2_fromScale_ret.X.Scale - (math_min_ret + math_max_ret) / AbsoluteSize.X, UDim2_fromScale_ret.Y.Scale);
    end;

    v81();
    MobileTouchButtons:GetPropertyChangedSignal("AbsoluteSize"):Connect(v81);

    u59 = function() -- Line: 846
        -- upvalues: InventoryController (copy), Inventory (copy), UDim2_fromScale_ret (copy), Inventory2 (copy), MobileLayoutState (copy)
        if InventoryController:GetAttribute("Open") then
            Inventory.Position = UDim2_fromScale_ret;

            if Inventory2 then
                Inventory.Size = UDim2.fromScale(Inventory2.W, Inventory2.H);
            end;

            return;
        end;

        local Centre, v82 = MobileLayoutState.GetCentre("Inventory");
        local Size, v83 = MobileLayoutState.GetSize("Inventory");

        if Centre and v82 then
            Inventory.Position = UDim2.fromScale(Centre, v82);
        end;

        if Size and v83 then
            Inventory.Size = UDim2.fromScale(Size, v83);
        end;
    end;

    InventoryController:GetAttributeChangedSignal("Open"):Connect(u59);
    u59();
end;

local Channel = MobileTouchButtons:FindFirstChild("Channel");

if Channel then
    local u84 = Channel:FindFirstChildOfClass("UIStroke");
    u84 = u84;
    local u85;

    if u84 then
        u85 = u84:GetAttribute("ColorDefault");
    else
        u85 = u84;
    end;

    local u86 = MobileLayoutState.LabelOf(Channel);

    local function v87() -- Line: 875
        -- upvalues: ChatController (copy), u84 (copy), u85 (copy), u86 (copy), Channel (copy)
        local Attribute = ChatController:GetAttribute("ChannelColor");

        if u84 then
            u84.Color = Attribute or (u85 or Color3.new(1, 1, 1));
        end;

        if u86 ~= Channel then
            u86.TextColor3 = Attribute or Color3.new(1, 1, 1);
        end;
    end;

    ChatController:GetAttributeChangedSignal("ChannelColor"):Connect(v87);
    v87();
end;

PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(v56);
WheelController:GetAttributeChangedSignal("Open"):Connect(v56);
TeamNavigationController:GetAttributeChangedSignal("MapOpen"):Connect(v56);
Codelock:GetPropertyChangedSignal("Visible"):Connect(v56);
GiveBed:GetPropertyChangedSignal("Visible"):Connect(v56);
RenameBed:GetPropertyChangedSignal("Visible"):Connect(v56);
Humanoid:GetAttributeChangedSignal("Downed"):Connect(v56);
Humanoid.Died:Connect(v56);
u31();
ReplicatedStorage:GetAttributeChangedSignal("Settings"):Connect(u31);
local u88 = nil;

for _, v in u9 do
    if v.Name == "Attachment" then
        u88 = v;
        break;
    end;
end;

if u88 then
    ViewmodelController.UpdateVM.Event:Connect(function() -- Line: 920
        -- upvalues: u52 (copy), u88 (ref)
        u52(u88);
    end);
end;

MobileTouchButtons.Visible = MobileModule.IsTouch();

for _, v in u9 do
    u52(v);
end;