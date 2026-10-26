-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / InventoryUIModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local UIConstants = require(script.Parent.Parent:WaitForChild("UIConstants"));
local PlayerDataModule = require(script.Parent.Parent:WaitForChild("PlayerDataModule"));
local Modules = ReplicatedStorage:WaitForChild("Modules");
local GlowSelectGradient = script:WaitForChild("GlowSelectGradient");
local Color3_fromRGB_ret = Color3.fromRGB(46, 84, 255);
Color3.fromRGB(189, 209, 255);
local Color3_new_ret = Color3.new(1, 1, 1);
local ShopRemotes = ReplicatedStorage:WaitForChild("ShopRemotes");
local Update = ShopRemotes:WaitForChild("Update");
local Purchase = ShopRemotes:WaitForChild("Purchase");
local Update2 = ReplicatedStorage:WaitForChild("SettingRemotes"):WaitForChild("Update");
local Modules2 = ReplicatedStorage:WaitForChild("Modules");
local Parent = script.Parent.Parent;
local ShopModule = require(Modules2:WaitForChild("ShopModule"));
local SkinsModule = require(Modules2:WaitForChild("SkinsModule"));
local SkinTagModule = require(Modules2:WaitForChild("SkinTagModule"));
local SettingsModule = require(Modules2:WaitForChild("SettingsModule"));
local NumberUtil = require(Modules2:WaitForChild("NumberUtil"));
local ConfirmModule = require(Parent:WaitForChild("ConfirmModule"));
local SoundModule = require(Parent:WaitForChild("SoundModule"));
local Update3 = script.Parent:WaitForChild("ShopUIModule"):WaitForChild("Update");
local OpenCase = script.Parent.Parent:WaitForChild("CaseOpenModule"):WaitForChild("OpenCase");
local LocalSounds = ReplicatedStorage:WaitForChild("LocalSounds");
local u1 = {};
local u2 = {};
local u3 = { "Exclusive", "Mythical", "Legendary" };

local function SellWarning(p4: number, p5: table) -- Line: 52
    -- upvalues: u3 (copy)
    local v6 = {};

    if p4 > 0 then
        table.insert(v6, string.format("FULL SELLING %d SKIN%s - NO COPIES LEFT", p4, p4 == 1 and "" or "S"));
    end;

    local v7 = {};

    for _, v in u3 do
        local v8 = p5[v];

        if v8 and v8 > 0 then
            local v9 = v8 .. " " .. v:upper();
            table.insert(v7, v9);
        end;
    end;

    if #v7 > 0 then
        local v10 = "SELLING " .. table.concat(v7, ", ");
        table.insert(v6, v10);
    end;

    if #v6 > 0 then
        return table.concat(v6, "\n");
    end;

    return nil;
end;

local u11 = {};
local u12 = {};
local u13 = {};
local u14 = {};
local u15 = {};
local u16 = nil;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = {};
local u21 = nil;
local u22 = nil;
local Viewing = UIConstants.FRAME_INVENTORY:FindFirstChild("Viewing");

local function CurrentSkins() -- Line: 87
    -- upvalues: u22 (ref), PlayerDataModule (copy)
    return u22 or PlayerDataModule.Skins or {};
end;

local u23 = false;
local u24 = {};
local u25 = 0;
local u26 = 0;
local QuickSell = UIConstants.FRAME_INVENTORY:WaitForChild("QuickSell");
local AmountLabel = QuickSell:WaitForChild("AmountLabel");
local SellAmount = QuickSell:WaitForChild("SellAmount");
local ConfirmSell = QuickSell:WaitForChild("ConfirmSell");
local u27 = QuickSell:FindFirstChildOfClass("ImageLabel");
local SellBackground = UIConstants.SCROLLFRAME_SKINS.Template:WaitForChild("SellBackground");
local RedTint = UIConstants.FRAME_INVENTORY.Parent:WaitForChild("RedTint");
local u28 = {
    Background = Color3.new(0.373, 0.596, 0.118),
    SelectGradient = Color3.new(0.537, 0.702, 0.271),
    Stroke = Color3.new(0.663, 0.945, 0.239),
    UIGradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0.467, 0.471, 0.157)), ColorSequenceKeypoint.new(0.25, Color3.new(0.737, 0.741, 0.431)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) })
};
local u29 = {
    Background = Color3.new(0.596, 0.098, 0.098),
    SelectGradient = Color3.new(0.702, 0.278, 0.278),
    Stroke = Color3.new(0.945, 0.282, 0.282),
    UIGradient = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0.471, 0.149, 0.149)), ColorSequenceKeypoint.new(0.25, Color3.new(0.741, 0.459, 0.459)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)) })
};
local Main = UIConstants.FRAME_CRATESCROLLER:WaitForChild("Main");

local function hideTemplates(p30) -- Line: 132
    for _, child in ipairs(p30:GetChildren()) do
        if child:IsA("ImageButton") and child.Name:sub(1, 8) == "Template" then
            child.Visible = false;
        end;
    end;
end;

hideTemplates(Main.List.Container);
hideTemplates(Main.ZoomEffect.Container);

