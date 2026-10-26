-- [PATH] ReplicatedStorage / CharacterScripts / EquipController @Type LocalScript


local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
game:GetService("RunService");
ReplicatedStorage:WaitForChild("Values");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local InventoryController = script_Parent:WaitForChild("InventoryController");
local ViewmodelController = script_Parent:WaitForChild("ViewmodelController");
local BuildController = script_Parent:WaitForChild("BuildController");
local CameraController = script_Parent:WaitForChild("CameraController");
local InteractController = script_Parent:WaitForChild("InteractController");
local ElectricityController = script_Parent:WaitForChild("ElectricityController");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Items = require(Modules:WaitForChild("Items"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local u1 = require(Modules:WaitForChild("AssetContainer"))();
local u2 = {
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four,
    Enum.KeyCode.Five,
    Enum.KeyCode.Six
};
local Main = PlayerGui:WaitForChild("Main");
local Toolbar = Main:WaitForChild("Toolbar");
local Codelock = Main:WaitForChild("Codelock");
local Fetch = InventoryController:WaitForChild("Fetch");
local EquipWires = ElectricityController:WaitForChild("EquipWires");
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local u3 = {};
local u4 = false;
local u5 = 0;

local function _() -- Line: 73
    -- upvalues: Humanoid (copy), CameraController (copy)
    local v6 = Humanoid and Humanoid.Parent;

    if v6 then
        if Humanoid.Health > 0 then
            v6 = not CameraController:GetAttribute("ViewmodelCFrame");
        else
            v6 = false;
        end;
    end;

    return v6;
end;

local function _(p7) -- Line: 77
    -- upvalues: Toolbar (copy), InventoryController (copy)
    local Attribute = script:GetAttribute("Equipped");
    local v8 = Toolbar:FindFirstChild("Slot" .. p7);

    if not v8 then
        return;
    end;

    v8.BackgroundColor3 = InventoryController:GetAttribute((Attribute == p7 and "Selected" or "Default") .. "SlotColor");
end;

local function _(p9) -- Line: 85
    -- upvalues: Fetch (copy), Items (copy)
    local v10 = Fetch:Invoke().Toolbar[p9];
    local v11;

    if v10 then
        if v10 == 0 or v10.Amount <= 0 then
            v11 = false;
        else
            v11 = Items[v10.ID];
        end;
    else
        v11 = v10;
    end;

    return v10, v11;
end;

local function u18(p12) -- Line: 93
    -- upvalues: Toolbar (copy), InventoryController (copy), Fetch (copy), Items (copy), ViewmodelController (copy), BuildController (copy), EquipWires (copy)
    local Attribute = script:GetAttribute("Equipped");
    script:SetAttribute("Equipped", p12);

    if Attribute ~= p12 then
        local Attribute2 = script:GetAttribute("Equipped");
        local v13 = Toolbar:FindFirstChild("Slot" .. Attribute);

        if v13 then
            v13.BackgroundColor3 = InventoryController:GetAttribute((Attribute2 == Attribute and "Selected" or "Default") .. "SlotColor");
        end;
    end;

    local Attribute2 = script:GetAttribute("Equipped");
    local v14 = Toolbar:FindFirstChild("Slot" .. p12);

    if v14 then
        v14.BackgroundColor3 = InventoryController:GetAttribute((Attribute2 == p12 and "Selected" or "Default") .. "SlotColor");
    end;

    local v15 = Fetch:Invoke().Toolbar[p12];
    local v16;

    if v15 then
        if v15 == 0 or v15.Amount <= 0 then
            v16 = false;
        else
            v16 = Items[v15.ID];
        end;
    else
        v16 = v15;
    end;

    local v17 = (v16 and (v16.Type ~= "Gun" and (v16.Type ~= "Tool" and v16.Type ~= "Bench")) or v16 and (v16.MaxDurability and v15.Durability <= 0)) and 0 or p12;
    ViewmodelController.EquipVM:Fire(v17);
    BuildController.EquipBench:Fire(v17);

    if v17 == 0 then
        v15 = false;
    elseif v15 then
        if typeof(v15) == "number" then
            v15 = false;
        else
            v15 = v15.ID == 326;
        end;
    end;

    EquipWires:Fire(v15);

    return true;
end;

local function u28(p19, p20, p21) -- Line: 109
    -- upvalues: Humanoid (copy), Fetch (copy), Items (copy), InventoryController (copy), u18 (copy), u5 (ref), u1 (copy), LocalPlayer (copy)
    if p19 ~= 0 and (Humanoid.SeatPart and (Humanoid.SeatPart.Name == "VehicleSeat" and (Humanoid.SeatPart:FindFirstAncestor("Salvaged Flycopter") or Humanoid.SeatPart.Parent and (Humanoid.SeatPart.Parent.Name == "Wooden Boat" or Humanoid.SeatPart.Parent.Name == "Military Boat")))) then
        return;
    end;

    local v22 = Fetch:Invoke().Toolbar[p19];
    local v23;

    if v22 then
        if v22 == 0 or v22.Amount <= 0 then
            v23 = false;
        else
            v23 = Items[v22.ID];
        end;
    else
        v23 = v22;
    end;

    if p19 ~= 0 and (type(v23) == "table" and (v23.Type:find("Armor") and not v23.Type:find("Consumable"))) then
        InventoryController.EquipArmor:Fire(p19);
    end;

    if not (v23 and v23.Type:find("Consumable")) then
        if type(v22) == "table" and v22.Amount <= 0 then
            return;
        end;

        local v24 = script:GetAttribute("Equipped") == p19 and 0 or p19;

        if v24 ~= 0 and (LocalPlayer:GetAttribute("SafeZone") and not workspace:GetAttribute("SafeZonesClosed")) then
            local v25 = Fetch:Invoke().Toolbar[v24];

            if v25 then
                if v25 == 0 or v25.Amount <= 0 then
                    v25 = false;
                else
                    v25 = Items[v25.ID];
                end;
            end;

            if type(v25) == "table" and v25.Type == "Gun" then
                return;
            end;
        end;

        local v26 = u18(v24);

        if v26 then
            u1("Fire", "\239\191\189\239\191\189\195\151\239\191\189\086\239\191\189\239\191\189\116\239\191\189\239\191\189\239\191\189\195\130\058\239\191\189\112\195\173\239\191\189\195\179\195\161\052", "\063\194\172\239\191\189\195\159\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\041\239\191\189\033\239\191\189\239\191\189\239\191\189", v24);

            return v26;
        end;

        return;
    end;

    if p21 then
        u18(p19);

        return true;
    end;

    if p20 then
        return;
    end;

    local v27 = tick();

    if v27 - u5 < 0.2 then
        return;
    end;

    u5 = v27;
    u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\124\195\156\239\191\189\075\239\191\189\239\191\189\239\191\189\109\195\136\100\195\140\239\191\189\239\191\189\239\191\189\194\181\195\155\239\191\189\195\176\195\169\049", "Toolbar", p19);
end;

local function u31(p29) -- Line: 168
    -- upvalues: u3 (copy), u4 (ref)
    if #u3 > 3 then
        return;
    end;

    table.insert(u3, p29);

    if not u4 then
        u4 = true;
        local os_clock_ret = os.clock();

        while #u3 > 0 do
            local os_clock_ret2 = os.clock();

            if os_clock_ret2 - os_clock_ret >= 0.1 then
                while os_clock_ret2 - os_clock_ret >= 0.1 do
                    os_clock_ret2 = os_clock_ret2 - 0.1;
                    local v30 = u3[1];

                    if not v30 then
                        break;
                    end;

                    v30();
                    table.remove(u3, 1);

                    if #u3 <= 0 then
                        u4 = false;
                        break;
                    end;
                end;

                os_clock_ret = os.clock();
            end;

            task.wait();
        end;
    end;
end;

local function u36(p32) -- Line: 146
    -- upvalues: u2 (copy), PreferredInputController (copy), u28 (copy)
    local Attribute = script:GetAttribute("Equipped");
    local v33 = Attribute + p32;
    local v34;

    if v33 < 0 then
        v34 = #u2;
    else
        v34 = #u2 < v33 and 0 or v33;
    end;

    local v35 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    return v34 == Attribute and true or u28(v34, true, v35);
end;

while Fetch and Fetch.Parent do
    local v37 = Fetch:Invoke();

    if type(v37) == "table" and type(v37.Toolbar) == "table" then
        UserInputService.InputBegan:Connect(function(p38) -- Line: 207
            -- upvalues: SettingsModule (copy), UserInputService (copy), Codelock (copy), Humanoid (copy), CameraController (copy), u2 (copy), InteractController (copy), u31 (copy), u28 (copy), u36 (copy), script_Parent (copy), Fetch (copy), Items (copy), u5 (ref), u1 (copy)
            if SettingsModule.MainMenuOpen() then
                return;
            end;

            local UserInputType = p38.UserInputType;

            if not (UserInputService:GetFocusedTextBox() or (Codelock.Visible or Humanoid:GetAttribute("Downed"))) then
                local v39 = Humanoid and Humanoid.Parent;

                if v39 then
                    if Humanoid.Health > 0 then
                        v39 = not CameraController:GetAttribute("ViewmodelCFrame");
                    else
                        v39 = false;
                    end;
                end;

                if v39 then
                    if UserInputType == Enum.UserInputType.Keyboard then
                        local KeyCode = p38.KeyCode;

                        for i, v in pairs(u2) do
                            if v == KeyCode then
                                if InteractController:GetAttribute("Dialog") and i <= (InteractController:GetAttribute("DialogOptions") or 2) then
                                    return;
                                end;

                                u31(function() -- Line: 217
                                    -- upvalues: CameraController (ref), u28 (ref), i (copy)
                                    if CameraController:GetAttribute("ViewmodelCFrame") then
                                        return;
                                    end;

                                    u28(i);
                                end);

                                return;
                            end;
                        end;

                        if KeyCode.Name == SettingsModule.GetSetting("Controls", "Toolbar Left") then
                            u36(-1);

                            return;
                        end;

                        if KeyCode.Name == SettingsModule.GetSetting("Controls", "Toolbar Right") then
                            u36(1);
                        end;
                    elseif UserInputType == Enum.UserInputType.Gamepad1 then
                        local TeamNavigationController = script_Parent:FindFirstChild("TeamNavigationController");

                        if TeamNavigationController and TeamNavigationController:GetAttribute("MapOpen") then
                            return;
                        end;

                        local KeyCode = p38.KeyCode;

                        if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Fire") then
                            local Attribute = script:GetAttribute("Equipped");
                            local v40 = Fetch:Invoke().Toolbar[Attribute];

                            if v40 then
                                if v40 == 0 or v40.Amount <= 0 then
                                    v40 = false;
                                else
                                    v40 = Items[v40.ID];
                                end;
                            end;

                            if v40 and v40.Type:find("Consumable") then
                                local v41 = tick();

                                if v41 - u5 < 0.2 then
                                    return;
                                end;

                                u5 = v41;
                                u1("Fire", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\124\195\156\239\191\189\075\239\191\189\239\191\189\239\191\189\109\195\136\100\195\140\239\191\189\239\191\189\239\191\189\194\181\195\155\239\191\189\195\176\195\169\049", "Toolbar", Attribute);
                            end;
                        else
                            if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Toolbar Left") then
                                u36(-1);

                                return;
                            end;

                            if KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Toolbar Right") then
                                u36(1);
                            end;
                        end;
                    end;
                end;
            end;
        end);
        UserInputService.InputChanged:Connect(function(p42, p43) -- Line: 250
            -- upvalues: SettingsModule (copy), UserInputService (copy), Codelock (copy), Humanoid (copy), LocalPlayer (copy), CameraController (copy), u31 (copy), u36 (copy)
            if SettingsModule.MainMenuOpen() then
                return;
            end;

            local UserInputType = p42.UserInputType;
            local FocusedTextBox = UserInputService:GetFocusedTextBox();

            if UserInputType == Enum.UserInputType.MouseWheel and not (FocusedTextBox or (p43 or (Codelock.Visible or (Humanoid:GetAttribute("Downed") or LocalPlayer:GetAttribute("SafeZone") and not workspace:GetAttribute("SafeZonesClosed"))))) then
                local v44 = Humanoid and Humanoid.Parent;

                if v44 then
                    if Humanoid.Health > 0 then
                        v44 = not CameraController:GetAttribute("ViewmodelCFrame");
                    else
                        v44 = false;
                    end;
                end;

                if v44 then
                    local Z = p42.Position.Z;

                    if Z >= 0.5 and SettingsModule.GetSetting("Controls", "Toolbar Right") ~= "M.WheelDown" then
                        return;
                    end;

                    if Z <= -0.5 and SettingsModule.GetSetting("Controls", "Toolbar Left") ~= "M.WheelUp" then
                        return;
                    end;

                    if math.abs(Z) < 0.5 then
                        return;
                    end;

                    u31(function() -- Line: 259
                        -- upvalues: u36 (ref), Z (copy)
                        u36(Z > 0 and -1 or 1);
                    end);
                end;
            end;
        end);

        for i = 1, #u2 do
            local v45 = Toolbar:FindFirstChild("Slot" .. i);
            local v46;

            if v45 then
                v45.Activated:Connect(function() -- Line: 268
                    -- upvalues: MobileModule (copy), SettingsModule (copy), InventoryController (copy), UserInputService (copy), Codelock (copy), Humanoid (copy), CameraController (copy), InteractController (copy), i (copy), u31 (copy), u28 (copy)
                    if not MobileModule.IsTouch() then
                        return;
                    end;

                    if SettingsModule.MainMenuOpen() then
                        return;
                    end;

                    if InventoryController:GetAttribute("Open") then
                        return;
                    end;

                    if not (UserInputService:GetFocusedTextBox() or (Codelock.Visible or Humanoid:GetAttribute("Downed"))) then
                        local v47 = Humanoid and Humanoid.Parent;

                        if v47 then
                            if Humanoid.Health > 0 then
                                v47 = not CameraController:GetAttribute("ViewmodelCFrame");
                            else
                                v47 = false;
                            end;
                        end;

                        if v47 then
                            if InteractController:GetAttribute("Dialog") and i <= (InteractController:GetAttribute("DialogOptions") or 2) then
                                return;
                            end;

                            u31(function() -- Line: 275
                                -- upvalues: CameraController (ref), u28 (ref), i (ref)
                                if CameraController:GetAttribute("ViewmodelCFrame") then
                                    return;
                                end;

                                u28(i);
                            end);
                        end;
                    end;
                end);
                v46 = i;
            else
                v46 = i;
            end;
        end;

        u1("Setup", "\239\191\189\239\191\189\195\151\239\191\189\086\239\191\189\239\191\189\116\239\191\189\239\191\189\239\191\189\195\130\058\239\191\189\112\195\173\239\191\189\195\179\195\161\052", "\063\194\172\239\191\189\195\159\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\041\239\191\189\033\239\191\189\239\191\189\239\191\189", u18);

        return;
    end;

    task.wait();
end;