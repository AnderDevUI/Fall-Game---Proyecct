-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / ShopUIModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local PolicyService = game:GetService("PolicyService");
local LocalPlayer = Players.LocalPlayer;
local Purchase = ReplicatedStorage:WaitForChild("ShopRemotes"):WaitForChild("Purchase");
local OpenCaps = script:WaitForChild("OpenCaps");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Parent = script.Parent.Parent;
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local ShopModule = require(Modules:WaitForChild("ShopModule"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local BundleContentsModule = require(script:WaitForChild("BundleContentsModule"));
local CaseContentsModule = require(script:WaitForChild("CaseContentsModule"));
local CasesScrollModule = require(script:WaitForChild("CasesScrollModule"));
local CapsRowsModule = require(script:WaitForChild("CapsRowsModule"));
local ConfirmModule = require(Parent:WaitForChild("ConfirmModule"));
local SoundModule = require(Parent:WaitForChild("SoundModule"));
local SkinTileModule = require(Modules:WaitForChild("SkinTileModule"));
local UIConstants = require(script.Parent.Parent:WaitForChild("UIConstants"));
local PlayerDataModule = require(script.Parent.Parent:WaitForChild("PlayerDataModule"));
local Color3_fromRGB_ret = Color3.fromRGB(75, 123, 255);
local Color3_new_ret = Color3.new(1, 1, 1);
local Values = ReplicatedStorage:WaitForChild("Values");
local TimerLabel = UIConstants.SHOP_FEATURED:FindFirstChild("TimerFrame"):FindFirstChild("TimerLabel");
local u1 = {
    [UIConstants.SHOP_NAV.Caps] = UIConstants.SHOP_CAPS,
    [UIConstants.SHOP_NAV.Cases] = UIConstants.SHOP_CASE,
    [UIConstants.SHOP_NAV.Featured] = UIConstants.SHOP_FEATURED
};
local u2 = nil;
local u3 = nil;
local v4 = {};

local function UpdateCaps() -- Line: 45
    -- upvalues: PlayerDataModule (copy), UIConstants (copy), NumberUtil (copy)
    local BottleCaps = PlayerDataModule.BottleCaps;

    if not BottleCaps then
        return;
    end;

    local v5 = tostring(BottleCaps);
    print(v5);
    UIConstants.SHOP_BUYCAPS.Detail.Frame.TextLabel.Text = NumberUtil:FormatNumber(v5);
end;

local function UpdateBundlesOwned() -- Line: 53
    -- upvalues: UIConstants (copy), PlayerDataModule (copy)
    for _, child in pairs(UIConstants.SHOP_FEATURED.BundleScrollingFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            local string_gsub_ret = string.gsub(child.Name, "Bundle", "");

            if table.find(PlayerDataModule.Bundles, string_gsub_ret) then
                child.Owned.Visible = true;
            end;
        end;
    end;
end;

local function SelectNavButton(p6: userdata, p7: boolean) -- Line: 63
    -- upvalues: u2 (ref), SelectNavButton (copy), BundleContentsModule (copy), CaseContentsModule (copy), Color3_fromRGB_ret (copy), Color3_new_ret (copy), u1 (copy)
    if not p7 and u2 == p6 then
        return;
    end;

    if not p7 and u2 then
        SelectNavButton(u2, true);
    end;

    BundleContentsModule.Close();
    CaseContentsModule.Close();
    local UIStroke = p6.Detail.Frame.UIStroke;
    UIStroke.Color = p7 and UIStroke:GetAttribute("ColorDefault") or Color3_fromRGB_ret;
    p6.Detail.Frame.TextLabel.TextColor3 = p7 and Color3_new_ret or Color3_fromRGB_ret;

    if p7 then
        return;
    end;

    local v8 = u1[u2];

    if v8 then
        v8.Visible = false;
    end;

    u2 = p6;
    local v9 = u1[p6];

    if v9 then
        v9.Visible = true;
    end;
end;

local function MouseEnterNavButton(p10: userdata) -- Line: 79
    -- upvalues: u2 (ref), Color3_new_ret (copy)
    if u2 == p10 then
        return;
    end;

    p10.Detail.Frame.UIStroke.Color = Color3_new_ret;
end;

local function MouseLeaveNavButton(p11: userdata) -- Line: 85
    -- upvalues: u2 (ref)
    if u2 == p11 then
        return;
    end;

    local UIStroke = p11.Detail.Frame.UIStroke;
    UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
end;

local function MouseEnterWeeklyOffer(p12: userdata) -- Line: 91
    p12.Frame.UIStroke.UIGradient.Enabled = false;
end;

local function MouseLeaveWeeklyOffer(p13: userdata) -- Line: 96
    p13.Frame.UIStroke.UIGradient.Enabled = true;
end;

local function PurchaseWeeklyOffer(p14: userdata) -- Line: 101
    -- upvalues: UIConstants (copy), ShopModule (copy), ConfirmModule (copy), Purchase (copy)
    if UIConstants.FRAME_BUNDLECONTENTS.Visible then
        return;
    end;

    local v15 = ShopModule[p14.Name];

    if not ConfirmModule.Prompt("Buy", "Are you sure you want to purchase?", v15.Price) then
        return;
    end;

    Purchase:FireServer(p14.Name, v15.Item);
end;

local function ToggleBundleHover(p16: userdata, p17: boolean) -- Line: 110
    p16.UIStroke.UIGradient.Enabled = not p17;
end;

local function ToggleContentsButtonHover(p18: userdata, p19: boolean) -- Line: 114
    -- upvalues: Color3_fromRGB_ret (copy), Color3_new_ret (copy)
    p18.Detail.Frame.TextLabel.TextColor3 = p19 and Color3_fromRGB_ret or Color3_new_ret;
end;

local function RefreshOwnedAmounts() -- Line: 118
    -- upvalues: PlayerDataModule (copy), UIConstants (copy)
    local v20 = PlayerDataModule and PlayerDataModule.Cases or {};

    for _, child in pairs(UIConstants.SHOP_CASE.CaseFrames:GetChildren()) do
        if child:IsA("ImageButton") and string.find(child.Name, "Case", 1, true) then
            local Attribute = child:GetAttribute("CaseName");

            if Attribute then
                local OwnedAmount = child:FindFirstChild("OwnedAmount");

                if OwnedAmount then
                    OwnedAmount.Text = "x" .. tostring(v20[Attribute] or 0) .. " Owned";
                end;
            end;
        end;
    end;
end;

local function RefreshCapsBonuses() -- Line: 133
    -- upvalues: Values (copy), ShopModule (copy), PlayerDataModule (copy), UIConstants (copy), SkinTileModule (copy)
    local Value = Values.ServerOS.Value;

    if not Value then
        return false;
    end;

    local CapsBonuses = ShopModule:GetCapsBonuses(Value);
    local v21 = PlayerDataModule and PlayerDataModule.Skins or {};

    for i = 1, 7 do
        local v22 = UIConstants.SHOP_CAPS.Packages:FindFirstChild("Caps" .. i, true);
        local v23;

        if v22 then
            local v24 = CapsBonuses[v22:GetAttribute("ProductId")];
            v23 = i;
            local v25 = 0;

            while true do
                v25 = v25 + 1;
                local v26 = v22:FindFirstChild("BonusCase" .. (v25 == 1 and "" or tostring(v25)));

                if not v26 then
                    break;
                end;

                local v27;

                if v24 then
                    v27 = v24.Cases[v25];
                else
                    v27 = v24;
                end;

                if v27 then
                    local v28 = ShopModule[v27.Case];
                    local Frame = v26:FindFirstChild("Frame");

                    if v28 and Frame then
                        local ItemImage = Frame:FindFirstChild("ItemImage");

                        if ItemImage then
                            ItemImage.Image = v28.Image;
                        end;

                        local CaseName = Frame:FindFirstChild("CaseName");

                        if CaseName then
                            CaseName.Text = v28.Name or v27.Case;
                        end;
                    end;

                    local ItemName = v26:FindFirstChild("ItemName");

                    if ItemName then
                        Frame = ItemName;
                    elseif Frame then
                        Frame = Frame:FindFirstChild("ItemName");
                    end;

                    if Frame then
                        Frame.Text = v27.Count .. (v27.Count == 1 and " CASE!" or " CASES!");
                    end;
                end;

                v26.Visible = v27 ~= nil;
            end;

            local BonusSkin = v22:FindFirstChild("BonusSkin");

            if BonusSkin then
                if v24 then
                    v24 = v24.Skin;
                end;

                local v29;

                if v24 == nil then
                    v29 = false;
                else
                    v29 = not table.find(v21, v24);
                end;

                if v29 then
                    SkinTileModule.Populate(BonusSkin, v24, true);
                end;

                BonusSkin.Visible = v29;
            end;
        else
            v23 = i;
        end;
    end;

    return true;
end;

function v4.Load() -- Line: 184
    -- upvalues: SelectNavButton (copy), UIConstants (copy), SoundModule (copy), u2 (ref), Color3_new_ret (copy), MarketplaceService (copy), LocalPlayer (copy), Color3_fromRGB_ret (copy), BundleContentsModule (copy), ShopModule (copy), SkinsModule (copy), NumberUtil (copy), ConfirmModule (copy), Purchase (copy), Values (copy), TimerLabel (copy), CaseContentsModule (copy), u3 (ref), PlayerDataModule (copy), PolicyService (copy), RefreshCapsBonuses (copy), OpenCaps (copy), UpdateBundlesOwned (copy), RefreshOwnedAmounts (copy), CasesScrollModule (copy), CapsRowsModule (copy)
    SelectNavButton(UIConstants.SHOP_NAV.Featured);

    for _, child in pairs(UIConstants.SHOP_NAV:GetChildren()) do
        if child:IsA("TextButton") then
            child.MouseEnter:Connect(function() -- Line: 190
                -- upvalues: SoundModule (ref), child (copy), u2 (ref), Color3_new_ret (ref)
                SoundModule.PlaySound("Hover");
                local v30 = child;

                if u2 == v30 then
                    return;
                end;

                v30.Detail.Frame.UIStroke.Color = Color3_new_ret;
            end);
            child.MouseLeave:Connect(function() -- Line: 194
                -- upvalues: child (copy), u2 (ref)
                local v31 = child;

                if u2 == v31 then
                    return;
                end;

                local UIStroke = v31.Detail.Frame.UIStroke;
                UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
            end);
            child.MouseButton1Click:Connect(function() -- Line: 197
                -- upvalues: SoundModule (ref), SelectNavButton (ref), child (copy)
                SoundModule.PlaySound("Click");
                SelectNavButton(child);
            end);
        end;
    end;

    UIConstants.SHOP_BUYCAPS.MouseEnter:Connect(function() -- Line: 203
        -- upvalues: SoundModule (ref), UIConstants (ref), u2 (ref), Color3_new_ret (ref)
        SoundModule.PlaySound("Hover");
        local Add = UIConstants.SHOP_BUYCAPS.Add;

        if u2 == Add then
            return;
        end;

        Add.Detail.Frame.UIStroke.Color = Color3_new_ret;
    end);
    UIConstants.SHOP_BUYCAPS.MouseLeave:Connect(function() -- Line: 207
        -- upvalues: UIConstants (ref), u2 (ref)
        local Add = UIConstants.SHOP_BUYCAPS.Add;

        if u2 == Add then
            return;
        end;

        local UIStroke = Add.Detail.Frame.UIStroke;
        UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
    end);
    UIConstants.SHOP_BUYCAPS.MouseButton1Click:Connect(function() -- Line: 210
        -- upvalues: SoundModule (ref), SelectNavButton (ref), UIConstants (ref)
        SoundModule.PlaySound("Click");
        SelectNavButton(UIConstants.SHOP_NAV.Caps);
    end);

    for _, child in pairs(UIConstants.SHOP_FEATURED.BundleScrollingFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            local string_gsub_ret = string.gsub(child.Name, "Bundle", "");
            child.MouseEnter:Connect(function() -- Line: 222
                -- upvalues: SoundModule (ref), child (copy)
                SoundModule.PlaySound("Hover");
                child.UIStroke.UIGradient.Enabled = false;
            end);
            child.MouseLeave:Connect(function() -- Line: 226
                -- upvalues: child (copy)
                child.UIStroke.UIGradient.Enabled = true;
            end);
            child.MouseButton1Click:Connect(function() -- Line: 229
                -- upvalues: SoundModule (ref), child (copy), MarketplaceService (ref), LocalPlayer (ref)
                SoundModule.PlaySound("Click");

                if child.Owned.Visible == true then
                    return;
                end;

                MarketplaceService:PromptProductPurchase(LocalPlayer, (child:GetAttribute("ProductId")));
            end);
            child.Contents.MouseEnter:Connect(function() -- Line: 237
                -- upvalues: SoundModule (ref), child (copy), Color3_fromRGB_ret (ref), Color3_new_ret (ref)
                SoundModule.PlaySound("Hover");
                child.Contents.Detail.Frame.TextLabel.TextColor3 = Color3_fromRGB_ret or Color3_new_ret;
            end);
            child.Contents.MouseLeave:Connect(function() -- Line: 241
                -- upvalues: child (copy), Color3_new_ret (ref)
                child.Contents.Detail.Frame.TextLabel.TextColor3 = Color3_new_ret;
            end);
            child.Contents.MouseButton1Click:Connect(function() -- Line: 244
                -- upvalues: SoundModule (ref), BundleContentsModule (ref), string_gsub_ret (copy)
                SoundModule.PlaySound("Click");
                BundleContentsModule.Open(string_gsub_ret);
            end);
        end;
    end;

    local Weekly = UIConstants.SHOP_FEATURED:FindFirstChild("Weekly");
    local Templates = Weekly.Templates;

    for i = 1, 5 do
        local v32 = "Weekly" .. i;
        local v33 = ShopModule[v32];
        local v34 = SkinsModule.CachedSkinRarities[v33.Item];
        local u35 = Templates:FindFirstChild("Template" .. v34.Rarity):Clone();
        local string_split_ret = string.split(v33.Item, "/");
        u35.LayoutOrder = i;
        u35.Frame.ItemImage.Image = v34.Image;
        u35.Frame.ItemName.Text = string_split_ret[1];
        u35.Frame.SkinName.Text = string_split_ret[2];
        u35.BuyCaps.Detail.Frame.TextLabel.Text = NumberUtil:FormatNumber(v33.Price);
        u35.Name = v32;
        u35.Parent = Weekly;
        u35.Visible = true;
        u35.MouseEnter:Connect(function() -- Line: 268
            -- upvalues: SoundModule (ref), u35 (copy)
            SoundModule.PlaySound("Hover");
            u35.Frame.UIStroke.UIGradient.Enabled = false;
        end);
        u35.MouseLeave:Connect(function() -- Line: 272
            -- upvalues: u35 (copy)
            u35.Frame.UIStroke.UIGradient.Enabled = true;
        end);
        u35.MouseButton1Click:Connect(function() -- Line: 275
            -- upvalues: SoundModule (ref), u35 (copy), UIConstants (ref), ShopModule (ref), ConfirmModule (ref), Purchase (ref)
            SoundModule.PlaySound("Click");
            local v36 = u35;

            if UIConstants.FRAME_BUNDLECONTENTS.Visible then
                return;
            end;

            local v37 = ShopModule[v36.Name];

            if not ConfirmModule.Prompt("Buy", "Are you sure you want to purchase?", v37.Price) then
                return;
            end;

            Purchase:FireServer(v36.Name, v37.Item);
        end);
        local _ = i;
    end;

    local EndOffer = ShopModule.Weekly1.EndOffer;
    task.defer(function() -- Line: 283
        -- upvalues: Values (ref), EndOffer (copy), NumberUtil (ref), TimerLabel (ref), UIConstants (ref)
        while true do
            local v38 = -os.difftime(Values.ServerOS.Value, EndOffer);
            TimerLabel.Text = NumberUtil:FormatTime(v38, "Hours", "Seconds", false);

            if v38 <= 0 then
                break;
            end;

            task.wait(1);
        end;

        TimerLabel.Parent.Visible = false;
        UIConstants.SHOP_FEATURED.Weekly.Visible = false;
    end);

    for _, child in pairs(UIConstants.SHOP_CASE.CaseFrames:GetChildren()) do
        if child:IsA("ImageButton") and string.find(child.Name, "Case", 1, true) then
            local Attribute = child:GetAttribute("CaseName");

            if Attribute then
                local u39 = ShopModule[Attribute] and ShopModule[Attribute].Price;

                if u39 then
                    child.BuyCaps.Detail.Frame.TextLabel.Text = NumberUtil:FormatNumber(u39);
                end;

                child.Contents.MouseEnter:Connect(function() -- Line: 312
                    -- upvalues: SoundModule (ref), child (copy), Color3_fromRGB_ret (ref), Color3_new_ret (ref)
                    SoundModule.PlaySound("Hover");
                    child.Contents.Detail.Frame.TextLabel.TextColor3 = Color3_fromRGB_ret or Color3_new_ret;
                end);
                child.Contents.MouseLeave:Connect(function() -- Line: 316
                    -- upvalues: child (copy), Color3_new_ret (ref)
                    child.Contents.Detail.Frame.TextLabel.TextColor3 = Color3_new_ret;
                end);
                child.Contents.MouseButton1Click:Connect(function() -- Line: 319
                    -- upvalues: SoundModule (ref), CaseContentsModule (ref), Attribute (copy), child (copy)
                    SoundModule.PlaySound("Click");
                    CaseContentsModule.Open(Attribute, child.Title.ItemName.Text);
                end);
                child.MouseEnter:Connect(function() -- Line: 324
                    -- upvalues: SoundModule (ref), child (copy)
                    SoundModule.PlaySound("Hover");
                    child.UIStroke.UIGradient.Enabled = false;
                end);
                child.MouseLeave:Connect(function() -- Line: 328
                    -- upvalues: child (copy)
                    child.UIStroke.UIGradient.Enabled = true;
                end);
                child.MouseButton1Click:Connect(function() -- Line: 331
                    -- upvalues: SoundModule (ref), u3 (ref), UIConstants (ref), PlayerDataModule (ref), Attribute (copy), u39 (copy), ConfirmModule (ref), child (copy), Purchase (ref)
                    SoundModule.PlaySound("Click");

                    if not u3 then
                        return;
                    end;

                    if UIConstants.FRAME_CASECONTENTS.Visible == true then
                        return;
                    end;

                    if UIConstants.FRAME_MAIN:FindFirstChild("ShowSkin") then
                        return;
                    end;

                    if UIConstants.FRAME_MAIN:FindFirstChild("c") then
                        return;
                    end;

                    if ((PlayerDataModule.Cases or {})[Attribute] or 0) > 0 then
                        Purchase:FireServer("OpenCase", Attribute);

                        return;
                    end;

                    local v40, v41 = ConfirmModule.Prompt("BuyCase", child.Title.ItemName.Text, u39, true);

                    if not v40 then
                        return;
                    end;

                    if UIConstants.FRAME_MAIN:FindFirstChild("ShowSkin") then
                        return;
                    end;

                    Purchase:FireServer(Attribute, nil, v41);
                end);
                child.BuyCaps.MouseEnter:Connect(function() -- Line: 350
                    -- upvalues: SoundModule (ref), child (copy), Color3_fromRGB_ret (ref), Color3_new_ret (ref)
                    SoundModule.PlaySound("Hover");
                    child.BuyCaps.Detail.Frame.TextLabel.TextColor3 = Color3_fromRGB_ret or Color3_new_ret;
                end);
                child.BuyCaps.MouseLeave:Connect(function() -- Line: 354
                    -- upvalues: child (copy), Color3_new_ret (ref)
                    child.BuyCaps.Detail.Frame.TextLabel.TextColor3 = Color3_new_ret;
                end);
                child.BuyCaps.MouseButton1Click:Connect(function() -- Line: 357
                    -- upvalues: SoundModule (ref), u3 (ref), UIConstants (ref), u39 (copy), ConfirmModule (ref), child (copy), Purchase (ref), Attribute (copy)
                    SoundModule.PlaySound("Click");

                    if not u3 then
                        return;
                    end;

                    if UIConstants.FRAME_CASECONTENTS.Visible == true then
                        return;
                    end;

                    local v42, v43 = ConfirmModule.Prompt("BuyCase", child.Title.ItemName.Text, u39, true);

                    if not v42 then
                        return;
                    end;

                    if UIConstants.FRAME_MAIN:FindFirstChild("ShowSkin") then
                        return;
                    end;

                    Purchase:FireServer(Attribute, nil, v43);
                end);
            end;
        end;
    end;

    task.defer(function() -- Line: 370
        -- upvalues: PolicyService (ref), LocalPlayer (ref), u3 (ref), UIConstants (ref)
        while true do
            while true do
                local success, result = pcall(function() -- Line: 372
                    -- upvalues: PolicyService (ref), LocalPlayer (ref)
                    return PolicyService:GetPolicyInfoForPlayerAsync(LocalPlayer);
                end);

                if not success then
                    break;
                end;

                u3 = not result.ArePaidRandomItemsRestricted;
                print("CAN USE CRATES", u3);
                UIConstants.SHOP_NAV.UIListLayout.HorizontalAlignment = u3 and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left;
                UIConstants.SHOP_NAV.Cases.Visible = u3;
                task.wait(300);
            end;

            task.wait(1);
        end;
    end);

    for i = 1, 7 do
        local u44 = UIConstants.SHOP_CAPS.Packages:FindFirstChild("Caps" .. i, true);
        u44.MouseEnter:Connect(function() -- Line: 390
            -- upvalues: SoundModule (ref), u44 (copy), Color3_new_ret (ref)
            SoundModule.PlaySound("Hover");
            u44.UIStroke.Color = Color3_new_ret;
        end);
        u44.MouseLeave:Connect(function() -- Line: 395
            -- upvalues: u44 (copy)
            local UIStroke = u44.UIStroke;
            UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
        end);
        u44.MouseButton1Click:Connect(function() -- Line: 399
            -- upvalues: SoundModule (ref), u44 (copy), MarketplaceService (ref), LocalPlayer (ref)
            SoundModule.PlaySound("Click");
            MarketplaceService:PromptProductPurchase(LocalPlayer, (u44:GetAttribute("ProductId")));
        end);
        local _ = i;
    end;

    task.defer(function() -- Line: 408
        -- upvalues: PlayerDataModule (ref), ShopModule (ref), Values (ref), RefreshCapsBonuses (ref)
        local v45 = nil;
        local v46 = false;

        while true do
            local v47;

            if PlayerDataModule then
                v47 = ShopModule:GetCapsBonuses(Values.ServerOS.Value or os.time());

                if v47 == v45 and v46 then
                    v47 = v45;
                else
                    v46 = RefreshCapsBonuses();
                end;
            else
                v47 = v45;
            end;

            task.wait(1);
            v45 = v47;
        end;
    end);
    OpenCaps.Event:Connect(function() -- Line: 423
        -- upvalues: SelectNavButton (ref), UIConstants (ref)
        SelectNavButton(UIConstants.SHOP_NAV.Caps);
    end);
    local Caps7 = UIConstants.SHOP_CAPS.Packages:FindFirstChild("Caps7");

    local function SetCaps7Visible() -- Line: 431
        -- upvalues: Caps7 (copy), PlayerDataModule (ref)
        if Caps7 then
            Caps7.Visible = (PlayerDataModule and PlayerDataModule.ShowCaps7) == true;
        end;
    end;

    if Caps7 then
        Caps7.Visible = (PlayerDataModule and PlayerDataModule.ShowCaps7) == true;
    end;

    script.Update.Event:Connect(function(p48: string) -- Line: 439
        -- upvalues: UpdateBundlesOwned (ref), PlayerDataModule (ref), UIConstants (ref), NumberUtil (ref), Caps7 (copy), RefreshOwnedAmounts (ref), RefreshCapsBonuses (ref)
        if p48 == "Bundles" then
            UpdateBundlesOwned();

            return;
        end;

        if p48 ~= "Caps" then
            if p48 == "Caps7" then
                if Caps7 then
                    Caps7.Visible = (PlayerDataModule and PlayerDataModule.ShowCaps7) == true;

                    return;
                end;
            else
                if p48 == "Cases" then
                    RefreshOwnedAmounts();

                    return;
                end;

                if p48 == "Skins" then
                    RefreshCapsBonuses();
                end;
            end;

            return;
        end;

        local BottleCaps = PlayerDataModule.BottleCaps;

        if not BottleCaps then
            return;
        end;

        local v49 = tostring(BottleCaps);
        print(v49);
        UIConstants.SHOP_BUYCAPS.Detail.Frame.TextLabel.Text = NumberUtil:FormatNumber(v49);
    end);
    UpdateBundlesOwned();
    local BottleCaps = PlayerDataModule.BottleCaps;

    if BottleCaps then
        local v50 = tostring(BottleCaps);
        print(v50);
        UIConstants.SHOP_BUYCAPS.Detail.Frame.TextLabel.Text = NumberUtil:FormatNumber(v50);
    end;

    CasesScrollModule.Init();
    CapsRowsModule.Init(UIConstants.SHOP_CAPS.Packages);
    RefreshOwnedAmounts();
end;

return v4;