local function CreateWheelSpinner(p31: string, p32: string, p33: number, p34: boolean, p35: any?) -- Line: 143
    -- upvalues: UIConstants (copy), ShopModule (copy), SkinsModule (copy), u21 (ref), LocalSounds (copy), TweenService (copy), SoundModule (copy), NumberUtil (copy), PlayerDataModule (copy), UserInputService (copy)
    local FRAME_CRATESCROLLER = UIConstants.FRAME_CRATESCROLLER;
    local Main2 = FRAME_CRATESCROLLER.Main;
    local Container = Main2.List.Container;
    local Container2 = Main2.ZoomEffect.Container;
    local Skip = Main2.Skip;
    local X = Container.AbsolutePosition.X;
    local X2 = Container.AbsoluteSize.X;
    local X3 = Container2.AbsolutePosition.X;
    local X4 = Container2.AbsoluteSize.X;
    local u36 = Container2.TemplateCommon.AbsoluteSize.X / Container.TemplateCommon.AbsoluteSize.X;

    local function masterToZoomX(p37: number) -- Line: 157
        -- upvalues: X (copy), X2 (copy), X3 (copy), X4 (copy), u36 (copy)
        return 0.5 + ((X + p37 * X2 - X3) / X4 - 0.5) * u36;
    end;

    local v38 = ShopModule[p32];

    if not v38 then
        return;
    end;

    local Items = v38.Items;
    local Spinner = v38.Spinner;
    local v39 = Items[p33];

    if not v39 then
        return;
    end;

    local v40 = v39[3];

    if not v40 or v40 < 1 then
        return;
    end;

    local math_random_ret = math.random(1, v40);
    local v41 = 0;
    local v42 = nil;

    for i, v in pairs(Spinner) do
        if v == p33 then
            v41 = v41 + 1;

            if v41 >= math_random_ret then
                v42 = i;
                break;
            end;
        end;
    end;

    if not v42 then
        return;
    end;

    for _, child in pairs(Container:GetChildren()) do
        if child.Name:sub(1, 4) == "Skin" and child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    for _, child in pairs(Container2:GetChildren()) do
        if child.Name:sub(1, 4) == "Skin" and child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;

    local VisibleSkin = FRAME_CRATESCROLLER:FindFirstChild("VisibleSkin");

    if VisibleSkin then
        VisibleSkin:Destroy();
    end;

    Main2.PressContinue.Visible = false;
    local Random_new_ret = Random.new();
    local v43 = Random_new_ret:NextInteger(45, 50);
    local v44 = v42 - (v43 - 5);
    local v45 = p32:match("^FallenCrate%d+$");
    local u46 = {};
    local v47 = -1;
    local v48 = {};
    local v49 = nil;
    local v50 = nil;
    local v51 = nil;
    local v52 = nil;

    for i, v in Items do
        local v53 = v[2];
        local v54;

        if type(v53) == "table" then
            v54 = v53[1] and SkinsModule:GetSkinInfo(v53[1]);
        else
            v54 = false;
        end;

        if v54 then
            v54 = v54.Rarity;
        end;

        u46[i] = v54;
    end;

    local function NearMissIndex(p55: string) -- Line: 213
        -- upvalues: Items (copy), u46 (copy), Random_new_ret (copy)
        local v56 = 0;
        local v57 = {};

        for i, v in Items do
            local v58 = v[3];

            if u46[i] == p55 and (v58 and v58 >= 1) then
                v56 = v56 + v58;
                table.insert(v57, { i, v56 });
            end;
        end;

        if v56 == 0 then
            return nil;
        end;

        local v59 = Random_new_ret:NextInteger(1, v56);

        for _, v in v57 do
            if v59 <= v[2] then
                return v[1];
            end;
        end;

        return nil;
    end;

    local v60;

    if v45 then
        v60 = NearMissIndex("Legendary");
    else
        v60 = nil;
    end;

    local v61;

    if v45 then
        v61 = NearMissIndex("Mythical");
    else
        v61 = nil;
    end;

    local v62;

    if v60 and Random_new_ret:NextInteger(1, 8) == 1 then
        v62 = Random_new_ret:NextInteger(1, 2) * (Random_new_ret:NextInteger(1, 2) * 2 - 3);
    else
        v62 = nil;
    end;

    local v63;

    if v61 and Random_new_ret:NextInteger(1, 16) == 1 then
        v63 = Random_new_ret:NextInteger(1, 2) * (Random_new_ret:NextInteger(1, 2) * 2 - 3);
    else
        v63 = nil;
    end;

    if v62 and v62 == v63 then
        v62 = v62 * -1;
    end;

    if v62 and (v63 and (math.abs(v62) == 1 and math.abs(v63) == 1)) then
        v62 = (math.abs(v62) + 1) * math.sign(v62);
    end;

    for i = 1, v43 do
        v44 = v44 + 1;
        v47 = v47 + 1;
        local v64;

        if v44 <= 0 then
            v64 = #Spinner + v44;
        elseif #Spinner < v44 then
            v64 = v44 - #Spinner;
        else
            v64 = v44;
        end;

        local v65 = v64 == v42;
        local v66, v67;

        if v65 then
            v66 = p31;
            v67 = i;
        else
            local v68 = Spinner[v64];

            if v63 and (v64 == v42 + v63 and u46[v68] ~= "Mythical") then
                v68 = v61;
                v62 = nil;
            elseif v62 and (v64 == v42 + v62 and u46[v68] ~= "Legendary") then
                v68 = v60;
                v62 = nil;
            end;

            local v69 = Items[v68][2];
            v66 = p31;
            v67 = i;

            for i2 = 1, 20 do
                p31 = v69[Random_new_ret:NextInteger(1, #v69)];

                if not v50 or `{v50}/{v52}` ~= p31 then
                    break;
                end;

                local _ = i2;
            end;
        end;

        v50, v52 = unpack(string.split(p31, "/"));
        local SkinInfo = SkinsModule:GetSkinInfo(p31);
        local Rarity = SkinInfo.Rarity;
        local Image = SkinInfo.Image;
        local v70 = Container:FindFirstChild("Template" .. Rarity);
        local v71 = Container2:FindFirstChild("Template" .. Rarity);

        if v70 and v71 then
            local v72 = v47 * 0.117 + 0.032;
            local v73 = 0.5 + ((X + v72 * X2 - X3) / X4 - 0.5) * u36;
            local v74 = v70:Clone();
            v74.Frame.ItemImage.Image = Rarity == "Mythical" and "rbxassetid://109638213801872" or Image;
            v74.Frame.SkinName.Text = Rarity == "Mythical" and "???" or v52;
            v74.Frame.ItemName.Text = Rarity == "Mythical" and "???" or v50;
            v74.Name = "Skin" .. v47 + 1;
            v74.Position = UDim2.new(v72, 0, 0.5, 0);
            v74.Parent = Container;
            v74.Visible = true;
            local v75 = v71:Clone();
            v75.Frame.ItemImage.Image = Rarity == "Mythical" and "rbxassetid://109638213801872" or Image;
            v75.Frame.SkinName.Text = Rarity == "Mythical" and "???" or v52;
            v75.Frame.ItemName.Text = Rarity == "Mythical" and "???" or v50;
            v75.Name = "Skin" .. v47 + 1;
            v75.Position = UDim2.new(v73, 0, 0.5, 0);
            v75.Parent = Container2;
            v75.Visible = true;
            local UIScale = Instance.new("UIScale");
            UIScale.Scale = 1.06;
            UIScale.Parent = v75;
            v48[v47] = {
                list = v74,
                zoom = v75,
                listStartX = v72,
                zoomStartX = v73,
                DoDrum = Rarity == "Mythical" and true or Rarity == "Legendary"
            };

            if v65 then
                local v76;

                if Random_new_ret:NextInteger(1, 3) == 1 then
                    v76 = Random_new_ret:NextNumber(0, 0.03);
                else
                    v76 = Random_new_ret:NextNumber(0.03, 0.057);
                end;

                local v77 = v76 * (Random_new_ret:NextInteger(1, 2) * 2 - 3);
                v51 = v72 - 0.5 + v77;

                if Rarity == "Mythical" then
                    v75:SetAttribute("Image", Image);
                    v75:SetAttribute("Skin", v52);
                    v75:SetAttribute("Item", v50);
                    v49 = v75;
                    p31 = v66;
                else
                    v49 = v75;
                    p31 = v66;
                end;
            else
                p31 = v66;
            end;
        else
            p31 = v66;
        end;
    end;

    local v78 = (1 / 0);
    local v79 = nil;

    for i, v in pairs(v48) do
        local math_abs_ret = math.abs(v.listStartX - 0.5);

        if math_abs_ret < v78 then
            v79 = i;
            v78 = math_abs_ret;
        end;
    end;

    for i, v in pairs(v48) do
        v.list.Visible = i ~= v79;
    end;

    local JoinedGroup = Main2:FindFirstChild("JoinedGroup");

    if JoinedGroup then
        JoinedGroup.Visible = p34 == true;
    end;

    Main2.Line.BackgroundTransparency = 0.25;
    FRAME_CRATESCROLLER.Visible = true;

    if u21 then
        u21:Disconnect();
    end;

    local u80 = 0;
    u21 = Skip.Activated:Connect(function() -- Line: 332
        -- upvalues: u80 (ref), Skip (copy)
        u80 = math.max(u80, 0.8);
        Skip.Visible = false;
    end);
    Skip.Visible = true;
    task.wait(0.25);
    LocalSounds.Drumroll.Volume = 0;
    LocalSounds.Drumroll:Stop();
    LocalSounds.Drumroll:Play();
    local v81 = 0;
    local v82 = 0;
    local v83 = 0.0585;

    repeat
        local v84 = u80 + task.wait() / (v82 * 10 + 5);
        u80 = math.min(v84, 1);

        if u80 >= 0.8 then
            Skip.Visible = false;
        end;

        local v85 = v51 * TweenService:GetValue(u80, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out);

        if v81 then
            v83 = v83 - (v85 - v81);

            if v83 < 0 then
                SoundModule.PlaySound("WheelClick");

                while v83 < 0 do
                    v83 = v83 + 0.117;
                end;
            end;
        end;

        v81 = v85;
        local v86 = (1 / 0);
        local v87 = (1 / 0);
        local v88 = nil;

        for i, v in pairs(v48) do
            local v89 = v.listStartX - v85;

            if v.DoDrum then
                local math_abs_ret = math.abs(v89 - 0.5);
                v86 = math.min(v86, math_abs_ret);
            end;

            local math_abs_ret = math.abs(v89 - 0.5);

            if math_abs_ret < v87 then
                v88 = i;
            else
                math_abs_ret = v87;
            end;

            v.list.Position = UDim2.new(v89, 0, 0.5, 0);
            v.zoom.Position = UDim2.new(0.5 + ((X + v89 * X2 - X3) / X4 - 0.5) * u36, 0, 0.5, 0);

            if v89 > -0.1 then
                v87 = math_abs_ret;
            else
                v.list:Destroy();
                v.zoom:Destroy();
                v48[i] = nil;
                v87 = math_abs_ret;
            end;
        end;

        for i, v in pairs(v48) do
            v.list.Visible = i ~= v88;
        end;

        v82 = math.clamp((0.25 - v86) / 0.25, 0, 1) * math.clamp((u80 - 0.65) / 0.05, 0, 1);
        LocalSounds.Drumroll.Volume = v82 * 0.7;
    until u80 >= 1;

    task.wait(0.3);

    if p35 then
        task.spawn(p35);
    end;

    v49.Name = "VisibleSkin";
    v49.ZIndex = v49.ZIndex + 1;
    v49.Position = UDim2.new(0.5, 0, 0.5, 0);
    v49:TweenSize(NumberUtil:MultUDim2ByNum(v49.Size, 1.4), "Out", "Quart", 0.3, true);
    local v90 = 0;

    for _, v in PlayerDataModule and PlayerDataModule.Skins or {} do
        if v == p31 then
            v90 = v90 + 1;

            if v90 > 1 then
                break;
            end;
        end;
    end;

    local v91 = v90 <= 1;
    local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out);
    TweenService:Create(Main2.Line, TweenInfo_new_ret, {
        BackgroundTransparency = 1
    }):Play();
    SoundModule.PlaySound("Sparkle");
    local v92 = TweenService:Create(LocalSounds.Drumroll, TweenInfo_new_ret, {
        Volume = 0
    });
    v92:Play();
    v92.Completed:Connect(function() -- Line: 419
        -- upvalues: LocalSounds (ref)
        LocalSounds.Drumroll:Stop();
    end);

    if v49:GetAttribute("Image") then
        task.wait(1);
        local TweenInfo_new_ret2 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        TweenService:Create(v49.Frame.ItemImage, TweenInfo_new_ret2, {
            ImageTransparency = 1
        }):Play();
        TweenService:Create(v49.Frame.SkinName, TweenInfo_new_ret2, {
            TextTransparency = 1
        }):Play();
        local v93 = TweenService:Create(v49.Frame.ItemName, TweenInfo_new_ret2, {
            TextTransparency = 1
        });
        v93:Play();
        v93.Completed:Wait();
        v49.Frame.ItemImage.Image = v49:GetAttribute("Image");
        v49.Frame.SkinName.Text = v49:GetAttribute("Skin");
        v49.Frame.ItemName.Text = v49:GetAttribute("Item");
        TweenService:Create(v49.Frame.ItemImage, TweenInfo_new_ret2, {
            ImageTransparency = 0
        }):Play();
        TweenService:Create(v49.Frame.SkinName, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
        TweenService:Create(v49.Frame.ItemName, TweenInfo_new_ret2, {
            TextTransparency = 0
        }):Play();
        v49.New.Visible = v91;
        task.wait(2);
    else
        v49.New.Visible = v91;
        task.wait(1);
    end;

    Main2.PressContinue.Visible = true;
    UserInputService.InputBegan:Wait();
    v49:TweenPosition(UDim2.new(0.5, 0, -1.5, 0), "In", "Quart", 1, true);
    task.wait(1);
    v49:Destroy();
    FRAME_CRATESCROLLER.Visible = false;
end;

script:WaitForChild("OpenSpinner").OnInvoke = CreateWheelSpinner;

local function ToggleSkinHover(p94: boolean, p95: userdata) -- Line: 455
    -- upvalues: u18 (ref), Color3_fromRGB_ret (copy), Color3_new_ret (copy), GlowSelectGradient (copy)
    if u18 == p95 then
        return;
    end;

    local Frame = p95.Frame;
    local UIStroke = Frame.UIStroke;
    local UIGradient = UIStroke.UIGradient;
    local Glow = Frame.Glow;
    local UIGradient2 = Glow.UIGradient;
    local GlowSelectGradient2 = Glow:FindFirstChild("GlowSelectGradient");
    UIGradient.Enabled = not p94;
    UIStroke.Color = p94 and Color3_fromRGB_ret or Color3_new_ret;

    if p94 then
        UIGradient2.Enabled = false;

        if not GlowSelectGradient2 then
            GlowSelectGradient:Clone().Parent = Glow;
        end;

        return;
    end;

    if GlowSelectGradient2 then
        GlowSelectGradient2:Destroy();
    end;

    UIGradient2.Enabled = true;
end;

local function SelectSkin(p96: userdata, p97: boolean?) -- Line: 479
    -- upvalues: u18 (ref), SelectSkin (copy), Color3_new_ret (copy), UIConstants (copy), SkinsModule (copy), SkinTagModule (copy), u20 (ref), SettingsModule (copy), PlayerDataModule (copy), ShopModule (copy), u22 (ref), SoundModule (copy), Update2 (copy), SellWarning (copy), u2 (copy), ConfirmModule (copy), Purchase (copy)
    local v98 = false;
    local v99;

    if p97 then
        v99 = true;
    else
        v99 = u18 == p96 and true or v98;

        if u18 and u18.Parent then
            SelectSkin(u18, true);
        end;

        local v100;

        if v99 or not p96 then
            v100 = nil;
        else
            v100 = p96;
        end;

        u18 = v100;
    end;

    local Frame = p96.Frame;
    local UIStroke = Frame.UIStroke;
    local UIGradient = UIStroke.UIGradient;
    local Glow = Frame.Glow;
    local UIGradient2 = Glow.UIGradient;
    local GlowSelectGradient2 = Glow:FindFirstChild("GlowSelectGradient");

    if GlowSelectGradient2 then
        GlowSelectGradient2:Destroy();
    end;

    UIGradient2.Enabled = v99;
    UIGradient.Enabled = v99;
    UIStroke.Color = Color3_new_ret;
    UIStroke.Transparency = v99 and 0.44 or 0;

    if p97 then
        return;
    end;

    if v99 then
        UIConstants.FRAME_SKINS_SELECTED.Visible = false;

        return;
    end;

    local Attribute = p96:GetAttribute("SkinIndex");
    local string_split_ret = string.split(Attribute, "/");
    local Rarity = SkinsModule.CachedSkinRarities[Attribute].Rarity;
    local _ = SkinsModule.CachedSkinRarities[Attribute].Info;
    local SelectedStats = UIConstants.FRAME_SKINS_SELECTED.SelectedStats;
    local ItemContainer = SelectedStats.ItemContainer;
    local u101 = SkinsModule.CachedItemIds[string_split_ret[1]];
    local u102;

    if u101 then
        u102 = tostring(u101) or nil;
    else
        u102 = nil;
    end;

    for _, child in pairs(ItemContainer:GetChildren()) do
        if child.Name == Rarity then
            child.ItemImage.Image = SkinsModule.CachedSkinRarities[Attribute].Image;
            child.Visible = true;
        else
            child.Visible = false;
        end;
    end;

    SkinTagModule.ApplyToFrame(SelectedStats.TextFrame, Attribute);

    for _, v in pairs(u20) do
        v:Disconnect();
    end;

    u20 = {};

    local function GetEquippedSkin() -- Line: 539
        -- upvalues: u102 (copy), SettingsModule (ref), PlayerDataModule (ref)
        if not u102 then
            return nil;
        end;

        local v103 = SettingsModule.SkinPresets or PlayerDataModule and PlayerDataModule.SkinPresets;

        return v103 and v103[u102] or nil;
    end;

    local function UpdateSelectedButton(p104: userdata) -- Line: 545
        -- upvalues: u102 (copy), SettingsModule (ref), PlayerDataModule (ref), string_split_ret (copy), ShopModule (ref), Rarity (copy), SkinsModule (ref), Attribute (copy), u22 (ref)
        if not u102 then
            p104.Visible = false;

            return;
        end;

        if not p104.Name:find("Equip") then
            if p104.Name:find("Sell") then
                local v105 = SkinsModule.CachedSkinRarities[Attribute];
                local v106;

                if u22 == nil and (ShopModule.RaritySells.Amounts[Rarity] ~= nil and type(v105) == "table") then
                    v106 = not v105.Info[5];
                else
                    v106 = false;
                end;

                p104.Visible = v106;
            end;

            return;
        end;

        local v107;

        if u102 then
            local v108 = SettingsModule.SkinPresets or PlayerDataModule and PlayerDataModule.SkinPresets;
            v107 = v108 and v108[u102] or nil;
        else
            v107 = nil;
        end;

        p104.Detail.Frame.TextLabel.Text = v107 == string_split_ret[2] and "UNEQUIP" or "EQUIP";
    end;

    local SelectedEquip = UIConstants.FRAME_SKINS_SELECTED.SelectedEquip;
    SelectedEquip.Visible = u22 == nil;
    UpdateSelectedButton(SelectedEquip);
    table.insert(u20, SelectedEquip.MouseButton1Click:Connect(function() -- Line: 568
        -- upvalues: SoundModule (ref), u101 (copy), u102 (copy), SettingsModule (ref), PlayerDataModule (ref), string_split_ret (copy), Update2 (ref), UpdateSelectedButton (copy), SelectedEquip (copy)
        SoundModule.PlaySound("Click");

        if not u101 then
            return;
        end;

        local v109;

        if u102 then
            local v110 = SettingsModule.SkinPresets or PlayerDataModule and PlayerDataModule.SkinPresets;
            v109 = v110 and v110[u102] or nil;
        else
            v109 = nil;
        end;

        local v111 = v109 == string_split_ret[2] and "Default" or string_split_ret[2];
        SettingsModule.SetSkinPreset(SettingsModule.SkinPresets, u101, v111);

        if PlayerDataModule and PlayerDataModule.SkinPresets then
            local v112;

            if v111 == "Default" or not v111 then
                v112 = nil;
            else
                v112 = v111;
            end;

            PlayerDataModule.SkinPresets[u102] = v112;
        end;

        Update2:FireServer("SkinPresets", u101, v111);
        UpdateSelectedButton(SelectedEquip);
    end));
    table.insert(u20, SelectedEquip.MouseEnter:Connect(function() -- Line: 588
        -- upvalues: SoundModule (ref), SelectedEquip (copy), Color3_new_ret (ref)
        SoundModule.PlaySound("Hover");
        SelectedEquip.Detail.Frame.UIStroke.Color = Color3_new_ret;
    end));
    table.insert(u20, SelectedEquip.MouseLeave:Connect(function() -- Line: 592
        -- upvalues: SelectedEquip (copy)
        SelectedEquip.Detail.Frame.UIStroke.Color = SelectedEquip.Detail.Frame.UIStroke:GetAttribute("ColorDefault");
    end));
    local SelectedSell = UIConstants.FRAME_SKINS_SELECTED.SelectedSell;
    UpdateSelectedButton(SelectedSell);
    table.insert(u20, SelectedSell.MouseButton1Click:Connect(function() -- Line: 600
        -- upvalues: SoundModule (ref), ShopModule (ref), Rarity (copy), SellWarning (ref), u2 (ref), Attribute (copy), ConfirmModule (ref), Purchase (ref), UIConstants (ref), u18 (ref)
        SoundModule.PlaySound("Click");
        local v113 = ShopModule.RaritySells.Amounts[Rarity];

        if not v113 then
            return;
        end;

        local v114 = SellWarning((u2[Attribute] or 0) <= 1 and 1 or 0, {
            [Rarity] = 1
        });

        if not ConfirmModule.Prompt("Sell", "Are you sure you want to sell this skin?", v113, nil, v114, v114 and 2 or nil) then
            return;
        end;

        Purchase:FireServer("RaritySells", Attribute);
        UIConstants.FRAME_SKINS_SELECTED.Visible = false;
        u18 = nil;
    end));
    table.insert(u20, SelectedSell.MouseEnter:Connect(function() -- Line: 612
        -- upvalues: SoundModule (ref), SelectedSell (copy), Color3_new_ret (ref)
        SoundModule.PlaySound("Hover");
        SelectedSell.Detail.Frame.UIStroke.Color = Color3_new_ret;
    end));
    table.insert(u20, SelectedSell.MouseLeave:Connect(function() -- Line: 616
        -- upvalues: SelectedSell (copy)
        SelectedSell.Detail.Frame.UIStroke.Color = SelectedSell.Detail.Frame.UIStroke:GetAttribute("ColorDefault");
    end));
    UIConstants.FRAME_SKINS_SELECTED.Visible = true;
end;

local function UpdateQuickSellLabels() -- Line: 626
    -- upvalues: AmountLabel (copy), u25 (ref), ShopModule (copy), SellAmount (copy), NumberUtil (copy), u26 (ref), u23 (ref), ConfirmSell (copy), u27 (copy), u16 (ref)
    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    local v115 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v115;
    ConfirmSell.Visible = v115;

    if u27 then
        u27.Visible = v115;
    end;

    if u16 then
        u16();
    end;
end;

local function SetSellHighlight(p116) -- Line: 640
    -- upvalues: u12 (copy), u24 (copy)
    local v117 = u12[p116];

    if not v117 then
        return;
    end;

    local SellHighlight = v117:FindFirstChild("SellHighlight");

    if SellHighlight then
        SellHighlight.Visible = u24[p116] == true;
    end;
end;

local function ClearQuickSellSelection() -- Line: 649
    -- upvalues: u24 (copy), u12 (copy), u25 (ref), u26 (ref)
    for i in pairs(u24) do
        u24[i] = nil;
        local v118 = u12[i];

        if v118 then
            local SellHighlight = v118:FindFirstChild("SellHighlight");

            if SellHighlight then
                SellHighlight.Visible = u24[i] == true;
            end;
        end;
    end;

    u25 = 0;
    u26 = 0;
end;

local function SellBlocked(p119) -- Line: 659
    return p119.Locked and "Locked" or (not p119.SellAmount and "NoValue" or nil);
end;

local function SetQuickSellSelected(p120: any, p121: boolean) -- Line: 666
    -- upvalues: u24 (copy), u25 (ref), ShopModule (copy), u26 (ref), u12 (copy)
    if p121 == (u24[p120] == true) then
        return true;
    end;

    if p121 then
        if p120.Locked and "Locked" or (not p120.SellAmount and "NoValue" or nil) then
            return false;
        end;

        if u25 >= ShopModule.RaritySells.MaxQuickSellBatch then
            return false;
        end;

        u24[p120] = true;
        u25 = u25 + 1;
        u26 = u26 + p120.SellAmount;
    else
        u24[p120] = nil;
        u25 = u25 - 1;
        u26 = u26 - p120.SellAmount;
    end;

    local v122 = u12[p120];
    local v123 = v122 and v122:FindFirstChild("SellHighlight");

    if v123 then
        v123.Visible = u24[p120] == true;
    end;

    return true;
end;

local function ToggleSkinQuickSell(p124: userdata) -- Line: 686
    -- upvalues: u13 (copy), u24 (copy), SoundModule (copy), u25 (ref), ShopModule (copy), u26 (ref), u12 (copy), AmountLabel (copy), SellAmount (copy), NumberUtil (copy), u23 (ref), ConfirmSell (copy), u27 (copy), u16 (ref)
    local v125 = u13[p124];

    if not v125 then
        return;
    end;

    local v126 = u24[v125] ~= true;

    if v126 and (v125.Locked or not v125.SellAmount) then
        SoundModule.PlaySound("Error");

        return;
    end;

    local v127, v128;

    if v126 == (u24[v125] == true) then
        v127 = true;
    else
        local v129, v130;

        if not v126 then
            u24[v125] = nil;
            u25 = u25 - 1;
            u26 = u26 - v125.SellAmount;
            v129 = u12[v125];
            v130 = v129 and v129:FindFirstChild("SellHighlight");

            if v130 then
                v130.Visible = u24[v125] == true;
                v127 = true;
            else
                v127 = true;
            end;

            if not v127 then
                SoundModule.PlaySound("Error");

                return;
            end;

            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            v128 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v128;
            ConfirmSell.Visible = v128;

            if u27 then
                u27.Visible = v128;
            end;

            if u16 then
                u16();
            end;
        end;

        if not v125.Locked and v125.SellAmount and u25 < ShopModule.RaritySells.MaxQuickSellBatch then
            u24[v125] = true;
            u25 = u25 + 1;
            u26 = u26 + v125.SellAmount;
            v129 = u12[v125];
            v130 = v129 and v129:FindFirstChild("SellHighlight");

            if v130 then
                v130.Visible = u24[v125] == true;
                v127 = true;
            else
                v127 = true;
            end;

            if not v127 then
                SoundModule.PlaySound("Error");

                return;
            end;

            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            v128 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v128;
            ConfirmSell.Visible = v128;

            if u27 then
                u27.Visible = v128;
            end;

            if u16 then
                u16();
            end;
        end;

        v127 = false;
    end;

    if not v127 then
        SoundModule.PlaySound("Error");

        return;
    end;

    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    v128 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v128;
    ConfirmSell.Visible = v128;

    if u27 then
        u27.Visible = v128;
    end;

    if u16 then
        u16();
    end;
end;

local function ApplyQuickSellAppearance(p131: boolean) -- Line: 701
    -- upvalues: u29 (copy), u28 (copy), QuickSell (copy)
    local v132;

    if p131 then
        v132 = u29;
    else
        v132 = u28;
    end;

    local Frame = QuickSell.Detail.Frame;
    Frame.BackgroundColor3 = v132.Background;
    Frame.Select.UIGradient.Color = ColorSequence.new(v132.SelectGradient);
    Frame.UIGradient.Color = v132.UIGradient;
    Frame.Effect.Color = v132.Stroke;
    Frame.Effect:SetAttribute("ColorDefault", v132.Stroke);
    Frame.TextLabel.Text = p131 and "QUICK SELL: ENABLED" or "QUICK SELL: DISABLED";
end;

local NavBar = UIConstants.FRAME_INVENTORY.Parent:FindFirstChild("NavBar");

if NavBar then
    NavBar = NavBar:FindFirstChild("Shop", true);
end;

if NavBar then
    NavBar = NavBar:FindFirstChild("Limited");
end;

local function ExitQuickSellMode() -- Line: 720
    -- upvalues: u24 (copy), u12 (copy), u25 (ref), u26 (ref), u23 (ref), RedTint (copy), NavBar (copy), ApplyQuickSellAppearance (copy), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), ConfirmSell (copy), u27 (copy), u16 (ref)
    for i in pairs(u24) do
        u24[i] = nil;
        local v133 = u12[i];

        if v133 then
            local SellHighlight = v133:FindFirstChild("SellHighlight");

            if SellHighlight then
                SellHighlight.Visible = u24[i] == true;
            end;
        end;
    end;

    u25 = 0;
    u26 = 0;
    u23 = false;
    RedTint.Visible = false;

    if NavBar then
        NavBar.Visible = true;
    end;

    ApplyQuickSellAppearance(false);
    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    local v134 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v134;
    ConfirmSell.Visible = v134;

    if u27 then
        u27.Visible = v134;
    end;

    if u16 then
        u16();
    end;

    if u16 then
        u16();
    end;
end;

local function EnterQuickSellMode() -- Line: 734
    -- upvalues: UIConstants (copy), u18 (ref), u24 (copy), u12 (copy), u25 (ref), u26 (ref), u23 (ref), RedTint (copy), NavBar (copy), ApplyQuickSellAppearance (copy), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), ConfirmSell (copy), u27 (copy), u16 (ref)
    UIConstants.FRAME_SKINS_SELECTED.Visible = false;
    u18 = nil;

    for i in pairs(u24) do
        u24[i] = nil;
        local v135 = u12[i];

        if v135 then
            local SellHighlight = v135:FindFirstChild("SellHighlight");

            if SellHighlight then
                SellHighlight.Visible = u24[i] == true;
            end;
        end;
    end;

    u25 = 0;
    u26 = 0;
    u23 = true;
    RedTint.Visible = true;

    if NavBar then
        NavBar.Visible = false;
    end;

    ApplyQuickSellAppearance(true);
    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    local v136 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v136;
    ConfirmSell.Visible = v136;

    if u27 then
        u27.Visible = v136;
    end;

    if u16 then
        u16();
    end;

    if u16 then
        u16();
    end;
