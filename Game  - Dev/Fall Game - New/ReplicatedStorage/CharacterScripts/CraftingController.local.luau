-- [PATH] ReplicatedStorage / CharacterScripts / CraftingController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Values = ReplicatedStorage:WaitForChild("Values");
local Bases = workspace:WaitForChild("Bases");
local VFX = workspace:WaitForChild("VFX");
local Animals = workspace:WaitForChild("Animals");
local Plants = workspace:WaitForChild("Plants");
local Vegetation = workspace:WaitForChild("Vegetation");
local SettingRemotes = ReplicatedStorage:WaitForChild("SettingRemotes");
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local RecipeModule = require(Modules:WaitForChild("RecipeModule"));
local ResearchModule = require(Modules:WaitForChild("ResearchModule"));
local ButtonClass = require(Modules:WaitForChild("ButtonClass"));
local Items = require(Modules:WaitForChild("Items"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local u1 = require(Modules:WaitForChild("AssetContainer"))();
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Humanoid = script_Parent:WaitForChild("Humanoid");
local HumanoidRootPart = script_Parent:WaitForChild("HumanoidRootPart");
local InventoryController = script_Parent:WaitForChild("InventoryController");
local StatsController = script_Parent:WaitForChild("StatsController");
local Update = script:WaitForChild("Update");
local Fetch = InventoryController:WaitForChild("Fetch");
local CraftUpdate = StatsController:WaitForChild("CraftUpdate");
local Crafting = PlayerGui:WaitForChild("Main"):WaitForChild("Crafting");
local Categories = Crafting:WaitForChild("Categories");
local Craftables = Crafting:WaitForChild("Craftables");
local Information = Crafting:WaitForChild("Information");
local Materials = Crafting:WaitForChild("Materials");
local Queue = Crafting:WaitForChild("Queue");
local Search = Crafting:WaitForChild("Search");
local Skins = Crafting:WaitForChild("Skins");
local Content = Craftables:WaitForChild("Content");
local Content2 = Queue:WaitForChild("Content");
local List = Materials:WaitForChild("List");
local CraftAmount = Materials:WaitForChild("CraftAmount");
local TextBox = Search:WaitForChild("TextBox");
local List2 = Skins:WaitForChild("List");
local CraftingCategories = RecipeModule:GetCraftingCategories();
local u2 = ResearchModule:FetchAllWorkbenches();
local u3 = "All";
local u4 = 0;
local u5 = "Default";
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = "";
local u11 = nil;
local u12 = true;
local u13 = true;
local u14 = 0;
local u15 = {};
local u16 = {};
local u17 = nil;
local u18 = {};
local u19 = {};
local v20 = {};
local u21 = nil;
local u22 = true;
local u23 = nil;
local u24 = nil;
local u25 = {};

local function u28() -- Line: 103
    -- upvalues: Fetch (copy)
    local v26 = Fetch:Invoke() or {};
    local v27 = {};

    for i, v in pairs(v26) do
        if i == "Inventory" or i == "Toolbar" then
            for _, v2 in pairs(v) do
                if v2 and (v2 ~= 0 and v2.Amount > 0) then
                    local ID = v2.ID;
                    v27[ID] = (v27[ID] or 0) + v2.Amount;
                end;
            end;
        end;
    end;

    return v27;
end;

local u29 = u28();

local function u34(p30: string) -- Line: 124
    -- upvalues: CraftingCategories (copy), u6 (copy), Categories (copy)
    local v31 = p30 == "All";
    local v32 = 0;

    for _, v in pairs(v31 and CraftingCategories or { p30 }) do
        local v33 = u6[v];
        local Hide = v33.Hide;

        for _, v2 in pairs(v33.Recipes) do
            if Hide[v2.ID] ~= 2 then
                v32 = v32 + 1;
            end;
        end;

        if not v31 then
            v33.AvailableCount = v32;
        end;
    end;

    Categories[p30].Category.Text = `{p30} (<font color="rgb(30, 158, 255)">{v32}</font>)`;
end;

local function _() -- Line: 143
    -- upvalues: CraftingCategories (copy), u34 (copy)
    for _, v in pairs(CraftingCategories) do
        u34(v);
    end;

    u34("All");
end;

local function u57() -- Line: 150
    -- upvalues: RecipeModule (copy), u4 (ref), Fetch (copy), u21 (ref), u19 (ref), Information (copy), u29 (ref), CraftAmount (copy), List (copy), NumberUtil (copy), u25 (copy), MarketplaceService (copy), LocalPlayer (copy), Materials (copy), u23 (ref), u24 (ref), u11 (ref), ResearchModule (copy), Values (copy)
    local v35 = (RecipeModule:GetRecipesForItem(u4) or {})[1];

    if v35 then
        local _, v36 = Fetch:Invoke();
        local BenchNeeded = v35.BenchNeeded;
        u21 = table.find(u19, BenchNeeded);
        local v37 = u21 and (v36[BenchNeeded] or 0) or 0;
        local v38 = v35.TierNeeded or 0;
        local v39;

        if BenchNeeded == nil then
            v39 = false;
        else
            v39 = v38 > 0;
        end;

        local v40 = v38 <= v37;
        Information.Required.Text = v40 and "" or "REQUIRED!";

        if v39 then
            Information.Required.Label.Text = `{BenchNeeded} - Tier: <font color="rgb(255, 248, 41)">{v38}</font>`;
        end;

        Information.Required.Visible = v39;
        local v41 = u29;
        local v42 = tonumber(CraftAmount.Text) or 1;

        for i, v in pairs(v35.Costs) do
            local v43 = v.Amount * v42;
            local v44 = v41[v.ID] or 0;
            local v45 = List["Slot" .. i];
            v45.ItemAmount.Text = "x" .. NumberUtil:FormatNumber(v43);
            v45.HasAmount.Text = "x" .. NumberUtil:FormatNumber(v44);
            local v46 = v43 <= v44;
            v45.Grey.Visible = not v46;

            if not v46 then
                v40 = false;
            end;
        end;

        local Attribute = script:GetAttribute(v40 and "CanCraftColor" or "CannotCraftColor");
        local v47 = true;
        local ProductNeeded = v35.ProductNeeded;
        local GamepassNeeded = v35.GamepassNeeded;

        if ProductNeeded or GamepassNeeded then
            local v48 = ProductNeeded or GamepassNeeded;
            local v49 = u25[v48];
            local v50 = false;

            if v49 and os.clock() - v49[1] < 20 then
                v50 = v49[2];
            else
                if not v49 then
                    v49 = {};
                    u25[v48] = v49;
                end;

                v49[1] = os.clock();

                if ProductNeeded then
                    local success, result = pcall(MarketplaceService.PlayerOwnsAsset, MarketplaceService, LocalPlayer, v48);
                    v50 = success and result and true or false;
                elseif GamepassNeeded then
                    local success, result = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, LocalPlayer.UserId, v48);
                    v50 = success and result and true or false;
                end;

                v49[2] = v50;
            end;

            if not v50 then
                Attribute = Color3.fromRGB(255, 225, 0);
                Materials.Craft.Text = "PURCHASE";
                Materials.Craft.Active = true;
                Materials.PriorityCraft.Visible = false;

                if ProductNeeded then
                    u23 = ProductNeeded;
                    v47 = false;
                elseif GamepassNeeded then
                    u24 = GamepassNeeded;
                    v47 = false;
                else
                    v47 = false;
                end;
            end;
        end;

        if v47 then
            u23 = nil;
            u24 = nil;
            Materials.Craft.Active = v40;
            Materials.Craft.Text = "CRAFT";
            Materials.PriorityCraft.Visible = v40;
        end;

        if u11 then
            u11:UpdateBaseColor(Attribute);
        end;

        Materials.Craft.BackgroundColor3 = Attribute;
        local v51 = 1;

        if v37 > 0 then
            local InfoFromName = ResearchModule:GetInfoFromName(BenchNeeded);

            if InfoFromName then
                v51 = ResearchModule:CalculateCraftTime(v37, v38, #InfoFromName.Tiers);
            end;
        end;

        local v52 = v35.Time * v42 / Values.CraftSpeedMult.Value * v51;
        local v53 = NumberUtil:FormatTime(v52, "Minutes", "Seconds", true);
        local v54 = v52 % 1;
        local v55 = v53:sub(1, 3) == "0m0" and v53:sub(4);

        if v55 then
            v53 = v55;
        elseif v53:sub(1, 2) == "0m" then
            v53 = v53:sub(3) or v53;
        end;

        if v54 > 0 and v52 < 60 then
            local v56 = tostring(NumberUtil:RoundNumber(v54, 2)):sub(2);
            v53 = v53:sub(1, #v53 - 1) .. v56 .. v53:sub(#v53);
        end;

        Materials.YieldInfo.Text = `Yields x<font color="rgb(255, 248, 43)">{NumberUtil:FormatNumber(v35.ReceiveAmount * v42)}</font> in <font color="rgb(30, 158, 255)">{v53}</font>`;

        return v41;
    end;
end;

local function u64(p58: string, p59: any, p60: boolean) -- Line: 251
    -- upvalues: u5 (ref), u9 (copy), Items (copy), Information (copy)
    if u5 == p58 then
        if not p60 then
            return;
        end;
    else
        local v61 = u9[u5];

        if v61 and v61:IsToggled() then
            task.defer(v61.ToggleButton, v61, false);
        end;
    end;

    local v62 = u9[p58];

    if v62 and not v62:IsToggled() then
        task.defer(v62.ToggleButton, v62, true, p60);
    end;

    u5 = p58;

    if not p59 then
        return;
    end;

    local Image = Items[p59.ID].Image;
    local v63 = type(Image) == "table";

    if v63 then
        Image = Image[u5] or (Image.Default or Image);
    end;

    Information.ItemImage.Image = Image;
end;

local function u76(u65: number) -- Line: 273
    -- upvalues: u4 (ref), u7 (copy), RecipeModule (copy), Items (copy), Information (copy), InventoryController (copy), u9 (copy), Fetch (copy), List2 (copy), ButtonClass (copy), u5 (ref), u64 (copy), SettingsModule (copy), SettingRemotes (copy), Skins (copy), List (copy), CraftAmount (copy), u10 (ref), u57 (copy)
    if u4 == u65 then
        return;
    end;

    local v66 = u7[u4];

    if v66 and v66:IsToggled() then
        task.defer(v66.ToggleButton, v66, false);
    end;

    local v67 = u7[u65];

    if v67 and not v67:IsToggled() then
        task.defer(v67.ToggleButton, v67, true);
    end;

    local u68 = (RecipeModule:GetRecipesForItem(u65) or {})[1];

    if not u68 then
        return;
    end;

    local Costs = u68.Costs;
    u4 = u65;
    local v69 = Items[u65];
    local Image = v69.Image;
    local v70 = type(Image) == "table";
    Information.ItemName.Text = v69.Name;
    Information.Description.Text = v69.Description;
    InventoryController.ItemStats:Invoke(Information.ItemStats, u65, v69);

    if v70 then
        for i, v in pairs(u9) do
            local Button = v.Button;

            if Button.Parent then
                Button:Destroy();
            end;

            v:Destroy();
            u9[i] = nil;
        end;

        local _, _, v71 = Fetch:Invoke();
        local v72 = {};

        for i, _ in pairs(Image) do
            local table_find_ret = table.find(v71 or {}, v69.Name .. "/" .. i);

            if i == "Default" or table_find_ret then
                table.insert(v72, i);
            end;
        end;

        local math_max_ret = math.max(#v72 / 8, 1);
        List2.CanvasSize = UDim2.new(math_max_ret * 0.95 - 0.001, 0, 0, 0);
        List2.Layout.Padding = UDim.new(0.005 / math_max_ret, 0);
        List2.Layout.Template.Size = UDim2.new(0.12 / math_max_ret, 0, 0.79, 0);

        for _, v in v72 do
            local v73 = List2.Layout.Template:Clone();
            v73.Name = v;
            v73.ItemImage.Image = Image[v];
            v73.Parent = List2;
            u9[v] = ButtonClass.new(v73, "BackgroundColor3", function() -- Line: 318
                -- upvalues: u5 (ref), u64 (ref), v (copy), u68 (copy), SettingsModule (ref), u65 (copy), SettingRemotes (ref)
                u64(v, u68);

                if u5 == u5 then
                    return;
                end;

                SettingsModule.SetSkinPreset(SettingsModule.SkinPresets, u65, v);
                SettingRemotes.Update:FireServer("SkinPresets", u65, v);
            end, 1.3, script:GetAttribute("SelectedSlotColor"));
        end;

        List2.CanvasPosition = Vector2.new(List2.AbsoluteSize.X * 0.125 * (math.max(#v72 - 8, 0) / 2), 0);
        u64(SettingsModule.GetSkinPreset(v71, u65, v69.Name), u68, true);
    else
        Information.ItemImage.Image = Image;
    end;

    Skins.List.Visible = v70;
    Skins.NotAvailable.Visible = not v70;

    for _, child in pairs(List:GetChildren()) do
        if child:IsA("ImageButton") and child.Name ~= "Slot1" then
            child:Destroy();
        end;
    end;

    for i, v in pairs(Costs) do
        local v74;

        if i == 1 then
            v74 = List.Slot1;
        else
            v74 = false;
        end;

        if not v74 then
            v74 = List.Slot1:Clone();
            v74.Name = "Slot" .. i;
            v74.Parent = List;
        end;

        local v75 = Items[v.ID];
        v74.ItemImage.Image = type(v75.Image) == "table" and v75.Image.Default or v75.Image;
        v74.ItemName.Text = v75.Name;
    end;

    CraftAmount.Text = "";
    u10 = "";
    u57();
end;

local function u93(p77) -- Line: 356
    -- upvalues: u3 (ref), u29 (ref), CraftingCategories (copy), u6 (copy), Content (copy), Fetch (copy), u19 (ref), u7 (copy), u4 (ref), u76 (copy)
    local v78 = p77 or u3;
    local v79 = u29;
    local v80 = {};
    local v81 = {};

    for _, v in pairs(v78 == "All" and CraftingCategories or { v78 }) do
        local v82 = u6[v];
        local Hide = v82.Hide;

        for _, v2 in pairs(v82.Recipes) do
            if not Hide[v2.ID] then
                local v83 = true;

                for _, v3 in pairs(v2.Costs) do
                    if (v79[v3.ID] or 0) < v3.Amount then
                        v83 = false;
                        break;
                    end;
                end;

                table.insert(v83 and v81 and v81 or v80, v2);
            end;
        end;
    end;

    local math_ceil_ret = math.ceil(#v81 / 5);
    local v84 = math_ceil_ret + math.ceil(#v80 / 5) - 1;
    local v85 = math.max(v84, 0) * 0.17 + 0.09 + 0.08;
    local math_max_ret = math.max(v85, 1);
    Content.CanvasSize = UDim2.new(0, 0, math_max_ret - 0.001, 0);
    local _, v86 = Fetch:Invoke();

    for i = 1, 2 do
        local v87 = i == 1;
        local _ = i;
        local v88 = -1;

        for _, v in pairs(v87 and v81 and v81 or v80) do
            local ID = v.ID;
            local BenchNeeded = v.BenchNeeded;
            local v89 = table.find(u19, BenchNeeded) and (v86[BenchNeeded] or 0) or 0;
            local TierNeeded = v.TierNeeded;
            local v90 = u7[ID];

            if v90 then
                v88 = v88 + 1;
                local Button = v90.Button;
                local UDim2_new_ret = UDim2.new(0.195, 0, 0.16 / math_max_ret, 0);
                v90.OrigSize = UDim2_new_ret;
                Button.Size = UDim2_new_ret;
                local v91 = 0.09 + 0.17 * ((v87 and 0 or math_ceil_ret) + math.floor(v88 / 5));
                Button.Position = UDim2.new(v88 % 5 * 0.2 + 0.1, 0, v91 / math_max_ret, 0);
                Button.ImageTransparency = v87 and 0 or 0.6;
                local v92;

                if BenchNeeded == nil then
                    v92 = false;
                else
                    v92 = v89 < TierNeeded;
                end;

                Button.Lock.Visible = v92;
                v90:ToggleButton(ID == u4, true);

                if u4 == 0 then
                    u76(ID);
                end;
            end;
        end;
    end;

    return v79;
end;

local function u98(p94: number, p95: number, p96: boolean) -- Line: 413
    -- upvalues: Values (copy), u14 (ref), u24 (ref), MarketplaceService (copy), LocalPlayer (copy), u23 (ref), u18 (ref), u21 (ref), u1 (copy), u5 (ref)
    if not (Values.CraftingEnabled.Value and (tick() - u14 >= 0.08 and (p94 ~= nil and p94 ~= 0))) then
        return;
    end;

    if u24 then
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, u24);
    elseif u23 then
        MarketplaceService:PromptPurchase(LocalPlayer, u23);
    end;

    u14 = tick();
    local math_clamp_ret = math.clamp(p95, 1, 99);
    local v97 = u18[u21];
    u1("Fire", "\195\172\239\191\189\195\136\239\191\189\195\170\037\195\157\195\145\239\191\189\195\152\239\191\189\239\191\189\239\191\189\239\191\189\040\239\191\189\239\191\189\081\098\239\191\189", "\239\191\189\239\191\189\239\191\189\075\239\191\189\057\239\191\189\239\191\189\195\167\239\191\189\195\180\038\038\239\191\189\063\239\191\189\194\175\051\239\191\189\123", p94, math_clamp_ret, u5 or "Default", (typeof(v97) ~= "Instance" or not v97.Parent) and "none" or v97, p96 and 1 or 0);
end;

local function u117(p99: string, p100: boolean, p101: boolean) -- Line: 436
    -- upvalues: u3 (ref), u8 (copy), Categories (copy), TextBox (copy), u7 (copy), Fetch (copy), CraftingCategories (copy), u6 (copy), Items (copy), Content (copy), ButtonClass (copy), u98 (copy), u76 (copy), u93 (copy)
    if p99 == u3 and not p100 then
        return;
    end;

    if not p100 then
        local v102 = u8[Categories[u3]];

        if v102:IsToggled() then
            task.defer(v102.ToggleButton, v102, false);
        end;
    end;

    if not p101 then
        local v103 = u8[Categories[p99]];

        if not v103:IsToggled() then
            task.defer(v103.ToggleButton, v103, true);
        end;
    end;

    local v104 = TextBox.Text ~= "";

    if not p101 then
        u3 = p99;
    end;

    if v104 and not p101 then
        return;
    end;

    local v105 = u3 == "All" and true or v104;

    for i, v in pairs(u7) do
        local Button = v.Button;

        if Button.Parent then
            Button:Destroy();
        end;

        v:Destroy();
        u7[i] = nil;
    end;

    local v106 = false;
    local _, v107 = Fetch:Invoke();
    local v108 = v105 and CraftingCategories;

    if not v108 then
        v108 = {};

        if p99 == "All" then
            p99 = u3 or p99;
        end;

        v108[1] = p99;
    end;

    for _, v in pairs(v108) do
        local v109 = u6[v];
        local Hide = v109.Hide;

        for _, v2 in pairs(v109.Recipes) do
            local ID = v2.ID;
            local BenchNeeded = v2.BenchNeeded;
            local v110 = v107[BenchNeeded] or 0;
            local TierNeeded = v2.TierNeeded;
            local v111 = Items[ID];

            if BenchNeeded then
                if v110 < TierNeeded then
                    BenchNeeded = not v104;
                else
                    BenchNeeded = false;
                end;
            end;

            if v104 and not string.find(v111.Name:lower(), TextBox.Text:lower(), 1, true) or BenchNeeded then
                Hide[ID] = BenchNeeded and 2 or 1;
            else
                Hide[ID] = nil;
                local Image = v111.Image;
                local v112 = Content.Template:Clone();

                if type(Image) == "table" then
                    Image = Image.Default or Image;
                end;

                v112.Image = Image;
                v112.Name = ID;
                v112.Parent = Content;
                local v113 = (v2.GamepassNeeded or v2.ProductNeeded) and true or false;

                if v113 then
                    v112.BackgroundColor3 = Color3.fromRGB(85, 57, 95);
                end;

                local u114 = nil;
                local new = ButtonClass.new;

                local function v115() -- Line: 493
                    -- upvalues: u114 (ref), u98 (ref), ID (copy), u76 (ref)
                    local os_clock_ret = os.clock();

                    if u114 and os_clock_ret - u114 <= 0.2 then
                        u114 = nil;
                        u98(ID, 1, false);

                        return;
                    end;

                    u114 = os_clock_ret;
                    u76(ID);
                end;

                local v116;

                if v113 then
                    v116 = Color3.fromRGB(215, 145, 241);
                else
                    v116 = script:GetAttribute("SelectedSlotColor");
                end;

                u7[ID] = new(v112, "BackgroundColor3", v115, 1.75, v116);
                v112.Visible = true;
                v106 = true;
            end;
        end;
    end;

    if not v106 then
        return;
    end;

    u93(v105 and "All");
end;

local function _(p118: number) -- Line: 513
    -- upvalues: CraftAmount (copy), u10 (ref), u57 (copy)
    local v119 = tonumber(CraftAmount.Text) or 1;
    local math_clamp_ret = math.clamp(v119 + p118, 1, 99);
    local v120 = tostring(math_clamp_ret);
    CraftAmount.Text = v120;
    u10 = v120;

    if tostring(v119) == v120 then
        return;
    end;

    u57();
end;

local function u126(p121: string?) -- Line: 522
    -- upvalues: u29 (ref), u28 (copy), u117 (copy), u3 (ref), CraftingCategories (copy), u34 (copy), u93 (copy), u57 (copy), Fetch (copy), u19 (ref), ResearchModule (copy), CraftUpdate (copy)
    u29 = u28();
    local v122 = nil;

    if p121 == "Research" then
        u117(u3, true);

        for _, v in pairs(CraftingCategories) do
            u34(v);
        end;

        u34("All");
    else
        v122 = u93();
    end;

    u57(v122);
    local _, v123 = Fetch:Invoke();
    local v124 = 0;

    for _, v in pairs(u19) do
        local InfoFromName = ResearchModule:GetInfoFromName(v);

        if InfoFromName then
            local Unlocks = InfoFromName.Unlocks;
            local v125 = 0;

            for i = 1, v123[v] or 0 do
                v125 = v125 + #Unlocks[i];
                local _ = i;
            end;

            v124 = v124 + v125;
        end;
    end;

    CraftUpdate:Fire("UpdateRecipes", v124);
end;

local function u132() -- Line: 550
    -- upvalues: u15 (ref), Content2 (copy), NumberUtil (copy), Items (copy), u17 (ref), Values (copy), CraftUpdate (copy)
    local v127 = 0;

    for i = #u15, 1, -1 do
        v127 = v127 + 1;
        local u128 = Content2:FindFirstChild("Slot" .. v127);
        local v129;

        if u128 then
            local u130 = u15[i];
            u128.Amount.Text = "x" .. NumberUtil:FormatNumber(u130.Amount);
            local u131 = Items[u130.ID];
            local Speed = u130.Speed;

            if Speed then
                if u17 then
                    task.cancel(u17);
                end;

                u17 = task.spawn(function() -- Line: 572
                    -- upvalues: u128 (copy), Speed (copy), u130 (copy), Values (ref), CraftUpdate (ref), u131 (copy), NumberUtil (ref)
                    while u128.Parent and u128.Visible do
                        local math_round_ret = math.round(Speed - (u130.Paused or Values.ServerTick.Value));
                        local math_clamp_ret = math.clamp(math_round_ret, 0, 999);
                        local math_abs_ret = math.abs(math_clamp_ret);
                        u128.Time.Text = math_abs_ret .. "s";
                        CraftUpdate:Fire("UpdateCraft", `{u131.Name} (x{NumberUtil:FormatNumber(u130.Amount)})`, math_abs_ret);
                        task.wait(0.1);
                    end;

                    CraftUpdate:Fire("RemoveCraft");
                end);
                v129 = i;
            else
                u128.Time.Text = "";
                v129 = i;
            end;
        else
            v129 = i;
        end;
    end;
end;

local function u138() -- Line: 586
    -- upvalues: Content2 (copy), u16 (copy), u15 (ref), Items (copy), u14 (ref), u1 (copy), u132 (copy)
    for _, child in pairs(Content2:GetChildren()) do
        if child:IsA("ImageButton") then
            local v133 = u16[child];
            local v134;

            if v133 then
                v134 = child;

                for _, v in pairs(v133) do
                    v:Disconnect();
                end;
            else
                v134 = child;
            end;

            if v134.Name == "Slot1" then
                v134.Visible = false;
                v134.X.Visible = false;
            else
                v134:Destroy();
            end;
        end;
    end;

    local v135 = 0;

    for i = #u15, 1, -1 do
        v135 = v135 + 1;
        local v136 = u15[i];
        local u137;

        if v135 == 1 then
            u137 = Content2.Slot1;
        else
            u137 = false;
        end;

        if not u137 then
            u137 = Content2.Slot1:Clone();
            u137.Name = "Slot" .. v135;
            u137.Parent = Content2;
        end;

        local Image = Items[v136.ID].Image;

        if type(Image) == "table" then
            Image = Image[v136.Skin or "Default"] or Image;
        end;

        u137.Image = Image;
        u16[u137] = { u137.MouseEnter:Connect(function() -- Line: 617
                -- upvalues: u137 (ref)
                u137.X.Visible = true;
            end), u137.MouseLeave:Connect(function() -- Line: 620
                -- upvalues: u137 (ref)
                u137.X.Visible = false;
            end), u137.Activated:Connect(function() -- Line: 623
                -- upvalues: u14 (ref), u1 (ref), i (copy)
                if tick() - u14 < 0.08 then
                    return;
                end;

                u14 = tick();
                u1("Fire", "\195\172\239\191\189\195\136\239\191\189\195\170\037\195\157\195\145\239\191\189\195\152\239\191\189\239\191\189\239\191\189\239\191\189\040\239\191\189\239\191\189\081\098\239\191\189", "\239\191\189\239\191\189\239\191\189\075\239\191\189\057\239\191\189\239\191\189\195\167\239\191\189\195\180\038\038\239\191\189\063\239\191\189\194\175\051\239\191\189\123", i);
            end) };
        u137.Visible = true;
        local _ = i;
    end;

    u132();
end;

CraftAmount:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 639
    -- upvalues: u10 (ref), CraftAmount (copy), u57 (copy)
    local v139 = u10;
    local v140 = tonumber(CraftAmount.Text);

    if v140 and (v140 % 1 == 0 and v140 > 0) then
        local math_min_ret = math.min(v140, 99);
        local v141 = tostring(math_min_ret);
        CraftAmount.Text = v141;
        u10 = v141;
    elseif CraftAmount.Text == "" then
        u10 = "";
    else
        CraftAmount.Text = u10;
    end;

    if v139 == CraftAmount.Text then
        return;
    end;

    u57();
end);
CraftAmount.FocusLost:Connect(function() -- Line: 655
    shared.LastTextBoxFocused = tick();
end);
TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 659
    -- upvalues: u117 (copy)
    u117("All", true, true);
end);
TextBox.FocusLost:Connect(function() -- Line: 663
    shared.LastTextBoxFocused = tick();
end);

if MobileModule.IsTouchDevice() then
    Materials.YieldInfo.Visible = false;

    for _, v in { Materials.Craft, Materials.PriorityCraft } do
        v.Size = UDim2.fromScale(v.Size.X.Scale, 0.272);
        v.Position = UDim2.fromScale(v.Position.X.Scale, 0.839);
    end;
end;

u11 = ButtonClass.new(Materials:WaitForChild("Craft"), "BackgroundColor3", function() -- Line: 677
    -- upvalues: u98 (copy), u4 (ref), CraftAmount (copy)
    u98(u4, tonumber(CraftAmount.Text) or 1, false);
end, 1.3, 1.3);
ButtonClass.new(Materials:WaitForChild("PriorityCraft"), "BackgroundColor3", function() -- Line: 680
    -- upvalues: u98 (copy), u4 (ref), CraftAmount (copy)
    u98(u4, tonumber(CraftAmount.Text) or 1, true);
end, 1.3, 1.3);
ButtonClass.new(Materials:WaitForChild("Add"), "BackgroundColor3", function() -- Line: 684
    -- upvalues: CraftAmount (copy), u10 (ref), u57 (copy)
    local v142 = tonumber(CraftAmount.Text) or 1;
    local math_clamp_ret = math.clamp(v142 + 1, 1, 99);
    local v143 = tostring(math_clamp_ret);
    CraftAmount.Text = v143;
    u10 = v143;

    if tostring(v142) == v143 then
        return;
    end;

    u57();
end, 1.25, 1.25);
ButtonClass.new(Materials:WaitForChild("Subtract"), "BackgroundColor3", function() -- Line: 688
    -- upvalues: CraftAmount (copy), u10 (ref), u57 (copy)
    local v144 = tonumber(CraftAmount.Text) or 1;
    local math_clamp_ret = math.clamp(v144 + -1, 1, 99);
    local v145 = tostring(math_clamp_ret);
    CraftAmount.Text = v145;
    u10 = v145;

    if tostring(v144) == v145 then
        return;
    end;

    u57();
end, 1.25, 1.25);
ButtonClass.new(Materials:WaitForChild("MaxPossible"), "BackgroundColor3", function() -- Line: 692
    -- upvalues: u29 (ref), RecipeModule (copy), u4 (ref), CraftAmount (copy), u10 (ref), u57 (copy)
    local v146 = u29;
    local v147 = (RecipeModule:GetRecipesForItem(u4) or {})[1];

    if not v147 then
        return;
    end;

    local v148 = (1 / 0);

    for _, v in pairs(v147.Costs) do
        v148 = math.min(v148, (v146[v.ID] or 0) / v.Amount);
    end;

    local math_floor_ret = math.floor(v148);
    local v149 = math_floor_ret <= 0 and "" or tostring(math_floor_ret);
    local Text = CraftAmount.Text;
    CraftAmount.Text = v149;
    u10 = v149;

    if Text == v149 then
        return;
    end;

    u57(v146);
end, 1.25, 1.25);
Update.Event:Connect(function(p150) -- Line: 711
    -- upvalues: InventoryController (copy), u126 (copy), u12 (ref)
    if InventoryController:GetAttribute("CurOpen") == "Crafting" then
        u126(p150);

        return;
    end;

    if u12 == false then
        u12 = p150 or true;

        return;
    end;

    if u12 == true and type(p150) == "string" then
        u12 = p150;
    end;
end);
InventoryController:GetAttributeChangedSignal("CurOpen"):Connect(function() -- Line: 727
    -- upvalues: InventoryController (copy), u22 (ref), u12 (ref), u29 (ref), u28 (copy), u117 (copy), u3 (ref), CraftingCategories (copy), u34 (copy), u126 (copy), u13 (ref), u138 (copy)
    if InventoryController:GetAttribute("CurOpen") ~= "Crafting" then
        return;
    end;

    if u22 then
        u22 = nil;
        u12 = false;
        u29 = u28();
        u117(u3, true);

        for _, v in pairs(CraftingCategories) do
            u34(v);
        end;

        u34("All");
    end;

    if u12 then
        local v151 = u12;
        u12 = false;
        u126(v151);
    end;

    if u13 then
        u13 = false;
        u138();
    end;
end);
u1("Setup", "\195\172\239\191\189\195\136\239\191\189\195\170\037\195\157\195\145\239\191\189\195\152\239\191\189\239\191\189\239\191\189\239\191\189\040\239\191\189\239\191\189\081\098\239\191\189", "\239\191\189\239\191\189\239\191\189\075\239\191\189\057\239\191\189\239\191\189\195\167\239\191\189\195\180\038\038\239\191\189\063\239\191\189\194\175\051\239\191\189\123", function(p152, p153) -- Line: 748
    -- upvalues: u15 (ref), InventoryController (copy), u138 (copy), u13 (ref), u132 (copy)
    u15 = p153;

    if not p152 then
        u132();

        return;
    end;

    if InventoryController:GetAttribute("CurOpen") == "Crafting" then
        u138();

        return;
    end;

    u13 = true;
end);

for _, v in pairs(CraftingCategories) do
    local v154 = RecipeModule:FetchRecipeList(v) or {};
    local v155 = {};

    for _, v2 in pairs(v154) do
        if not v2.Hidden or Values.ShowHiddenRecipes.Value then
            table.insert(v155, v2);
        end;
    end;

    u6[v] = {
        AvailableCount = 0,
        Recipes = v155,
        Hide = {}
    };
end;

if MobileModule.IsTouchDevice() then
    local v156 = {};

    for _, child in pairs(Categories:GetChildren()) do
        if child:IsA("TextButton") then
            table.insert(v156, child);
        end;
    end;

    table.sort(v156, function(p157, p158) -- Line: 787
        if p157.Position.Y.Scale == p158.Position.Y.Scale then
            return p157.Position.X.Scale < p158.Position.X.Scale;
        end;

        return p157.Position.Y.Scale < p158.Position.Y.Scale;
    end);
    Categories.AnchorPoint = Vector2.new(0, 0);
    Categories.Position = UDim2.fromScale(0.179, Categories.Position.Y.Scale);
    Categories.Size = UDim2.fromScale(0.693, Categories.Size.Y.Scale);

    for i, v in ipairs(v156) do
        v.Size = UDim2.fromScale(0.19, 0.44);
        v.Position = UDim2.fromScale(((i - 1) % 5 + 0.5) / 5, ((i - 1) // 5 + 0.5) / 2);
    end;
end;

for _, child in pairs(Categories:GetChildren()) do
    if child:IsA("TextButton") then
        local Name = child.Name;
        u8[child] = ButtonClass.new(child, "TextColor3", function() -- Line: 805
            -- upvalues: u117 (copy), Name (copy)
            u117(Name);
        end, 0.9, script:GetAttribute("CategorySelectedColor"), nil, child.Category);
    end;
end;

local function _(p159) -- Line: 810
    return p159:GetAttribute("Comfort") ~= nil;
end;

local OverlapParams_new_ret = OverlapParams.new();
OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
OverlapParams_new_ret.FilterDescendantsInstances = { Bases };
local u160 = RaycastUtil:FilterFunction("View");

while true do
    if not (Humanoid.Parent and (Humanoid.Health > 0 and HumanoidRootPart.Parent)) then
        return;
    end;

    local Position = HumanoidRootPart.Position;
    local PartBoundsInRadius = workspace:GetPartBoundsInRadius(Position, 8, OverlapParams_new_ret);
    local v161 = {};
    local v162 = {};
    local v163 = {};
    local v164 = {};

    for _, v in pairs(PartBoundsInRadius) do
        local Parent = v.Parent;

        if Parent then
            local u165 = Parent:GetAttribute("Comfort") ~= nil;

            if not (u165 or u2[Parent.Name]) then
                Parent = Parent.Parent;
            end;

            local Name = Parent.Name;

            if (u165 or u2[Name]) and not v161[Parent] then
                if u165 or not table.find(v164, Name) then
                    local v167 = RaycastUtil:Raycast(Position, v.Position - Position, "Exclude", {
                        script_Parent,
                        VFX,
                        Animals,
                        Plants,
                        Vegetation
                    }, false, function(p166) -- Line: 836
                        -- upvalues: u165 (copy), u2 (copy), Parent (ref), u160 (copy)
                        local Parent2 = p166.Parent;

                        if not (u165 or u2[Parent2.Name]) then
                            Parent2 = Parent2.Parent;
                        end;

                        if (Parent:GetAttribute("Comfort") ~= nil or u2[Parent2.Name]) and Parent2 ~= Parent then
                            return Parent2;
                        end;

                        return u160(p166);
                    end, true);

                    if v167 and v167:IsDescendantOf(Parent) then
                        v161[Parent] = true;

                        if u165 then
                            table.insert(v162, Parent);
                        else
                            table.insert(v164, Name);
                            table.insert(v163, Parent);
                        end;
                    end;
                end;
            end;
        end;
    end;

    local v168 = false;

    if #v162 == #v20 then
        if #v162 > 0 then
            for _, v in pairs(v20) do
                if not table.find(v162, v) then
                    v168 = true;
                    break;
                end;
            end;
        end;
    else
        v168 = true;
    end;

    local v169 = #v164 ~= #u19;

    if #v164 > 0 then
        table.sort(v164);
        table.sort(v163, function(p170, p171) -- Line: 876
            return p170.Name < p171.Name;
        end);
        v169 = v169 or table.concat(v164) ~= table.concat(u19);
    end;

    u18 = v163;
    u19 = v164;

    if v168 or v169 then
        local table_clone_ret = table.clone(v163);
        table.move(v162, 1, #v162, #table_clone_ret + 1, table_clone_ret);
        u1("Fire", "\195\172\239\191\189\195\136\239\191\189\195\170\037\195\157\195\145\239\191\189\195\152\239\191\189\239\191\189\239\191\189\239\191\189\040\239\191\189\239\191\189\081\098\239\191\189", "\053\239\191\189\059\239\191\189\239\191\189\239\191\189\065\194\189\195\143\239\191\189\099\082\108\195\187\195\171\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189", unpack(table_clone_ret, 1, 100));

        if v169 then
            u126();
        end;
    end;

    task.wait(#u18 > 0 and 1 or 2);
    v20 = v162;
end;