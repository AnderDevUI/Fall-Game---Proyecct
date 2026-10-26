-- [PATH] ReplicatedStorage / CharacterScripts / InventoryController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local UserService = game:GetService("UserService");
game:GetService("SoundService");
local GamepadService = game:GetService("GamepadService");
local GuiService = game:GetService("GuiService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Values = ReplicatedStorage:WaitForChild("Values");
ReplicatedStorage:WaitForChild("LocalSounds");
local ClientSignals = ReplicatedStorage:WaitForChild("ClientSignals");
local Items = require(Modules:WaitForChild("Items"));
local TweenUtil = require(Modules:WaitForChild("TweenUtil"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local ButtonClass = require(Modules:WaitForChild("ButtonClass"));
local ViewportModule = require(Modules:WaitForChild("ViewportModule"));
local SoundModule = require(Modules:WaitForChild("SoundModule"));
local ToolInfo = require(Modules:WaitForChild("ToolInfo"));
local ResearchModule = require(Modules:WaitForChild("ResearchModule"));
local RecipeModule = require(Modules:WaitForChild("RecipeModule"));
local ItemClass = require(Modules:WaitForChild("ItemClass"));
local GamepadIconModule = require(Modules:WaitForChild("GamepadIconModule"));
local ItemSearchModule = require(Modules:WaitForChild("ItemSearchModule"));
ItemSearchModule.CancelSearch(true);
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local ActiveBenchModule = require(Modules:WaitForChild("ActiveBenchModule"));
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local u1 = require(Modules:WaitForChild("AssetContainer"))();
local Fetch = script:WaitForChild("Fetch");
local GetBench = script:WaitForChild("GetBench");
local ItemStats = script:WaitForChild("ItemStats");
local Toggle = script:WaitForChild("Toggle");
local MobileToggle = script:WaitForChild("MobileToggle");
local MobileClose = script:WaitForChild("MobileClose");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Humanoid = script_Parent:WaitForChild("Humanoid");
local Mouse = LocalPlayer:GetMouse();
local workspace_CurrentCamera = workspace.CurrentCamera;
local ViewmodelController = script_Parent:WaitForChild("ViewmodelController");
local WheelController = script_Parent:WaitForChild("WheelController");
local CraftingController = script_Parent:WaitForChild("CraftingController");
local StateController = script_Parent:WaitForChild("StateController");
local TeamNavigationController = script_Parent:WaitForChild("TeamNavigationController");
local InteractController = script_Parent:WaitForChild("InteractController");
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local Main = PlayerGui:WaitForChild("Main");
local Boombox = PlayerGui:WaitForChild("Boombox");
local BG = Main:WaitForChild("BG");
local Inventory = Main:WaitForChild("Inventory");
local Toolbar = Main:WaitForChild("Toolbar");
local Drag = Main:WaitForChild("Drag");
local Inv = Inventory:WaitForChild("Inv");
local Backpack = Inventory:WaitForChild("Backpack");
local ActionMenu = Inventory:WaitForChild("ActionMenu");
local ImageLabel = ActionMenu:WaitForChild("Actions"):WaitForChild("Drop"):WaitForChild("Label"):WaitForChild("ImageLabel");
GamepadIconModule.Register(ImageLabel, "ButtonX");
local ItemStats2 = ActionMenu:WaitForChild("ItemStats");
local Benches = Inventory:WaitForChild("Benches");
local Armor = Inventory:WaitForChild("Armor");
local ViewportFrame = Armor:WaitForChild("ViewportFrame");
local HitboxChest = Armor:WaitForChild("HitboxChest");
local HitboxHead = Armor:WaitForChild("HitboxHead");
local HitboxLegs = Armor:WaitForChild("HitboxLegs");
local CraftingKeyboard = Inventory:WaitForChild("CraftingKeyboard");
local CraftingConsole = Inventory:WaitForChild("CraftingConsole");
GamepadIconModule.Register(CraftingConsole:WaitForChild("ImageLabel"), "ButtonY");
local Crafting = Main:WaitForChild("Crafting");
local CraftingKeyboard2 = Crafting:WaitForChild("CraftingKeyboard");
local CraftingConsole2 = Crafting:WaitForChild("CraftingConsole");
GamepadIconModule.Register(CraftingConsole2:WaitForChild("ImageLabel"), "ButtonY");
local Stats = Main:WaitForChild("Stats");
local Team = Main:WaitForChild("Team");
local GamepadControls = Main:WaitForChild("GamepadControls");
local ToolTip = GamepadControls:WaitForChild("ToolTip");
local u2 = { GamepadControls:WaitForChild("TopControls"), GamepadControls:WaitForChild("ToolbarRight"), GamepadControls:WaitForChild("ToolbarLeft") };
local DragEntry = ToolTip:WaitForChild("DragEntry");
local MenuEntry = ToolTip:WaitForChild("MenuEntry");
local TransferEntry = ToolTip:WaitForChild("TransferEntry");
GamepadIconModule.RegisterSetting(DragEntry:FindFirstChildWhichIsA("ImageLabel"), "Gamepad", "Jump");
GamepadIconModule.RegisterSetting(MenuEntry:FindFirstChildWhichIsA("ImageLabel"), "Gamepad", "Interact/Reload");
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {
    Inventory = Inv,
    Toolbar = Toolbar,
    Armor = Armor
};
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = 1;

if MobileModule.IsTouchDevice() then
    local Size = ActionMenu.Size;
    local Position = ActionMenu.Position;
    local v13 = Size.Y.Scale * 1.21;
    ActionMenu.Size = UDim2.fromScale(Size.X.Scale * 1.2, v13);
    ActionMenu.Position = UDim2.fromScale(Position.X.Scale, Position.Y.Scale - (v13 - Size.Y.Scale) / 2);
end;

local Size = ActionMenu.Size;
local u14 = true;
local u15 = false;
local u16 = nil;
local u17 = nil;
local u18 = false;
local u19 = false;
local u20 = 0;
local u21 = 0;
local u22 = {};
local u23 = 0;
local u24 = false;
local u25 = {};
local u26 = nil;
local u27 = nil;
local u28 = 0;
local u29 = 1;
local u30 = 0;
local u31 = 1;
local u32 = {};
local u33 = false;
local u34 = false;
local u35 = nil;

local function v37() -- Line: 175
    -- upvalues: PreferredInputController (copy)
    local v36 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    return v36;
end;

local function v38() -- Line: 178
    -- upvalues: MobileModule (copy), SettingsModule (copy)
    return MobileModule.IsTouch() and "TAP" or SettingsModule.GetSetting("Controls", "Open Crafting");
end;

local function u42() -- Line: 181
    -- upvalues: Mouse (copy), u6 (copy)
    local X = Mouse.X;
    local Y = Mouse.Y;

    for i, v in pairs(u6) do
        local v39 = v:FindFirstChild("Inv") or v;
        local v40 = i;

        for _, child in pairs(v39:GetChildren()) do
            if child.Name:sub(1, 4) == "Slot" and (child:IsA("ImageButton") and child.Visible) then
                local AbsolutePosition = child.AbsolutePosition;
                local AbsoluteSize = child.AbsoluteSize;

                if AbsolutePosition.X <= X and (X <= AbsolutePosition.X + AbsoluteSize.X and (AbsolutePosition.Y <= Y and Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
                    local v41 = tonumber(child.Name:sub(5));

                    if v41 then
                        return child, v40, v41;
                    end;
                end;
            end;
        end;
    end;
end;

local function _() -- Line: 198
    -- upvalues: Humanoid (copy)
    return Humanoid and Humanoid.Parent and Humanoid.Health > 0;
end;

local function _() -- Line: 202
    -- upvalues: Drag (copy), RunService (copy), u10 (ref)
    Drag.Visible = false;
    RunService:UnbindFromRenderStep("Drag");
    u10 = nil;
end;

local u43 = nil;

local function u44() -- Line: 209
    -- upvalues: SoundModule (copy), u17 (ref), ItemSearchModule (copy), u6 (copy), u3 (ref), u10 (ref), Drag (copy), RunService (copy), u9 (ref), u43 (ref)
    SoundModule:PlayBenchSound(u17 and u17.Name, "Close");
    ItemSearchModule.CancelSearch(true);
    u17 = nil;
    local Bench = u6.Bench;

    if Bench and Bench.Parent then
        Bench.Visible = false;
    end;

    u6.Bench = nil;
    u3.Bench = nil;

    if u10 and u10.Container == "Bench" then
        Drag.Visible = false;
        RunService:UnbindFromRenderStep("Drag");
        u10 = nil;
    end;

    if u9 and u9.Container == "Bench" then
        u43(nil);
    end;
end;

local function u53(p45, p46) -- Line: 227
    -- upvalues: u7 (ref), TweenUtil (copy), BG (copy), u8 (ref), PreferredInputController (copy), u35 (ref), Humanoid (copy), GamepadService (copy), u17 (ref), u1 (copy), u44 (copy), Drag (copy), RunService (copy), u10 (ref), u33 (ref), Inventory (copy), Crafting (copy), TeamNavigationController (copy), UserInputService (copy), Boombox (copy), MobileModule (copy), SettingsModule (copy), CraftingKeyboard (copy), CraftingConsole (copy), CraftingKeyboard2 (copy), CraftingConsole2 (copy), ToolTip (copy), DragEntry (copy), MenuEntry (copy), TransferEntry (copy), u2 (copy), Mouse (copy)
    if not u7 then
        u7 = TweenUtil:Tween(BG, "BackgroundTransparency", 0.5, 0.15, "Quart", "Out", true);
        u8 = TweenUtil:Tween(BG, "BackgroundTransparency", 1, 0.15, "Quart", "In", true);
    end;

    local v47 = p45 ~= "None";

    if v47 then
        if p46 then
            BG.BackgroundTransparency = 0.5;
        else
            u7:Play();
        end;

        local v48 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v48 and not u35 then
            u35 = Humanoid.WalkSpeed;
            Humanoid.WalkSpeed = 0;
        end;

        local v49 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v49 then
            pcall(function() -- Line: 247
                -- upvalues: GamepadService (ref)
                GamepadService:EnableGamepadCursor(nil);
            end);
        end;
    else
        if u17 and u17.Parent then
            u1("Fire", "\239\191\189\057\195\183\239\191\189\239\191\189\239\191\189\239\191\189\071\239\191\189\239\191\189\239\191\189\194\167\239\191\189\239\191\189\038\239\191\189\106\239\191\189\239\191\189\239\191\189", "\239\191\189\194\168\076\239\191\189\121\239\191\189\102\195\128\195\182\086\078\239\191\189\090\195\130\239\191\189\045\081\239\191\189\070\239\191\189", "Close", u17);
        end;

        u44();

        if p46 then
            BG.BackgroundTransparency = 1;
        else
            u8:Play();
        end;

        Drag.Visible = false;
        RunService:UnbindFromRenderStep("Drag");
        u10 = nil;
        u33 = false;

        if u35 then
            Humanoid.WalkSpeed = u35;
            u35 = nil;
        end;

        pcall(function() -- Line: 270
            -- upvalues: GamepadService (ref)
            GamepadService:DisableGamepadCursor();
        end);
    end;

    Inventory:TweenPosition(UDim2.new(p45 == "Crafting" and 1 or (p45 == "Inventory" and 0 or -1), 0, 0, 0), v47 and "Out" or "In", "Quart", p46 and 0 or 0.1, true);
    Crafting:TweenPosition(UDim2.new(p45 == "Crafting" and 0 or (p45 == "Inventory" and -1 or -2), 0, 0, 0), v47 and "Out" or "In", "Quart", p46 and 0 or 0.1, true);

    if not TeamNavigationController:GetAttribute("MapOpen") or v47 then
        UserInputService.MouseBehavior = Enum.MouseBehavior[v47 and "Default" or "LockCenter"];
        UserInputService.MouseIconEnabled = v47;
    end;

    Boombox.Enabled = Boombox.Enabled and v47;
    script:SetAttribute("Open", v47);
    script:SetAttribute("CurOpen", p45);
    local v50 = MobileModule.IsTouch() and "TAP" or SettingsModule.GetSetting("Controls", "Open Crafting");
    local v51 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    CraftingKeyboard.Text = `CRAFTING [<font color="rgb(255, 244, 88)">{v50}</font>]`;
    CraftingConsole.Text = "CRAFTING    ";
    CraftingKeyboard.Visible = not v51;
    CraftingConsole.Visible = v51;
    CraftingKeyboard2.Text = `INVENTORY [<font color="rgb(255, 244, 88)">{v50}</font>]`;
    CraftingConsole2.Text = "INVENTORY    ";
    CraftingKeyboard2.Visible = not v51;
    CraftingConsole2.Visible = v51;

    if not v47 then
        script:SetAttribute("ClosedTick", tick());
    end;

    local v52 = v47 and PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    ToolTip.Visible = v52;

    if p45 == "Crafting" then
        DragEntry.Visible = true;
        DragEntry.Text = " - Double Tap Craft";
        MenuEntry.Visible = false;
        TransferEntry.Visible = false;
    else
        DragEntry.Visible = true;
        DragEntry.Text = " - Drag Item";
        MenuEntry.Visible = true;
        TransferEntry.Visible = true;
    end;

    for _, v in pairs(u2) do
        v.Visible = not v47;
    end;

    if not v52 then
        pcall(function() -- Line: 321
            -- upvalues: RunService (ref)
            RunService:UnbindFromRenderStep("GamepadTooltip");
        end);

        return;
    end;

    pcall(function() -- Line: 316
        -- upvalues: RunService (ref)
        RunService:UnbindFromRenderStep("GamepadTooltip");
    end);
    RunService:BindToRenderStep("GamepadTooltip", Enum.RenderPriority.Last.Value, function() -- Line: 317
        -- upvalues: ToolTip (ref), Mouse (ref)
        ToolTip.Position = UDim2.new(0, Mouse.X - 10, 0, Mouse.Y - ToolTip.AbsoluteSize.Y + 80);
    end);
end;

local function u63(p54, p55, p56, p57, p58, p59, p60, p61) -- Line: 325
    -- upvalues: u10 (ref), Drag (copy), RunService (copy), Mouse (copy), SoundModule (copy)
    if script:GetAttribute("Open") then
        u10 = {
            Slot = p54,
            Container = p56,
            Index = p57,
            Mouse = p58,
            IsActionMenu = p59,
            EditIndex = p61
        };
        Drag.Image = p55;
        local u62 = false;
        RunService:BindToRenderStep("Drag", Enum.RenderPriority.Input.Value + 1, function() -- Line: 340
            -- upvalues: u62 (ref), Drag (ref), Mouse (ref)
            if not u62 then
                Drag.Visible = true;
                u62 = true;
            end;

            Drag.Position = UDim2.new(0, Mouse.X + 1, 0, Mouse.Y + 1);
        end);
        SoundModule:PlayItemSound(p60.ID, "Drag");

        return true;
    end;
end;

local function u80(p64, p65, p66, p67, p68, p69, p70) -- Line: 351
    -- upvalues: u3 (ref), Items (copy), Backpack (copy), u17 (ref), u20 (ref), SoundModule (copy), RunService (copy), u21 (ref), u1 (copy)
    if p68 ~= "ArmorEquip" and not script:GetAttribute("Open") then
        return;
    end;

    local v71 = u3[p65];

    if not (v71 and (tick() - (p64.Fill:GetAttribute("Cooldown") or 0) >= 0.4 and not p64.Fill.Visible)) then
        return;
    end;

    local v72 = v71[p66];

    if not (v72 and (v72 ~= 0 and not (p70 and (not p70 or p70 == 0)))) then
        return;
    end;

    local ID = (p70 or v72).ID;
    local _ = (Items[ID] or {}).Type:find("Armor") == nil;
    p64.Fill.Visible = true;
    local v73 = Backpack.Visible and not u17 and (p65 == "Inventory" and true or p65 == "Toolbar");
    local v74 = p68 == "ArmorEquip" and 0.9 or ((u17 and p65 ~= "Armor" or (v73 or p70)) and 0.3 or 0.1);
    local v75 = false;
    local v76 = 0;
    local v77;

    if p68 then
        v77 = u20;
        u20 = u20 + 1;
    else
        v77 = nil;
    end;

    SoundModule:PlayItemSound(ID, "Drag");

    while u3[p65] and (v71[p66] and v71[p66] ~= 0) do
        local math_min_ret = math.min(v76, v74);
        local v78 = math_min_ret / v74;

        if p68 then
            v78 = 1 - v78;
        end;

        local math_clamp_ret = math.clamp(v78, 0, 1);
        p64.Fill.Size = UDim2.new(1, 0, math_clamp_ret, 0);
        p64.Fill.Position = UDim2.new(0, 0, 1 - math_clamp_ret, 0);

        if v74 <= math_min_ret then
            v75 = true;
            break;
        end;

        local v79 = RunService.Heartbeat:Wait();

        if not p68 or v77 <= u21 then
            v76 = v76 + v79;
        end;
    end;

    if v75 then
        SoundModule:PlayItemSound(ID, "Drop");

        if v73 then
            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", p65, p66, nil, "Armor", 8);
        elseif p70 then
            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", p65, p66, "QuickStack", p67, p69);
        else
            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", p65, p66, "QuickStack", p67);
        end;
    end;

    p64.Fill:SetAttribute("Cooldown", tick());
    p64.Fill.Visible = false;

    if p68 then
        u21 = u21 + 1;
    end;
end;

local function u83(p81) -- Line: 427
    -- upvalues: u11 (ref), ActionMenu (copy), NumberUtil (copy)
    if not u11 then
        u11 = {};

        for _, descendant in pairs(ActionMenu:GetDescendants()) do
            if not descendant:IsA("UIGradient") then
                local v82 = `{descendant:IsA("TextLabel") and "Text" or (descendant:IsA("UIStroke") and "" or ((descendant:IsA("Frame") or descendant.Image == "") and "Background" or "Image"))}Transparency`;
                u11[descendant] = { v82, descendant[v82] };
            end;
        end;
    end;

    for i, v in u11 do
        i[v[1]] = NumberUtil:Lerp(v[2], 1, p81);
    end;

    ActionMenu.Visible = p81 < 1;
end;

local function u86() -- Line: 444
    -- upvalues: u9 (ref), u3 (ref), u16 (ref), ActionMenu (copy), NumberUtil (copy)
    if u9 then
        local v84 = u3[u9.Container];

        if not v84 then
            return;
        end;

        local v85 = v84[u9.Index];

        if not (v85 and (v85 ~= 0 and v85.Amount > 0)) then
            return;
        end;

        u16 = math.clamp(u16, 1, v85.Amount);
        ActionMenu.SplitBar.Fill:TweenSize(UDim2.new(u16 / v85.Amount, 0, 1, 0), "Out", "Quart", 0.15, true);
        ActionMenu.SplitBar.Amount.Text = NumberUtil:FormatNumber(u16);
    end;
end;

local function u109(p87, p88, p89, p90) -- Line: 457
    -- upvalues: Items (copy), NumberUtil (copy), ViewmodelController (copy), Toolbar (copy)
    local v91 = tonumber(p87.Name:sub(5));
    local v92 = (1 / 0);
    local v93, v94, v95, v96, v97, v98, v99;

    if p88 and p88 ~= 0 then
        v93 = Items[p88.ID];
        v94 = v93.Image;
        v95 = v93.MaxDurability;
        v96 = v93.Attachments;
        v97 = p88.Ammo;
        v98 = p88.CookTimes;
        v99 = p88.Container;
        v92 = v93.MaxAttachments or v92;
    else
        v99 = nil;
        v98 = nil;
        v95 = nil;
        v96 = nil;
        v94 = nil;
        v93 = nil;
        v97 = nil;
    end;

    local Durability = p87:FindFirstChild("Durability");
    local v100;

    if Durability then
        v100 = v95 ~= nil;

        if v95 then
            Durability.Fill.Size = UDim2.new(math.clamp(p88.Durability / v95, 0, 1), 0, 1, 0);
            local math_min_ret = math.min(p88.Repair, 1);
            Durability.Repair.Position = UDim2.new(1 - math_min_ret, 0, 0, 0);
            Durability.Repair.Size = UDim2.new(math_min_ret, 0, 1, 0);
        end;

        Durability.Visible = v100;
    else
        v100 = false;
    end;

    for i = 1, 4 do
        local v101 = p87:FindFirstChild("Att" .. i);
        local v102;

        if v101 then
            if v96 then
                v101.BackgroundColor3 = i <= #p88.Attachments and Color3.fromRGB(255, 244, 88) or Color3.fromRGB(167, 165, 130);
            end;

            local v103;

            if v96 == nil then
                v103 = false;
            else
                v103 = i <= math.min(#v96, v92);
            end;

            v101.Visible = v103;
            v102 = i;
        else
            v102 = i;
        end;
    end;

    local v104;

    if type(v94) == "table" then
        v104 = v94[p88.Skin];
    else
        v104 = v94;
    end;

    p87.ItemImage.Image = type(v104) ~= "string" and "" or v104;

    if v93 and (v93.Type == "Backpack" and v99) then
        local v105 = 0;

        for _, v in v99 do
            if type(v) == "table" and v.Amount > 0 then
                v105 = v105 + 1;
            end;
        end;

        p87.ItemAmount.Text = `{v105}/{#v99}`;
    else
        p87.ItemAmount.Text = v93 and (v93.Type:find("Ammo") == nil and v93.AmmoType ~= nil and NumberUtil:FormatNumber(v97 == nil and 0 or (p89 or (v97.Amount or 0))) or (p88.Amount > 1 and ("x" .. NumberUtil:FormatNumber(p88.Amount) or "") or "")) or "";
    end;

    p87.ItemAmount.Position = UDim2.new(0.25, 0, v100 and 0.71 or 0.76, 0);
    local Broken = p87:FindFirstChild("Broken");

    if Broken then
        local v106;

        if v95 == nil then
            v106 = false;
        else
            v106 = p88.Durability <= 0;
        end;

        Broken.Visible = v106;
    end;

    local Empty = p87:FindFirstChild("Empty");

    if Empty then
        Empty.Visible = v94 == nil;
    end;

    local Checker = p87:FindFirstChild("Checker");

    if Checker then
        Checker.Visible = false;
    end;

    local CookBar = p87:FindFirstChild("CookBar");

    if CookBar then
        if v98 then
            local math_clamp_ret = math.clamp(v98[1] / v98[2], 0, 1);
            local v107;

            if math_clamp_ret < CookBar.Fill.Size.Y.Scale - 0.001 then
                v107 = CookBar.Visible;
            else
                v107 = false;
            end;

            local v108 = math_clamp_ret <= 0.001;
            CookBar.Fill:TweenSize(UDim2.new(1, 0, v107 and not v108 and 1 or math_clamp_ret, 0), "InOut", "Linear", CookBar.Visible and not v108 and (v107 and 0.8 or 1) or 0, true);

            if v107 and not v108 then
                task.delay(0.8, function() -- Line: 529
                    -- upvalues: CookBar (copy), math_clamp_ret (copy)
                    if not (CookBar and (CookBar.Parent and (CookBar.Visible and CookBar.Fill.Size.Y.Scale >= 0.99))) then
                        return;
                    end;

                    CookBar.Fill:TweenSize(UDim2.new(1, 0, math_clamp_ret, 0), "InOut", "Linear", 0.1, true);
                end);
            end;
        end;

        CookBar.Visible = v98 ~= nil;
    end;

    local Attribute = ViewmodelController:GetAttribute("Equipped");

    if p90 or (p87.Parent ~= Toolbar or v91 ~= Attribute) then
        return;
    end;

    ViewmodelController.UpdateVM:Fire(p88);
end;

local function u115(p110, ...) -- Line: 542
    local v111 = { ... };

    for i = 1, 8 do
        local v112 = p110["Stat" .. i];
        local v113 = v111[i] or "";
        v112.Size = UDim2.new(i > 4 and 0.5 or 1, 0, 0.24, 0);
        v112.RichText = v113:find("</") ~= nil;
        v112.Text = v113;
        local v114;

        if i <= 4 then
            v114 = i;
        else
            p110["Stat" .. i - 4].Size = UDim2.new(0.5, 0, 0.24, 0);
            v114 = i;
        end;
    end;
end;

local function u155(p116, p117, p118) -- Line: 556
    -- upvalues: u115 (copy), Items (copy), ToolInfo (copy), NumberUtil (copy)
    u115(p116);
    local v119 = p118 or Items[p117];
    local AmmoStats = v119.AmmoStats;
    local ConsumableStats = v119.ConsumableStats;
    local Resistances = v119.Resistances;
    local v120 = ToolInfo[v119.Name];

    if v119.Type == "Gun" and v120 then
        local Weapon = v120.Weapon;
        local Bullet = v120.Bullet;

        if Bullet then
            local Dropoff = Bullet.Dropoff;
            local ActualRPM = Weapon.ActualRPM;
            local v121 = `Base Damage: {NumberUtil:RoundNumber(Bullet.DisplayDamage or Bullet.HumanoidDamages.Chest)}`;

            if type(ActualRPM) ~= "string" then
                ActualRPM = NumberUtil:FormatNumber(ActualRPM or Weapon.RPM);
            end;

            u115(p116, v121, `RPM: {ActualRPM}`, `Range Dropoff: {NumberUtil:FormatNumber(Dropoff.Start) .. (Dropoff.End == Dropoff.Start and "" or "-" .. NumberUtil:FormatNumber(Dropoff.End))}`, (`Bullet Velocity: {NumberUtil:FormatNumber(Bullet.Speed)}`));
        end;
    else
        if v119.Type == "Tool" or v119.Type:find("Consumable") then
            local v122 = {};

            if v120 then
                local Weapon = v120.Weapon;
                local Melee = v120.Melee;
                local ObjectDamages = v120.ObjectDamages;
                local v123 = Melee and Melee.HumanoidDamages;

                if v123 then
                    local v124 = `Base Damage: {NumberUtil:RoundNumber(v123.Chest)}`;
                    table.insert(v122, v124);
                end;

                local v125;

                if Weapon then
                    v125 = Weapon.ThrowInfo;
                else
                    v125 = Weapon;
                end;

                local v126 = v125 and v125.Explosive;

                if v126 then
                    local v127 = `Splash Damage: {NumberUtil:RoundNumber(v126.HumanoidMaxDamage)}`;
                    table.insert(v122, v127);
                end;

                if Weapon then
                    Weapon = Weapon.Cooldown;
                end;

                if Weapon then
                    local v128 = `Cooldown: {NumberUtil:RoundNumber(Weapon)}`;
                    table.insert(v122, v128);
                end;

                if ObjectDamages then
                    local Trees = ObjectDamages.Trees;

                    if Trees then
                        local v129 = `Tree Gather: {math.round(Trees.Medium.Mult * 1000) / 100}`;
                        table.insert(v122, v129);
                    end;

                    local Nodes = ObjectDamages.Nodes;

                    if Nodes then
                        local v130 = `Node Gather: {math.round(Nodes.Stone.Mult * 1000) / 100}`;
                        table.insert(v122, v130);
                    end;
                end;
            end;

            if ConsumableStats then
                for i, v in pairs(ConsumableStats) do
                    if v ~= 0 and type(v) == "number" then
                        local v131 = NumberUtil:RoundNumber(v);
                        local math_abs_ret = math.abs(v);
                        local Attribute = script:GetAttribute(v131 < 0 == (i ~= "Radiation") and "StatRedColor" or "StatGreenColor");
                        local v132 = `{i == "HQueue" and "Health Regen" or (i == "Health" and "Instant Health" or i)}: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">{(v131 < 0 and "-" or "+") .. math_abs_ret}</font>`;
                        table.insert(v122, v132);
                    end;
                end;
            end;

            u115(p116, unpack(v122));

            return;
        end;

        if AmmoStats then
            local v133 = {};

            for i, v in pairs(AmmoStats) do
                if i:sub(#i - 3) == "Mult" then
                    local v134 = i:sub(1, #i - 4);
                    local v135 = v134 == "Gravity";
                    local math_round_ret = math.round(((v135 or v134 == "ArmorPen") and 1 - v or (v134 == "HeadshotDamage" and v and v or v * (AmmoStats.Bullets or 1) - 1)) * 100);
                    local math_abs_ret = math.abs(math_round_ret);
                    local v136 = math_round_ret < 0 == (v134:find("Spread") == nil);
                    local Attribute = script:GetAttribute(v136 and "StatRedColor" or "StatGreenColor");
                    local v137 = `{v135 and "Drop" or (v134 == "ArmorPen" and "Armor Penetration" or (v134 == "HeadshotDamage" and "HS Mult" or v134:gsub("Spread", " Spread")))}: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">{(math_round_ret < 0 and "-" or "+") .. math_abs_ret}%</font>`;
                    table.insert(v133, v137);
                elseif i == "Explosive" then
                    local v138 = NumberUtil:FormatNumber(v.HumanoidMaxDamage);

                    if v119.AmmoType == "Rocket" then
                        if v119.Name ~= "Rocket" then
                            local v139 = `Damage Override: {NumberUtil:FormatNumber(v138)}`;
                            table.insert(v133, v139);
                        end;
                    else
                        local Attribute = script:GetAttribute("StatGreenColor");
                        local v140 = `Splash Damage: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">+{v138}</font>`;
                        table.insert(v133, v140);
                    end;
                elseif i == "Bullets" then
                    local v141 = `Pellets: {v}`;
                    table.insert(v133, v141);
                end;
            end;

            u115(p116, unpack(v133));

            return;
        end;

        if Resistances then
            local v142 = {};

            for _, v in pairs({ "Chest", "Legs", "Head" }) do
                local v143 = Resistances[v];
                local Bullet = v143.Bullet;
                local Melee = v143.Melee;

                if Bullet ~= 0 or Melee ~= 0 then
                    if Bullet ~= 0 then
                        table.insert(v142, { "Bullet", Bullet });
                    end;

                    if Melee ~= 0 then
                        table.insert(v142, { "Melee", Melee });
                    end;

                    break;
                end;
            end;

            for i, v in pairs(Resistances) do
                if v ~= 0 and type(v) == "number" then
                    table.insert(v142, { i, v });
                end;
            end;

            local v144 = {};

            for _, v in pairs(v142) do
                local v145 = v[2];
                local v146 = NumberUtil:RoundNumber((math.abs(v145)));
                local Attribute = script:GetAttribute(v145 < 0 and "StatRedColor" or "StatGreenColor");
                local v147 = `{v[1]}: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">{(v145 < 0 and "-" or "+") .. v146}</font>`;
                table.insert(v144, v147);
            end;

            u115(p116, unpack(v144));

            return;
        end;

        if v119.Name == "Armor Plate" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Bullet Resistance: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">+5%</font>`));

            return;
        end;

        if v119.Name == "Heavy Padding" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Melee Resistance: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">+5%</font>`));

            return;
        end;

        if v119.Name == "Night Vision Goggles" then
            local Attribute = script:GetAttribute("StatGreenColor");
            local Attribute2 = script:GetAttribute("StatRedColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, `Night Visibility: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">+100%</font>`, (`Daytime Visibility: <font color="rgb({math.round(Attribute2.R * 255)}, {math.round(Attribute2.G * 255)}, {math.round(Attribute2.B * 255)})">-100%</font>`));

            return;
        end;

        if v119.Name == "Lightweight Padding" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Footstep Range: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">-25%</font>`));

            return;
        end;

        if v119.Name == "Resistant Rubber" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Radiation Resistance: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">+5%</font>`));

            return;
        end;

        if v119.Name == "Armor Polish" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Durability Damage: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">-25%</font>`));

            return;
        end;

        if v119.Name == "Steel Toes" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Fall Damage: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">-25%</font>`));

            return;
        end;

        if v119.Name == "Snorkle" then
            local Attribute = script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, (`Breathing Time: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">+150%</font>`));

            return;
        end;

        if v119.Name == "Water Filter" then
            script:GetAttribute("StatGreenColor");
            u115(p116, `Armor Mod Type: {v119.AttachmentType:upper()}`, "Salt Water Filtering: YES", "Water Heal Max Health: 60");

            return;
        end;

        local AttachmentStats = v119.AttachmentStats;

        if AttachmentStats then
            local v148 = {};

            for i, v in pairs(AttachmentStats) do
                local v149 = i == "ZoomLevel";

                if i ~= "GunRecoilAimMult" and (type(v) == "number" and (v ~= 0 and (i:sub(#i - 3) == "Mult" or v149))) then
                    local v150 = v149 and i and i or i:sub(1, #i - 4);
                    local v151 = v150 == "Sway" and "Aim Sway" or v150:gsub("(%u)", " %1"):gsub("^%s", "");
                    local v152 = v149 and NumberUtil:RoundNumber(v, 2) or math.round(v * 100);
                    local math_abs_ret = math.abs(v152);
                    local v153 = v152 < 0 == (v150 == "Damage" and true or v150 == "FireRate");

                    if v149 then
                        v153 = v152 < 1.2;
                    end;

                    local Attribute = script:GetAttribute(v153 and "StatRedColor" or "StatGreenColor");
                    local v154 = `{v151}: <font color="rgb({math.round(Attribute.R * 255)}, {math.round(Attribute.G * 255)}, {math.round(Attribute.B * 255)})">{(v149 and "" or (v152 < 0 and "-" or "+")) .. math_abs_ret .. (v149 and "x" or "%")}</font>`;
                    table.insert(v148, v154);
                end;
            end;

            u115(p116, unpack(v148));
        end;
    end;
end;

local u156 = 0;
local u157 = nil;

local function _(p158) -- Line: 733
    -- upvalues: PreferredInputController (copy), u157 (ref), u156 (ref)
    if PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
        return false;
    end;

    local v159 = tick();
    local v160;

    if p158 == u157 then
        v160 = v159 - u156 <= 0.3;
    else
        v160 = false;
    end;

    u156 = v160 and 0 or v159;
    u157 = p158;

    return v160;
end;

local function u174(u161, u162, u163, u164, u165) -- Line: 742
    -- upvalues: Mouse (copy), u33 (ref), PreferredInputController (copy), NumberUtil (copy), RunService (copy), u10 (ref), Drag (copy)
    local u166 = nil;
    local u167 = 0;
    local u168 = false;
    u161["MouseButton" .. u162 .. "Down"]:Connect(function() -- Line: 746
        -- upvalues: u167 (ref), u162 (copy), u166 (ref), Mouse (ref), u168 (ref), u33 (ref), PreferredInputController (ref), u161 (copy), NumberUtil (ref), u163 (copy), RunService (ref)
        u167 = u162;
        u166 = Vector2.new(Mouse.X, Mouse.Y);
        u168 = false;

        if not u33 then
            local v169 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

            if not v169 then
                while u167 > 0 and u161.Parent do
                    if not NumberUtil:IsWithin(u166, Vector2.new(Mouse.X, Mouse.Y), 5) then
                        if u163 then
                            local v170, v171 = u163(u168, u167);
                            u168 = v170;
                            u167 = v171;

                            return;
                        end;

                        break;
                    end;

                    RunService.RenderStepped:Wait();
                end;
            end;
        end;
    end);
    u161["MouseButton" .. u162 .. "Up"]:Connect(function() -- Line: 765
        -- upvalues: u33 (ref), u167 (ref), u165 (copy), u10 (ref), u162 (copy), u164 (copy), Drag (ref), RunService (ref), u168 (ref)
        if u33 then
            if u167 > 0 then
                local v172 = u167;
                u167 = 0;

                if u165 then
                    u165(v172);
                end;
            end;

            return;
        end;

        if not u10 or u10.Mouse ~= u162 then
            if u167 > 0 then
                local v173 = u167;
                u167 = 0;

                if u165 and not u168 then
                    u165(v173);
                end;
            end;

            return;
        end;

        if u164 then
            u164();
        end;

        Drag.Visible = false;
        RunService:UnbindFromRenderStep("Drag");
        u10 = nil;
    end);
end;

local function u179() -- Line: 794
    -- upvalues: u10 (ref), u3 (ref), UserInputService (copy), StateController (copy), u16 (ref)
    local Index = u10.Index;
    local v175 = u3[u10.Container];

    if v175 then
        local v176 = v175[Index];
        local v177 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not StateController:GetAttribute("IsSprint");
        local Mouse2 = u10.Mouse;
        local v178 = u10.IsActionMenu == true and u16;

        if not v178 then
            if Mouse2 == 1 and v177 then
                return 1;
            end;

            v178 = math.ceil(v176.Amount / (Mouse2 == 2 and v177 and 3 or Mouse2));
        end;

        return v178;
    end;
end;

local function QuickStackBackpackSlot(p180, p181) -- Line: 806
    -- upvalues: u9 (ref), u3 (ref), u80 (copy), u19 (ref)
    local Container = u9.Container;
    local v182 = u3[Container];

    if not v182 then
        return;
    end;

    local v183 = v182[u9.Index];

    if not v183 or v183 == 0 then
        return;
    end;

    local Container2 = v183.Container;
    local v184;

    if Container2 == nil then
        v184 = false;
    else
        v184 = Container2[p181];
    end;

    if not v184 or v184 == 0 then
        return;
    end;

    u80(p180, Container, u9.Index, u19, true, p181, v184);
end;

local function u219() -- Line: 819
    -- upvalues: u9 (ref), u3 (ref), Items (copy), ActionMenu (copy), SkinsModule (copy), u109 (copy), u31 (ref), Backpack (copy), u32 (copy), u18 (ref), PreferredInputController (copy), GuiService (copy), QuickStackBackpackSlot (copy), u174 (copy), u10 (ref), u63 (copy), u179 (copy), SoundModule (copy), u1 (copy), u157 (ref), u156 (ref), ViewportModule (copy), ViewportFrame (copy), u16 (ref), u155 (copy), ItemStats2 (copy), u86 (copy), u25 (copy), UserService (copy)
    if u9 then
        local Container = u9.Container;
        local v185 = u3[Container];

        if not v185 then
            return;
        end;

        local Index = u9.Index;
        local v186 = v185[Index];

        if not (v186 and (v186 ~= 0 and v186.Amount > 0)) then
            return;
        end;

        local v187 = Items[v186.ID];
        local Attachments = v186.Attachments;
        local Attachments2 = v187.Attachments;
        local Skin = v186.Skin;
        local v188 = v187.MaxAttachments or (1 / 0);
        local Image = v187.Image;
        local _ = v187.AmmoStats;
        local ConsumableStats = v187.ConsumableStats;
        local _ = v187.Resistances;
        local v189 = Image and (type(Image) == "table" and Image[Skin] or (Image or "")) or "";
        ActionMenu.Split.ItemImage.Image = v189;
        ActionMenu.ItemInfo.ItemImage.Image = v189;

        if Skin and Skin ~= "Default" then
            local v190 = "Common";
            local SkinInfo = SkinsModule:GetSkinInfo((`{v187.Name}/{Skin}`));

            if type(SkinInfo) == "table" then
                v190 = SkinInfo.Rarity or v190;
            end;

            for _, child in ActionMenu.Skin:GetChildren() do
                if child:IsA("UIGradient") then
                    child.Enabled = child.Name == v190;
                end;
            end;

            ActionMenu.Skin.Text = Skin;
        else
            ActionMenu.Skin.Text = "";
        end;

        for i = 1, 4 do
            local v191 = ActionMenu.ItemDetails["Slot" .. i];

            if Attachments2 then
                u109(v191, Attachments[i]);
            end;

            v191.Checker.Visible = (Attachments2 and (math.min(#Attachments2, v188) or 0) or 0) < i;
            v191.Visible = Attachments2 ~= nil;
            local _ = i;
        end;

        local Container2 = v186.Container;

        if Container2 then
            local v192 = false;

            for _, v in Container2 do
                if v and v ~= 0 then
                    v192 = true;
                    break;
                end;
            end;

            if v192 or (Container == "Armor" or Container == "Bench") then
                if u31 ~= #Container2 then
                    for i = 1, math.max(u31, #Container2) do
                        local v193 = `Slot{i}`;
                        local v194;

                        if i <= u31 then
                            v194 = Backpack[v193];
                        else
                            v194 = false;
                        end;

                        local v195;

                        if v194 or i > #Container2 then
                            if v194 and #Container2 < i then
                                v194:Destroy();
                                u32[v194] = nil;
                                v195 = i;
                            else
                                v195 = i;
                            end;
                        else
                            local v196 = Backpack.Slot1:Clone();
                            v196.Name = v193;
                            v196.Parent = Backpack;
                            v195 = i;
                        end;
                    end;

                    u31 = #Container2;
                end;

                for i, v in Container2 do
                    local u197 = Backpack[`Slot{i}`];
                    u109(u197, v);

                    if not u32[u197] then
                        u32[u197] = true;
                        u197.InputChanged:Connect(function(p198) -- Line: 894
                            -- upvalues: u18 (ref), u9 (ref), PreferredInputController (ref), GuiService (ref), u197 (copy), QuickStackBackpackSlot (ref), i (copy)
                            if p198.UserInputType ~= Enum.UserInputType.MouseMovement or not (u18 and u9) then
                                return;
                            end;

                            local v199 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

                            if v199 and GuiService.SelectedObject ~= u197 then
                                return;
                            end;

                            QuickStackBackpackSlot(u197, i);
                        end);
                        u197.MouseButton2Click:Connect(function() -- Line: 900
                            -- upvalues: QuickStackBackpackSlot (ref), u197 (copy), i (copy)
                            QuickStackBackpackSlot(u197, i);
                        end);
                        local u200 = i;

                        for i2 = 1, 2 do
                            u174(u197, i2, function(p201, p202) -- Line: 904
                                -- upvalues: u9 (ref), u3 (ref), u10 (ref), u200 (copy), u63 (ref), u197 (copy)
                                local Slot = u9.Slot;
                                local v203 = u3[u9.Container];

                                if v203 then
                                    local v204 = v203[u9.Index];

                                    if v204 and (v204 ~= 0 and (v204.Amount > 0 and not u10)) then
                                        local Container3 = v204.Container;
                                        local v205;

                                        if Container3 == nil then
                                            v205 = false;
                                        else
                                            v205 = Container3[u200];
                                        end;

                                        if v205 and v205 ~= 0 then
                                            p201 = u63(Slot, u197.ItemImage.Image, u9.Container, u9.Index, p202, nil, v205, u200);
                                        end;
                                    end;
                                end;

                                return p201, p202;
                            end, function() -- Line: 918
                                -- upvalues: u9 (ref), u10 (ref), u3 (ref), u179 (ref), SoundModule (ref), u1 (ref)
                                if u9 then
                                    local Container3 = u10.Container;
                                    local Index2 = u10.Index;
                                    local v206 = u3[Container3];

                                    if not v206 then
                                        return;
                                    end;

                                    local v207 = v206[Index2];
                                    local v208 = u179();

                                    if v207 and (v207 ~= 0 and v208 > 0) then
                                        SoundModule:PlayItemSound(v207.ID, "Drop");
                                    end;

                                    u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container3, Index2, v208, u9.Container, u9.Index);
                                end;
                            end, function() -- Line: 954
                                -- upvalues: u197 (copy), PreferredInputController (ref), u157 (ref), u156 (ref), QuickStackBackpackSlot (ref), u200 (copy)
                                local v209 = u197;
                                local v210;

                                if PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
                                    v210 = false;
                                else
                                    local v211 = tick();

                                    if v209 == u157 then
                                        v210 = v211 - u156 <= 0.3;
                                    else
                                        v210 = false;
                                    end;

                                    u156 = v210 and 0 or v211;
                                    u157 = v209;
                                end;

                                if v210 then
                                    QuickStackBackpackSlot(u197, u200);
                                end;
                            end);
                            local _ = i2;
                        end;
                    end;
                end;
            else
                Container2 = nil;
            end;
        end;

        local v212 = Container2 ~= nil;

        if Backpack.Visible ~= v212 then
            local v213;

            if v212 then
                v213 = CFrame.new(-2, 0, 0);
            else
                v213 = CFrame.new();
            end;

            ViewportModule:TweenCamera(ViewportFrame, v213);
        end;

        Backpack.Visible = v212;
        local DropInfo = v187.DropInfo;

        if v187.Type == "Gun" then
            ActionMenu.Actions.Action1.Label.Text = "UNLOAD AMMO";
        elseif v187.Type:find("Consumable") and (ConsumableStats and ConsumableStats.Instant) then
            ActionMenu.Actions.Action1.Label.Text = "EAT";
        elseif DropInfo then
            ActionMenu.Actions.Action1.Label.Text = DropInfo.ButtonName;
        end;

        local v214 = v187.Type == "Gun";
        local v215 = v187.Type:find("Consumable") ~= nil;
        ActionMenu.Actions.Action1.Visible = v214 or (v215 or DropInfo ~= nil);
        u16 = u16 or math.ceil(v186.Amount / 2);
        u155(ItemStats2, v186.ID, v187);
        u86();
        local v216 = "[ERR]";
        local v217 = "[ERR]";
        local Owner = v186.Owner;

        if Owner then
            local v218 = u25[Owner];

            if not v218 or tick() - v218.Called >= 600 then
                local success, result = pcall(function() -- Line: 997
                    -- upvalues: UserService (ref), Owner (copy)
                    return UserService:GetUserInfosByUserIdsAsync({ Owner });
                end);

                if success and (result and #result > 0) then
                    v218 = result[1];
                    v218.Called = tick();
                end;
            end;

            if v218 then
                u25[Owner] = v218;
                v216 = `{v218.DisplayName}{not v218.HasVerifiedBadge and "" or utf8.char(57344)}`;

                if v218.DisplayName == v218.Username then
                    v217 = `@{v216}`;
                else
                    v217 = `{v216}(@{v218.Username})`;
                end;
            end;
        end;

        if u9 and (u9.Container == Container and u9.Index == Index) then
            ActionMenu.ItemName.Text = string.format(v187.Name, v216);
            ActionMenu.ItemInfo.ItemDesc.Text = string.format(v187.Description, v217);
        end;
    end;
end;

u43 = function(p220, p221, p222) -- Line: 1018
    -- upvalues: u9 (ref), u3 (ref), SoundModule (copy), u219 (copy), u14 (ref), ActionMenu (copy), NumberUtil (copy), Size (copy), Backpack (copy), ViewportModule (copy), ViewportFrame (copy), u12 (ref), u83 (copy)
    local v223 = u9;

    if u9 and u9.Slot then
        u9.Slot.BackgroundColor3 = u9.Color;
    end;

    u9 = nil;

    if p220 and (not v223 or p220 ~= v223.Slot) then
        u9 = {
            Slot = p220,
            Container = p221,
            Index = p222,
            Color = p220.BackgroundColor3
        };
        p220.BackgroundColor3 = script:GetAttribute("SelectedSlotColor");
    end;

    local v224 = u9;

    if v224 ~= v223 then
        local v225 = v224 ~= nil;

        if v225 then
            local v226 = u3[v224.Container];

            if v226 then
                local v227 = v226[v224.Index];

                if v227 == nil or v227 == 0 then
                    v225 = false;
                else
                    v225 = v227.Amount > 0;
                end;

                if v225 then
                    SoundModule:PlayItemSound(v227.ID, "Drag");
                end;
            else
                v225 = false;
            end;
        end;

        u219();

        if u14 then
            ActionMenu.Size = NumberUtil:MultUDim2ByNum(Size, 1.3);
            u14 = false;
        end;

        ActionMenu:TweenSize(NumberUtil:MultUDim2ByNum(Size, v225 and 1 or 1.3), v225 and "Out" or "In", "Quart", 0.175, true);
        local v228 = tick();
        local v229 = v225 and 0 or 1;

        if not v225 then
            if Backpack.Visible then
                ViewportModule:TweenCamera(ViewportFrame, CFrame.new());
            end;

            Backpack.Visible = false;
        end;

        if u12 ~= v229 then
            u12 = v229;

            while true do
                local v230 = tick() - v228;
                local math_min_ret = math.min(v230 / 0.1, 1);

                if v225 then
                    math_min_ret = 1 - math_min_ret or math_min_ret;
                end;

                u83(math_min_ret);

                if v230 >= 0.1 then
                    break;
                end;

                task.wait(0.016666666666666666);
            end;
        end;
    end;
end;

local function u237(p231, p232) -- Line: 1083
    -- upvalues: u10 (ref), u179 (copy), workspace_CurrentCamera (copy), u3 (ref), SoundModule (copy), u1 (copy)
    local Container = u10.Container;
    local Index = u10.Index;
    local IsActionMenu = u10.IsActionMenu;
    local EditIndex = u10.EditIndex;
    local v233 = u179();
    local v234;

    if p231 == "Drop" then
        v234 = workspace_CurrentCamera.CFrame;
    else
        v234 = false;
    end;

    local v235 = v234 and u3[Container];

    if v235 then
        local v236 = v235[Index];

        if v236 and v236 ~= 0 then
            SoundModule:PlayItemSound(v236.ID, "Drop");
        end;
    end;

    if not (IsActionMenu and type(IsActionMenu) == "number" or EditIndex) then
        u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, v233, p231, p232, "none", "none", v234);

        return;
    end;

    if EditIndex then
        v233 = nil;
    end;

    u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, v233, p231, p232, EditIndex and "RemoveItem" or "RemoveAttachment", EditIndex or IsActionMenu, v234);
end;

local function v260(u238, u239, u240) -- Line: 1123
    -- upvalues: TweenUtil (copy), NumberUtil (copy), u18 (ref), PreferredInputController (copy), GuiService (copy), u80 (copy), u19 (ref), u174 (copy), u3 (ref), u10 (ref), u63 (copy), u43 (ref), SoundModule (copy), u237 (copy), u157 (ref), u156 (ref), u33 (ref), Drag (copy), RunService (copy)
    local u241 = TweenUtil:Tween(u238, "Size", NumberUtil:MultUDim2ByNum(u238.Size, 1.05), 0.04, "Quart", "Out", true);
    local u242 = TweenUtil:Tween(u238, "Size", u238.Size, 0.46, "Elastic", "Out", true);
    local Checker = u238:FindFirstChild("Checker");
    u238.MouseEnter:Connect(function() -- Line: 1128
        -- upvalues: Checker (copy), u241 (copy), u242 (copy)
        if Checker and Checker.Visible then
            return;
        end;

        u241:Play();
        wait(0.04);
        u242:Play();
    end);
    u238.InputChanged:Connect(function(p243) -- Line: 1134
        -- upvalues: u18 (ref), PreferredInputController (ref), GuiService (ref), u238 (copy), u80 (ref), u239 (copy), u240 (copy), u19 (ref)
        if p243.UserInputType ~= Enum.UserInputType.MouseMovement or not u18 then
            return;
        end;

        local v244 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v244 and GuiService.SelectedObject ~= u238 then
            return;
        end;

        u80(u238, u239, u240, u19, true);
    end);

    for i = 1, 2 do
        u174(u238, i, function(p245, p246) -- Line: 1141
            -- upvalues: u3 (ref), u239 (copy), u240 (copy), u10 (ref), u63 (ref), u238 (copy)
            local v247 = u3[u239];

            if v247 then
                local v248 = v247[u240];

                if v248 and (v248 ~= 0 and not u10) then
                    p245 = u63(u238, u238.ItemImage.Image, u239, u240, p246, nil, v248);
                end;
            end;

            return p245, p246;
        end, function() -- Line: 1150
            -- upvalues: u10 (ref), u238 (copy), u43 (ref), u239 (copy), u240 (copy), u80 (ref), u19 (ref), u3 (ref), SoundModule (ref), u237 (ref)
            if u10.Slot == u238 then
                if u10.Mouse == 1 then
                    task.spawn(u43, u238, u239, u240);

                    return;
                end;

                task.spawn(u80, u238, u239, u240, u19);

                return;
            end;

            local Index = u10.Index;
            local v249 = u3[u10.Container];

            if v249 then
                local v250 = v249[Index];

                if v250 and v250 ~= 0 then
                    SoundModule:PlayItemSound(v250.ID, "Drop");
                end;
            end;

            u237(u239, u240);
        end, function(p251) -- Line: 1172
            -- upvalues: u80 (ref), u238 (copy), u239 (copy), u240 (copy), u19 (ref), PreferredInputController (ref), u157 (ref), u156 (ref), u43 (ref), u33 (ref), u10 (ref), Drag (ref), RunService (ref), u3 (ref), SoundModule (ref), u237 (ref), u63 (ref)
            if p251 == 2 then
                u80(u238, u239, u240, u19);

                return;
            end;

            local v252 = u238;
            local v253;

            if PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" then
                v253 = false;
            else
                local v254 = tick();

                if v252 == u157 then
                    v253 = v254 - u156 <= 0.3;
                else
                    v253 = false;
                end;

                u156 = v253 and 0 or v254;
                u157 = v252;
            end;

            if v253 then
                u80(u238, u239, u240, u19);
                u43(nil);

                return;
            end;

            local v255 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

            if v255 and script:GetAttribute("Open") then
                if u33 and u10 then
                    if u10.Slot == u238 then
                        Drag.Visible = false;
                        RunService:UnbindFromRenderStep("Drag");
                        u10 = nil;
                    else
                        local Index = u10.Index;
                        local v256 = u3[u10.Container];

                        if v256 then
                            local v257 = v256[Index];

                            if v257 and v257 ~= 0 then
                                SoundModule:PlayItemSound(v257.ID, "Drop");
                            end;
                        end;

                        u237(u239, u240);
                    end;

                    Drag.Visible = false;
                    RunService:UnbindFromRenderStep("Drag");
                    u10 = nil;
                    u33 = false;

                    return;
                end;

                local v258 = u3[u239];

                if v258 then
                    local v259 = v258[u240];

                    if not (v259 and (v259 ~= 0 and (v259.Amount > 0 and not u10))) then
                        u43(u238, u239, u240);

                        return;
                    end;

                    u63(u238, u238.ItemImage.Image, u239, u240, 1, nil, v259);
                    u33 = true;
                end;
            else
                u43(u238, u239, u240);
            end;
        end);
        local _ = i;
    end;
end;

local function u265(u261, u262) -- Line: 1227
    -- upvalues: u10 (ref), ActionMenu (copy), Values (copy), u237 (copy), Drag (copy), RunService (copy)
    local u263 = 1;
    u261["MouseButton" .. 1 .. "Up"]:Connect(function() -- Line: 1229
        -- upvalues: u10 (ref), u263 (copy), u261 (copy), ActionMenu (ref), Values (ref), u262 (copy), u237 (ref), Drag (ref), RunService (ref)
        if not u10 or u10.Mouse ~= u263 then
            return;
        end;

        if u10.IsActionMenu and u261 == ActionMenu.Split then
            return;
        end;

        if Values.ClientDropping.Value and u262 then
            u237("Drop");
        end;

        Drag.Visible = false;
        RunService:UnbindFromRenderStep("Drag");
        u10 = nil;
    end);
    local u264 = 2;
    u261["MouseButton" .. 2 .. "Up"]:Connect(function() -- Line: 1229
        -- upvalues: u10 (ref), u264 (copy), u261 (copy), ActionMenu (ref), Values (ref), u262 (copy), u237 (ref), Drag (ref), RunService (ref)
        if not u10 or u10.Mouse ~= u264 then
            return;
        end;

        if u10.IsActionMenu and u261 == ActionMenu.Split then
            return;
        end;

        if Values.ClientDropping.Value and u262 then
            u237("Drop");
        end;

        Drag.Visible = false;
        RunService:UnbindFromRenderStep("Drag");
        u10 = nil;
    end);
end;

local function u266() -- Line: 1245
    -- upvalues: WheelController (copy), Humanoid (copy), u53 (copy)
    if not (WheelController:GetAttribute("Open") or Humanoid:GetAttribute("Downed")) then
        if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
            u53(script:GetAttribute("CurOpen") == "Crafting" and "Inventory" or "Crafting");
        end;
    end;
end;

local function u267() -- Line: 1240
    -- upvalues: WheelController (copy), Humanoid (copy), u53 (copy)
    if not (WheelController:GetAttribute("Open") or Humanoid:GetAttribute("Downed")) then
        if Humanoid and Humanoid.Parent and Humanoid.Health > 0 then
            u53(script:GetAttribute("CurOpen") == "None" and "Inventory" or "None");
        end;
    end;
end;

for _, v in { CraftingKeyboard, CraftingKeyboard2 } do
    v.Activated:Connect(function() -- Line: 1252
        -- upvalues: SettingsModule (copy), u266 (copy)
        if SettingsModule.MainMenuOpen() then
            return;
        end;

        u266();
    end);
end;

local function _() -- Line: 1258
    -- upvalues: u18 (ref)
    u18 = true;
end;

local function _() -- Line: 1262
    -- upvalues: u18 (ref)
    u18 = false;
end;

local function _() -- Line: 1266
    -- upvalues: u19 (ref)
    u19 = true;
end;

local function _() -- Line: 1270
    -- upvalues: u19 (ref)
    u19 = false;
end;

local function u269() -- Line: 1274
    -- upvalues: u3 (ref)
    local v268 = {};

    for i, v in pairs(u3) do
        if i == "Inventory" or i == "Toolbar" then
            for _, v2 in pairs(v) do
                if v2 and v2 ~= 0 then
                    local ID = v2.ID;
                    v268[ID] = (v268[ID] or 0) + v2.Amount;
                end;
            end;
        end;
    end;

    return v268;
end;

local function _() -- Line: 1288
    -- upvalues: u6 (copy), u17 (ref)
    local Bench = u6.Bench;

    if not (u17 and (u17.Parent and (Bench and (Bench.Parent and Bench.Name == "CraftingStation")))) then
        return;
    end;

    local Attribute = u17:GetAttribute("ID");

    if Attribute then
        return Bench, Attribute;
    end;
end;

local function u278(p270: userdata, p271: number, p272: any) -- Line: 1296
    -- upvalues: u6 (copy), u17 (ref), Items (copy), ResearchModule (copy), u4 (ref), u269 (copy), u26 (ref)
    if not (p270 and p271) then
        p270 = u6.Bench;

        if u17 and (u17.Parent and (p270 and (p270.Parent and p270.Name == "CraftingStation"))) then
            p271 = u17:GetAttribute("ID");

            if not p271 then
                p270 = nil;
                p271 = nil;
            end;
        else
            p270 = nil;
            p271 = nil;
        end;

        if not p270 then
            return;
        end;
    end;

    if not p272 then
        local v273 = Items[p271];

        if not v273 then
            return;
        end;

        local Name = v273.Name;
        local InfoFromName = ResearchModule:GetInfoFromName(Name);

        if not InfoFromName then
            return;
        end;

        p272 = InfoFromName.Tiers[(u4[Name] or 0) + 1];
    end;

    local v274 = p272 ~= nil;

    if p272 then
        local v275 = u269();

        for _, v in pairs(p272) do
            local ID = v.ID;
            local v276 = p270.UpgradeFrame.Items:FindFirstChild(ID);

            if v276 then
                local v277 = (v275[ID] or 0) >= v.Amount;
                v276.Grey.Visible = not v277;

                if not v277 then
                    v274 = false;
                end;
            end;
        end;
    end;

    if u26 and (v274 and not u26:IsToggled()) or v274 == false and u26:IsToggled() then
        task.defer(u26.ToggleButton, u26, v274);
    end;
end;

local function u292(p279: userdata, p280: number) -- Line: 1331
    -- upvalues: u6 (copy), u17 (ref), Items (copy), ResearchModule (copy), u4 (ref), NumberUtil (copy), u278 (copy)
    if not (p279 and p280) then
        p279 = u6.Bench;

        if u17 and (u17.Parent and (p279 and (p279.Parent and p279.Name == "CraftingStation"))) then
            p280 = u17:GetAttribute("ID");

            if not p280 then
                p279 = nil;
                p280 = nil;
            end;
        else
            p279 = nil;
            p280 = nil;
        end;

        if not p279 then
            return;
        end;
    end;

    local Items2 = p279.UnlocksFrame.Items;
    local Items3 = p279.UpgradeFrame.Items;

    for _, child in pairs(Items3:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    for _, child in pairs(Items2:GetChildren()) do
        if child.Name ~= "Template" then
            child:Destroy();
        end;
    end;

    p279.UnlocksFrame.Maxed.Visible = false;
    local v281 = Items[p280];

    if not v281 then
        return;
    end;

    local Name = v281.Name;
    local InfoFromName = ResearchModule:GetInfoFromName(Name);

    if not InfoFromName then
        return;
    end;

    local Tiers = InfoFromName.Tiers;
    local Unlocks = InfoFromName.Unlocks;
    local v282 = u4[Name] or 0;
    local v283 = #Tiers <= v282;
    p279.Item.Label.Image = type(v281.Image) == "table" and v281.Image.Default or v281.Image;
    p279.CurrentTier.Text = `Current Tier: <font color="rgb(255, 248, 41)">{v282}</font>`;
    p279.UpgradeTier.Text = `Upgrade Current Tier: <font color="rgb(255, 248, 41)">{v282 .. (v283 and " (MAX)" or "")}</font>` .. (v283 and "" or ` -> <font color="rgb(255, 248, 41)">{v282 + 1 .. (v282 + 1 == #Tiers and " (MAX)" or "")}</font>`);

    if v283 then
        p279.UnlocksFrame.Maxed.Visible = true;
        p279.UpgradeFrame.Free.Text = "N/A";

        return;
    end;

    local v284 = Tiers[v282 + 1];
    local v285 = Unlocks[v282 + 1] or {};
    local v286 = math.floor((#v285 - 1) / 4) * 0.42 + 0.4;
    local math_max_ret = math.max(v286, 1);
    Items2.CanvasSize = UDim2.new(0, 0, math_max_ret * 0.76 - 0.001, 0);
    local Template = Items2.Template;
    Template.Size = UDim2.new(0.24, 0, 0.4 / math_max_ret, 0);
    local v287 = -1;

    for _, v in pairs(v285) do
        v287 = v287 + 1;
        local v288 = Items[v.ID];
        local u289 = Template:Clone();
        u289.Name = "Slot" .. v287 + 1;
        u289.ItemImage.Image = type(v288.Image) == "table" and v288.Image.Default or v288.Image;
        u289.ItemName.Text = v288.Name;
        u289.Position = UDim2.new(v287 % 4 * 0.25, 0, math.floor(v287 / 4) * 0.42 / math_max_ret, 0);
        u289.Parent = Items2;
        u289.MouseEnter:Connect(function() -- Line: 1381
            -- upvalues: u289 (copy)
            u289.ItemName:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.4, true);
        end);
        u289.MouseLeave:Connect(function() -- Line: 1384
            -- upvalues: u289 (copy)
            u289.ItemName:TweenPosition(UDim2.new(0.5, 0, -0.26, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quart, 0.15, true);
        end);
        u289.Visible = true;
    end;

    for _, v in pairs(v284) do
        local v290 = Items[v.ID];
        local v291 = Items3.Layout.Template:Clone();
        v291.Name = tostring(v.ID);
        v291.ItemImage.Image = type(v290.Image) == "table" and v290.Image.Default or v290.Image;
        v291.ItemName.Text = v290.Name;
        v291.ItemAmount.Text = "x" .. NumberUtil:FormatNumber(v.Amount);
        v291.Parent = Items3;
    end;

    p279.UpgradeFrame.Free.Text = #v284 <= 0 and "FREE" or "";
    u278(p279, p280, v284);
end;

local u293 = {};
local u294 = nil;

local function u316(u295: userdata) -- Line: 1406
    -- upvalues: u3 (ref), u294 (ref), u293 (ref), Items (copy), u5 (ref), ButtonClass (copy), u28 (ref), u1 (copy), u17 (ref), RecipeModule (copy), ResearchModule (copy), u4 (ref), u269 (copy), NumberUtil (copy), u27 (ref)
    local Bench = u3.Bench;

    if not (Bench and (u295 and u295.Parent)) then
        return;
    end;

    local v296 = Bench[1];
    local v297 = v296 == 0 and 0 or v296.ID;
    local v298 = u294 == v297;
    u294 = v297;
    local Items2 = u295.CostFrame.Items;
    local Items3 = u295.SkinsFrame.Items;

    if not v298 then
        for _, child in pairs(Items2:GetChildren()) do
            if child:IsA("ImageButton") then
                child:Destroy();
            end;
        end;

        for i, v in pairs(u293) do
            v:Destroy();

            if i.Parent then
                i:Destroy();
            end;
        end;

        u293 = {};
    end;

    local v299 = false;
    u295.DetailExtra.Text = "";

    if type(v296) == "table" then
        local v300 = Items[v297];
        local Image = v300.Image;

        if type(Image) == "table" then
            if not v298 then
                local v301 = {};

                for i, _ in pairs(Image) do
                    local table_find_ret = table.find(u5 or {}, v300.Name .. "/" .. i);

                    if i ~= "Default" and table_find_ret then
                        table.insert(v301, i);
                    end;
                end;

                table.insert(v301, "Default");
                local v302 = math.floor((#v301 - 1) / 4) * 0.42 + 0.4;
                local math_max_ret = math.max(v302, 1);
                Items3.CanvasSize = UDim2.new(0, 0, math_max_ret * 0.76 - 0.001, 0);
                local Template = Items3.Template;
                Template.Size = UDim2.new(0.24, 0, 0.4 / math_max_ret, 0);
                local v303 = -1;

                for _, v in pairs(v301) do
                    v303 = v303 + 1;
                    local v304 = Template:Clone();
                    v304.Name = "Skin" .. v;
                    v304.ItemImage.Image = Image[v];
                    v304.ItemName.Text = v;
                    v304.Position = UDim2.new(v303 % 4 * 0.25 + 0.12, 0, (math.floor(v303 / 4) * 0.42 + 0.2) / math_max_ret, 0);
                    v304.Parent = Items3;
                    u293[v304] = ButtonClass.new(v304, "BackgroundColor3", function() -- Line: 1462
                        -- upvalues: u3 (ref), u295 (copy), u28 (ref), v (copy), u1 (ref), u17 (ref)
                        local Bench2 = u3.Bench;

                        if not (Bench2 and u295.Visible) then
                            return;
                        end;

                        local v305 = Bench2[1];

                        if tick() - u28 < 0.4 or not (v305 and (v305 ~= 0 and (v305.Amount > 0 and v305.Skin ~= v))) then
                            return;
                        end;

                        u28 = tick();
                        u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "Repair2", v);
                    end, 1.3, script:GetAttribute("SelectedSlotColor"));
                    v304.Visible = true;
                end;
            end;

            for i, v in pairs(u293) do
                local v306 = i.Name:sub(5);

                if v296.Skin == v306 and not v:IsToggled() then
                    task.defer(v.ToggleButton, v, true);
                elseif v296.Skin ~= v306 and v:IsToggled() then
                    task.defer(v.ToggleButton, v, false);
                end;
            end;

            u295.SkinsFrame.Visible = true;
        else
            u295.SkinsFrame.Visible = false;
        end;

        local v307 = (RecipeModule:GetRecipesForItem(v297) or {})[1];

        if v307 and (v296.Repair < 1 and v300.MaxDurability) then
            local BenchNeeded = v307.BenchNeeded;
            local TierNeeded = v307.TierNeeded;
            local v308 = 0.5;

            if (TierNeeded or 0) > 0 then
                local InfoFromName = ResearchModule:GetInfoFromName(BenchNeeded);

                if InfoFromName then
                    local _ = #InfoFromName.Tiers;
                    local v309 = TierNeeded - (u4[BenchNeeded] or 0);
                    v308 = v309 <= 0 and 0.5 or v309;

                    if v309 > 4 then
                        u295.CostFrame.Extra.Text = `Level {math.max(TierNeeded - 4, 0)} {BenchNeeded} or higher required.`;
                        v308 = nil;
                    elseif v308 > 0.5 then
                        u295.DetailExtra.Text = `<font color="rgb(255, 66, 69)">{math.round(v308 / 0.5)}X COST PENALTY</font> (<font color="rgb(0, 157, 255)">{v309}</font> more <font color="rgb(255, 248, 41)">{BenchNeeded}</font> tiers needed for no penalty)`;
                    end;
                end;
            end;

            if v308 then
                local v310 = RecipeModule:CalculateTotalCost(v307, v308, v307.SplitComponentOverride or { 24 }, v307.RepairOverride or { 6, 68, 179 });

                if not v298 then
                    for i, v in pairs(v310) do
                        local v311 = Items[v.ID];
                        local v312 = Items2.Layout.Template:Clone();
                        v312.Name = "Slot" .. i;
                        v312.ItemImage.Image = type(v311.Image) == "table" and v311.Image.Default or v311.Image;
                        v312.ItemName.Text = v311.Name;
                        v312.Parent = Items2;
                    end;
                end;

                local v313 = u269();
                v299 = true;

                for i, v in pairs(v310) do
                    local v314 = Items2:FindFirstChild("Slot" .. i);

                    if v314 then
                        v314.ItemAmount.Text = "x" .. NumberUtil:FormatNumber((math.ceil(v.Amount)));
                        local v315 = (v313[v.ID] or 0) < math.ceil(v.Amount);
                        v314.Grey.Visible = v315;

                        if v315 then
                            v299 = false;
                        end;
                    end;
                end;

                if v299 and v296.Durability >= (v300.MaxDurability or 0) * (1 - v296.Repair) - 0.01 then
                    v299 = false;
                end;

                u295.CostFrame.Extra.Text = "";
            end;
        else
            u295.CostFrame.Extra.Text = "Item unavailable for repairing.";
        end;
    else
        u295.SkinsFrame.Visible = false;
        u295.CostFrame.Extra.Text = "Insert an item into the slot to Repair.";
    end;

    if not u27 then
        return;
    end;

    if v299 and not u27:IsToggled() then
        task.defer(u27.ToggleButton, u27, true);

        return;
    end;

    if not v299 and u27:IsToggled() then
        task.defer(u27.ToggleButton, u27, false);
    end;
end;

UserInputService.InputBegan:Connect(function(p317, p318) -- Line: 1555
    -- upvalues: SettingsModule (copy), UserInputService (copy), u267 (copy), u266 (copy), u18 (ref), u19 (ref), TeamNavigationController (copy), WheelController (copy), Humanoid (copy), InteractController (copy), u53 (copy), u33 (ref), u9 (ref), ActionMenu (copy), Mouse (copy), u3 (ref), u10 (ref), u63 (copy), u34 (ref), u42 (copy), Values (copy), u237 (copy), Drag (copy), RunService (copy), u1 (copy), workspace_CurrentCamera (copy), u43 (ref)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    local UserInputType = p317.UserInputType;
    local FocusedTextBox = UserInputService:GetFocusedTextBox();

    if UserInputType == Enum.UserInputType.Keyboard and not FocusedTextBox then
        local Name = p317.KeyCode.Name;

        if Name == SettingsModule.GetSetting("Controls", "Open Inventory") then
            u267();

            return;
        end;

        if Name == SettingsModule.GetSetting("Controls", "Open Crafting") then
            u266();

            return;
        end;

        if Name == SettingsModule.GetSetting("Controls", "Quick Loot") and not p318 then
            u18 = true;

            return;
        end;

        if Name == "LeftShift" then
            u19 = true;
        end;
    elseif UserInputType == Enum.UserInputType.Gamepad1 then
        if TeamNavigationController:GetAttribute("MapOpen") then
            return;
        end;

        local Name = p317.KeyCode.Name;
        local Attribute = script:GetAttribute("Open");
        local Attribute2 = script:GetAttribute("CurOpen");

        if Name == SettingsModule.GetSetting("Gamepad", "Open Inventory/Crafting") then
            if WheelController:GetAttribute("Open") or Humanoid:GetAttribute("Downed") then
                return;
            end;

            if not (Humanoid and Humanoid.Parent and Humanoid.Health > 0) or InteractController:GetAttribute("Dialog") then
                return;
            end;

            if not Attribute then
                u53("Inventory");

                return;
            end;

            if Attribute2 == "Inventory" then
                u53("Crafting");

                return;
            end;

            if Attribute2 == "Crafting" then
                u53("Inventory");
            end;
        else
            if Name == "ButtonB" and Attribute then
                u53("None");

                return;
            end;

            if Name == SettingsModule.GetSetting("Gamepad", "Jump") and (Attribute and (not u33 and (u9 and ActionMenu.Visible))) then
                local Split = ActionMenu.Split;
                local AbsolutePosition = Split.AbsolutePosition;
                local AbsoluteSize = Split.AbsoluteSize;
                local v319 = Split.Visible and (Mouse.X >= AbsolutePosition.X and (Mouse.X <= AbsolutePosition.X + AbsoluteSize.X and (Mouse.Y >= AbsolutePosition.Y and (Mouse.Y <= AbsolutePosition.Y + AbsoluteSize.Y and u3[u9.Container]))));

                if v319 then
                    local v320 = v319[u9.Index];

                    if v320 and v320 ~= 0 then
                        if not u10 then
                            u63(u9.Slot, u9.Slot.ItemImage.Image, u9.Container, u9.Index, 1, true, v320);
                        end;

                        u33 = true;
                        u34 = true;
                    end;
                end;
            elseif Name == SettingsModule.GetSetting("Gamepad", "Jump") and (Attribute and (u33 and u10)) then
                if not u42() then
                    if Values.ClientDropping.Value then
                        u237("Drop");
                    end;

                    Drag.Visible = false;
                    RunService:UnbindFromRenderStep("Drag");
                    u10 = nil;
                    u33 = false;
                end;
            elseif Name == SettingsModule.GetSetting("Gamepad", "Interact/Reload") and Attribute then
                if u33 and u10 then
                    Drag.Visible = false;
                    RunService:UnbindFromRenderStep("Drag");
                    u10 = nil;
                    u33 = false;

                    return;
                end;

                local v321, v322, v323 = u42();

                if v321 then
                    if not (u9 and (u9.Slot == v321 and Values.ClientDropping.Value)) then
                        u43(v321, v322, v323);

                        return;
                    end;

                    local Container = u9.Container;
                    local Index = u9.Index;
                    local v324 = u3[Container];

                    if v324 then
                        local v325 = v324[Index];

                        if v325 and (v325 ~= 0 and v325.Amount > 0) then
                            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, nil, "Drop", "none", "none", "none", workspace_CurrentCamera.CFrame);
                        end;
                    end;
                elseif u9 then
                    u43(nil);
                end;
            elseif Name == "ButtonR2" and Attribute then
                u18 = true;
            end;
        end;
    end;
end);
UserInputService.InputEnded:Connect(function(p326, p327) -- Line: 1653
    -- upvalues: UserInputService (copy), u15 (ref), u33 (ref), u10 (ref), u34 (ref), u42 (copy), Values (copy), u237 (copy), Drag (copy), RunService (copy), SettingsModule (copy), u18 (ref), u19 (ref)
    local UserInputType = p326.UserInputType;
    local FocusedTextBox = UserInputService:GetFocusedTextBox();

    if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
        u15 = false;

        if u33 and u10 then
            if u34 then
                u34 = false;

                return;
            end;

            if not u42() then
                if Values.ClientDropping.Value then
                    u237("Drop");
                end;

                Drag.Visible = false;
                RunService:UnbindFromRenderStep("Drag");
                u10 = nil;
                u33 = false;
            end;
        elseif u10 and (u10.Mouse == 1 and not p327) then
            if Values.ClientDropping.Value then
                u237("Drop");
            end;

            Drag.Visible = false;
            RunService:UnbindFromRenderStep("Drag");
            u10 = nil;
        end;
    else
        if UserInputType == Enum.UserInputType.MouseButton2 and (u10 and (u10.Mouse == 2 and not p327)) then
            if Values.ClientDropping.Value then
                u237("Drop");
            end;

            Drag.Visible = false;
            RunService:UnbindFromRenderStep("Drag");
            u10 = nil;

            return;
        end;

        if UserInputType == Enum.UserInputType.Keyboard and not FocusedTextBox then
            local Name = p326.KeyCode.Name;

            if Name == SettingsModule.GetSetting("Controls", "Quick Loot") then
                u18 = false;

                return;
            end;

            if Name == "LeftShift" then
                u19 = false;
            end;
        elseif UserInputType == Enum.UserInputType.Gamepad1 then
            local Name = p326.KeyCode.Name;
            local Attribute = script:GetAttribute("Open");

            if Name == SettingsModule.GetSetting("Gamepad", "Jump") and Attribute then
                u15 = false;

                return;
            end;

            if Name == "ButtonR2" and Attribute then
                u18 = false;
            end;
        end;
    end;
end);
ViewmodelController.AttributeChanged:Connect(function(p328) -- Line: 1709
    -- upvalues: ViewmodelController (copy), u109 (copy), Toolbar (copy), u3 (ref)
    if p328 ~= "LocalAmmo" then
        return;
    end;

    local Attribute = ViewmodelController:GetAttribute("Equipped");

    if Attribute <= 0 then
        return;
    end;

    u109(Toolbar["Slot" .. Attribute], u3.Toolbar[Attribute], ViewmodelController:GetAttribute("LocalAmmo"));
end);
Humanoid.Died:Connect(function() -- Line: 1716
    -- upvalues: ItemSearchModule (copy), Drag (copy), RunService (copy), u10 (ref), ViewportModule (copy), ViewportFrame (copy), WheelController (copy), u53 (copy)
    ItemSearchModule.CancelSearch(true);
    Drag.Visible = false;
    RunService:UnbindFromRenderStep("Drag");
    u10 = nil;
    ViewportModule:ClearViewport(ViewportFrame);
    WheelController:SetAttribute("Open", false);
    u53("None", true);
end);
Humanoid:GetAttributeChangedSignal("Downed"):Connect(function() -- Line: 1724
    -- upvalues: Humanoid (copy), WheelController (copy), u53 (copy)
    if not Humanoid:GetAttribute("Downed") then
        return;
    end;

    WheelController:SetAttribute("Open", false);
    u53("None", true);
end);
PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(function() -- Line: 1730
    -- upvalues: PreferredInputController (copy), CraftingKeyboard (copy), CraftingConsole (copy), CraftingKeyboard2 (copy), CraftingConsole2 (copy), ImageLabel (copy), GamepadService (copy)
    local v329 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";
    CraftingKeyboard.Visible = not v329;
    CraftingConsole.Visible = v329;
    CraftingKeyboard2.Visible = not v329;
    CraftingConsole2.Visible = v329;
    ImageLabel.Visible = v329;

    if not script:GetAttribute("Open") then
        return;
    end;

    if v329 then
        pcall(function() -- Line: 1739
            -- upvalues: GamepadService (ref)
            GamepadService:EnableGamepadCursor(nil);
        end);

        return;
    end;

    pcall(function() -- Line: 1741
        -- upvalues: GamepadService (ref)
        GamepadService:DisableGamepadCursor();
    end);
end);
u265(HitboxHead, false);
u265(HitboxChest, false);
u265(HitboxLegs, false);

for _, child in Stats:GetChildren() do
    if child:IsA("ImageButton") or child:IsA("TextButton") then
        u265(child, false);
    end;
end;

Stats.ChildAdded:Connect(function(p330) -- Line: 1752
    -- upvalues: u265 (copy)
    if not (p330:IsA("ImageButton") or p330:IsA("TextButton")) then
        return;
    end;

    u265(p330, false);
end);

for _, child in Team:GetChildren() do
    if child:IsA("ImageButton") or child:IsA("TextButton") then
        u265(child, false);
    end;
end;

local function u333() -- Line: 1764
    -- upvalues: u3 (ref)
    local v331 = 0;
    local v332 = 0;

    for _, v in u3.Armor or {} do
        if type(v) == "table" and type(v.Container) == "table" then
            v332 = #v.Container;

            for _, v2 in v.Container do
                if v2 and v2 ~= 0 then
                    v331 = v331 + 1;
                end;
            end;

            break;
        end;
    end;

    if v332 == 0 and type(u3.Inventory) == "table" then
        v332 = #u3.Inventory;

        for _, v in u3.Inventory do
            if v and v ~= 0 then
                v331 = v331 + 1;
            end;
        end;
    end;

    script:SetAttribute("BackpackUsed", v331);
    script:SetAttribute("BackpackSize", v332);
end;

ClientSignals:WaitForChild("Inventory").OnClientEvent:Connect(function(...) -- Line: 1784
    -- upvalues: u17 (ref), Benches (copy), u26 (ref), ButtonClass (copy), u28 (ref), u1 (copy), u292 (copy), u29 (ref), Values (copy), u109 (copy), SoundModule (copy), u6 (copy), u3 (ref), u27 (ref), u53 (copy), u22 (copy), u23 (ref), u24 (ref), NumberUtil (copy), u4 (ref), TweenUtil (copy), ViewmodelController (copy), u9 (ref), u43 (ref), u219 (copy), u316 (copy), CraftingController (copy), u278 (copy), ViewportModule (copy), ViewportFrame (copy), u10 (ref), Drag (copy), RunService (copy), ActiveBenchModule (copy), ItemClass (copy), u333 (copy)
    local v334 = false;
    local v335 = false;
    local v336 = false;
    local v337 = false;
    local v338 = false;
    local v339 = false;

    for _, v in pairs({ ... }) do
        if type(v) == "table" then
            local v340 = v[1];

            if v340 then
                local v341 = v[2];
                local v342 = v[3];
                local v343 = v[4];
                local v344 = u3[v340];
                local v345 = u6[v340];

                if v344 and v345 then
                    if v343 == "LocalAmmo" and v342.Ammo then
                        ViewmodelController:SetAttribute("LocalAmmo", v342.Ammo.Amount);
                    end;

                    local v346 = (v345:FindFirstChild("Inv") or v345):FindFirstChild("Slot" .. v341);
                    local v347 = v344[v341];

                    if u9 and (u9.Slot == v346 and (v347 ~= 0 and (v342 == 0 or v347.ID ~= v342.ID))) then
                        task.defer(u43);
                    end;

                    if v334 == false and (v340 == "Inventory" or v340 == "Toolbar") and (v342 and v347) then
                        v334 = (v342 == 0 and 0 or v342.ID) ~= (v347 == 0 and 0 or v347.ID) and true or ((v342 == 0 and 0 or v342.Amount) ~= (v347 == 0 and 0 or v347.Amount) and true or v334);
                    end;

                    v344[v341] = v342;

                    if u9 and u9.Slot == v346 then
                        u219();
                    end;

                    if v346 then
                        u109(v346, v342, nil, v335);
                    end;

                    v339 = v340 == "Armor" and true or v339;

                    if v340 == "Bench" and v345.Name == "RepairTable" then
                        u316(v345);
                        v338 = true;
                    end;
                end;
            else
                local Bench = u6.Bench;

                if Bench then
                    local Upkeep = v.Upkeep;
                    local UpkeepTick = v.UpkeepTick;
                    local RL = v.RL;
                    local Offers = v.Offers;
                    local MaxPower = v.MaxPower;
                    local CurrentPower = v.CurrentPower;

                    if v.On == nil then
                        if Upkeep and UpkeepTick then
                            local C = Bench:FindFirstChild("C");

                            if C then
                                local ProtectionFrame = Bench:FindFirstChild("ProtectionFrame");

                                if ProtectionFrame then
                                    for _, child in pairs(Bench:GetChildren()) do
                                        if child.Name:sub(1, 4) == "Cost" and child:IsA("ImageButton") then
                                            child:Destroy();
                                        end;
                                    end;

                                    for i, v2 in pairs(Upkeep) do
                                        local v348 = C:Clone();
                                        v348.Position = UDim2.new(0.5 - (#Upkeep - 1) * 0.1 + (i - 1) * 0.2, 0, 0.711, 0);
                                        v348.Name = "Cost" .. i;
                                        v348.Parent = Bench;
                                        u109(v348, v2);
                                        v348.Visible = true;
                                    end;

                                    u23 = UpkeepTick;

                                    if not u24 then
                                        u24 = true;
                                        Values.ServerTick.Changed:Connect(function() -- Line: 1907
                                            -- upvalues: u23 (ref), Values (ref), ProtectionFrame (copy), NumberUtil (ref)
                                            local math_max_ret = math.max(u23 - Values.ServerTick.Value, 0);

                                            if not (ProtectionFrame and ProtectionFrame.Parent) then
                                                return;
                                            end;

                                            ProtectionFrame.Timer.TextColor3 = ProtectionFrame.Timer:GetAttribute(math_max_ret > 0 and "Protected" or "Decaying");
                                            ProtectionFrame.Timer.Text = math_max_ret > 0 and NumberUtil:FormatTime(math_max_ret, "Days", "Minutes", true) or "Base is Decaying!";
                                        end);
                                    end;
                                end;
                            end;
                        elseif RL then
                            u4 = v.RL;
                            v337 = true;
                        elseif type(Offers) == "table" and not v336 then
                            v336 = Offers;
                        elseif type(v.ShpAnim) == "number" and (u6.Bench and u6.Bench.Name == "TradingPost") then
                            local v349 = u6.Bench:FindFirstChild("Trade" .. v.ShpAnim);

                            if v349 then
                                v349.Arrow.Rotation = 0;
                                TweenUtil:Tween(v349.Arrow, "Rotation", 360, 0.5, "Quart", "InOut");
                            end;
                        elseif CurrentPower and (u6.Bench and u6.Bench.Name == "Battery") then
                            local Bar = u6.Bench.Bar;
                            u6.Bench.PowerLabel.Text = CurrentPower .. "kw / " .. MaxPower .. "kw";
                            Bar.Fill.Size = UDim2.new(CurrentPower / MaxPower, 0, 1, 0);
                        end;
                    else
                        local ControlFrame = Bench:FindFirstChild("ControlFrame");

                        if ControlFrame then
                            local Toggle2 = ControlFrame:FindFirstChild("Toggle");

                            if Toggle2 then
                                local v350 = u22[Toggle2];

                                if v350 then
                                    Toggle2.Label.Text = v.On and "Turn Off" or "Turn On";
                                    v350:ToggleButton(v.On);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        elseif v == "IgnoreVMUpdate" then
            v335 = true;
        elseif typeof(v) == "Instance" then
            u17 = v;
        elseif type(v) == "string" and v:sub(1, 5) == "Bench" then
            local v351 = Benches:FindFirstChild(v:sub(6));

            if not v351 then
                return;
            end;

            for _, child in pairs(Benches:GetChildren()) do
                child.Visible = child == v351;

                if child == v351 and child:FindFirstChild("BenchName") then
                    local v352 = child:FindFirstChild("Inv") or child;
                    local Name = u17.Name;
                    local NameTag = u17:FindFirstChild("NameTag");
                    local v353 = Name == "Sleeper";
                    child.BenchName.Text = u17:GetAttribute("BenchName") or Name == "Body Bag" and "CORPSE OF <b>" .. (u17:GetAttribute("OwnerName") or "[ERR]") .. "</b>" or (v353 and `INVENTORY OF <b>{NameTag and NameTag.Label.Text or "[ERR]"}</b>` or Name:upper());

                    if child.Name == "BodyLoot" then
                        child.BenchName.Position = UDim2.new(v353 and 0.808 or 0.858, 0, 0.36, 0);
                    elseif child.Name == "CraftingStation" then
                        if not u26 then
                            u26 = ButtonClass.new(child.UpgradeFrame.Upgrade, "BackgroundColor3", function() -- Line: 1816
                                -- upvalues: u28 (ref), u17 (ref), u1 (ref)
                                if tick() - u28 < 0.5 or not (u17 and u17.Parent) then
                                    return;
                                end;

                                u28 = tick();
                                u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "Upgrade");
                            end, 1.3, Color3.fromRGB(89, 148, 64));
                        end;

                        u292(child, u17:GetAttribute("ID"));
                    elseif child.Name == "Plinko" then
                        u29 = u17:GetAttribute("PlinkoIndex");
                        child.Timer.Text = Values["PlinkoTimer" .. u29].Value .. "s";
                    end;

                    for _, child2 in pairs(v352:GetChildren()) do
                        if child2.Name:sub(1, 4) == "Slot" and child2:IsA("ImageButton") then
                            u109(child2, 0);
                            local Checker = child2:FindFirstChild("Checker");

                            if Checker then
                                Checker.Visible = true;
                            end;
                        end;
                    end;
                end;
            end;

            SoundModule:PlayBenchSound(u17.Name, v351 and v351.Name == "TradingPost" and "Open2" or "Open", u17:GetAttribute("Skin"));
            u6.Bench = v351;
            local v354 = v351:FindFirstChild("Inv") or v351;
            local v355 = {};

            for _, child in pairs(v354:GetChildren()) do
                if child.Name:sub(1, 4) == "Slot" then
                    table.insert(v355, 0);
                end;
            end;

            u3.Bench = v355;

            if v351.Name == "RepairTable" and not u27 then
                u27 = ButtonClass.new(v351.CostFrame.Repair, "BackgroundColor3", function() -- Line: 1851
                    -- upvalues: u17 (ref), u28 (ref), u27 (ref), u1 (ref)
                    if not (u17 and (u17.Parent and (tick() - u28 >= 0.4 and u27:IsToggled()))) then
                        return;
                    end;

                    u28 = tick();
                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "Repair1");
                end, 1.3, Color3.fromRGB(89, 148, 64));
            end;

            u53("Inventory");
        end;
    end;

    if v337 then
        CraftingController.Update:Fire("Research");
        u292();
    elseif v334 then
        u278();
        CraftingController.Update:Fire();
        local Bench = u6.Bench;

        if Bench and (Bench.Parent and (Bench.Name == "RepairTable" and not v338)) then
            u316(Bench);
        end;
    end;

    if v339 then
        ViewportModule:UpdateArmors(ViewportFrame, u3.Armor);
    end;

    if u10 then
        local v356 = u3[u10.Container];

        if v356 then
            if v356[u10.Index] == 0 then
                Drag.Visible = false;
                RunService:UnbindFromRenderStep("Drag");
                u10 = nil;
            end;
        elseif u10.Container == "Bench" then
            Drag.Visible = false;
            RunService:UnbindFromRenderStep("Drag");
            u10 = nil;
        end;
    end;

    if v336 and (u6.Bench and (u6.Bench.Name == "TradingPost" and (u3.Bench and (u17 and u17.Parent)))) then
        local ClientInfo = ActiveBenchModule.GetClientInfo(u17);
        local v357;

        if type(ClientInfo) == "table" then
            v357 = ClientInfo.CanEdit == true;
        else
            v357 = false;
        end;

        local Bench = u6.Bench;
        local v358 = 1;
        local v359 = 2;

        for i = 1, 5 do
            local v360 = Bench[`Give{i}`];
            local v361 = Bench[`Receive{i}`];
            local v362 = u22[Bench[`Trade{i}`]];
            local v363 = u22[v360];
            local v364 = u22[v361];
            local v365 = v336[v358];
            local v366 = v336[v359];
            local v367 = (type(v365) ~= "table" or (v365[1] == 0 or v365[2] < 0)) and 0 or ItemClass.new(v365[1], v365[2]);
            local v368, v369, v370;

            if type(v366) == "table" and (v366[1] ~= 0 and v366[2] > 0) then
                if u17:GetAttribute("ShopOnly") then
                    v368 = ItemClass.new(v366[1], v366[2]);
                    v369 = i;
                    v370 = true;
                else
                    v369 = i;
                    local v371 = 0;
                    local v372 = nil;

                    for _, v in pairs(u3.Bench) do
                        if v ~= 0 and v.ID == v366[1] then
                            v371 = v371 + v.Amount;

                            if not v372 then
                                v372 = v;
                            end;
                        end;
                    end;

                    if v372 then
                        v368 = table.clone(v372);
                        v368.Amount = v366[2];
                    else
                        v368 = ItemClass.new(v366[1], v366[2]);
                    end;

                    if v366[2] <= v371 then
                        v370 = type(v367) == "table";
                    else
                        v370 = false;
                    end;
                end;
            else
                v369 = i;
                v368 = 0;
                v370 = false;
            end;

            if v363 then
                v363:Enable(v357);
            end;

            if v364 then
                v364:Enable(v357);
            end;

            if v362 and (not v370 and v362:IsToggled()) or v370 and not v362:IsToggled() then
                task.defer(v362.ToggleButton, v362, v370);
            end;

            u109(v360, v367);

            if type(v367) == "table" then
                v360.ItemAmount.Text = `x{NumberUtil:FormatNumber(v367.Amount)}`;
            end;

            u109(v361, v368);

            if type(v368) == "table" then
                v361.ItemAmount.Text = `x{NumberUtil:FormatNumber(v368.Amount)}`;
            end;

            v358 = v358 + 2;
            v359 = v359 + 2;
        end;
    end;

    u333();
end);
u1("Setup", "\239\191\189\057\195\183\239\191\189\239\191\189\239\191\189\239\191\189\071\239\191\189\239\191\189\239\191\189\194\167\239\191\189\239\191\189\038\239\191\189\106\239\191\189\239\191\189\239\191\189", "\239\191\189\194\168\076\239\191\189\121\239\191\189\102\195\128\195\182\086\078\239\191\189\090\195\130\239\191\189\045\081\239\191\189\070\239\191\189", function(p373, ...) -- Line: 2090
    -- upvalues: u6 (copy), u44 (copy)
    local v374 = { ... };

    if p373 == "Close" then
        local Bench = u6.Bench;

        if not Bench or Bench.Name ~= v374[1] then
            return;
        end;

        u44();
    end;
end);

function Fetch.OnInvoke() -- Line: 2102
    -- upvalues: u3 (ref), u4 (ref), u5 (ref)
    return u3, u4, u5;
end;

function GetBench.OnInvoke() -- Line: 2108
    -- upvalues: u17 (ref)
    return u17;
end;

ItemStats.OnInvoke = u155;
Toggle.Event:Connect(u53);
MobileToggle.Event:Connect(function(p375) -- Line: 2113
    -- upvalues: u266 (copy), u267 (copy)
    if not p375 then
        return;
    end;

    if script:GetAttribute("Open") then
        u266();

        return;
    end;

    u267();
end);
MobileClose.Event:Connect(function(p376) -- Line: 2117
    -- upvalues: u53 (copy)
    if p376 then
        u53("None");
    end;
end);
script:WaitForChild("EquipArmor").Event:Connect(function(p377: number) -- Line: 2121
    -- upvalues: Toolbar (copy), u80 (copy), u19 (ref)
    u80(Toolbar[`Slot{p377}`], "Toolbar", p377, u19, "ArmorEquip");
end);
BG.Visible = true;
Inventory.Visible = true;
Crafting.Visible = true;
CraftingKeyboard.Visible = not v37();
CraftingConsole.Visible = v37();
local v378 = v38();
CraftingKeyboard.Text = `CRAFTING [<font color="rgb(255, 244, 88)">{v378}</font>]`;
CraftingConsole.Text = "CRAFTING    ";
CraftingKeyboard2.Text = `INVENTORY [<font color="rgb(255, 244, 88)">{v378}</font>]`;
CraftingConsole2.Text = "INVENTORY    ";
CraftingKeyboard2.Visible = not v37();
CraftingConsole2.Visible = v37();
ImageLabel.Visible = v37();
u53("None", true);
u83(1);
ActionMenu.Visible = false;
warn("Initiated;ShowCharacter")
local v379, v380, v381 = u1(
    "Fire",
    "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189",
    "\045\195\169\239\191\189\239\191\189\195\183\239\191\189\239\191\189\037\239\191\189\076\239\191\189\123\195\163\195\130\239\191\189\115\239\191\189\109\239\191\189\125"
);
u3 = v379;
u4 = v380;
u5 = v381;
warn("Initiated;ShowCharacter")
ViewportModule:Initialize();
warn("Initiated;ShowCharacter")
ViewportModule:ShowCharacter(ViewportFrame, script_Parent, { HitboxChest, HitboxHead, HitboxLegs }, u3.Armor);
warn("Initiated;ShowCharacter")
script:SetAttribute("Initiated", true);
ActionMenu.SplitBar.MouseButton1Down:Connect(function() -- Line: 2150
    -- upvalues: u9 (ref), u3 (ref), u15 (ref), Mouse (copy), ActionMenu (copy), u16 (ref), u86 (copy), RunService (copy)
    local v382 = u9;

    if v382 then
        local v383 = u3[v382.Container];

        if not v383 then
            return;
        end;

        local v384 = v383[v382.Index];

        if v384 and (v384 ~= 0 and v384.Amount > 0) then
            u15 = true;

            while u15 and (u9 and u9 == v382) do
                local math_clamp_ret = math.clamp((Mouse.X - ActionMenu.SplitBar.AbsolutePosition.X) / ActionMenu.SplitBar.AbsoluteSize.X, 0, 1);
                local v385 = v384.Amount * math.clamp(math_clamp_ret, 0, 1);
                u16 = math.ceil(v385);
                u86();
                RunService.Heartbeat:Wait();
            end;
        end;
    end;
end);
u265(ActionMenu.SplitBar, true);
u174(ActionMenu.Split, 1, function(p386, p387) -- Line: 2169
    -- upvalues: u9 (ref), u3 (ref), u10 (ref), u63 (copy)
    if u9 then
        local Slot = u9.Slot;
        local v388 = u3[u9.Container];

        if v388 and Slot then
            local v389 = v388[u9.Index];

            if v389 and (v389 ~= 0 and not u10) then
                p386 = u63(Slot, Slot.ItemImage.Image, u9.Container, u9.Index, p387, true, v389);
            end;
        end;
    end;

    return p386, p387;
end);
u265(ActionMenu.Split, true);
pcall(function() -- Line: 2184
    -- upvalues: RunService (copy)
    RunService:UnbindFromRenderStep("SliderTextPosition");
end);
RunService:BindToRenderStep("SliderTextPosition", Enum.RenderPriority.Last.Value, function() -- Line: 2187
    -- upvalues: ActionMenu (copy)
    ActionMenu.SplitBar.Amount.Position = UDim2.new(math.max(ActionMenu.SplitBar.Fill.Size.X.Scale, 0.1), 0, 0.5, 0);
end);

for i = 1, 4 do
    local u390 = ActionMenu.ItemDetails["Slot" .. i];
    u174(u390, 1, function(p391, p392) -- Line: 2193
        -- upvalues: u9 (ref), u3 (ref), u10 (ref), i (copy), u63 (copy), u390 (copy)
        local Slot = u9.Slot;
        local v393 = u3[u9.Container];

        if v393 then
            local v394 = v393[u9.Index];

            if v394 and (v394 ~= 0 and (v394.Amount > 0 and not u10)) then
                local v395 = v394.Attachments[i];

                if v395 then
                    p391 = u63(Slot, u390.ItemImage.Image, u9.Container, u9.Index, p392, i, v395);
                end;
            end;
        end;

        return p391, p392;
    end, function() -- Line: 2206
        -- upvalues: u9 (ref), u10 (ref), u3 (ref), SoundModule (copy), u1 (copy)
        if u9 then
            local Container = u10.Container;
            local Index = u10.Index;
            local v396 = u3[Container];

            if not v396 then
                return;
            end;

            local v397 = v396[Index];

            if v397 and (v397 ~= 0 and v397.Amount > 0) then
                SoundModule:PlayItemSound(v397.ID, "Drop");
            end;

            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, v397.Amount, u9.Container, u9.Index);
        end;
    end, function(p398) -- Line: 2224
        -- upvalues: PreferredInputController (copy), u9 (ref), u10 (ref), u3 (ref), i (copy), u63 (copy), u390 (copy), u33 (ref)
        local v399 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v399 and (u9 and not u10) then
            local v400 = u3[u9.Container];
            local v401 = v400 and v400[u9.Index];
            local v402 = v401 and (v401 ~= 0 and (v401.Amount > 0 and v401.Attachments[i]));

            if v402 then
                u63(u9.Slot, u390.ItemImage.Image, u9.Container, u9.Index, p398, i, v402);
                u33 = true;
            end;
        end;
    end);
    local _ = i;
end;

for _, child in pairs(ActionMenu.Actions:GetChildren()) do
    local Name = child.Name;
    child.Activated:Connect(function() -- Line: 2242
        -- upvalues: u9 (ref), u3 (ref), Items (copy), Name (copy), Values (copy), u1 (copy), workspace_CurrentCamera (copy), u30 (ref)
        if u9 then
            local Container = u9.Container;
            local Index = u9.Index;
            local v403 = u3[Container];

            if v403 then
                local v404 = v403[Index];

                if v404 and (v404 ~= 0 and v404.Amount > 0) then
                    local v405 = Items[v404.ID];

                    if Name == "Drop" and Values.ClientDropping.Value then
                        u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, nil, "Drop", "none", "none", "none", workspace_CurrentCamera.CFrame);

                        return;
                    end;

                    if Name == "Action1" then
                        local DropInfo = v405.DropInfo;

                        if v405.Type == "Gun" and (v404.Ammo and v404.Ammo.Amount > 0) then
                            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, "UnloadAmmo");

                            return;
                        end;

                        if DropInfo then
                            u1("Fire", "\239\191\189\239\191\189\239\191\189\099\057\239\191\189\115\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\164\239\191\189\239\191\189\239\191\189\054\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\050\077\114\041\119\239\191\189\239\191\189\239\191\189\239\191\189\194\174\064\239\191\189\195\156\239\191\189\239\191\189\125\060\055", Container, Index, "ItemDrop");

                            return;
                        end;

                        if v405.Type:find("Consumable") then
                            local v406 = tick();

                            if v406 - u30 < 0.15 then
                                return;
                            end;

                            u30 = v406;
                            u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\124\195\156\239\191\189\075\239\191\189\239\191\189\239\191\189\109\195\136\100\195\140\239\191\189\239\191\189\239\191\189\194\181\195\155\239\191\189\195\176\195\169\049", Container, Index);
                        end;
                    end;
                end;
            end;
        end;
    end);
    u265(child, true);
end;

for i, v in pairs(u3) do
    local v407 = i;

    for i2, v2 in pairs(v) do
        local v408 = u6[v407];

        if v408 then
            local v409 = v408["Slot" .. i2];
            v260(v409, v407, i2);
            u109(v409, v2);
        end;
    end;
end;

u333();

for _, child in pairs(Benches:GetChildren()) do
    child.Visible = false;
    local v410 = child:FindFirstChild("Inv") or child;

    for _, child2 in pairs(v410:GetChildren()) do
        if v410.Name == "TradingPost" then
            local u411 = 0;
            local v412 = child2.Name:gsub("%D", "");
            local u413 = tonumber(v412);
            local v414 = child2.Name:sub(1, 4) == "Give";

            if child2.Name:sub(1, 5) == "Trade" then
                child2.BackgroundColor3 = child2:GetAttribute("ColorOff");
                u22[child2] = ButtonClass.new(child2, "BackgroundColor3", function() -- Line: 2317
                    -- upvalues: u17 (ref), u411 (ref), u1 (copy), u413 (copy)
                    if not u17 then
                        return;
                    end;

                    local v415 = tick();

                    if v415 - u411 < 0.2 then
                        return;
                    end;

                    u411 = v415;
                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "ShopBuy", u413);
                end, 1.3, child2:GetAttribute("ColorOn"));
            elseif v414 or child2.Name:sub(1, 7) == "Receive" then
                local u416 = u413 * 2 - (v414 and 1 or 0);
                u22[child2] = ButtonClass.new(child2, "BackgroundColor3", function() -- Line: 2330
                    -- upvalues: u17 (ref), ItemSearchModule (copy), u411 (ref), u1 (copy), u416 (copy)
                    if not (u17 and (u17.Parent and not (u17:GetAttribute("OffersLocked") or ItemSearchModule.IsSearching()))) then
                        return;
                    end;

                    local v417 = tick();

                    if v417 - u411 < 0.2 then
                        return;
                    end;

                    u411 = v417;
                    local v418, v419 = ItemSearchModule.BeginSearch();

                    if not (v418 and v419) then
                        return;
                    end;

                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "ShopUpdate", (`{u416}/{v418}/{v419}`));
                end, 1.3, Color3.fromRGB(75, 35, 35), function() -- Line: 2342
                    -- upvalues: u17 (ref), u411 (ref), u1 (copy), u416 (copy)
                    if not u17 then
                        return;
                    end;

                    local v420 = tick();

                    if v420 - u411 < 0.2 then
                        return;
                    end;

                    u411 = v420;
                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "ShopUpdate", (`{u416}/0/0`));
                end);
            end;
        else
            if v410.Name == "ArmorStand" and child2.Name == "Swap" then
                local u421 = false;
                child2.BackgroundColor3 = child2:GetAttribute("ColorOn");
                u22[child2] = ButtonClass.new(child2, "BackgroundColor3", function() -- Line: 2358
                    -- upvalues: u17 (ref), u421 (ref), child2 (copy), TweenUtil (copy), u22 (copy), u1 (copy)
                    if not u17 then
                        return;
                    end;

                    if u421 then
                        return;
                    end;

                    u421 = true;
                    child2.Arrow.Rotation = 0;
                    TweenUtil:Tween(child2.Arrow, "Rotation", 360, 0.5, "Quart", "InOut");
                    task.spawn(u22[child2].ToggleButton, u22[child2], true);
                    u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, "StandSwap");
                    task.wait(1);

                    if not child2.Parent then
                        return;
                    end;

                    u421 = false;
                    u22[child2]:ToggleButton(false);
                end, 1.3, child2:GetAttribute("ColorOff"));
            end;

            if child2.Name:sub(1, 4) == "Slot" then
                local v422 = tonumber(child2.Name:sub(5));

                if v422 then
                    v260(child2, "Bench", v422);
                    u109(child2, 0);
                end;
            end;
        end;
    end;

    local u423 = 0;
    local ControlFrame = child:FindFirstChild("ControlFrame");

    if ControlFrame then
        if MobileModule.IsTouchDevice() then
            ControlFrame.Size = UDim2.fromScale(ControlFrame.Size.X.Scale, ControlFrame.Size.Y.Scale * 2);
        end;

        local Toggle2 = ControlFrame:FindFirstChild("Toggle");

        if Toggle2 then
            Toggle2.BackgroundColor3 = Toggle2:GetAttribute("ColorOff");
            u22[Toggle2] = ButtonClass.new(Toggle2, "BackgroundColor3", function() -- Line: 2390
                -- upvalues: u17 (ref), u423 (ref), u1 (copy), u22 (copy), Toggle2 (copy)
                if not u17 then
                    return;
                end;

                local v424 = tick();

                if v424 - u423 < 0.2 then
                    return;
                end;

                u423 = v424;
                u1("Fire", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\195\175\239\191\189\239\191\189\239\191\189\194\175\194\176\239\191\189\083\239\191\189\072\239\191\189\194\179\052\195\154", "\108\074\239\191\189\093\239\191\189\075\239\191\189\195\146\239\191\189\116\239\191\189\239\191\189\239\191\189\194\183\239\191\189\239\191\189\122\049\239\191\189\239\191\189", u17, u22[Toggle2]:IsToggled() and "Turn Off" or "Turn On");
            end, 1.3, Toggle2:GetAttribute("ColorOn"));
        end;
    end;
end;

for i = 1, 4 do
    local u425 = Values:WaitForChild("PlinkoTimer" .. i);
    u425:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 2405
        -- upvalues: i (copy), u29 (ref), Benches (copy), u425 (copy)
        if i ~= u29 or not Benches.Plinko.Visible then
            return;
        end;

        Benches.Plinko.Timer.Text = u425.Value .. "s";
    end);
    local _ = i;
end;