end;

local function OnQuickSellConfirm() -- Line: 750
    -- upvalues: u25 (ref), u26 (ref), u24 (copy), u2 (copy), SellWarning (copy), ConfirmModule (copy), Purchase (copy), u12 (copy), u23 (ref), RedTint (copy), NavBar (copy), ApplyQuickSellAppearance (copy), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), ConfirmSell (copy), u27 (copy), u16 (ref)
    if u25 == 0 or u26 <= 0 then
        return;
    end;

    local v137 = {};

    for i in pairs(u24) do
        table.insert(v137, i.Index);
    end;

    local v138 = {};
    local v139 = {};

    for i in pairs(u24) do
        v138[i.Index] = (v138[i.Index] or 0) + 1;
        v139[i.Rarity] = (v139[i.Rarity] or 0) + 1;
    end;

    local v140 = 0;

    for i, v in v138 do
        if (u2[i] or 0) <= v then
            v140 = v140 + 1;
        end;
    end;

    local v141 = SellWarning(v140, v139);

    if not ConfirmModule.Prompt("Sell", string.format("Sell %d skins?", u25), u26, nil, v141, v141 and 5 or nil) then
        return;
    end;

    Purchase:FireServer("QuickSell", v137);

    for i in pairs(u24) do
        u24[i] = nil;
        local v142 = u12[i];

        if v142 then
            local SellHighlight = v142:FindFirstChild("SellHighlight");

            if SellHighlight then
                SellHighlight.Visible = u24[i] == true;
            end;
        end;
    end;

    u25 = 0;
    u26 = 0;
    u23 = false;
    RedTint.Visible = false;

    if NavBar then
        NavBar.Visible = true;
    end;

    ApplyQuickSellAppearance(false);
    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    local v143 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v143;
    ConfirmSell.Visible = v143;

    if u27 then
        u27.Visible = v143;
    end;

    if u16 then
        u16();
    end;

    if u16 then
        u16();
    end;
