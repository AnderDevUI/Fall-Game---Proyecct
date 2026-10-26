-- [PATH] ReplicatedStorage / CharacterScripts / ServerTypeController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Values = ReplicatedStorage:WaitForChild("Values");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local ButtonClass = require(Modules:WaitForChild("ButtonClass"));
local TableUtil = require(Modules:WaitForChild("TableUtil"));
local Items = require(Modules:WaitForChild("Items"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local ArenaSettings = require(Modules:WaitForChild("ArenaSettings"));
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
script_Parent:WaitForChild("Humanoid");
local Main = PlayerGui:WaitForChild("Main");
local CombatServer = Main:WaitForChild("CombatServer");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local BuildServer = Main:WaitForChild("BuildServer");
local Value = Values:WaitForChild("ServerType").Value;
local os_clock_ret = os.clock();
local u7 = false;
local u8 = false;
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = nil;
local u13 = "Red";
local u14 = {};
local u15 = {
    Red = "rgb(255, 66, 69)",
    Blue = "rgb(66, 115, 255)"
};
local u16 = {};
local u17 = {};
local u18 = {};
local u19 = { "Weapon", "Armor" };
local u20 = { "Red", "Blue" };
local u21 = {};
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = 0;
local u27 = false;
local u28 = nil;

local function _() -- Line: 70
    -- upvalues: UserInputService (copy), u2 (ref), u3 (ref)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    u2.Visible = false;

    if u3:IsFocused() then
        u3:ReleaseFocus();
    end;
end;

local function u30(p29: number) -- Line: 79
    -- upvalues: u12 (ref)
    return u12 and u12.KitGuns[p29] or {};
end;

local function _(u31: userdata) -- Line: 84
    local function v34() -- Line: 85
        -- upvalues: u31 (copy)
        local v32 = u31.AbsoluteSize.Y / (u31:GetAttribute("TextReferenceHeight") or 311);

        for _, descendant in pairs(u31:GetDescendants()) do
            local v33 = descendant:IsA("UITextSizeConstraint") and descendant:GetAttribute("BaseMaxTextSize");

            if v33 then
                local math_round_ret = math.round(v33 * v32);
                descendant.MaxTextSize = math.max(1, math_round_ret);
            end;
        end;
    end;

    v34();
    u31:GetPropertyChangedSignal("AbsoluteSize"):Connect(v34);
end;

local function _(p35: number) -- Line: 98
    -- upvalues: Items (copy)
    return Items[p35].Name:gsub("^External ", "");
end;

local function u60(p36) -- Line: 102
    -- upvalues: u13 (ref), u19 (copy), u5 (ref), u14 (copy), u9 (copy), u4 (ref), u20 (copy), u10 (ref), u11 (ref), u12 (ref), ArenaSettings (copy), u15 (copy), u16 (copy), u18 (copy), u17 (copy), Items (copy)
    local SplitTeams = p36.SplitTeams;

    if not SplitTeams then
        u13 = "Red";
    end;

    local v37 = p36.Loadouts[u13];

    for _, v in pairs(u19) do
        local v38 = v37[v];
        local v39 = u5[`{v}Kits`];
        local v40 = u14[v];

        if v40 and v40 ~= v38 then
            local v41 = v39:FindFirstChild((`Kit{v40}`));

            if v41 then
                v41 = u9[v41];
            end;

            if v41 and v41:IsToggled() then
                task.defer(v41.ToggleButton, v41, false);
            end;
        end;

        local v42 = v39:FindFirstChild((`Kit{v38}`));

        if v42 then
            v42 = u9[v42];
        end;

        if v42 and not v42:IsToggled() then
            task.defer(v42.ToggleButton, v42, true);
        end;

        u14[v] = v38;
    end;

    local TeamTabs = u4.TeamTabs;
    TeamTabs.Visible = SplitTeams;

    for _, v in u20 do
        local v43 = TeamTabs[v];
        local v44 = v == u13;
        local v45;

        if v44 then
            v45 = `EDITING {v:upper()}`;
        else
            v45 = `{v:upper()} TEAM`;
        end;

        v43.Text = v45;
        v43.BackgroundTransparency = v44 and 0 or 0.45;
        v43.TextTransparency = v44 and 0 or 0.2;
        v43.SelectedStroke.Enabled = v44;
    end;

    u5.SplitTeams.Text = `Split Team Kits: <font color="{SplitTeams and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    local Public = p36.Public;

    if not Public and u10.Public then
        u5.PasswordInput.Text = "";
    end;

    if u11.Public == false then
        u5.PasswordExtra.Visible = true;
        u5.PasswordInput.Visible = false;
    else
        u5.PasswordExtra.Visible = false;
        u5.PasswordInput.Visible = not Public;
    end;

    u5.Public.Text = `Arena Status: <font color="{Public and "rgb(0, 255, 0)\">PUBLIC" or "rgb(255, 0, 0)\">PRIVATE"}</font>`;
    u5.AutoStart.Text = `Auto Start: <font color="{p36.AutoStart and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    u5.HealthRegen.Text = `Health Regen on Kill: <font color="{p36.HealthRegen and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    local v46 = false;

    for _, v in u20 do
        local v47 = p36.Loadouts[v];

        if #ArenaSettings.GetGunsMissingAmmo(v47, u12 and u12.KitGuns[v47.Weapon] or {}) > 0 then
            v46 = true;
            break;
        end;
    end;

    if v46 or not (Public or (u11.Public == Public or u5.PasswordInput.Text ~= "")) then
        u4.Apply.Visible = false;
    else
        u4.Apply.Visible = not ArenaSettings.Equals(u11, p36);
    end;

    u5.Downing.Text = `Player Downing: <font color="{p36.Downing and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    u5.AutoRotate.Text = `Auto Rotate Kits: <font color="{p36.AutoRotate and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    local TimeLimitInput = u5.TimeLimitInput;

    if not TimeLimitInput:IsFocused() then
        TimeLimitInput.Text = p36.TimeLimit <= 0 and "" or tostring(p36.TimeLimit);
    end;

    local AutoRotate = p36.AutoRotate;
    local v48 = AutoRotate and " (ROTATES AUTOMATICALLY WHILE AUTO ROTATE KITS IS ON)" or "";
    local v49 = not SplitTeams and "" or ` <font color="{u15[u13]}">({u13:upper()} TEAM)</font>`;
    u5.DetailWepKit.Text = `WEAPON KIT{v49}:{v48}`;
    u5.DetailArmorKit.Text = `ARMOR KIT{v49}:{v48}`;
    u5.DetailAttachments.Text = `ATTACHMENTS{v49}:{v48}`;
    u5.DetailEquipment.Text = `EQUIPMENT{v49}:`;

    for i, v in u9 do
        v:Enable(not AutoRotate);
        i.TextTransparency = AutoRotate and 0.6 or 0;
    end;

    local v50 = u12 and u12.KitGuns[v37.Weapon] or {};

    for i, v in u16 do
        local v51 = v37.Attachments[tostring(i)] or 0;
        local AttachmentMax = ArenaSettings.GetAttachmentMax(i, v50);
        local v52;

        if AttachmentMax > 0 then
            v52 = not AutoRotate;
        else
            v52 = false;
        end;

        local Button = v.Button;
        local v53;

        if v51 > 0 then
            v53 = `{v.Name} ({v51}/{AttachmentMax})`;
        else
            v53 = v.Name;
        end;

        Button.Text = v53;
        v.Button.TextTransparency = v52 and 0 or 0.6;
        v.Class:Enable(v52);

        if v.Class:IsToggled() ~= (v51 > 0) then
            task.defer(v.Class.ToggleButton, v.Class, v51 > 0);
        end;
    end;

    local v54 = {};

    for _, v in ArenaSettings.GetKitAmmoChoices(v50) do
        v54[v] = true;
    end;

    for i, v in u18 do
        local v55 = v54[i];
        v.Button.Visible = v55 == true;

        if v55 then
            local v56 = v37.Ammo[tostring(i)] == true;
            v.Class:Enable(not AutoRotate);
            v.Button.TextTransparency = AutoRotate and 0.6 or 0;

            if v.Class:IsToggled() ~= v56 then
                task.defer(v.Class.ToggleButton, v.Class, v56);
            end;
        end;
    end;

    local GunsMissingAmmo = ArenaSettings.GetGunsMissingAmmo(v37, v50);
    local DetailAmmo = u5.DetailAmmo;
    local v57;

    if #GunsMissingAmmo > 0 then
        v57 = `AMMUNITION{v49}: <font color="rgb(255, 80, 80)">EVERY GUN NEEDS AT LEAST ONE</font>`;
    else
        v57 = `AMMUNITION{v49}:`;
    end;

    DetailAmmo.Text = v57;
    local v58 = u12 and u12.MaxStackMult or 1;

    for i, v in u17 do
        local v59 = v37.Equipment[tostring(i)];
        v.Label.Text = `{Items[i].Name:gsub("^External ", "")}\n<font color="rgb(170, 170, 170)">(MAX {ArenaSettings.GetEquipmentMax(i, v58)})</font>:`;

        if not v.Input:IsFocused() then
            v.Input.Text = not v59 and "" or tostring(v59);
        end;
    end;

    u10 = p36;
end;

local function u63(p61) -- Line: 232
    -- upvalues: u10 (ref), u5 (ref), u11 (ref), u4 (ref), TableUtil (copy)
    local v62 = p61[1];

    if not v62 and u10[1] then
        u5.PasswordInput.Text = "";
    end;

    if u11[1] == false then
        u5.PasswordExtra.Visible = true;
        u5.PasswordInput.Visible = false;
    else
        u5.PasswordExtra.Visible = false;
        u5.PasswordInput.Visible = not v62;
    end;

    u5.Public.Text = `Arena Status: <font color="{v62 and "rgb(0, 255, 0)\">PUBLIC" or "rgb(255, 0, 0)\">PRIVATE"}</font>`;

    if v62 or (u11[1] == v62 or u5.PasswordInput.Text ~= "") then
        u4.Apply.Visible = not TableUtil:CompareTables(u11, p61);
    else
        u4.Apply.Visible = false;
    end;

    u5.CostBaseParts.Text = `/cost Calculate Base Parts: <font color="{p61[2] and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    u5.CostDeployables.Text = `/cost Calculate Deployables: <font color="{p61[3] and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    u5.AllowMemberSaves.Text = `Allow Save Sharing: <font color="{p61[4] and "rgb(0, 255, 0)\">ON" or "rgb(255, 0, 0)\">OFF"}</font>`;
    u10 = p61;
end;

local function u69(...) -- Line: 258
    -- upvalues: u21 (ref), u6 (ref), u20 (copy), ButtonClass (copy), os_clock_ret (ref), ReplicatedStorage (copy)
    local v64 = { ... };

    for _, v in pairs(u21) do
        v:Destroy();
    end;

    u21 = {};

    for _, child in pairs(u6:GetChildren()) do
        if child.Name ~= "Red" and child.Name ~= "Blue" then
            child:Destroy();
        end;
    end;

    for i, v in pairs(u20) do
        local v65 = i;
        local v66 = v;
        local v67 = 0;

        for _, v2 in pairs(v64[i]) do
            if v2 and v2.Parent then
                v67 = v67 + 1;
                local v68 = u6[v66]:Clone();
                v68.Name = `{v66}{v67}`;
                v68.Label.Text = v2.Name;
                v68.Label.TextColor3 = v2:GetAttribute("CombatReady") and Color3.fromRGB(0, 255, 0) or Color3.new(1, 1, 1);
                v68.Position = UDim2.new(v65 == 1 and 0 or 0.5, 0, (v67 - 1) * 0.1, 0);
                v68.Parent = u6;
                v68.Visible = true;
                table.insert(u21, ButtonClass.new(v68.Kick, "BackgroundColor3", function() -- Line: 281
                    -- upvalues: os_clock_ret (ref), ReplicatedStorage (ref), v2 (copy)
                    local os_clock_ret2 = os.clock();

                    if os_clock_ret2 - os_clock_ret < 2 then
                        return;
                    end;

                    os_clock_ret = os_clock_ret2;
                    ReplicatedStorage.CombatServerRemote:FireServer("PlayerList", v2, "Kick");
                end, 1.3, 1.5));

                if v68:FindFirstChild("Swap") then
                    table.insert(u21, ButtonClass.new(v68.Swap, "BackgroundColor3", function() -- Line: 288
                        -- upvalues: os_clock_ret (ref), ReplicatedStorage (ref), v2 (copy)
                        local os_clock_ret2 = os.clock();

                        if os_clock_ret2 - os_clock_ret < 2 then
                            return;
                        end;

                        os_clock_ret = os_clock_ret2;
                        ReplicatedStorage.CombatServerRemote:FireServer("PlayerList", v2, "Swap");
                    end, 1.3, 1.5));
                end;
            end;
        end;
    end;
end;

local function _(p70: boolean) -- Line: 299
    -- upvalues: u8 (ref), u4 (ref), UserInputService (copy)
    u8 = p70;
    u4.Visible = p70;

    if p70 then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;

        return;
    end;

    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
end;

local function v71() -- Line: 311
    -- upvalues: LocalPlayer (copy), CombatServer (copy)
    local Attribute = LocalPlayer:GetAttribute("CombatReady");
    CombatServer.Ready.Text = Attribute and "Ready: YES" or (Attribute == false and "Ready: NO" or "");
    CombatServer.Ready.TextColor3 = Attribute and Color3.fromRGB(0, 255, 64) or Color3.fromRGB(255, 82, 82);
end;

local function v72() -- Line: 317
    -- upvalues: LocalPlayer (copy), u1 (ref)
    local Attribute = LocalPlayer:GetAttribute("IsArenaOwner");
    u1.IsOwner.Visible = Attribute == true;
end;

local function v73() -- Line: 322
    -- upvalues: u1 (ref), LocalPlayer (copy)
    u1.ArenaName.Text = LocalPlayer:GetAttribute("ArenaName") or "";
end;

if Value == "Combat" then
    u1 = CombatServer;
    u2 = u1:WaitForChild("Private");
    u3 = u2:WaitForChild("Password");
    u4 = u1:WaitForChild("Settings");
    u5 = u4:WaitForChild("MainFrame");
    u6 = u5:WaitForChild("PlayerList");
    local u74;

    while true do
        u74 = ReplicatedStorage:FindFirstChild("CombatServerRemote");

        if u74 then
            break;
        end;

        task.wait();
    end;

    local function _(p75: any) -- Line: 342
        -- upvalues: u10 (ref), TableUtil (copy), u60 (copy)
        if not u10.Loadouts then
            return;
        end;

        local v76 = TableUtil:CloneTable(u10);
        p75(v76);
        u60(v76);
    end;

    u3.FocusLost:Connect(function() -- Line: 349
        -- upvalues: u2 (ref), UserInputService (copy)
        shared.LastTextBoxFocused = tick();

        if not u2.Visible then
            return;
        end;

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
    end);
    u3:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 355
        -- upvalues: u3 (ref), u2 (ref)
        local v77 = u3.Text:sub(1, 20);
        u3.Text = v77;
        u2.Enter.Visible = v77:len() > 0;
    end);
    ButtonClass.new(u2.Enter, "BackgroundColor3", function() -- Line: 361
        -- upvalues: u3 (ref), os_clock_ret (ref), u2 (ref), u74 (ref)
        local Text = u3.Text;
        local os_clock_ret2 = os.clock();

        if Text:len() <= 0 or (Text:len() > 20 or os_clock_ret2 - os_clock_ret < 2) then
            return;
        end;

        os_clock_ret = os_clock_ret2;
        u2.Detail.Text = "...";
        u74:FireServer("EnterPass", Text);
    end, 1.3, 1.5);
    ButtonClass.new(u2.Cancel, "BackgroundColor3", function() -- Line: 369
        -- upvalues: u74 (ref), UserInputService (copy), u2 (ref), u3 (ref)
        u74:FireServer("CancelPass");
        task.wait();
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
        u2.Visible = false;

        if u3:IsFocused() then
            u3:ReleaseFocus();
        end;
    end, 1.3, 1.5);
    ButtonClass.new(u4.Close, "BackgroundColor3", function() -- Line: 375
        -- upvalues: u8 (ref), u4 (ref), UserInputService (copy)
        u8 = false;
        u4.Visible = false;
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
    end, 1.3, 1.5);
    ButtonClass.new(u4.Apply, "BackgroundColor3", function() -- Line: 379
        -- upvalues: u10 (ref), os_clock_ret (ref), u74 (ref), u5 (ref)
        if not u10.Loadouts then
            return;
        end;

        local os_clock_ret2 = os.clock();

        if os_clock_ret2 - os_clock_ret < 2 then
            return;
        end;

        os_clock_ret = os_clock_ret2;
        u74:FireServer("UpdateSettings", u10, u5.PasswordInput.Text);
    end, 1.3, 1.5);
    u5:WaitForChild("PasswordInput"):GetPropertyChangedSignal("Text"):Connect(function() -- Line: 387
        -- upvalues: u5 (ref)
        local v78 = u5.PasswordInput.Text:sub(1, 20);
        u5.PasswordInput.Text = v78;
    end);
    u5.PasswordInput.FocusLost:Connect(function() -- Line: 391
        -- upvalues: u8 (ref), UserInputService (copy), u60 (copy), u10 (ref)
        shared.LastTextBoxFocused = tick();

        if not u8 then
            return;
        end;

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
        u60(u10);
    end);
    ButtonClass.new(u5.Public, "BackgroundColor3", function() -- Line: 399
        -- upvalues: u10 (ref), TableUtil (copy), u60 (copy)
        local function _(p79) -- Line: 400
            p79.Public = not p79.Public;
        end;

        if not u10.Loadouts then
            return;
        end;

        local v80 = TableUtil:CloneTable(u10);
        v80.Public = not v80.Public;
        u60(v80);
    end, 1.3, 1.5);
    ButtonClass.new(u5.ClearWalls, "BackgroundColor3", function() -- Line: 407
        -- upvalues: os_clock_ret (ref), u74 (ref)
        local os_clock_ret2 = os.clock();

        if os_clock_ret2 - os_clock_ret < 2 then
            return;
        end;

        os_clock_ret = os_clock_ret2;
        u74:FireServer("ClearWalls");
    end, 1.3, 1.5);
    ButtonClass.new(u5.ForceStart, "BackgroundColor3", function() -- Line: 414
        -- upvalues: u74 (ref)
        u74:FireServer("ForceStart");
    end, 1.3, 1.5);
    ButtonClass.new(u5.ShuffleTeams, "BackgroundColor3", function() -- Line: 418
        -- upvalues: os_clock_ret (ref), u74 (ref)
        local os_clock_ret2 = os.clock();

        if os_clock_ret2 - os_clock_ret < 2 then
            return;
        end;

        os_clock_ret = os_clock_ret2;
        u74:FireServer("ShuffleTeams");
    end, 1.3, 1.5);
    ButtonClass.new(u5.AutoStart, "BackgroundColor3", function() -- Line: 425
        -- upvalues: u10 (ref), TableUtil (copy), u60 (copy)
        local function _(p81) -- Line: 426
            p81.AutoStart = not p81.AutoStart;
        end;

        if not u10.Loadouts then
            return;
        end;

        local v82 = TableUtil:CloneTable(u10);
        v82.AutoStart = not v82.AutoStart;
        u60(v82);
    end, 1.3, 1.5);
    ButtonClass.new(u5.HealthRegen, "BackgroundColor3", function() -- Line: 430
        -- upvalues: u10 (ref), TableUtil (copy), u60 (copy)
        local function _(p83) -- Line: 431
            p83.HealthRegen = not p83.HealthRegen;
        end;

        if not u10.Loadouts then
            return;
        end;

        local v84 = TableUtil:CloneTable(u10);
        v84.HealthRegen = not v84.HealthRegen;
        u60(v84);
    end, 1.3, 1.5);
    ButtonClass.new(u5.Downing, "BackgroundColor3", function() -- Line: 436
        -- upvalues: u10 (ref), TableUtil (copy), u60 (copy)
        local function _(p85) -- Line: 437
            p85.Downing = not p85.Downing;
        end;

        if not u10.Loadouts then
            return;
        end;

        local v86 = TableUtil:CloneTable(u10);
        v86.Downing = not v86.Downing;
        u60(v86);
    end, 1.3, 1.5);
    ButtonClass.new(u5.AutoRotate, "BackgroundColor3", function() -- Line: 441
        -- upvalues: u10 (ref), TableUtil (copy), u60 (copy)
        local function _(p87) -- Line: 442
            p87.AutoRotate = not p87.AutoRotate;
        end;

        if not u10.Loadouts then
            return;
        end;

        local v88 = TableUtil:CloneTable(u10);
        v88.AutoRotate = not v88.AutoRotate;
        u60(v88);
    end, 1.3, 1.5);
    ButtonClass.new(u5.SplitTeams, "BackgroundColor3", function() -- Line: 446
        -- upvalues: TableUtil (copy), u10 (ref), u60 (copy)
        local function _(p89) -- Line: 447
            -- upvalues: TableUtil (ref)
            p89.SplitTeams = not p89.SplitTeams;

            if p89.SplitTeams then
                p89.Loadouts.Blue = TableUtil:CloneTable(p89.Loadouts.Red);
            end;
        end;

        if not u10.Loadouts then
            return;
        end;

        local v90 = TableUtil:CloneTable(u10);
        v90.SplitTeams = not v90.SplitTeams;

        if v90.SplitTeams then
            v90.Loadouts.Blue = TableUtil:CloneTable(v90.Loadouts.Red);
        end;

        u60(v90);
    end, 1.3, 1.5);

    for _, v in u20 do
        ButtonClass.new(u4:WaitForChild("TeamTabs"):WaitForChild(v), "BackgroundColor3", function() -- Line: 456
            -- upvalues: u10 (ref), u13 (ref), v (copy), u60 (copy)
            if not u10.Loadouts or u13 == v then
                return;
            end;

            u13 = v;
            u60(u10);
        end, 1.3, 1.5);
    end;

    local function v94(u91: userdata, u92: any) -- Line: 464
        -- upvalues: u8 (ref), UserInputService (copy)
        u91:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 465
            -- upvalues: u91 (copy)
            local v93 = u91.Text:gsub("%D", ""):sub(1, 5);

            if v93 ~= u91.Text then
                u91.Text = v93;
            end;
        end);
        u91.FocusLost:Connect(function() -- Line: 471
            -- upvalues: u8 (ref), UserInputService (ref), u92 (copy), u91 (copy)
            shared.LastTextBoxFocused = tick();

            if u8 then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
                UserInputService.MouseIconEnabled = true;
            end;

            u92((tonumber(u91.Text)));
        end);
    end;

    u5.TimeLimitLabel.Text = `Time Limit (in seconds, max {ArenaSettings.MaxTimeLimit}):`;
    v94(u5.TimeLimitInput, function(u95: number?) -- Line: 482
        -- upvalues: ArenaSettings (copy), u10 (ref), TableUtil (copy), u60 (copy)
        local function _(p96) -- Line: 483
            -- upvalues: u95 (copy), ArenaSettings (ref)
            p96.TimeLimit = (not u95 or u95 <= 0) and 0 or math.clamp(u95, ArenaSettings.MinTimeLimit, ArenaSettings.MaxTimeLimit);
        end;

        if not u10.Loadouts then
            return;
        end;

        local v97 = TableUtil:CloneTable(u10);
        v97.TimeLimit = (not u95 or u95 <= 0) and 0 or math.clamp(u95, ArenaSettings.MinTimeLimit, ArenaSettings.MaxTimeLimit);
        u60(v97);
    end);
    local Attachments = u5:WaitForChild("Attachments");

    for i, v in ArenaSettings.Attachments do
        local v98 = Attachments:WaitForChild("Template"):Clone();
        v98.Name = `Attachment{v}`;
        v98.LayoutOrder = i;
        v98.Text = Items[v].Name;
        v98.Visible = true;
        v98.Parent = Attachments;
        u16[v] = {
            Button = v98,
            Name = Items[v].Name,
            Class = ButtonClass.new(v98, "BackgroundColor3", function() -- Line: 498
                -- upvalues: u13 (ref), v (copy), ArenaSettings (copy), u12 (ref), u10 (ref), TableUtil (copy), u60 (copy)
                local function _(p99) -- Line: 499
                    -- upvalues: u13 (ref), v (ref), ArenaSettings (ref), u12 (ref)
                    if p99.AutoRotate then
                        return;
                    end;

                    local v100 = p99.Loadouts[u13];
                    local v101 = tostring(v);
                    local AttachmentMax = ArenaSettings.GetAttachmentMax(v, u12 and u12.KitGuns[v100.Weapon] or {});
                    local v102 = (v100.Attachments[v101] or 0) + 1;

                    if v102 > AttachmentMax then
                        v102 = nil;
                    end;

                    v100.Attachments[v101] = v102;
                end;

                if not u10.Loadouts then
                    return;
                end;

                local v103 = TableUtil:CloneTable(u10);

                if not v103.AutoRotate then
                    local v104 = v103.Loadouts[u13];
                    local v105 = tostring(v);
                    local AttachmentMax = ArenaSettings.GetAttachmentMax(v, u12 and u12.KitGuns[v104.Weapon] or {});
                    local v106 = (v104.Attachments[v105] or 0) + 1;

                    if v106 > AttachmentMax then
                        v106 = nil;
                    end;

                    v104.Attachments[v105] = v106;
                end;

                u60(v103);
            end, 1.3, Color3.fromRGB(0, 83, 127))
        };
    end;

    local Ammo = u5:WaitForChild("Ammo");
    local v107 = {};

    for _, v in ArenaSettings.AmmoTypeOrder do
        for _, v2 in ArenaSettings.AmmoByType[v] or {} do
            table.insert(v107, v2);
        end;
    end;

    for i, v in ArenaSettings.AmmoByType do
        if not table.find(ArenaSettings.AmmoTypeOrder, i) then
            for _, v2 in v do
                table.insert(v107, v2);
            end;
        end;
    end;

    for i, v in v107 do
        local v108 = Ammo:WaitForChild("Template"):Clone();
        v108.Name = `Ammo{v}`;
        v108.LayoutOrder = i;
        v108.Text = Items[v].Name;
        v108.Visible = false;
        v108.Parent = Ammo;
        u18[v] = {
            Button = v108,
            Class = ButtonClass.new(v108, "BackgroundColor3", function() -- Line: 532
                -- upvalues: u13 (ref), v (copy), u10 (ref), TableUtil (copy), u60 (copy)
                local function _(p109) -- Line: 533
                    -- upvalues: u13 (ref), v (ref)
                    if p109.AutoRotate then
                        return;
                    end;

                    local v110 = p109.Loadouts[u13];
                    local v111 = tostring(v);
                    v110.Ammo[v111] = not v110.Ammo[v111] and true or nil;
                end;

                if not u10.Loadouts then
                    return;
                end;

                local v112 = TableUtil:CloneTable(u10);

                if not v112.AutoRotate then
                    local v113 = v112.Loadouts[u13];
                    local v114 = tostring(v);
                    v113.Ammo[v114] = not v113.Ammo[v114] and true or nil;
                end;

                u60(v112);
            end, 1.3, Color3.fromRGB(0, 83, 127))
        };
    end;

    local Equipment = u5:WaitForChild("Equipment");

    for i, v in ArenaSettings.Equipment do
        local v115 = Equipment:WaitForChild("Template"):Clone();
        v115.Name = `Equipment{v}`;
        v115.LayoutOrder = i;
        v115.Label.Text = `{Items[v].Name:gsub("^External ", "")}:`;
        v115.Visible = true;
        v115.Parent = Equipment;
        u17[v] = v115;
        v94(v115.Input, function(u116: number?) -- Line: 552
            -- upvalues: ArenaSettings (copy), v (copy), u12 (ref), u13 (ref), u10 (ref), TableUtil (copy), u60 (copy)
            local function _(p117) -- Line: 553
                -- upvalues: ArenaSettings (ref), v (ref), u12 (ref), u13 (ref), u116 (copy)
                local EquipmentMax = ArenaSettings.GetEquipmentMax(v, u12 and u12.MaxStackMult or 1);
                local Equipment2 = p117.Loadouts[u13].Equipment;
                local v118 = tostring(v);
                local v119;

                if u116 and u116 > 0 then
                    v119 = math.min(u116, EquipmentMax);
                else
                    v119 = nil;
                end;

                Equipment2[v118] = v119;
            end;

            if not u10.Loadouts then
                return;
            end;

            local v120 = TableUtil:CloneTable(u10);
            local EquipmentMax = ArenaSettings.GetEquipmentMax(v, u12 and u12.MaxStackMult or 1);
            local Equipment2 = v120.Loadouts[u13].Equipment;
            local v121 = tostring(v);
            local v122;

            if u116 and u116 > 0 then
                v122 = math.min(u116, EquipmentMax);
            else
                v122 = nil;
            end;

            Equipment2[v121] = v122;
            u60(v120);
        end);
    end;

    local u123 = u4;

    local function v126() -- Line: 85
        -- upvalues: u123 (copy)
        local v124 = u123.AbsoluteSize.Y / (u123:GetAttribute("TextReferenceHeight") or 311);

        for _, descendant in pairs(u123:GetDescendants()) do
            local v125 = descendant:IsA("UITextSizeConstraint") and descendant:GetAttribute("BaseMaxTextSize");

            if v125 then
                local math_round_ret = math.round(v125 * v124);
                descendant.MaxTextSize = math.max(1, math_round_ret);
            end;
        end;
    end;

    v126();
    u123:GetPropertyChangedSignal("AbsoluteSize"):Connect(v126);
    u74.OnClientEvent:Connect(function(p127, ...) -- Line: 561
        -- upvalues: u2 (ref), UserInputService (copy), u3 (ref), u12 (ref), u7 (ref), u19 (copy), u5 (ref), u9 (copy), ButtonClass (copy), u13 (ref), ArenaSettings (copy), u30 (copy), u10 (ref), TableUtil (copy), u60 (copy), u27 (ref), u11 (ref), u8 (ref), u4 (ref), u69 (copy)
        if p127 ~= "ShowPrivate" then
            if p127 == "HidePrivate" then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                UserInputService.MouseIconEnabled = false;
                u2.Visible = false;

                if u3:IsFocused() then
                    u3:ReleaseFocus();

                    return;
                end;
            else
                if p127 == "ChangeTextPrivate" then
                    u2.Detail.Text = ...;

                    return;
                end;

                if p127 == "ShowSettings" then
                    local v128, v129, v130 = ...;

                    if type(v130) == "table" then
                        u12 = v130;
                    end;

                    if type(v129) == "table" and not u7 then
                        u7 = true;

                        for i, v in pairs(u19) do
                            local v131 = u5[`{v}Kits`];
                            local v132 = i;
                            local u133 = v;

                            for i2 = 1, #v129[i] do
                                local v134;

                                if i2 == 1 then
                                    v134 = v131.Kit1;
                                else
                                    v134 = false;
                                end;

                                if not v134 then
                                    v134 = v131.Kit1:Clone();
                                    v134.Name = `Kit{i2}`;
                                    v134.Parent = v131;
                                    v134.Visible = true;
                                end;

                                v134.Text = v129[v132][i2];
                                u9[v134] = ButtonClass.new(v134, "BackgroundColor3", function() -- Line: 592
                                    -- upvalues: u13 (ref), u133 (copy), i2 (copy), ArenaSettings (ref), u30 (ref), u12 (ref), u10 (ref), TableUtil (ref), u60 (ref)
                                    local function _(p135) -- Line: 593
                                        -- upvalues: u13 (ref), u133 (ref), i2 (ref), ArenaSettings (ref), u30 (ref), u12 (ref)
                                        if p135.AutoRotate then
                                            return;
                                        end;

                                        local v136 = p135.Loadouts[u13];
                                        v136[u133] = i2;
                                        ArenaSettings.SanitizeLoadout(v136, u30, u12 and u12.MaxStackMult or 1);
                                    end;

                                    if not u10.Loadouts then
                                        return;
                                    end;

                                    local v137 = TableUtil:CloneTable(u10);

                                    if not v137.AutoRotate then
                                        local v138 = v137.Loadouts[u13];
                                        v138[u133] = i2;
                                        ArenaSettings.SanitizeLoadout(v138, u30, u12 and u12.MaxStackMult or 1);
                                    end;

                                    u60(v137);
                                end, 1.3, Color3.fromRGB(0, 83, 127));
                                local _ = i2;
                            end;
                        end;
                    end;

                    if u7 and (type(v128) == "table" and (not u10.Loadouts or u27)) then
                        if u27 then
                            u27 = false;
                            u13 = "Red";
                            u5.PasswordInput.Text = "";
                        end;

                        u11 = TableUtil:CloneTable(v128);
                        u60(v128);
                    end;

                    local v139 = not u8;
                    u8 = v139;
                    u4.Visible = v139;

                    if v139 then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
                        UserInputService.MouseIconEnabled = true;

                        return;
                    end;

                    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                    UserInputService.MouseIconEnabled = false;

                    return;
                end;

                if p127 == "UpdateSettings" then
                    local v140 = ...;

                    if type(v140) ~= "table" then
                        return;
                    end;

                    u11 = TableUtil:CloneTable(v140);
                    u60(v140);

                    return;
                end;

                if p127 == "PlayerList" then
                    local v141, v142 = ...;

                    if not (v141 and v142) then
                        return;
                    end;

                    u69(v141, v142);
                end;
            end;

            return;
        end;

        u2.Detail.Text = "THIS ARENA IS PRIVATED WITH A PASSWORD. PLEASE ENTER IT TO JOIN:";
        u2.Password.Text = "";
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
        u2.Visible = true;
    end);
    LocalPlayer:GetAttributeChangedSignal("CombatReady"):Connect(v71);
    LocalPlayer:GetAttributeChangedSignal("IsArenaOwner"):Connect(v72);
    LocalPlayer:GetAttributeChangedSignal("ArenaName"):Connect(v73);

    for _, v in { "IsArenaOwner", "ArenaIndex" } do
        LocalPlayer:GetAttributeChangedSignal(v):Connect(function() -- Line: 632
            -- upvalues: u27 (ref), u8 (ref), u4 (ref), UserInputService (copy)
            u27 = true;

            if u8 then
                u8 = false;
                u4.Visible = false;
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                UserInputService.MouseIconEnabled = false;
            end;
        end);
    end;

    u74:FireServer("FetchPlayerList");
    v71();
    local Attribute = LocalPlayer:GetAttribute("IsArenaOwner");
    u1.IsOwner.Visible = Attribute == true;
    u1.ArenaName.Text = LocalPlayer:GetAttribute("ArenaName") or "";
    u8 = false;
    u4.Visible = false;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    CombatServer.Visible = true;
elseif Value == "Build" then
    u1 = BuildServer;
    u2 = u1:WaitForChild("Private");
    u3 = u2:WaitForChild("Password");
    u4 = u1:WaitForChild("Settings");
    u5 = u4:WaitForChild("MainFrame");
    u6 = u5:WaitForChild("PlayerList");
    BuildCost = u1:WaitForChild("BuildCost");
    BuildMats = BuildCost:WaitForChild("Materials");
    local u143;

    while true do
        u143 = ReplicatedStorage:FindFirstChild("CombatServerRemote");

        if u143 then
            break;
        end;

        task.wait();
    end;

    local SaveStatus = u5:WaitForChild("SaveStatus");
    local OwnerNotice = u5:WaitForChild("OwnerNotice");
    local Slot = u5:WaitForChild("Slot");
    local Confirm = u4:WaitForChild("Confirm");
    local u144 = {};
    local u145 = {};
    local u146 = {};
    local u147 = u4;

    local function v150() -- Line: 85
        -- upvalues: u147 (copy)
        local v148 = u147.AbsoluteSize.Y / (u147:GetAttribute("TextReferenceHeight") or 311);

        for _, descendant in pairs(u147:GetDescendants()) do
            local v149 = descendant:IsA("UITextSizeConstraint") and descendant:GetAttribute("BaseMaxTextSize");

            if v149 then
                local math_round_ret = math.round(v149 * v148);
                descendant.MaxTextSize = math.max(1, math_round_ret);
            end;
        end;
    end;

    v150();
    u147:GetPropertyChangedSignal("AbsoluteSize"):Connect(v150);

    local function _(p151: string) -- Line: 675
        local v152 = p151:match("^Terrain(%d+)$");

        if v152 then
            return `TERRAIN ARENA #{v152}`;
        end;

        return `{p151:upper()} ARENA`;
    end;

    local function u156(p153: userdata, p154: any, p155: boolean) -- Line: 680
        if p154.Enabled == p155 then
            return;
        end;

        local Attribute = p153:GetAttribute("OrigColor");

        if not Attribute then
            Attribute = p154.OrigColor;
            p153:SetAttribute("OrigColor", Attribute);
        end;

        if not p155 then
            Attribute = Attribute:Lerp(Color3.fromRGB(45, 45, 45), 0.75);
        end;

        p154:Enable(p155);
        p154:UpdateBaseColor(Attribute);
        p153.BackgroundColor3 = Attribute;
        p153.TextTransparency = p155 and 0 or 0.6;
    end;

    local function _(p157: string, p158: any) -- Line: 694
        -- upvalues: u28 (ref), Confirm (copy)
        u28 = p158;
        Confirm.Box.Detail.Text = p157;
        Confirm.Visible = true;
    end;

    local function v159() -- Line: 700
        -- upvalues: u28 (ref), Confirm (copy)
        u28 = nil;
        Confirm.Visible = false;
    end;

    local function u160(...) -- Line: 705
        -- upvalues: u26 (ref), u24 (ref), u25 (ref), u143 (ref)
        local os_clock_ret2 = os.clock();

        if os_clock_ret2 - u26 < 1.1 then
            return;
        end;

        u26 = os_clock_ret2;
        u24 = "SENDING REQUEST...";
        u25 = os_clock_ret2;
        u143:FireServer(...);
    end;

    local function _() -- Line: 714
        -- upvalues: u22 (ref), u26 (ref), u143 (ref)
        u22 = nil;
        u26 = os.clock();
        u143:FireServer("FetchSaveInfo");
    end;

    local function u182() -- Line: 721
        -- upvalues: LocalPlayer (copy), u22 (ref), u23 (ref), u144 (copy), u156 (copy), u27 (ref), u5 (ref), OwnerNotice (copy), u4 (ref), u24 (ref), u25 (ref), SaveStatus (copy), u145 (copy), Slot (copy), ButtonClass (copy), u160 (copy), u28 (ref), Confirm (copy), u182 (ref), u146 (copy), NumberUtil (copy)
        local v161 = LocalPlayer:GetAttribute("IsArenaOwner") == true;
        local v162 = u22 and u22.Busy;
        local v163 = u23 and os.clock() - u23 or 0;
        local v164 = {};

        for i, v in u22 and u22.Cooldowns or {} do
            local math_ceil_ret = math.ceil(v - v163);
            v164[i] = math.max(math_ceil_ret, 0);
        end;

        for i, v in u144 do
            local v165 = v161 and not u27;

            if v165 then
                if i == u5.ClearArena then
                    v165 = not (v162 or (v164.Clear or 0) > 0);
                else
                    v165 = true;
                end;
            end;

            u156(i, v, v165);
        end;

        u5.PasswordInput.TextEditable = v161;
        OwnerNotice.Visible = not v161;

        if v161 then
            if v162 then
                OwnerNotice.Visible = true;
                OwnerNotice.Text = `CAN'T CLEAR, ARENA IS CURRENTLY {v162}`;
            elseif (v164.Clear or 0) > 0 then
                OwnerNotice.Visible = true;
                OwnerNotice.Text = `CAN CLEAR AGAIN IN {v164.Clear}s`;
            end;
        else
            u4.Apply.Visible = false;
            OwnerNotice.Text = "ONLY THE ARENA OWNER CAN CHANGE THESE SETTINGS";
        end;

        local v166 = u22 and u22.Slots;

        if u24 and os.clock() - u25 < 6 then
            SaveStatus.Text = u24;
        elseif u22 then
            if v166 then
                if v162 then
                    SaveStatus.Text = `THE ARENA IS CURRENTLY {v162}...`;
                else
                    SaveStatus.Text = `YOU'RE IN A <font color="rgb(255, 204, 0)">{u22.ArenaType}</font>`;
                end;
            else
                SaveStatus.Text = "FAILED TO LOAD YOUR SAVES, REOPEN SETTINGS TO TRY AGAIN";
            end;
        else
            SaveStatus.Text = "LOADING YOUR SAVES...";
        end;

        for i, v in u145 do
            local v167;

            if v166 then
                v167 = v166[i] ~= nil;
            else
                v167 = v166;
            end;

            v.Visible = v167;
        end;

        if not v166 then
            return;
        end;

        for i, v in v166 do
            local v168 = u145[i];

            if not v168 then
                v168 = Slot:Clone();
                v168.Name = `Slot{i}`;
                v168.Position = UDim2.new(Slot.Position.X.Scale, 0, Slot.Position.Y.Scale + (i - 1) * (Slot.Size.Y.Scale + Slot:GetAttribute("Gap")), 0);
                v168.Parent = u5;
                local v170 = ButtonClass.new(v168.Save, "BackgroundColor3", function() -- Line: 774
                    -- upvalues: u22 (ref), i (copy), u160 (ref), u28 (ref), Confirm (ref), u182 (ref)
                    if u22 and u22.Slots and u22.Slots[i] then
                        local v169 = `SAVING TO SLOT {i} WILL OVERWRITE THE SAVE ALREADY IN IT.`;

                        u28 = function() -- Line: 777
                            -- upvalues: u160 (ref), i (ref)
                            u160("SaveArena", i);
                        end;

                        Confirm.Box.Detail.Text = v169;
                        Confirm.Visible = true;
                    else
                        u160("SaveArena", i);
                    end;

                    u182();
                end, 1.3, 1.5);
                local v172 = ButtonClass.new(v168.Load, "BackgroundColor3", function() -- Line: 785
                    -- upvalues: i (copy), u160 (ref), u28 (ref), Confirm (ref)
                    local v171 = `LOADING SLOT {i} WILL CLEAR EVERY BUILD CURRENTLY IN THIS ARENA.`;

                    u28 = function() -- Line: 786
                        -- upvalues: u160 (ref), i (ref)
                        u160("LoadArena", i);
                    end;

                    Confirm.Box.Detail.Text = v171;
                    Confirm.Visible = true;
                end, 1.3, 1.5);
                u145[i] = v168;
                u146[i] = { v170, v172 };
                v168.Visible = true;
            end;

            local v173 = u146[i];

            if v then
                local Info = v168.Info;
                local v174 = tostring(v.ArenaType);
                local v175 = v174:match("^Terrain(%d+)$");
                local v176;

                if v175 then
                    v176 = `TERRAIN ARENA #{v175}`;
                else
                    v176 = `{v174:upper()} ARENA`;
                end;

                Info.Text = `SLOT {i} - <font color="rgb(255, 204, 0)">{v176}</font>\nBY {tostring(v.OwnerName)} • {os.date("%m/%d/%Y", tonumber(v.Time) or 0)} • {NumberUtil:FormatNumber(tonumber(v.Count) or 0)} BUILDS • {NumberUtil:BytesToKB(tonumber(v.Size) or 0)} KB`;
            else
                v168.Info.Text = `SLOT {i} - EMPTY`;
            end;

            local v177 = u22.SaveReason or v162 and `ARENA IS CURRENTLY {v162}`;

            if not v177 then
                if v164.Save > 0 then
                    v177 = `ON COOLDOWN ({v164.Save}s)`;
                else
                    v177 = false;
                end;
            end;

            local v178 = u22.LoadReasons[i] or v162 and `ARENA IS CURRENTLY {v162}`;

            if not v178 then
                if v164.Load > 0 then
                    v178 = `ON COOLDOWN ({v164.Load}s)`;
                else
                    v178 = false;
                end;
            end;

            u156(v168.Save, v173[1], not v177);
            u156(v168.Load, v173[2], not v178);
            local v179 = {};

            if v177 then
                local v180 = `CAN'T SAVE: {v177}`;
                table.insert(v179, v180);
            end;

            if v178 then
                local v181 = `CAN'T LOAD: {v178}`;
                table.insert(v179, v181);
            end;

            v168.Reason.Text = table.concat(v179, "\n");
        end;
    end;

    u3.FocusLost:Connect(function() -- Line: 815
        -- upvalues: u2 (ref), UserInputService (copy)
        shared.LastTextBoxFocused = tick();

        if not u2.Visible then
            return;
        end;

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
    end);
    u3:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 821
        -- upvalues: u3 (ref), u2 (ref)
        local v183 = u3.Text:sub(1, 20);
        u3.Text = v183;
        u2.Enter.Visible = v183:len() > 0;
    end);
    ButtonClass.new(u2.Enter, "BackgroundColor3", function() -- Line: 827
        -- upvalues: u3 (ref), os_clock_ret (ref), u2 (ref), u143 (ref)
        local Text = u3.Text;
        local os_clock_ret2 = os.clock();

        if Text:len() <= 0 or (Text:len() > 20 or os_clock_ret2 - os_clock_ret < 2) then
            return;
        end;

        os_clock_ret = os_clock_ret2;
        u2.Detail.Text = "...";
        u143:FireServer("EnterPass", Text);
    end, 1.3, 1.5);
    ButtonClass.new(u2.Cancel, "BackgroundColor3", function() -- Line: 835
        -- upvalues: u143 (ref), UserInputService (copy), u2 (ref), u3 (ref)
        u143:FireServer("CancelPass");
        task.wait();
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
        u2.Visible = false;

        if u3:IsFocused() then
            u3:ReleaseFocus();
        end;
    end, 1.3, 1.5);
    ButtonClass.new(u4.Close, "BackgroundColor3", function() -- Line: 841
        -- upvalues: u28 (ref), Confirm (copy), u8 (ref), u4 (ref), UserInputService (copy)
        u28 = nil;
        Confirm.Visible = false;
        u8 = false;
        u4.Visible = false;
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
    end, 1.3, 1.5);
    ButtonClass.new(u4.Apply, "BackgroundColor3", function() -- Line: 846
        -- upvalues: u10 (ref), u27 (ref), LocalPlayer (copy), os_clock_ret (ref), u143 (ref), u5 (ref)
        if #u10 ~= 4 or (u27 or not LocalPlayer:GetAttribute("IsArenaOwner")) then
            return;
        end;

        local os_clock_ret2 = os.clock();

        if os_clock_ret2 - os_clock_ret < 2 then
            return;
        end;

        os_clock_ret = os_clock_ret2;
        u143:FireServer("UpdateSettings", u10, u5.PasswordInput.Text);
    end, 1.3, 1.5);
    u5:WaitForChild("PasswordInput"):GetPropertyChangedSignal("Text"):Connect(function() -- Line: 854
        -- upvalues: u5 (ref)
        local v184 = u5.PasswordInput.Text:sub(1, 20);
        u5.PasswordInput.Text = v184;
    end);
    u5.PasswordInput.FocusLost:Connect(function() -- Line: 858
        -- upvalues: u8 (ref), UserInputService (copy), u63 (copy), u10 (ref)
        shared.LastTextBoxFocused = tick();

        if not u8 then
            return;
        end;

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
        u63(u10);
    end);
    u144[u5.Public] = ButtonClass.new(u5.Public, "BackgroundColor3", function() -- Line: 866
        -- upvalues: u10 (ref), u63 (copy)
        local table_clone_ret = table.clone(u10);
        table_clone_ret[1] = not table_clone_ret[1];
        u63(table_clone_ret);
    end, 1.3, 1.5);
    u144[u5.CostBaseParts] = ButtonClass.new(u5.CostBaseParts, "BackgroundColor3", function() -- Line: 872
        -- upvalues: u10 (ref), u63 (copy)
        local table_clone_ret = table.clone(u10);
        table_clone_ret[2] = not table_clone_ret[2];
        u63(table_clone_ret);
    end, 1.3, 1.5);
    u144[u5.CostDeployables] = ButtonClass.new(u5.CostDeployables, "BackgroundColor3", function() -- Line: 877
        -- upvalues: u10 (ref), u63 (copy)
        local table_clone_ret = table.clone(u10);
        table_clone_ret[3] = not table_clone_ret[3];
        u63(table_clone_ret);
    end, 1.3, 1.5);
    u144[u5.AllowMemberSaves] = ButtonClass.new(u5.AllowMemberSaves, "BackgroundColor3", function() -- Line: 882
        -- upvalues: u10 (ref), u63 (copy)
        local table_clone_ret = table.clone(u10);
        table_clone_ret[4] = not table_clone_ret[4];
        u63(table_clone_ret);
    end, 1.3, 1.5);
    u144[u5.ClearArena] = ButtonClass.new(u5.ClearArena, "BackgroundColor3", function() -- Line: 887
        -- upvalues: u160 (copy), u28 (ref), Confirm (copy)
        u28 = function() -- Line: 888
            -- upvalues: u160 (ref)
            u160("ClearArena");
        end;

        Confirm.Box.Detail.Text = "CLEARING WILL REMOVE EVERY BUILD CURRENTLY IN THIS ARENA.";
        Confirm.Visible = true;
    end, 1.3, 1.5);
    ButtonClass.new(Confirm.Box.Accept, "BackgroundColor3", function() -- Line: 892
        -- upvalues: u28 (ref), Confirm (copy), u182 (ref)
        local v185 = u28;
        u28 = nil;
        Confirm.Visible = false;

        if v185 then
            v185();
        end;

        u182();
    end, 1.3, 1.5);
    ButtonClass.new(Confirm.Box.Cancel, "BackgroundColor3", v159, 1.3, 1.5);
    ButtonClass.new(BuildCost.Close, "BackgroundColor3", function() -- Line: 901
        -- upvalues: UserInputService (copy)
        BuildCost.Visible = false;
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
    end, 1.3, 1.5);
    u143.OnClientEvent:Connect(function(p186, ...) -- Line: 908
        -- upvalues: u2 (ref), UserInputService (copy), u3 (ref), u10 (ref), u27 (ref), LocalPlayer (copy), u11 (ref), u63 (copy), u8 (ref), u4 (ref), u28 (ref), Confirm (copy), u22 (ref), u26 (ref), u143 (ref), u182 (ref), u23 (ref), u24 (ref), u25 (ref), u69 (copy), Items (copy), NumberUtil (copy)
        if p186 ~= "ShowPrivate" then
            if p186 == "HidePrivate" then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                UserInputService.MouseIconEnabled = false;
                u2.Visible = false;

                if u3:IsFocused() then
                    u3:ReleaseFocus();

                    return;
                end;
            else
                if p186 == "ChangeTextPrivate" then
                    u2.Detail.Text = ...;

                    return;
                end;

                if p186 == "ShowSettings" then
                    local v187 = ...;

                    if v187 and (#u10 == 0 or (u27 or not LocalPlayer:GetAttribute("IsArenaOwner"))) then
                        u27 = false;
                        u11 = table.clone(v187);
                        u63(v187);
                    end;

                    local v188 = not u8;
                    u8 = v188;
                    u4.Visible = v188;

                    if v188 then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
                        UserInputService.MouseIconEnabled = true;
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
                        UserInputService.MouseIconEnabled = false;
                    end;

                    u28 = nil;
                    Confirm.Visible = false;

                    if u8 then
                        u22 = nil;
                        u26 = os.clock();
                        u143:FireServer("FetchSaveInfo");
                    end;

                    u182();

                    return;
                end;

                if p186 == "UpdateSettings" then
                    local v189 = ...;

                    if type(v189) ~= "table" then
                        return;
                    end;

                    u11 = table.clone(v189);
                    u63(v189);

                    return;
                end;

                if p186 == "SaveInfo" then
                    local v190 = ...;

                    if type(v190) ~= "table" then
                        return;
                    end;

                    u22 = v190;
                    u23 = os.clock();

                    if u24 == "SENDING REQUEST..." then
                        u24 = nil;
                    end;

                    if type(v190.Settings) == "table" and (u27 or not v190.IsOwner) then
                        u27 = false;
                        u11 = table.clone(v190.Settings);
                        u63(v190.Settings);
                    end;

                    u182();

                    return;
                end;

                if p186 == "SaveMessage" then
                    local v191 = ...;

                    if type(v191) ~= "string" then
                        return;
                    end;

                    u24 = v191;
                    u25 = os.clock();
                    u182();

                    return;
                end;

                if p186 == "PlayerList" then
                    local v192, v193 = ...;

                    if not (v192 and v193) then
                        return;
                    end;

                    u69(v192, v193);

                    return;
                end;

                if p186 == "BuildCost" then
                    local v194 = ...;

                    if type(v194) ~= "table" then
                        return;
                    end;

                    for _, child in BuildMats:GetChildren() do
                        if child.Name ~= "C" then
                            child:Destroy();
                        end;
                    end;

                    local math_max_ret = math.max(#v194 * 0.08, 1);
                    BuildMats.C.Size = UDim2.new(1, 0, 0.08 / math_max_ret, 0);
                    BuildMats.CanvasSize = UDim2.new(0, 0, math_max_ret * 0.94 - 0.001, 0);
                    local v195 = -1;

                    for _, v in v194 do
                        local Amount = v.Amount;
                        local v196 = Items[v.ID];

                        if v196 then
                            v195 = v195 + 1;
                            local v197 = BuildMats.C:Clone();
                            v197.ItemName.Text = v196.Name;
                            v197.Amount.Text = NumberUtil:FormatNumber(Amount);
                            local ItemImage = v197.ItemImage;
                            local v198;

                            if type(v196.Image) == "table" then
                                v198 = v196.Image.Default;
                            else
                                v198 = v196.Image;
                            end;

                            ItemImage.Image = v198;
                            v197.Position = UDim2.new(0, 0, v195 * 0.08 / math_max_ret, 0);
                            v197.Name = `Cost{v195 + 1}`;
                            v197.Parent = BuildMats;
                            v197.Visible = true;
                        end;
                    end;

                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
                    UserInputService.MouseIconEnabled = true;
                    BuildCost.Visible = true;
                end;
            end;

            return;
        end;

        u2.Detail.Text = "THIS ARENA IS PRIVATED WITH A PASSWORD. PLEASE ENTER IT TO JOIN:";
        u2.Password.Text = "";
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
        u2.Visible = true;
    end);

    local function v200() -- Line: 997
        -- upvalues: LocalPlayer (copy), u1 (ref)
        local v199 = LocalPlayer:GetAttribute("IsArenaOwner") == true;
        u1.IsOwner.Text = v199 and "YOU ARE THE ARENA OWNER - TYPE /settings FOR CONFIGS" or "TYPE /settings FOR CONFIGS";
        u1.IsOwner.Visible = v199 or LocalPlayer:GetAttribute("ArenaName") ~= nil;
    end;

    LocalPlayer:GetAttributeChangedSignal("IsArenaOwner"):Connect(v200);
    LocalPlayer:GetAttributeChangedSignal("ArenaName"):Connect(function() -- Line: 1003
        -- upvalues: u1 (ref), LocalPlayer (copy)
        u1.ArenaName.Text = LocalPlayer:GetAttribute("ArenaName") or "";
        local v201 = LocalPlayer:GetAttribute("IsArenaOwner") == true;
        u1.IsOwner.Text = v201 and "YOU ARE THE ARENA OWNER - TYPE /settings FOR CONFIGS" or "TYPE /settings FOR CONFIGS";
        u1.IsOwner.Visible = v201 or LocalPlayer:GetAttribute("ArenaName") ~= nil;
    end);
    u143:FireServer("FetchPlayerList");

    for _, v in { "IsArenaOwner", "ArenaIndex" } do
        LocalPlayer:GetAttributeChangedSignal(v):Connect(function() -- Line: 1010
            -- upvalues: u27 (ref), u28 (ref), Confirm (copy), u8 (ref), u22 (ref), u26 (ref), u143 (ref), u182 (ref)
            u27 = true;
            u28 = nil;
            Confirm.Visible = false;

            if not u8 then
                return;
            end;

            u22 = nil;
            u26 = os.clock();
            u143:FireServer("FetchSaveInfo");
            u182();
        end);
    end;

    task.spawn(function() -- Line: 1018
        -- upvalues: u8 (ref), u182 (ref)
        while script.Parent do
            task.wait(0.5);

            if u8 then
                u182();
            end;
        end;
    end);
    local v202 = LocalPlayer:GetAttribute("IsArenaOwner") == true;
    u1.IsOwner.Text = v202 and "YOU ARE THE ARENA OWNER - TYPE /settings FOR CONFIGS" or "TYPE /settings FOR CONFIGS";
    u1.IsOwner.Visible = v202 or LocalPlayer:GetAttribute("ArenaName") ~= nil;
    u1.ArenaName.Text = LocalPlayer:GetAttribute("ArenaName") or "";
    u8 = false;
    u4.Visible = false;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    BuildServer.Visible = true;
end;