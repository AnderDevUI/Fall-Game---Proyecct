-- [PATH] ReplicatedStorage / CharacterScripts / StatsController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("UserInputService");
game:GetService("RunService");
local Lighting = game:GetService("Lighting");
local Modules = ReplicatedStorage:WaitForChild("Modules");
require(Modules:WaitForChild("Items"));
local TweenUtil = require(Modules:WaitForChild("TweenUtil"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local StatusClass = require(Modules:WaitForChild("StatusClass"));
require(Modules:WaitForChild("RaycastUtil"));
local ViewportModule = require(Modules:WaitForChild("ViewportModule"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local v1 = require(Modules:WaitForChild("AssetContainer"))();
local Blur = Lighting:WaitForChild("Blur");
local ColorCorrection = Lighting:WaitForChild("ColorCorrection");
local Color3_fromRGB_ret = Color3.fromRGB(255, 165, 150);
local Radiation = script:WaitForChild("Radiation");
local CraftUpdate = script:WaitForChild("CraftUpdate");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Humanoid = script_Parent:WaitForChild("Humanoid");
local _ = workspace.CurrentCamera;
local Main = PlayerGui:WaitForChild("Main");
local Stats = Main:WaitForChild("Stats");
Stats:WaitForChild("Health");
Stats:WaitForChild("Hunger");
Stats:WaitForChild("Thirst");
local Cold = Main:WaitForChild("Cold");
local Hot = Main:WaitForChild("Hot");
local Armor = Main:WaitForChild("Inventory"):WaitForChild("Armor");
local ViewportFrame = Armor:WaitForChild("ViewportFrame");
local HitboxHead = Armor:WaitForChild("HitboxHead");
local HitboxChest = Armor:WaitForChild("HitboxChest");
local HitboxLegs = Armor:WaitForChild("HitboxLegs");
local BulletBars = Armor:WaitForChild("BulletBars");
local BulletDetail = Armor:WaitForChild("BulletDetail");
local MeleeBars = Armor:WaitForChild("MeleeBars");
local MeleeDetail = Armor:WaitForChild("MeleeDetail");
local BulletPercent = Armor:WaitForChild("BulletPercent");
local MeleePercent = Armor:WaitForChild("MeleePercent");
local u2 = StatusClass.new();

if MobileModule.IsTouchDevice() then
    local Template = Stats.Template;
    local v3 = Template.Size.Y.Scale * 1.5;
    Template.Position = UDim2.fromScale(Template.Position.X.Scale, Template.Position.Y.Scale + Template.Size.Y.Scale * 0.5 - v3 * 0.5);
    Template.Size = UDim2.fromScale(Template.Size.X.Scale, v3);
end;

local u4 = Stats.Template.Size.Y.Scale + 0.01;
local u5 = {
    Health = 100,
    Hunger = 100,
    Thirst = 100,
    Bleeding = 100,
    Radiation = 499,
    Comfort = 100,
    Wet = 100,
    Temperature = 40
};
local u6 = {
    BCAccess = {
        Name = "Building Privilege",
        Color = Color3.fromRGB(89, 148, 64)
    },
    BCDenied = {
        Name = "Building Blocked",
        Color = Color3.fromRGB(255, 66, 69)
    },
    InCombat = {
        Name = "In Combat",
        Color = Color3.fromRGB(255, 66, 69)
    },
    Safezone = {
        Name = "Safezone!",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Recipes = {
        Name = "Recipes Available",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Comfort = {
        Color = Color3.fromRGB(89, 148, 64)
    },
    Craft = {
        Name = "Craft",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Wet = {
        Color = Color3.fromRGB(255, 66, 69)
    },
    Drowning = {
        Color = Color3.fromRGB(255, 66, 69)
    },
    Temperature = {
        Color = Color3.fromRGB(255, 66, 69)
    },
    Bleed = {
        Name = "Bleeding",
        Color = Color3.fromRGB(255, 66, 69)
    },
    Radiation = {
        Color = Color3.fromRGB(182, 179, 89)
    },
    Pickup = {
        Remove = "Pickup",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Drop = {
        Remove = "Drop",
        Color = Color3.fromRGB(255, 94, 0)
    },
    Decay = {
        Name = "Building Decaying!",
        Color = Color3.fromRGB(255, 94, 0)
    },
    Health_Buff = {
        Name = "Health Buff",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Node_Buff = {
        Name = "Mining Buff",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Wood_Buff = {
        Name = "Chopping Buff",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Caps_Buff = {
        Name = "Barrel Caps Buff",
        Color = Color3.fromRGB(89, 148, 64)
    },
    Regen_Buff = {
        Name = "Regeneration Buff",
        SkipLabelNumber = true,
        Color = Color3.fromRGB(89, 148, 64)
    }
};
local u7 = {
    Radiation = {
        BlurSize = 8,
        ColorCorrectionLowest = 83
    },
    Health = {
        BlurSize = 4,
        ColorCorrectionLowest = 83
    }
};
tick();
local v8 = tick();
local v9 = tick();
local u10 = {};
local u11 = {
    Head = {
        Bullet = 0,
        Melee = 0
    },
    Chest = {
        Bullet = 0,
        Melee = 0
    },
    Legs = {
        Bullet = 0,
        Melee = 0
    }
};
local u12 = "";
local u13 = 255;

local function u17() -- Line: 221
    -- upvalues: Lighting (copy), Color3_fromRGB_ret (copy), u13 (ref), ColorCorrection (copy)
    local v14 = tonumber(Lighting:GetAttribute("BloodMoon")) or 0;
    local math_clamp_ret = math.clamp(v14, 0, 1);
    local v15 = Color3.new(1, 1, 1):Lerp(Color3_fromRGB_ret, math_clamp_ret);
    local v16 = u13 / 255;
    ColorCorrection.TintColor = Color3.new(v15.R * v16, v15.G * v16, v15.B * v16);
end;

local function u20(p18, p19) -- Line: 227
    -- upvalues: NumberUtil (copy)
    if string.find(p19, "Pickup") then
        return "+" .. math.ceil(p18);
    end;

    if string.find(p19, "Drop") then
        return "-" .. math.ceil(p18);
    end;

    if p19 == "Wet" then
        return "" .. math.ceil(p18) .. "%";
    end;

    if p19 == "Drowning" then
        return "X";
    end;

    if p19 == "BCAccess" then
        return NumberUtil:FormatTime(p18 == -1 and 0 or p18, "Days", "Minutes", true, 2);
    end;

    if p19 == "BCDenied" then
        return "X";
    end;

    if p19 == "InCombat" then
        return "X";
    end;

    if p19 == "Decay" then
        return "X";
    end;

    if p19 == "Craft" then
        return p18 .. "s";
    end;

    if p19 == "Safezone" then
        return "X";
    end;

    if p19 == "Temperature" then
        return "" .. math.ceil(p18) .. "°C";
    end;

    if p19 == "Comfort" then
        return "" .. math.ceil(p18) .. "%";
    end;

    if string.find(p19, "Buff") then
        return NumberUtil:FormatTime(p18 == -1 and 0 or p18, "Minutes", "Seconds", true, 2);
    end;

    local math_ceil_ret = math.ceil(p18);

    return tostring(math_ceil_ret);
end;

local function _(p21) -- Line: 262
    if not p21 then
        return;
    end;

    p21:Destroy();
end;

local function u24(u22, p23) -- Line: 268
    -- upvalues: TweenUtil (copy)
    local Attributes = u22:GetAttributes();

    for i, v in pairs(Attributes) do
        if pcall(function() -- Line: 271
            -- upvalues: u22 (copy), i (copy)
            local _ = u22[i];
        end) then
            TweenUtil:Tween(u22, i, p23 and v and v or 1, 0.4);
        end;
    end;
end;

local function u27(p25, p26) -- Line: 280
    -- upvalues: u24 (copy)
    u24(p26, p25);

    for _, child in pairs(p26:GetChildren()) do
        u24(child, p25);
    end;
end;

local function u38() -- Line: 288
    -- upvalues: u2 (copy), Stats (copy), u4 (copy), TweenUtil (copy), u6 (copy), u12 (ref), u20 (copy), u27 (copy)
    local StatsPickupTableCombined = u2:GetStatsPickupTableCombined();
    local Position = Stats.Template.Position;
    local v28 = { "I", "II", "III", "IV" };

    for i, v in pairs(StatsPickupTableCombined) do
        local v29 = string.find(v[1], "Buff") and true or false;
        local v30 = Stats:FindFirstChild(v[1]);

        if v30 then
            v30:SetAttribute("Reach", typeof(v[2]) == "table" and v[2][2] or v[2]);

            if i ~= v30:GetAttribute("Index") then
                v30:SetAttribute("Index", i);
                TweenUtil:Tween(v30, "Position", UDim2.new(Position.X.Scale, 0, Position.Y.Scale - u4 * (i - 1), 0), 0.4);
            end;

            if v29 then
                local v31 = u6[v[1]];
                v30.StatLabel.Text = v31 and v31.Name or v[1];
                v30.StatLabel.Text = v29 and v30.StatLabel.Text .. " " .. v28[v[2][1]] or v30.StatLabel.Text;
            end;
        else
            local v32 = u6[v[1]];

            if string.find(v[1], "Pickup") then
                v32 = u6.Pickup;
            elseif string.find(v[1], "Drop") then
                v32 = u6.Drop;
            end;

            if v32 then
                local v33 = Stats.Template:Clone();
                v33.Color.BackgroundColor3 = v32.Color;
                v33.Name = v[1];

                if v32.Remove == nil then
                    v33.StatLabel.Text = v[1];
                else
                    local string_gsub_ret = string.gsub(v[1], v32.Remove, "");
                    v33.StatLabel.Text = string_gsub_ret:find(" Trophy") and "Bone Trophy" or string_gsub_ret;
                end;

                v33.StatLabel.Text = v32.Name == "Craft" and u12 or (v32.Name ~= nil and v32.Name or v33.StatLabel.Text);
                v33.StatLabel.Text = v29 and not v32.SkipLabelNumber and v33.StatLabel.Text .. " " .. v28[v[2][1]] or v33.StatLabel.Text;
                local v34 = v29 and v[2][2] or v[2];
                local v35 = u20(v34, v[1]);

                if v35 == "X" then
                    v33.BackColor.Visible = false;
                    v33.Num.Visible = false;
                end;

                v33.Num.Text = v35;
                v33:SetAttribute("CurrentNum", v34);
                v33:SetAttribute("Reach", v34);
                v33:SetAttribute("Index", i);
                v33.Parent = Stats;
                v33.Position = UDim2.new(Position.X.Scale, 0, Position.Y.Scale - u4 * (i - 1), 0);
                u27(true, v33);
            end;
        end;
    end;

    for _, child in pairs(Stats:GetChildren()) do
        local IndexOfStat = u2:GetIndexOfStat(child.Name);
        local Name = child.Name;

        if IndexOfStat and (Name == "Health" or (Name == "Hunger" or (Name == "Thirst" or (Name == "Template" or not (string.find(Name, "Pickup") or string.find(Name, "Drop")))))) then
            local v36 = child;
            local v37 = false;

            for _, v in pairs(StatsPickupTableCombined) do
                if v[1] == Name then
                    v37 = true;
                end;
            end;

            if not v37 then
                if v36 then
                    v36:Destroy();
                end;
            end;
        end;
    end;
end;

local function u50(p39) -- Line: 378
    -- upvalues: u2 (copy), Stats (copy), Humanoid (copy), TweenUtil (copy), u5 (copy), u38 (copy), NumberUtil (copy), Radiation (copy), u7 (copy), Blur (copy), u13 (ref), u17 (copy), Cold (copy), Hot (copy)
    u2:CompareServerTable(p39);
    local Health = Stats:FindFirstChild("Health");
    local Health2 = Humanoid.Health;
    local Bar = Health.Bar;
    TweenUtil:Tween(Bar.Fill, "Size", UDim2.new(math.clamp(Health2 / 100, 0, 1), 0, 1, 0), 0.4);
    local StatLabel = Bar.StatLabel;
    local math_ceil_ret = math.ceil(Health2);
    StatLabel.Text = tostring(math_ceil_ret);

    for i, v in pairs(p39) do
        local v40 = Stats:FindFirstChild(i);

        if v40 and (i == "Hunger" or i == "Thirst") then
            local Bar2 = v40.Bar;
            TweenUtil:Tween(Bar2.Fill, "Size", UDim2.new(v / u5[i], 0, 1, 0), 0.4);
            local StatLabel2 = Bar2.StatLabel;
            local math_ceil_ret2 = math.ceil(v);
            StatLabel2.Text = tostring(math_ceil_ret2);
        elseif i == "HQueue" then
            TweenUtil:Tween(Stats.Health.Bar.HQueue, "Size", UDim2.new(math.clamp((Humanoid.Health + v) / 100, 0, 1), 0, 1, 0), 0.4);
        end;
    end;

    u38();
    local v41 = Stats:FindFirstChild("Radiation") and Stats.Radiation:GetAttribute("Reach") or 0;
    local v42 = v41 / 120;
    local v43 = NumberUtil:Lerp(0.8, 1.3, v42);
    local math_clamp_ret = math.clamp(v43, 0.8, 1.3);
    local v44 = NumberUtil:Lerp(0.9, 1.2, v42);
    local math_clamp_ret2 = math.clamp(v44, 0.9, 1.2);
    Radiation.Volume = math_clamp_ret;
    Radiation.PlaybackSpeed = math_clamp_ret2;

    if v41 > 0 then
        Radiation:Play();
    else
        Radiation:Stop();
    end;

    local v45 = Health2 <= 40 and (u7.Health.BlurSize - Health2 / 40 * u7.Health.BlurSize or 0) or 0;
    local v46 = v41 >= 15 and (math.clamp(v41 / 120 * u7.Radiation.BlurSize, 0, u7.Radiation.BlurSize) or 0) or 0;

    if v46 <= v45 then
        v46 = v45 or v46;
    end;

    local v47 = Health2 <= 40 and 255 - (u7.Health.ColorCorrectionLowest - Health2 / 40 * u7.Health.ColorCorrectionLowest) or 255;
    local v48 = v41 >= 15 and math.clamp(255 - v41 / 120 * u7.Radiation.ColorCorrectionLowest, u7.Radiation.ColorCorrectionLowest, 255) or 255;

    if v47 <= v48 then
        v48 = v47 or v48;
    end;

    Blur.Size = v46;
    u13 = v48;
    u17();
    local v49 = Stats:FindFirstChild("Temperature") and Stats.Temperature:GetAttribute("Reach") or 0;
    Cold.Visible = v49 <= -8;
    Hot.Visible = v49 >= 29;
end;

local function u53(p51, p52) -- Line: 436
    for _, child in pairs(p51:GetChildren()) do
        if child:IsA("Frame") then
            child.BackgroundColor3 = p52;
            child.Fill.BackgroundColor3 = p52;
        end;
    end;
end;

local function u61(p54, p55) -- Line: 444
    -- upvalues: u53 (copy), Armor (copy)
    local v56 = p55 < 0;
    local v57;

    if v56 and p54:GetAttribute("ColorNegative") then
        v57 = p55 * -1;
        u53(p54, p54:GetAttribute("ColorNegative"));
    elseif p54:GetAttribute("ColorPositive") == nil then
        v57 = p55;
    else
        u53(p54, p54:GetAttribute("ColorPositive"));
        v57 = p55;
    end;

    local math_ceil_ret = math.ceil(v57 / 10);

    for i = 1, 10 do
        local v58 = p54:FindFirstChild(i >= 10 and tostring(i) or "0" .. i);
        local v59 = math_ceil_ret < i and 0 or math.min((v57 - (i - 1) * 10) / 10, 1);
        v58.Fill.Size = UDim2.new(v59, 0, 1, 0);
        local _ = i;
    end;

    local v60 = Armor:FindFirstChild(p54.Name:gsub("Bars$", "") .. "Percent");

    if v60 then
        v60.Text = math.round(p55) .. "%";
        v60.TextColor3 = v56 and p54:GetAttribute("ColorNegative") or (v60:GetAttribute("BaseColor") or v60.TextColor3);
    end;
end;

local function _(p62) -- Line: 509
    -- upvalues: BulletBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeBars (copy), MeleeDetail (copy), MeleePercent (copy)
    BulletBars.Visible = p62;
    BulletDetail.Visible = p62;
    BulletPercent.Visible = p62;
    MeleeBars.Visible = p62;
    MeleeDetail.Visible = p62;
    MeleePercent.Visible = p62;
end;

local function _(p63, p64) -- Line: 518
    -- upvalues: u61 (copy), BulletBars (copy), u11 (copy), MeleeBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeDetail (copy), MeleePercent (copy)
    if not p63 then
        BulletBars.Visible = p63;
        BulletDetail.Visible = p63;
        BulletPercent.Visible = p63;
        MeleeBars.Visible = p63;
        MeleeDetail.Visible = p63;
        MeleePercent.Visible = p63;

        return;
    end;

    u61(BulletBars, u11[p64].Bullet);
    u61(MeleeBars, u11[p64].Melee);
    BulletBars.Visible = p63;
    BulletDetail.Visible = p63;
    BulletPercent.Visible = p63;
    MeleeBars.Visible = p63;
    MeleeDetail.Visible = p63;
    MeleePercent.Visible = p63;
end;

HitboxHead.MouseEnter:Connect(function() -- Line: 534
    -- upvalues: u61 (copy), BulletBars (copy), u11 (copy), MeleeBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeDetail (copy), MeleePercent (copy), ViewportModule (copy), ViewportFrame (copy)
    u61(BulletBars, u11.Head.Bullet);
    u61(MeleeBars, u11.Head.Melee);
    BulletBars.Visible = true;
    BulletDetail.Visible = true;
    BulletPercent.Visible = true;
    MeleeBars.Visible = true;
    MeleeDetail.Visible = true;
    MeleePercent.Visible = true;
    ViewportModule:HighlightCharArea(ViewportFrame, "Head");
end);
HitboxHead.MouseLeave:Connect(function() -- Line: 538
    -- upvalues: BulletBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeBars (copy), MeleeDetail (copy), MeleePercent (copy), ViewportModule (copy), ViewportFrame (copy)
    BulletBars.Visible = false;
    BulletDetail.Visible = false;
    BulletPercent.Visible = false;
    MeleeBars.Visible = false;
    MeleeDetail.Visible = false;
    MeleePercent.Visible = false;
    ViewportModule:HighlightCharArea(ViewportFrame);
end);
HitboxChest.MouseEnter:Connect(function() -- Line: 543
    -- upvalues: u61 (copy), BulletBars (copy), u11 (copy), MeleeBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeDetail (copy), MeleePercent (copy), ViewportModule (copy), ViewportFrame (copy)
    u61(BulletBars, u11.Chest.Bullet);
    u61(MeleeBars, u11.Chest.Melee);
    BulletBars.Visible = true;
    BulletDetail.Visible = true;
    BulletPercent.Visible = true;
    MeleeBars.Visible = true;
    MeleeDetail.Visible = true;
    MeleePercent.Visible = true;
    ViewportModule:HighlightCharArea(ViewportFrame, "Chest");
end);
HitboxChest.MouseLeave:Connect(function() -- Line: 547
    -- upvalues: BulletBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeBars (copy), MeleeDetail (copy), MeleePercent (copy), ViewportModule (copy), ViewportFrame (copy)
    BulletBars.Visible = false;
    BulletDetail.Visible = false;
    BulletPercent.Visible = false;
    MeleeBars.Visible = false;
    MeleeDetail.Visible = false;
    MeleePercent.Visible = false;
    ViewportModule:HighlightCharArea(ViewportFrame);
end);
HitboxLegs.MouseEnter:Connect(function() -- Line: 552
    -- upvalues: u61 (copy), BulletBars (copy), u11 (copy), MeleeBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeDetail (copy), MeleePercent (copy), ViewportModule (copy), ViewportFrame (copy)
    u61(BulletBars, u11.Legs.Bullet);
    u61(MeleeBars, u11.Legs.Melee);
    BulletBars.Visible = true;
    BulletDetail.Visible = true;
    BulletPercent.Visible = true;
    MeleeBars.Visible = true;
    MeleeDetail.Visible = true;
    MeleePercent.Visible = true;
    ViewportModule:HighlightCharArea(ViewportFrame, "Legs");
end);
HitboxLegs.MouseLeave:Connect(function() -- Line: 556
    -- upvalues: BulletBars (copy), BulletDetail (copy), BulletPercent (copy), MeleeBars (copy), MeleeDetail (copy), MeleePercent (copy), ViewportModule (copy), ViewportFrame (copy)
    BulletBars.Visible = false;
    BulletDetail.Visible = false;
    BulletPercent.Visible = false;
    MeleeBars.Visible = false;
    MeleeDetail.Visible = false;
    MeleePercent.Visible = false;
    ViewportModule:HighlightCharArea(ViewportFrame);
end);
LocalPlayer:GetAttributeChangedSignal("SafeZone"):Connect(function() -- Line: 561
    -- upvalues: LocalPlayer (copy), u2 (copy)
    if LocalPlayer:GetAttribute("SafeZone") then
        u2:InsertStat("Safezone", 1);

        return;
    end;

    u2:UpdateStat("Safezone", 0);
end);
CraftUpdate.Event:Connect(function(p65, p66, p67) -- Line: 571
    -- upvalues: u2 (copy), u12 (ref), u38 (copy)
    if p65 == "UpdateRecipes" then
        if p66 <= 0 then
            u2:InsertStat("Recipes", 0);

            return;
        end;

        u2:InsertStat("Recipes", p66);

        return;
    end;

    if p65 == "UpdateCraft" then
        u12 = p66;
        u2:InsertStat("Craft", p67);
    elseif p65 == "RemoveCraft" then
        u2:InsertStat("Craft", 0);
    end;

    u38();
end);
v1("Setup", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\036\239\191\189\239\191\189\239\191\189\109\101\239\191\189\055\105\122\239\191\189\048\195\145\114\052\239\191\189\239\191\189\239\191\189\077\239\191\189", function(p68, p69) -- Line: 598
    -- upvalues: u50 (copy), u11 (copy), Armor (copy), u61 (copy)
    if p68 ~= nil then
        u50(p68);
    end;

    if p69 ~= nil then
        for i, v in pairs(p69) do
            if i == "Head" or (i == "Chest" or i == "Legs") then
                u11[i].Bullet = v.Bullet;
                u11[i].Melee = v.Melee;
            else
                local v70 = Armor:FindFirstChild(i .. "Bars");

                if v70 then
                    u61(v70, v);
                else
                    print("BAR CONTAINER NOT FOUND FOR " .. i);
                end;
            end;
        end;
    end;
end);
v1("Setup", "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033", "\239\191\189\239\191\189\239\191\189\239\191\189\036\239\191\189\055\239\191\189\060\239\191\189\239\191\189\069\195\175\194\168\098\239\191\189\125\239\191\189\239\191\189\239\191\189", function(p71, p72) -- Line: 617
    -- upvalues: u10 (copy), u38 (copy)
    table.insert(u10, p71);
    u38();
end);
Blur.Size = 0;
u13 = 255;
u17();
Lighting:GetAttributeChangedSignal("BloodMoon"):Connect(u17);
local u73 = {
    ["Salvaged Flycopter"] = true,
    ["Wooden Boat"] = true,
    ["Military Boat"] = true
};
local VehicleHealth = Main:WaitForChild("VehicleHealth");
local CameraController = script_Parent:WaitForChild("CameraController");
local u74 = {};

local function updateVehicleHealth(p75: userdata) -- Line: 636
    -- upvalues: VehicleHealth (copy), TweenUtil (copy)
    local v76 = p75:GetAttribute("Health") or 0;
    local v77 = p75:GetAttribute("MaxHealth") or 0;
    local v78 = v77 <= 0 and 0 or math.clamp(v76 / v77, 0, 1);
    local Bar = VehicleHealth.Bar;
    TweenUtil:Tween(Bar.Fill, "Size", UDim2.new(v78, 0, 1, 0), 0.4);
    local StatLabel = Bar.StatLabel;
    local math_ceil_ret = math.ceil(v76);
    StatLabel.Text = tostring(math_ceil_ret);
end;

local Inventory = Main:WaitForChild("Inventory");
local u79 = { Inventory:WaitForChild("Inv"), Inventory:WaitForChild("ActionMenu") };

local function u84(p80: boolean) -- Line: 653
    -- upvalues: u79 (copy)
    local v81 = p80 and 0.045 or 0;

    for _, v in u79 do
        local v82 = v:GetAttribute("VehicleLift") or 0;

        if v82 ~= v81 then
            local Position = v.Position;
            v.Position = UDim2.new(Position.X.Scale, Position.X.Offset, Position.Y.Scale - (v81 - v82), Position.Y.Offset);
            local v83;

            if v81 == 0 then
                v83 = nil;
            else
                v83 = v81;
            end;

            v:SetAttribute("VehicleLift", v83);
        end;
    end;
end;

local function watchSeatedVehicle() -- Line: 672
    -- upvalues: u74 (copy), Humanoid (copy), u73 (copy), updateVehicleHealth (copy), CameraController (copy), VehicleHealth (copy), u84 (copy)
    for _, v in u74 do
        v:Disconnect();
    end;

    table.clear(u74);
    local SeatPart = Humanoid.SeatPart;

    if SeatPart then
        SeatPart = SeatPart.Parent;
    end;

    if SeatPart and (u73[SeatPart.Name] and SeatPart:GetAttribute("MaxHealth")) then
        local function update() -- Line: 680
            -- upvalues: updateVehicleHealth (ref), SeatPart (copy)
            updateVehicleHealth(SeatPart);
        end;

        local AttributeChangedSignal = SeatPart:GetAttributeChangedSignal("Health");
        table.insert(u74, AttributeChangedSignal:Connect(update));
        local AttributeChangedSignal2 = SeatPart:GetAttributeChangedSignal("MaxHealth");
        table.insert(u74, AttributeChangedSignal2:Connect(update));
        updateVehicleHealth(SeatPart);
    end;

    local v85;

    if #u74 > 0 then
        v85 = CameraController:GetAttribute("UI") ~= false;
    else
        v85 = false;
    end;

    VehicleHealth.Visible = v85;
    u84(v85);
end;

Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(watchSeatedVehicle);
CameraController:GetAttributeChangedSignal("UI"):Connect(function() -- Line: 665, Name: updateVisible
    -- upvalues: u74 (copy), CameraController (copy), VehicleHealth (copy), u84 (copy)
    local v86;

    if #u74 > 0 then
        v86 = CameraController:GetAttribute("UI") ~= false;
    else
        v86 = false;
    end;

    VehicleHealth.Visible = v86;
    u84(v86);
end);
watchSeatedVehicle();
v1(
    "Fire",
    "\195\154\239\191\189\082\089\075\239\191\189\195\148\239\191\189\239\191\189\057\239\191\189\239\191\189\194\175\123\089\239\191\189\239\191\189\194\174\107\033",
    "\036\239\191\189\239\191\189\239\191\189\109\101\239\191\189\055\105\122\239\191\189\048\195\145\114\052\239\191\189\239\191\189\239\191\189\077\239\191\189"
);

while true do
    local v87 = false;

    if tick() - v8 >= 0.2 then
        v8 = tick();
        local v88 = u10[1];

        if v88 then
            table.remove(u10, 1);
            u2:InsertStat(v88[1], v88[2]);
            v87 = true;
        end;
    end;

    for _, v in pairs(u2:GetPickups()) do
        if tick() - v[3] >= 5 then
            local u89 = Stats:FindFirstChild(v[1]);

            if u89 then
                delay(0.4, function() -- Line: 718
                    -- upvalues: u89 (copy)
                    u89:Destroy();
                end);
                u27(false, u89);
            end;

            u2:RemovePickup(v[1]);
            v87 = true;
        end;
    end;

    if tick() - v9 >= 0.06 then
        v9 = tick();

        for _, child in pairs(Stats:GetChildren()) do
            local v90 = child;
            local v91 = false;

            for _, v in pairs({ "Health", "Hunger", "Thirst", "Template" }) do
                if v90.Name == v then
                    v91 = true;
                end;
            end;

            if not v91 then
                local Attribute = v90:GetAttribute("CurrentNum");
                local Attribute2 = v90:GetAttribute("Reach");
                local Num = v90.Num;

                if Attribute2 then
                    if Attribute ~= Attribute2 then
                        if Attribute2 - 0.4 <= Attribute then
                            v90:SetAttribute("CurrentNum", Attribute2);
                            Num.Text = u20(Attribute2, v90.Name);
                        else
                            local v92 = NumberUtil:Lerp(Attribute, Attribute2, 0.45);
                            v90:SetAttribute("CurrentNum", v92);
                            Num.Text = u20(v92, v90.Name);
                        end;
                    end;
                end;
            end;
        end;
    end;

    if v87 then
        u38();
    end;

    if #u2:GetPickups() <= 0 then
        wait(0.5);
    else
        wait();
    end;
end;