end;

local SkinFilterState = require(Modules:WaitForChild("SkinFilterState"));
local u144 = {};
local u145 = { "Exclusive", "Mythical", "Legendary", "Epic", "Rare", "Common" };
local u146 = {
    Exclusive = 1,
    Mythical = 2,
    Legendary = 3,
    Epic = 4,
    Rare = 5,
    Common = 6
};

for i, v in SkinsModule.CachedItemIds do
    if v then
        u144[v] = i;
    end;
end;

local u147 = nil;
local u148 = 0;
local u149 = false;

local function FlushSaveFilters() -- Line: 817
    -- upvalues: u149 (ref), Update2 (copy), u147 (ref), SkinFilterState (copy)
    if not u149 then
        return;
    end;

    u149 = false;
    Update2:FireServer("SkinFilters", u147 or SkinFilterState.DEFAULT_ENCODED);
end;

local function QueueSaveFilters() -- Line: 828
    -- upvalues: SkinFilterState (copy), SkinsModule (copy), u147 (ref), u149 (ref), u148 (ref), Update2 (copy)
    if not SkinFilterState.Hydrated then
        return;
    end;

    local v150 = SkinFilterState.Encode(SkinsModule.CachedItemIds);

    if v150 == u147 then
        return;
    end;

    u147 = v150;
    u149 = true;
    u148 = u148 + 1;
    local u151 = u148;
    task.delay(0.6, function() -- Line: 836
        -- upvalues: u151 (copy), u148 (ref), u149 (ref), Update2 (ref), u147 (ref), SkinFilterState (ref)
        if u151 ~= u148 then
            return;
        end;

        if not u149 then
            return;
        end;

        u149 = false;
        Update2:FireServer("SkinFilters", u147 or SkinFilterState.DEFAULT_ENCODED);
    end);
end;

local function BuildEntries() -- Line: 843
    -- upvalues: u1 (copy), u2 (copy), u15 (copy), u22 (ref), PlayerDataModule (copy), SkinsModule (copy), ShopModule (copy)
    table.clear(u1);
    table.clear(u2);
    table.clear(u15);

    for i, v in u22 or PlayerDataModule.Skins or {} do
        local v152 = SkinsModule.CachedSkinRarities[v];

        if v152 then
            local string_split_ret = string.split(v, "/");
            local Info = v152.Info;
            local v153 = (u2[v] or 0) + 1;
            u2[v] = v153;
            u15[v152.Rarity] = (u15[v152.Rarity] or 0) + 1;
            local v154 = {
                Index = v,
                Item = string_split_ret[1],
                Skin = string_split_ret[2],
                Rarity = v152.Rarity,
                Image = v152.Image
            };
            local v155;

            if type(Info) == "table" then
                v155 = Info[6];
            else
                v155 = nil;
            end;

            v154.Bundle = v155;
            v154.Locked = type(Info) == "table" and Info[5] and true or false;
            v154.SellAmount = ShopModule.RaritySells.Amounts[v152.Rarity];
            v154.Order = i;
            v154.Copy = v153;
            table.insert(u1, v154);
        else
            warn("SKIN : " .. tostring(v) .. " WARNING: NO CACHE FOUND IN CachedSkinRarities");
        end;
    end;
end;

local function SearchTerms() -- Line: 874
    -- upvalues: SkinFilterState (copy)
    local v156 = {};

    for i in string.gmatch(SkinFilterState.Search:lower(), "[^,]+") do
        local v157 = i:gsub("^%s+", ""):gsub("%s+$", "");

        if v157 ~= "" then
            table.insert(v156, v157);
        end;
    end;

    return v156;
end;

local function MatchesSearch(p158: any, p159: table) -- Line: 885
    for _, v in p159 do
        if p158.Item:lower():find(v, 1, true) or (p158.Skin:lower():find(v, 1, true) or p158.Bundle ~= nil and p158.Bundle:lower():find(v, 1, true)) then
            return true;
        end;
    end;

    return false;
end;

local function SortValue(p160: any, p161: string) -- Line: 896
    -- upvalues: u146 (copy)
    if p161 == "Skin" then
        return p160.Skin:lower();
    end;

    if p161 == "Weapon" then
        return p160.Item:lower();
    end;

    if p161 == "Newest" then
        return -p160.Order;
    end;

    return p161 ~= "Bundle" and (u146[p160.Rarity] or 99) or (p160.Bundle or "zzzz"):lower();
end;

local function CompareEntries(p162, p163) -- Line: 912
    -- upvalues: SkinFilterState (copy), SortValue (copy), u146 (copy)
    for _, v in SkinFilterState.SortKeys do
        local v164 = SortValue(p162, v);
        local v165 = SortValue(p163, v);

        if v164 ~= v165 then
            if SkinFilterState.SortDescending then
                return v165 < v164;
            end;

            return v164 < v165;
        end;
    end;

    if #SkinFilterState.SortKeys == 0 then
        local v166 = u146[p162.Rarity] or 99;
        local v167 = u146[p163.Rarity] or 99;

        if v166 ~= v167 then
            return v166 < v167;
        end;
    end;

    if p162.Skin ~= p163.Skin then
        return p162.Skin < p163.Skin;
    end;

    if p162.Item == p163.Item then
        return p162.Order < p163.Order;
    end;

    return p162.Item < p163.Item;
end;

local function ApplyFilters() -- Line: 929
    -- upvalues: u11 (copy), SearchTerms (copy), SkinFilterState (copy), u1 (copy), MatchesSearch (copy), CompareEntries (copy)
    table.clear(u11);
    local v168 = SearchTerms();
    local Duplicates = SkinFilterState.Duplicates;

    for _, v in u1 do
        if not (not SkinFilterState.Rarities[v.Rarity] or (SkinFilterState.HiddenWeapons[v.Item] or Duplicates == "Hide" and v.Copy > 1) or (Duplicates == "Only" and v.Copy < 2 or #v168 > 0 and not MatchesSearch(v, v168))) then
            table.insert(u11, v);
        end;
    end;

    table.sort(u11, CompareEntries);
end;

local function ReleaseTile(p169) -- Line: 944
    -- upvalues: u12 (copy), u13 (copy), u18 (ref), UIConstants (copy), u14 (copy)
    local v170 = u12[p169];

    if not v170 then
        return;
    end;

    u12[p169] = nil;
    u13[v170] = nil;

    if u18 == v170 then
        u18 = nil;
        UIConstants.FRAME_SKINS_SELECTED.Visible = false;
    end;

    v170.Visible = false;
    local v171 = u14[v170:GetAttribute("Rarity")];

    if v171 then
        table.insert(v171, v170);
    end;
end;

local function AcquireTile(p172: string) -- Line: 962
    -- upvalues: u14 (copy), UIConstants (copy), SellBackground (copy), SoundModule (copy), u18 (ref), Color3_fromRGB_ret (copy), Color3_new_ret (copy), GlowSelectGradient (copy), u23 (ref), ToggleSkinQuickSell (copy), SelectSkin (copy)
    local v173 = u14[p172];

    if not v173 then
        v173 = {};
        u14[p172] = v173;
    end;

    local table_remove_ret = table.remove(v173);

    if table_remove_ret then
        return table_remove_ret;
    end;

    local v174 = UIConstants.SCROLLFRAME_SKINS.Template:FindFirstChild("Template" .. p172);

    if not v174 then
        return nil;
    end;

    local u175 = v174:Clone();
    u175.Name = "Skin";
    u175.Visible = false;
    u175:SetAttribute("Rarity", p172);

    if SellBackground then
        local v176 = SellBackground:Clone();
        v176.Name = "SellHighlight";
        v176.Visible = false;
        v176.Parent = u175;
    end;

    local v177 = u175.Frame.SkinName:Clone();
    v177.Name = "CopyCount";
    v177.AnchorPoint = Vector2.new(1, 0);
    v177.Position = UDim2.new(0.96, 0, 0.03, 0);
    v177.Size = UDim2.new(0.3, 0, 0.12, 0);
    v177.TextXAlignment = Enum.TextXAlignment.Right;
    v177.ZIndex = u175.Frame.SkinName.ZIndex + 1;
    v177.Visible = false;
    v177.Parent = u175.Frame;
    u175.MouseEnter:Connect(function() -- Line: 991
        -- upvalues: SoundModule (ref), u175 (ref), u18 (ref), Color3_fromRGB_ret (ref), Color3_new_ret (ref), GlowSelectGradient (ref)
        SoundModule.PlaySound("Hover");
        local v178 = u175;

        if u18 == v178 then
            return;
        end;

        local Frame = v178.Frame;
        local UIStroke = Frame.UIStroke;
        local UIGradient = UIStroke.UIGradient;
        local Glow = Frame.Glow;
        local UIGradient2 = Glow.UIGradient;
        local GlowSelectGradient2 = Glow:FindFirstChild("GlowSelectGradient");
        UIGradient.Enabled = false;
        UIStroke.Color = Color3_fromRGB_ret or Color3_new_ret;
        UIGradient2.Enabled = false;

        if not GlowSelectGradient2 then
            GlowSelectGradient:Clone().Parent = Glow;
        end;
    end);
    u175.MouseLeave:Connect(function() -- Line: 995
        -- upvalues: u175 (ref), u18 (ref), Color3_new_ret (ref)
        local v179 = u175;

        if u18 == v179 then
            return;
        end;

        local Frame = v179.Frame;
        local UIStroke = Frame.UIStroke;
        local UIGradient = UIStroke.UIGradient;
        local Glow = Frame.Glow;
        local UIGradient2 = Glow.UIGradient;
        local GlowSelectGradient2 = Glow:FindFirstChild("GlowSelectGradient");
        UIGradient.Enabled = true;
        UIStroke.Color = Color3_new_ret;

        if GlowSelectGradient2 then
            GlowSelectGradient2:Destroy();
        end;

        UIGradient2.Enabled = true;
    end);
    u175.MouseButton1Click:Connect(function() -- Line: 998
        -- upvalues: SoundModule (ref), u23 (ref), ToggleSkinQuickSell (ref), u175 (ref), SelectSkin (ref)
        SoundModule.PlaySound("Click");

        if u23 then
            ToggleSkinQuickSell(u175);

            return;
        end;

        SelectSkin(u175);
    end);
    u175.Parent = UIConstants.SCROLLFRAME_SKINS;

    return u175;
end;

local function ApplyTile(p180: userdata, p181: any, p182: number) -- Line: 1010
    -- upvalues: u24 (copy), u2 (copy), SkinFilterState (copy)
    p180.LayoutOrder = p182;

    if p180:GetAttribute("SkinIndex") ~= p181.Index then
        p180:SetAttribute("SkinIndex", p181.Index);
        local Frame = p180.Frame;
        Frame.ItemName.Text = p181.Item;
        Frame.SkinName.Text = p181.Skin;
        Frame.ItemImage.Image = p181.Image;
    end;

    local SellHighlight = p180:FindFirstChild("SellHighlight");

    if SellHighlight then
        SellHighlight.Visible = u24[p181] == true;
    end;

    local CopyCount = p180.Frame:FindFirstChild("CopyCount");

    if CopyCount then
        local v183 = u2[p181.Index] or 1;
        local v184;

        if SkinFilterState.Duplicates == "Hide" then
            v184 = v183 > 1;
        else
            v184 = false;
        end;

        CopyCount.Text = `x{v183}`;
        CopyCount.Visible = v184;
    end;

    p180.Visible = true;
end;

local function UpdateCanvasSize() -- Line: 1035
    -- upvalues: UIConstants (copy)
    task.defer(function() -- Line: 1036
        -- upvalues: UIConstants (ref)
        if not UIConstants.SCROLLFRAME_SKINS.Parent then
            return;
        end;

        UIConstants.SCROLLFRAME_SKINS.CanvasSize = UDim2.new(0, 0, 0, UIConstants.SKINS_UIGRIDLAYOUT.AbsoluteContentSize.Y + UIConstants.SCROLLFRAME_SKINS.UIPadding.PaddingTop.Offset + 5);
    end);
end;

local u185 = nil;
local u186 = false;

local function RelockCellSize() -- Line: 1048
    -- upvalues: u186 (ref), u185 (ref), UIConstants (copy), u19 (ref), RelockCellSize (copy)
    if u186 or not u185 then
        return;
    end;

    u186 = true;
    task.defer(function() -- Line: 1051
        -- upvalues: UIConstants (ref), u185 (ref), u19 (ref), u186 (ref), RelockCellSize (ref)
        local SCROLLFRAME_SKINS = UIConstants.SCROLLFRAME_SKINS;
        local SKINS_UIGRIDLAYOUT = UIConstants.SKINS_UIGRIDLAYOUT;
        local AbsoluteSize = SCROLLFRAME_SKINS.AbsoluteSize;

        if SCROLLFRAME_SKINS.Parent then
            local CanvasPosition = SCROLLFRAME_SKINS.CanvasPosition;
            SCROLLFRAME_SKINS.CanvasSize = UDim2.new();
            SKINS_UIGRIDLAYOUT.CellSize = u185;
            task.wait();
            u19 = SKINS_UIGRIDLAYOUT.AbsoluteCellSize;
            SKINS_UIGRIDLAYOUT.CellSize = UDim2.new(0, u19.X, 0, u19.Y);
            task.defer(function() -- Line: 1036
                -- upvalues: UIConstants (ref)
                if not UIConstants.SCROLLFRAME_SKINS.Parent then
                    return;
                end;

                UIConstants.SCROLLFRAME_SKINS.CanvasSize = UDim2.new(0, 0, 0, UIConstants.SKINS_UIGRIDLAYOUT.AbsoluteContentSize.Y + UIConstants.SCROLLFRAME_SKINS.UIPadding.PaddingTop.Offset + 5);
            end);
            task.defer(function() -- Line: 1063
                -- upvalues: SCROLLFRAME_SKINS (copy), CanvasPosition (copy)
                SCROLLFRAME_SKINS.CanvasPosition = CanvasPosition;
            end);
        end;

        u186 = false;

        if SCROLLFRAME_SKINS.Parent and SCROLLFRAME_SKINS.AbsoluteSize ~= AbsoluteSize then
            RelockCellSize();
        end;
    end);
end;

local function Render() -- Line: 1076
    -- upvalues: u11 (copy), u12 (copy), u13 (copy), u18 (ref), UIConstants (copy), u14 (copy), AcquireTile (copy), ApplyTile (copy)
    local v187 = {};

    for _, v in u11 do
        v187[v] = true;
    end;

    for i in pairs(u12) do
        if not v187[i] then
            local v188 = u12[i];

            if v188 then
                u12[i] = nil;
                u13[v188] = nil;

                if u18 == v188 then
                    u18 = nil;
                    UIConstants.FRAME_SKINS_SELECTED.Visible = false;
                end;

                v188.Visible = false;
                local v189 = u14[v188:GetAttribute("Rarity")];

                if v189 then
                    table.insert(v189, v188);
                end;
            end;
        end;
    end;

    for i, v in u11 do
        local v190 = u12[v];

        if not v190 then
            v190 = AcquireTile(v.Rarity);

            if v190 then
                u12[v] = v190;
                u13[v190] = v;
            end;
        end;

        if v190 then
            ApplyTile(v190, v, i);
        end;
    end;

    task.defer(function() -- Line: 1036
        -- upvalues: UIConstants (ref)
        if not UIConstants.SCROLLFRAME_SKINS.Parent then
            return;
        end;

        UIConstants.SCROLLFRAME_SKINS.CanvasSize = UDim2.new(0, 0, 0, UIConstants.SKINS_UIGRIDLAYOUT.AbsoluteContentSize.Y + UIConstants.SCROLLFRAME_SKINS.UIPadding.PaddingTop.Offset + 5);
    end);
end;

local function Refresh() -- Line: 1103
    -- upvalues: ApplyFilters (copy), Render (copy), u16 (ref)
    ApplyFilters();
    Render();

    if u16 then
        u16();
    end;
end;

local function _() -- Line: 1112
    -- upvalues: u23 (ref), u24 (copy), u12 (copy), u25 (ref), u26 (ref), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), ConfirmSell (copy), u27 (copy), u16 (ref), BuildEntries (copy), u17 (ref), ApplyFilters (copy), Render (copy)
    if u23 then
        for i in pairs(u24) do
            u24[i] = nil;
            local v191 = u12[i];

            if v191 then
                local SellHighlight = v191:FindFirstChild("SellHighlight");

                if SellHighlight then
                    SellHighlight.Visible = u24[i] == true;
                end;
            end;
        end;

        u25 = 0;
        u26 = 0;
        AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
        SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
        local v192 = u25 > 0;
        AmountLabel.Visible = u23;
        SellAmount.Visible = v192;
        ConfirmSell.Visible = v192;

        if u27 then
            u27.Visible = v192;
        end;

        if u16 then
            u16();
        end;
    end;

    BuildEntries();

    if u17 then
        u17();
    end;

    ApplyFilters();
    Render();

    if u16 then
        u16();
    end;
end;

local u193 = {
    Background = Color3.new(0.373, 0.596, 0.118),
    Stroke = Color3.new(0.663, 0.945, 0.239)
};
local u194 = {
    Background = Color3.new(0.22, 0.22, 0.22),
    Stroke = Color3.new(0.45, 0.45, 0.45)
};
local u195 = {
    Background = Color3.new(0.596, 0.098, 0.098),
    Stroke = Color3.new(0.945, 0.282, 0.282)
};
local u196 = { "Rarity", "Skin", "Weapon", "Newest", "Bundle" };
local u197 = {
    Rarity = "RARITY",
    Skin = "SKIN NAME",
    Weapon = "ITEM NAME",
    Newest = "NEWEST",
    Bundle = "BUNDLE"
};
local u198 = { "Show", "Hide", "Only" };
local u199 = {
    Show = "DUPES: SHOW",
    Hide = "DUPES: HIDE",
    Only = "DUPES: ONLY"
};
local FRAME_INVENTORY = UIConstants.FRAME_INVENTORY;
local WeaponPanel = FRAME_INVENTORY:WaitForChild("WeaponPanel");
local T = WeaponPanel.List:WaitForChild("T");
local u200 = {};

local function WeaponRowSize() -- Line: 1147
    -- upvalues: WeaponPanel (copy)
    local UDim2_new = UDim2.new;
    local math_round_ret = math.round(WeaponPanel.List.AbsoluteSize.Y * 0.1);

    return UDim2_new(1, -8, 0, (math.max(math_round_ret, 12)));
end;

WeaponPanel.List:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 1150
    -- upvalues: WeaponPanel (copy), u200 (copy)
    local UDim2_new = UDim2.new;
    local math_round_ret = math.round(WeaponPanel.List.AbsoluteSize.Y * 0.1);
    local v201 = UDim2_new(1, -8, 0, (math.max(math_round_ret, 12)));

    for _, v in u200 do
        v.Size = v201;
    end;
end);
local u202 = 0;

local function PaintButton(p203: userdata, p204: boolean, p205: table?) -- Line: 1158
    -- upvalues: u193 (copy), u194 (copy)
    local Frame = p203.Detail.Frame;

    if not p205 then
        if p204 then
            p205 = u193;
        else
            p205 = u194;
        end;
    end;

    Frame.BackgroundColor3 = p205.Background;
    Frame.Effect.Color = p205.Stroke;
    Frame.Effect:SetAttribute("ColorDefault", p205.Stroke);
    Frame.Select.UIGradient.Color = ColorSequence.new(p205.Stroke);
end;

local function HookRow(p206: any, u207: any) -- Line: 1168
    -- upvalues: SoundModule (copy)
    for _, v in { "ClickButton", "RowButton" } do
        local v208 = p206:FindFirstChild(v);

        if v208 then
            v208.MouseButton1Click:Connect(function() -- Line: 1172
                -- upvalues: SoundModule (ref), u207 (copy)
                SoundModule.PlaySound("Click");
                u207();
            end);
        end;
    end;
end;

local function HookButton(u209: userdata, u210: any) -- Line: 1180
    -- upvalues: SoundModule (copy), Color3_new_ret (copy)
    u209.MouseEnter:Connect(function() -- Line: 1181
        -- upvalues: SoundModule (ref), u209 (copy), Color3_new_ret (ref)
        SoundModule.PlaySound("Hover");
        u209.Detail.Frame.Effect.Color = Color3_new_ret;
    end);
    u209.MouseLeave:Connect(function() -- Line: 1185
        -- upvalues: u209 (copy)
        u209.Detail.Frame.Effect.Color = u209.Detail.Frame.Effect:GetAttribute("ColorDefault");
    end);
    u209.MouseButton1Click:Connect(function() -- Line: 1188
        -- upvalues: SoundModule (ref), u210 (copy)
        SoundModule.PlaySound("Click");
        u210();
    end);
end;

local u211 = setmetatable({}, {
    __mode = "k"
});

local function PaintCheckbox(p212: any, u213: boolean, p214: boolean?) -- Line: 1196
    -- upvalues: u211 (copy), TweenService (copy)
    if u211[p212] == u213 then
        return;
    end;

    u211[p212] = u213;
    local Bar = p212.ClickButton:FindFirstChild("Bar");

    if not Bar then
        return;
    end;

    local BarGreen = Bar.BarGreen;
    local BarRed = Bar.BarRed;
    local Attribute = BarGreen:GetAttribute(u213 and "PositionTrue" or "PositionFalse");

    if p214 then
        BarGreen.Position = Attribute;
        BarRed.Position = Attribute;
        BarGreen.Visible = u213;
        BarRed.Visible = not u213;

        return;
    end;

    local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v215 = TweenService:Create(BarGreen, TweenInfo_new_ret, {
        Position = Attribute
    });
    TweenService:Create(BarRed, TweenInfo_new_ret, {
        Position = Attribute
    }):Play();
    v215:Play();
    v215.Completed:Connect(function() -- Line: 1214
        -- upvalues: BarGreen (copy), u213 (copy), BarRed (copy)
        BarGreen.Visible = u213;
        BarRed.Visible = not u213;
    end);
end;

u17 = function() -- Line: 1221, Name: RebuildWeaponRows
    -- upvalues: u1 (copy), u200 (copy), SkinFilterState (copy), T (copy), WeaponPanel (copy), HookRow (copy), PaintCheckbox (copy), ApplyFilters (copy), Render (copy), u16 (ref), u211 (copy)
    local u216 = {};

    for _, v in u1 do
        u216[v.Item] = (u216[v.Item] or 0) + 1;
    end;

    for i, v in u200 do
        if not u216[i] then
            v:Destroy();
            u200[i] = nil;
            SkinFilterState.HiddenWeapons[i] = nil;
        end;
    end;

    local v217 = {};

    for i in u216 do
        table.insert(v217, i);
    end;

    table.sort(v217, function(p218, p219) -- Line: 1237
        -- upvalues: SkinFilterState (ref), u216 (copy)
        if SkinFilterState.WeaponSort == "Count" and u216[p218] ~= u216[p219] then
            return u216[p218] > u216[p219];
        end;

        return p218 < p219;
    end);

    for i, v in v217 do
        local u220 = u200[v];

        if not u220 then
            u220 = T:Clone();
            u220.Name = v;
            local UDim2_new = UDim2.new;
            local math_round_ret = math.round(WeaponPanel.List.AbsoluteSize.Y * 0.1);
            u220.Size = UDim2_new(1, -8, 0, (math.max(math_round_ret, 12)));
            u220.Visible = true;
            u220.Parent = WeaponPanel.List;
            u200[v] = u220;
            HookRow(u220, function() -- Line: 1252
                -- upvalues: SkinFilterState (ref), v (copy), PaintCheckbox (ref), u220 (ref), ApplyFilters (ref), Render (ref), u16 (ref)
                local v221 = not SkinFilterState.HiddenWeapons[v];
                SkinFilterState.HiddenWeapons[v] = v221 and true or nil;
                PaintCheckbox(u220, not v221);
                ApplyFilters();
                Render();

                if u16 then
                    u16();
                end;
            end);
        end;

        u220.LayoutOrder = i;
        u220.Description.Text = `{v} ({u216[v]})`;
        local v222 = not SkinFilterState.HiddenWeapons[v];

        if u211[u220] ~= v222 then
            u211[u220] = v222;
            local Bar = u220.ClickButton:FindFirstChild("Bar");

            if Bar then
                local BarGreen = Bar.BarGreen;
                local BarRed = Bar.BarRed;
                local Attribute = BarGreen:GetAttribute(v222 and "PositionTrue" or "PositionFalse");
                BarGreen.Position = Attribute;
                BarRed.Position = Attribute;
                BarGreen.Visible = v222;
                BarRed.Visible = not v222;
            end;
        end;
    end;
end;

local function SetAllWeapons(p223: boolean) -- Line: 1265
    -- upvalues: SkinFilterState (copy), u200 (copy), PaintCheckbox (copy), ApplyFilters (copy), Render (copy), u16 (ref)
    table.clear(SkinFilterState.HiddenWeapons);

    if not p223 then
        for i in u200 do
            SkinFilterState.HiddenWeapons[i] = true;
        end;
    end;

    for i, v in u200 do
        PaintCheckbox(v, not SkinFilterState.HiddenWeapons[i]);
    end;

    ApplyFilters();
    Render();

    if u16 then
        u16();
    end;
end;

local function SetShownSelected(p224: boolean) -- Line: 1280
    -- upvalues: u11 (copy), u24 (copy), u25 (ref), ShopModule (copy), u26 (ref), u12 (copy), SoundModule (copy), AmountLabel (copy), SellAmount (copy), NumberUtil (copy), u23 (ref), ConfirmSell (copy), u27 (copy), u16 (ref)
    local v225 = 0;
    local v226 = false;

    for _, v in u11 do
        if p224 then
            if v.Locked and "Locked" or (not v.SellAmount and "NoValue" or nil) then
                v225 = v225 + 1;
            else
                local v227;

                if u24[v] == true == true then
                    v227 = true;
                elseif v.Locked and "Locked" or (not v.SellAmount and "NoValue" or nil) or u25 >= ShopModule.RaritySells.MaxQuickSellBatch then
                    v227 = false;
                else
                    u24[v] = true;
                    u25 = u25 + 1;
                    u26 = u26 + v.SellAmount;
                    local v228 = u12[v];

                    if v228 then
                        local SellHighlight = v228:FindFirstChild("SellHighlight");

                        if SellHighlight then
                            SellHighlight.Visible = u24[v] == true;
                            v227 = true;
                        else
                            v227 = true;
                        end;
                    else
                        v227 = true;
                    end;
                end;

                if not v227 then
                    v226 = true;
                    break;
                end;
            end;
        elseif u24[v] == true ~= false then
            u24[v] = nil;
            u25 = u25 - 1;
            u26 = u26 - v.SellAmount;
            local v229 = u12[v];

            if v229 then
                local SellHighlight = v229:FindFirstChild("SellHighlight");

                if SellHighlight then
                    SellHighlight.Visible = u24[v] == true;
                end;
            end;
        end;
    end;

    if v226 or p224 and (v225 > 0 and u25 == 0) then
        SoundModule.PlaySound("Error");
    end;

    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    local v230 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v230;
    ConfirmSell.Visible = v230;

    if u27 then
        u27.Visible = v230;
    end;

    if u16 then
        u16();
    end;

    if u16 then
        u16();
    end;
end;

u16 = function() -- Line: 1305
    -- upvalues: u145 (copy), FRAME_INVENTORY (copy), u15 (copy), PaintCheckbox (copy), SkinFilterState (copy), u196 (copy), u197 (copy), u193 (copy), u194 (copy), u199 (copy), u200 (copy), u195 (copy), WeaponPanel (copy), u11 (copy), u1 (copy), u23 (ref), u25 (ref), QueueSaveFilters (copy)
    for _, v in u145 do
        local v231 = FRAME_INVENTORY:FindFirstChild("Rarity" .. v);

        if v231 then
            v231.Description.Text = `{v:upper()} - {u15[v] or 0}`;
            PaintCheckbox(v231, SkinFilterState.Rarities[v] == true);
        end;
    end;

    for _, v in u196 do
        local v232 = FRAME_INVENTORY:FindFirstChild("Sort" .. v);

        if v232 then
            local table_find_ret = table.find(SkinFilterState.SortKeys, v);
            local Description = v232.Description;
            local v233;

            if table_find_ret then
                v233 = `{table_find_ret}. {u197[v]}`;
            else
                v233 = u197[v];
            end;

            Description.Text = v233;
            PaintCheckbox(v232, table_find_ret ~= nil);
        end;
    end;

    FRAME_INVENTORY.SortOrder.Detail.Frame.TextLabel.Text = SkinFilterState.SortDescending and "Z-A" or "A-Z";
    local SortDescending = SkinFilterState.SortDescending;
    local v234 = nil;
    local Frame = FRAME_INVENTORY.SortOrder.Detail.Frame;

    if not v234 then
        if SortDescending then
            v234 = u193;
        else
            v234 = u194;
        end;
    end;

    Frame.BackgroundColor3 = v234.Background;
    Frame.Effect.Color = v234.Stroke;
    Frame.Effect:SetAttribute("ColorDefault", v234.Stroke);
    Frame.Select.UIGradient.Color = ColorSequence.new(v234.Stroke);
    FRAME_INVENTORY.DupeFilter.Detail.Frame.TextLabel.Text = u199[SkinFilterState.Duplicates];
    local v235 = SkinFilterState.Duplicates ~= "Show";
    local v236 = nil;
    local Frame2 = FRAME_INVENTORY.DupeFilter.Detail.Frame;

    if not v236 then
        if v235 then
            v236 = u193;
        else
            v236 = u194;
        end;
    end;

    Frame2.BackgroundColor3 = v236.Background;
    Frame2.Effect.Color = v236.Stroke;
    Frame2.Effect:SetAttribute("ColorDefault", v236.Stroke);
    Frame2.Select.UIGradient.Color = ColorSequence.new(v236.Stroke);
    local v237 = 0;
    local v238 = 0;

    for i in u200 do
        v237 = v237 + 1;

        if not SkinFilterState.HiddenWeapons[i] then
            v238 = v238 + 1;
        end;
    end;

    local v239 = v238 == v237;
    FRAME_INVENTORY.WeaponFilter.Detail.Frame.TextLabel.Text = v239 and "ITEMS: ALL" or `ITEMS: {v238}/{v237}`;
    local v240;

    if v237 > 0 then
        v240 = v238 == 0;
    else
        v240 = false;
    end;

    local v241 = not v239;
    local v242;

    if v240 then
        v242 = u195;
    else
        v242 = nil;
    end;

    local Frame3 = FRAME_INVENTORY.WeaponFilter.Detail.Frame;

    if not v242 then
        if v241 then
            v242 = u193;
        else
            v242 = u194;
        end;
    end;

    Frame3.BackgroundColor3 = v242.Background;
    Frame3.Effect.Color = v242.Stroke;
    Frame3.Effect:SetAttribute("ColorDefault", v242.Stroke);
    Frame3.Select.UIGradient.Color = ColorSequence.new(v242.Stroke);
    WeaponPanel.SortBy.Detail.Frame.TextLabel.Text = SkinFilterState.WeaponSort == "Count" and "SORT: COUNT" or "SORT: A-Z";
    local v243 = #u11;
    local v244 = #u1;
    local ShownCount = FRAME_INVENTORY.ShownCount;
    local v245;

    if v243 == v244 then
        v245 = `{v244} SKINS`;
    else
        v245 = `SHOWING {v243} / {v244}`;
    end;

    ShownCount.Text = v245;
    FRAME_INVENTORY.SelectShown.Visible = u23 and v243 < v244;
    FRAME_INVENTORY.UnselectShown.Visible = u23 and u25 > 0;
    QueueSaveFilters();
end;

local function SetupControls() -- Line: 1347
    -- upvalues: u145 (copy), FRAME_INVENTORY (copy), HookRow (copy), SkinFilterState (copy), PaintCheckbox (copy), ApplyFilters (copy), Render (copy), u16 (ref), u196 (copy), HookButton (copy), u198 (copy), WeaponPanel (copy), u17 (ref), u200 (copy), SetAllWeapons (copy), SetShownSelected (copy), u11 (copy), u24 (copy), u25 (ref), u26 (ref), u12 (copy), SoundModule (copy), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), u23 (ref), ConfirmSell (copy), u27 (copy), u202 (ref), UIConstants (copy)
    for _, v in u145 do
        local u246 = FRAME_INVENTORY:FindFirstChild("Rarity" .. v);

        if u246 then
            HookRow(u246, function() -- Line: 1351
                -- upvalues: SkinFilterState (ref), v (copy), PaintCheckbox (ref), u246 (copy), ApplyFilters (ref), Render (ref), u16 (ref)
                SkinFilterState.Rarities[v] = not SkinFilterState.Rarities[v];
                PaintCheckbox(u246, SkinFilterState.Rarities[v] == true);
                ApplyFilters();
                Render();

                if u16 then
                    u16();
                end;
            end);
        end;
    end;

    for _, v in u196 do
        local v247 = FRAME_INVENTORY:FindFirstChild("Sort" .. v);

        if v247 then
            HookRow(v247, function() -- Line: 1360
                -- upvalues: SkinFilterState (ref), v (copy), ApplyFilters (ref), Render (ref), u16 (ref)
                local table_find_ret = table.find(SkinFilterState.SortKeys, v);

                if table_find_ret then
                    table.remove(SkinFilterState.SortKeys, table_find_ret);
                else
                    table.insert(SkinFilterState.SortKeys, v);
                end;

                ApplyFilters();
                Render();

                if u16 then
                    u16();
                end;
            end);
        end;
    end;

    HookButton(FRAME_INVENTORY.SortOrder, function() -- Line: 1370
        -- upvalues: SkinFilterState (ref), ApplyFilters (ref), Render (ref), u16 (ref)
        SkinFilterState.SortDescending = not SkinFilterState.SortDescending;
        ApplyFilters();
        Render();

        if u16 then
            u16();
        end;
    end);
    HookButton(FRAME_INVENTORY.DupeFilter, function() -- Line: 1374
        -- upvalues: u198 (ref), SkinFilterState (ref), ApplyFilters (ref), Render (ref), u16 (ref)
        SkinFilterState.Duplicates = u198[(table.find(u198, SkinFilterState.Duplicates) or 1) % #u198 + 1];
        ApplyFilters();
        Render();

        if u16 then
            u16();
        end;
    end);
    HookButton(FRAME_INVENTORY.WeaponFilter, function() -- Line: 1379
        -- upvalues: WeaponPanel (ref)
        WeaponPanel.Visible = not WeaponPanel.Visible;
    end);
    HookButton(WeaponPanel.SortBy, function() -- Line: 1382
        -- upvalues: SkinFilterState (ref), u17 (ref), u16 (ref)
        SkinFilterState.WeaponSort = SkinFilterState.WeaponSort == "Count" and "Name" or "Count";
        u17();
        u16();
    end);
    HookButton(WeaponPanel.All, function() -- Line: 1387
        -- upvalues: SkinFilterState (ref), u200 (ref), PaintCheckbox (ref), ApplyFilters (ref), Render (ref), u16 (ref)
        table.clear(SkinFilterState.HiddenWeapons);

        for i, v in u200 do
            PaintCheckbox(v, not SkinFilterState.HiddenWeapons[i]);
        end;

        ApplyFilters();
        Render();

        if u16 then
            u16();
        end;
    end);
    HookButton(WeaponPanel.None, function() -- Line: 1390
        -- upvalues: SetAllWeapons (ref)
        SetAllWeapons(false);
    end);
    HookButton(FRAME_INVENTORY.SelectShown, function() -- Line: 1393
        -- upvalues: SetShownSelected (ref)
        SetShownSelected(true);
    end);
    HookButton(FRAME_INVENTORY.UnselectShown, function() -- Line: 1396
        -- upvalues: u11 (ref), u24 (ref), u25 (ref), u26 (ref), u12 (ref), SoundModule (ref), AmountLabel (ref), ShopModule (ref), SellAmount (ref), NumberUtil (ref), u23 (ref), ConfirmSell (ref), u27 (ref), u16 (ref)
        for _, v in u11 do
            if u24[v] == true ~= false then
                u24[v] = nil;
                u25 = u25 - 1;
                u26 = u26 - v.SellAmount;
                local v248 = u12[v];

                if v248 then
                    local SellHighlight = v248:FindFirstChild("SellHighlight");

                    if SellHighlight then
                        SellHighlight.Visible = u24[v] == true;
                    end;
                end;
            end;
        end;

        if false then
            SoundModule.PlaySound("Error");
        end;

        AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
        SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
        local v249 = u25 > 0;
        AmountLabel.Visible = u23;
        SellAmount.Visible = v249;
        ConfirmSell.Visible = v249;

        if u27 then
            u27.Visible = v249;
        end;

        if u16 then
            u16();
        end;

        if u16 then
            u16();
        end;
    end);
    FRAME_INVENTORY.Search.TextBox.Text = SkinFilterState.Search;
    FRAME_INVENTORY.Search.TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1401
        -- upvalues: SkinFilterState (ref), FRAME_INVENTORY (ref), u202 (ref), ApplyFilters (ref), Render (ref), u16 (ref)
        SkinFilterState.Search = FRAME_INVENTORY.Search.TextBox.Text;
        u202 = u202 + 1;
        local u250 = u202;
        task.delay(0.15, function() -- Line: 1405
            -- upvalues: u250 (copy), u202 (ref), ApplyFilters (ref), Render (ref), u16 (ref)
            if u250 ~= u202 then
                return;
            end;

            ApplyFilters();
            Render();

            if u16 then
                u16();
            end;
        end);
    end);
    UIConstants.FRAME_INVENTORY:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1411
        -- upvalues: UIConstants (ref), WeaponPanel (ref)
        if not UIConstants.FRAME_INVENTORY.Visible then
            WeaponPanel.Visible = false;
        end;
    end);
end;

local u259 = {
    ViewSkins = function(p251: table?, p252: string?) -- Line: 1422
        -- upvalues: u22 (ref), u23 (ref), u24 (copy), u12 (copy), u25 (ref), u26 (ref), RedTint (copy), NavBar (copy), ApplyQuickSellAppearance (copy), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), ConfirmSell (copy), u27 (copy), u16 (ref), QuickSell (copy), Viewing (copy), u18 (ref), Color3_new_ret (copy), UIConstants (copy), BuildEntries (copy), u17 (ref), ApplyFilters (copy), Render (copy), UserInputService (copy)
        local v253;

        if type(p251) == "table" then
            v253 = table.clone(p251);
        else
            v253 = nil;
        end;

        u22 = v253;

        if u23 then
            for i in pairs(u24) do
                u24[i] = nil;
                local v254 = u12[i];

                if v254 then
                    local SellHighlight = v254:FindFirstChild("SellHighlight");

                    if SellHighlight then
                        SellHighlight.Visible = u24[i] == true;
                    end;
                end;
            end;

            u25 = 0;
            u26 = 0;
            u23 = false;
            RedTint.Visible = false;

            if NavBar then
                NavBar.Visible = true;
            end;

            ApplyQuickSellAppearance(false);
            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            local v255 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v255;
            ConfirmSell.Visible = v255;

            if u27 then
                u27.Visible = v255;
            end;

            if u16 then
                u16();
            end;

            if u16 then
                u16();
            end;
        end;

        QuickSell.Visible = u22 == nil;

        if Viewing then
            Viewing.Text = p252 or "";
            Viewing.Visible = u22 ~= nil;
        end;

        if u18 and u18.Parent then
            local v256 = true;
            local Frame = u18.Frame;
            local UIStroke = Frame.UIStroke;
            local UIGradient = UIStroke.UIGradient;
            local Glow = Frame.Glow;
            local UIGradient2 = Glow.UIGradient;
            local GlowSelectGradient2 = Glow:FindFirstChild("GlowSelectGradient");

            if GlowSelectGradient2 then
                GlowSelectGradient2:Destroy();
            end;

            UIGradient2.Enabled = v256;
            UIGradient.Enabled = v256;
            UIStroke.Color = Color3_new_ret;
            UIStroke.Transparency = v256 and 0.44 or 0;
        end;

        u18 = nil;
        UIConstants.FRAME_SKINS_SELECTED.Visible = false;

        if u23 then
            for i in pairs(u24) do
                u24[i] = nil;
                local v257 = u12[i];

                if v257 then
                    local SellHighlight = v257:FindFirstChild("SellHighlight");

                    if SellHighlight then
                        SellHighlight.Visible = u24[i] == true;
                    end;
                end;
            end;

            u25 = 0;
            u26 = 0;
            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            local v258 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v258;
            ConfirmSell.Visible = v258;

            if u27 then
                u27.Visible = v258;
            end;

            if u16 then
                u16();
            end;
        end;

        BuildEntries();

        if u17 then
            u17();
        end;

        ApplyFilters();
        Render();

        if u16 then
            u16();
        end;

        if not u22 then
            return;
        end;

        local MainMenu = UIConstants.PLAYER_GUI:FindFirstChild("MainMenu");

        if MainMenu then
            MainMenu.Enabled = true;
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
            UserInputService.MouseIconEnabled = true;
        end;

        require(script.Parent).ChangeFrame(UIConstants.FRAME_INVENTORY);
    end
};

function u259.Load() -- Line: 1454
    -- upvalues: UIConstants (copy), u185 (ref), u19 (ref), RelockCellSize (copy), SkinFilterState (copy), PlayerDataModule (copy), u144 (copy), u147 (ref), SkinsModule (copy), SetupControls (copy), u23 (ref), u24 (copy), u12 (copy), u25 (ref), u26 (ref), AmountLabel (copy), ShopModule (copy), SellAmount (copy), NumberUtil (copy), ConfirmSell (copy), u27 (copy), u16 (ref), BuildEntries (copy), u17 (ref), ApplyFilters (copy), Render (copy), QuickSell (copy), SoundModule (copy), Color3_new_ret (copy), RedTint (copy), NavBar (copy), ApplyQuickSellAppearance (copy), u18 (ref), OnQuickSellConfirm (copy), u149 (ref), Update2 (copy), u22 (ref), u259 (copy), Update (copy), Update3 (copy), OpenCase (copy), CreateWheelSpinner (copy)
    local UIGridLayout = UIConstants.SCROLLFRAME_SKINS.UIGridLayout;
    local Vector2_zero = Vector2.zero;
    local v260 = os.clock() + 5;

    while true do
        local AbsoluteCellSize = UIGridLayout.AbsoluteCellSize;

        if AbsoluteCellSize.X > 1 and (AbsoluteCellSize.Y > 1 and AbsoluteCellSize == Vector2_zero) or v260 < os.clock() then
            break;
        end;

        task.wait();
        Vector2_zero = AbsoluteCellSize;
    end;

    for _, child in UIConstants.SCROLLFRAME_SKINS:GetChildren() do
        if child:IsA("ImageButton") and child:GetAttribute("Rarity") == nil then
            child:Destroy();
        end;
    end;

    u185 = UIGridLayout.CellSize;
    u19 = UIGridLayout.AbsoluteCellSize;
    UIConstants.SCROLLFRAME_SKINS.UIGridLayout.CellSize = UDim2.new(0, u19.X, 0, u19.Y);
    UIConstants.SCROLLFRAME_SKINS:GetPropertyChangedSignal("AbsoluteSize"):Connect(RelockCellSize);
    UIConstants.FRAME_SKINS_SELECTED.Visible = false;

    if not SkinFilterState.Hydrated then
        SkinFilterState.Hydrated = true;
        SkinFilterState.Apply(PlayerDataModule.SkinFilters, u144);
    end;

    u147 = SkinFilterState.Encode(SkinsModule.CachedItemIds);
    SetupControls();

    if u23 then
        for i in pairs(u24) do
            u24[i] = nil;
            local v261 = u12[i];

            if v261 then
                local SellHighlight = v261:FindFirstChild("SellHighlight");

                if SellHighlight then
                    SellHighlight.Visible = u24[i] == true;
                end;
            end;
        end;

        u25 = 0;
        u26 = 0;
        AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
        SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
        local v262 = u25 > 0;
        AmountLabel.Visible = u23;
        SellAmount.Visible = v262;
        ConfirmSell.Visible = v262;

        if u27 then
            u27.Visible = v262;
        end;

        if u16 then
            u16();
        end;
    end;

    BuildEntries();

    if u17 then
        u17();
    end;

    ApplyFilters();
    Render();

    if u16 then
        u16();
    end;

    QuickSell.MouseEnter:Connect(function() -- Line: 1492
        -- upvalues: SoundModule (ref), QuickSell (ref), Color3_new_ret (ref)
        SoundModule.PlaySound("Hover");
        QuickSell.Detail.Frame.Effect.Color = Color3_new_ret;
    end);
    QuickSell.MouseLeave:Connect(function() -- Line: 1496
        -- upvalues: QuickSell (ref)
        QuickSell.Detail.Frame.Effect.Color = QuickSell.Detail.Frame.Effect:GetAttribute("ColorDefault");
    end);
    QuickSell.MouseButton1Click:Connect(function() -- Line: 1499
        -- upvalues: SoundModule (ref), u23 (ref), u24 (ref), u12 (ref), u25 (ref), u26 (ref), RedTint (ref), NavBar (ref), ApplyQuickSellAppearance (ref), AmountLabel (ref), ShopModule (ref), SellAmount (ref), NumberUtil (ref), ConfirmSell (ref), u27 (ref), u16 (ref), UIConstants (ref), u18 (ref)
        SoundModule.PlaySound("Click");

        if u23 then
            for i in pairs(u24) do
                u24[i] = nil;
                local v263 = u12[i];

                if v263 then
                    local SellHighlight = v263:FindFirstChild("SellHighlight");

                    if SellHighlight then
                        SellHighlight.Visible = u24[i] == true;
                    end;
                end;
            end;

            u25 = 0;
            u26 = 0;
            u23 = false;
            RedTint.Visible = false;

            if NavBar then
                NavBar.Visible = true;
            end;

            ApplyQuickSellAppearance(false);
            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            local v264 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v264;
            ConfirmSell.Visible = v264;

            if u27 then
                u27.Visible = v264;
            end;

            if u16 then
                u16();
            end;

            if u16 then
                u16();
            end;
        else
            UIConstants.FRAME_SKINS_SELECTED.Visible = false;
            u18 = nil;

            for i in pairs(u24) do
                u24[i] = nil;
                local v265 = u12[i];

                if v265 then
                    local SellHighlight = v265:FindFirstChild("SellHighlight");

                    if SellHighlight then
                        SellHighlight.Visible = u24[i] == true;
                    end;
                end;
            end;

            u25 = 0;
            u26 = 0;
            u23 = true;
            RedTint.Visible = true;

            if NavBar then
                NavBar.Visible = false;
            end;

            ApplyQuickSellAppearance(true);
            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            local v266 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v266;
            ConfirmSell.Visible = v266;

            if u27 then
                u27.Visible = v266;
            end;

            if u16 then
                u16();
            end;

            if u16 then
                u16();
            end;
        end;
    end);
    ConfirmSell.MouseEnter:Connect(function() -- Line: 1504
        -- upvalues: SoundModule (ref), ConfirmSell (ref), Color3_new_ret (ref)
        SoundModule.PlaySound("Hover");
        ConfirmSell.Detail.Frame.Effect.Color = Color3_new_ret;
    end);
    ConfirmSell.MouseLeave:Connect(function() -- Line: 1508
        -- upvalues: ConfirmSell (ref)
        ConfirmSell.Detail.Frame.Effect.Color = ConfirmSell.Detail.Frame.Effect:GetAttribute("ColorDefault");
    end);
    ConfirmSell.MouseButton1Click:Connect(function() -- Line: 1511
        -- upvalues: SoundModule (ref), OnQuickSellConfirm (ref)
        SoundModule.PlaySound("Click");
        OnQuickSellConfirm();
    end);
    AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
    SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
    local v267 = u25 > 0;
    AmountLabel.Visible = u23;
    SellAmount.Visible = v267;
    ConfirmSell.Visible = v267;

    if u27 then
        u27.Visible = v267;
    end;

    if u16 then
        u16();
    end;

    UIConstants.FRAME_INVENTORY:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1519
        -- upvalues: UIConstants (ref), u149 (ref), Update2 (ref), u147 (ref), SkinFilterState (ref), u23 (ref), u24 (ref), u12 (ref), u25 (ref), u26 (ref), RedTint (ref), NavBar (ref), ApplyQuickSellAppearance (ref), AmountLabel (ref), ShopModule (ref), SellAmount (ref), NumberUtil (ref), ConfirmSell (ref), u27 (ref), u16 (ref)
        if not UIConstants.FRAME_INVENTORY.Visible then
            if u149 then
                u149 = false;
                Update2:FireServer("SkinFilters", u147 or SkinFilterState.DEFAULT_ENCODED);
            end;

            if u23 then
                for i in pairs(u24) do
                    u24[i] = nil;
                    local v268 = u12[i];

                    if v268 then
                        local SellHighlight = v268:FindFirstChild("SellHighlight");

                        if SellHighlight then
                            SellHighlight.Visible = u24[i] == true;
                        end;
                    end;
                end;

                u25 = 0;
                u26 = 0;
                u23 = false;
                RedTint.Visible = false;

                if NavBar then
                    NavBar.Visible = true;
                end;

                ApplyQuickSellAppearance(false);
                AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
                SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
                local v269 = u25 > 0;
                AmountLabel.Visible = u23;
                SellAmount.Visible = v269;
                ConfirmSell.Visible = v269;

                if u27 then
                    u27.Visible = v269;
                end;

                if u16 then
                    u16();
                end;

                if u16 then
                    u16();
                end;
            end;
        end;
    end);
    UIConstants.FRAME_MAIN:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1532
        -- upvalues: UIConstants (ref), u22 (ref), u259 (ref)
        if not UIConstants.FRAME_MAIN.Visible and u22 then
            u259.ViewSkins(nil);
        end;
    end);
    script.Update.Event:Connect(function(p270: string) -- Line: 1539
        -- upvalues: u23 (ref), u24 (ref), u12 (ref), u25 (ref), u26 (ref), AmountLabel (ref), ShopModule (ref), SellAmount (ref), NumberUtil (ref), ConfirmSell (ref), u27 (ref), u16 (ref), BuildEntries (ref), u17 (ref), ApplyFilters (ref), Render (ref)
        if p270 == "Skins" then
            if u23 then
                for i in pairs(u24) do
                    u24[i] = nil;
                    local v271 = u12[i];

                    if v271 then
                        local SellHighlight = v271:FindFirstChild("SellHighlight");

                        if SellHighlight then
                            SellHighlight.Visible = u24[i] == true;
                        end;
                    end;
                end;

                u25 = 0;
                u26 = 0;
                AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
                SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
                local v272 = u25 > 0;
                AmountLabel.Visible = u23;
                SellAmount.Visible = v272;
                ConfirmSell.Visible = v272;

                if u27 then
                    u27.Visible = v272;
                end;

                if u16 then
                    u16();
                end;
            end;

            BuildEntries();

            if u17 then
                u17();
            end;

            ApplyFilters();
            Render();

            if u16 then
                u16();
            end;
        end;
    end);
    Update.OnClientEvent:Connect(function(p273, ...) -- Line: 1546
        -- upvalues: PlayerDataModule (ref), u23 (ref), u24 (ref), u12 (ref), u25 (ref), u26 (ref), AmountLabel (ref), ShopModule (ref), SellAmount (ref), NumberUtil (ref), ConfirmSell (ref), u27 (ref), u16 (ref), BuildEntries (ref), u17 (ref), ApplyFilters (ref), Render (ref), Update3 (ref), OpenCase (ref), CreateWheelSpinner (ref)
        if p273 ~= "Skins" then
            return;
        end;

        local v274, v275, v276, v277, v278 = ...;
        PlayerDataModule.Skins = v274;

        if u23 then
            for i in pairs(u24) do
                u24[i] = nil;
                local v279 = u12[i];

                if v279 then
                    local SellHighlight = v279:FindFirstChild("SellHighlight");

                    if SellHighlight then
                        SellHighlight.Visible = u24[i] == true;
                    end;
                end;
            end;

            u25 = 0;
            u26 = 0;
            AmountLabel.Text = u25 .. "/" .. ShopModule.RaritySells.MaxQuickSellBatch .. " selected";
            SellAmount.Text = "+" .. NumberUtil:FormatNumber(u26);
            local v280 = u25 > 0;
            AmountLabel.Visible = u23;
            SellAmount.Visible = v280;
            ConfirmSell.Visible = v280;

            if u27 then
                u27.Visible = v280;
            end;

            if u16 then
                u16();
            end;
        end;

        BuildEntries();

        if u17 then
            u17();
        end;

        ApplyFilters();
        Render();

        if u16 then
            u16();
        end;

        Update3:Fire("Skins");

        if not v275 then
            return;
        end;

        if OpenCase:GetAttribute("Ready") then
            OpenCase:Fire(v275, v276, v277, v278);

            return;
        end;

        task.spawn(CreateWheelSpinner, v275, v276, v277, v278);
    end);
end;

return u259;