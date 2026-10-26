-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / ConfirmModule @Type ModuleScript


game:GetService("ReplicatedStorage");
game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts");
local UIConstants = require(script.Parent:WaitForChild("UIConstants"));
local PlayerDataModule = require(script.Parent:WaitForChild("PlayerDataModule"));
local Color3_new_ret = Color3.new(1, 1, 1);
local SoundModule = require(script.Parent:WaitForChild("SoundModule"));
local NumberUtil = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("NumberUtil"));
local OpenCaps = script.Parent:WaitForChild("NavBarUIModule"):WaitForChild("ShopUIModule"):WaitForChild("OpenCaps");
local u1 = nil;

return {
    Prompt = function(p2: string, p3: string, ...) -- Line: 39
        -- upvalues: u1 (ref), UIConstants (copy), PlayerDataModule (copy), NumberUtil (copy), SoundModule (copy), Color3_new_ret (copy), OpenCaps (copy)
        if u1 ~= nil then
            return false;
        end;

        u1 = {};
        local u4 = nil;
        local u5 = UIConstants.FRAME_CONFIRM:Clone();
        local u6 = false;
        local v7, v8, v9 = ...;
        local u10 = p2 == "BuyCase";
        local u11 = p2 == "GiftCase";
        local v12 = p2 == "GiftBundle";
        local u13 = u10 or u11;
        local u14 = nil;
        local u15 = 0;
        local u16 = nil;
        local u17;

        if u11 then
            u16 = tostring(v7 or "");
            u15 = tonumber(v8) or 0;
            u17 = v9;
        elseif v12 then
            u16 = tostring(v7 or "");
            u17 = v9;
        else
            u14 = v7;
            u17 = v8;

            if u10 then
                u15 = tonumber(u14) or 0;
            end;
        end;

        local u18;

        if p2 == "Sell" then
            local v19 = select(4, ...);
            u18 = tonumber(v19);
        else
            u18 = nil;
        end;

        local u20;

        if u10 then
            u20 = p3;
        else
            u20 = nil;
        end;

        local u21;

        if u11 or v12 then
            u21 = p3;
        else
            u21 = nil;
        end;

        local u22 = 1;
        local u23;

        if u13 and u15 > 0 then
            local math_floor_ret = math.floor((PlayerDataModule and PlayerDataModule.BottleCaps or 0) / u15);
            u23 = math.max(1, math_floor_ret);
        else
            u23 = 1;
        end;

        if u11 then
            u23 = math.min(u23, 100);
        end;

        local function applyCount(p24: number) -- Line: 81
            -- upvalues: u22 (ref), u23 (ref), u10 (copy), u5 (copy), u20 (copy), NumberUtil (ref), u15 (ref), u11 (copy), u21 (copy), u16 (ref)
            u22 = math.clamp(p24, 1, u23);

            if not u10 then
                if u11 then
                    u5.Message.Text = string.format("Gift %s (<font color=\"#FFDC5D\">%d</font>) to @%s", u21 or "", u22, u16 or "");
                    u5.BuyAmount.Text = "-" .. NumberUtil:FormatNumber(u15 * u22);
                end;

                return;
            end;

            u5.Message.Text = string.format("Purchasing (<font color=\"#FFDC5D\">%d</font>) %s", u22, u20 or "");
            u5.BuyAmount.Text = "-" .. NumberUtil:FormatNumber(u15 * u22);
        end;

        task.defer(function() -- Line: 94
            -- upvalues: u18 (copy), u4 (ref), u5 (copy), u6 (ref), u17 (ref)
            if u18 then
                for i = u18, 1, -1 do
                    if u4 ~= nil then
                        return;
                    end;

                    u5.Options.Yes.Detail.Frame.TextLabel.Text = "Yes(" .. i .. ")";
                    task.wait(1);
                    local _ = i;
                end;

                if u4 ~= nil then
                    return;
                end;

                u5.Options.Yes.Detail.Frame.TextLabel.Text = "Yes";
                u6 = true;

                return;
            end;

            if u17 then
                u5.Options.Yes.Detail.Frame.TextLabel.Text = "Yes";
                u6 = true;

                return;
            end;

            for i = 1, -1, -1 do
                if u4 ~= nil then
                    break;
                end;

                if i == -1 then
                    u5.Options.Yes.Detail.Frame.TextLabel.Text = "Yes";
                    break;
                end;

                u5.Options.Yes.Detail.Frame.TextLabel.Text = "Yes(" .. i .. ")";
                task.wait(1);
                local _ = i;
            end;

            u6 = true;
        end);
        table.insert(u1, u5.Options.Yes.MouseEnter:Connect(function() -- Line: 122
            -- upvalues: SoundModule (ref), u5 (copy), Color3_new_ret (ref)
            SoundModule.PlaySound("Hover");
            u5.Options.Yes.Detail.Frame.UIStroke.Color = Color3_new_ret;
        end));
        table.insert(u1, u5.Options.Yes.MouseLeave:Connect(function() -- Line: 127
            -- upvalues: u5 (copy)
            local UIStroke = u5.Options.Yes.Detail.Frame.UIStroke;
            UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
        end));
        table.insert(u1, u5.Options.Yes.MouseButton1Click:Connect(function() -- Line: 131
            -- upvalues: u6 (ref), SoundModule (ref), u4 (ref), u13 (copy), u15 (ref), u22 (ref), u14 (ref), PlayerDataModule (ref), OpenCaps (ref)
            if not u6 then
                return;
            end;

            SoundModule.PlaySound("Click");
            u4 = true;
            local v25;

            if u13 then
                v25 = u15 * u22;
            else
                v25 = u14 or 0;
            end;

            if PlayerDataModule and (PlayerDataModule.BottleCaps and PlayerDataModule.BottleCaps < v25) then
                OpenCaps:Fire();
            end;
        end));
        table.insert(u1, u5.Options.No.MouseEnter:Connect(function() -- Line: 143
            -- upvalues: SoundModule (ref), u5 (copy), Color3_new_ret (ref)
            SoundModule.PlaySound("Hover");
            u5.Options.No.Detail.Frame.UIStroke.Color = Color3_new_ret;
        end));
        table.insert(u1, u5.Options.No.MouseLeave:Connect(function() -- Line: 148
            -- upvalues: u5 (copy)
            local UIStroke = u5.Options.No.Detail.Frame.UIStroke;
            UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
        end));
        table.insert(u1, u5.Options.No.MouseButton1Click:Connect(function() -- Line: 152
            -- upvalues: SoundModule (ref), u4 (ref)
            SoundModule.PlaySound("Click");
            u4 = false;
        end));

        for _, descendant in ipairs(u5:GetDescendants()) do
            if descendant:IsA("GuiButton") then
                local v26 = tonumber(descendant.Name:match("Increase(%d+)"));
                local v27 = tonumber(descendant.Name:match("Decrease(%d+)"));

                if v26 or v27 then
                    descendant.Visible = u13;

                    if u13 then
                        local u28 = (v26 or 0) - (v27 or 0);
                        table.insert(u1, descendant.MouseButton1Click:Connect(function() -- Line: 167
                            -- upvalues: SoundModule (ref), applyCount (copy), u22 (ref), u28 (copy)
                            SoundModule.PlaySound("Click");
                            applyCount(u22 + u28);
                        end));
                    end;
                end;
            end;
        end;

        local SellBuyDetail = u5:FindFirstChild("SellBuyDetail");
        local BuyAmount = u5:FindFirstChild("BuyAmount");
        local SellAmount = u5:FindFirstChild("SellAmount");
        local GiftMessage = u5:FindFirstChild("GiftMessage");

        if v12 then
            if BuyAmount then
                BuyAmount.Visible = false;
            end;

            if SellAmount then
                SellAmount.Visible = false;
            end;

            if SellBuyDetail then
                SellBuyDetail.Visible = false;
            end;

            if GiftMessage then
                GiftMessage.Text = "DON\'T LEAVE WHILE GIFTING! - Do not gift bundles that are already owned by the receiver.";
                GiftMessage.Visible = true;
            end;
        elseif u11 then
            if BuyAmount then
                BuyAmount.Visible = true;
            end;

            if SellAmount then
                SellAmount.Visible = false;
            end;

            if SellBuyDetail then
                SellBuyDetail.Visible = true;
            end;

            if GiftMessage then
                GiftMessage.Text = "DON\'T LEAVE WHILE GIFTING!";
                GiftMessage.Visible = true;
            end;
        else
            local v29 = u10 and "Buy" or p2;

            for _, child in pairs(u5:GetChildren()) do
                if string.find(child.Name, v29) then
                    child.Visible = true;
                end;
            end;

            if p2 == "Sell" then
                u5.SellAmount.Text = "+" .. NumberUtil:FormatNumber(u14);
                u5.BuyAmount.Visible = false;
            end;

            if p2 == "Buy" then
                u5.BuyAmount.Text = "-" .. NumberUtil:FormatNumber(u14);
                u5.SellAmount.Visible = false;
            end;

            if p2 ~= "Buy" and (p2 ~= "Sell" and not u10) then
                if BuyAmount then
                    BuyAmount.Visible = false;
                end;

                if SellAmount then
                    SellAmount.Visible = false;
                end;

                if SellBuyDetail then
                    SellBuyDetail.Visible = false;
                end;
            end;

            if GiftMessage then
                if type(v9) ~= "string" or v9 == "" then
                    v9 = nil;
                end;

                GiftMessage.Text = v9 or GiftMessage.Text;
                GiftMessage.Visible = v9 ~= nil;

                if v9 and v9:find("\n", 1, true) then
                    GiftMessage.Size = UDim2.new(GiftMessage.Size.X, UDim.new(GiftMessage.Size.Y.Scale * 1.5, GiftMessage.Size.Y.Offset));
                end;
            end;
        end;

        if u10 or u11 then
            applyCount(1);
        elseif v12 then
            u5.Message.Text = string.format("Gift %s to @%s", u21 or "", u16 or "");
        else
            u5.Message.Text = p3;
        end;

        u5.Name = "c";
        u5.Parent = UIConstants.FRAME_MAIN;
        u5.Visible = true;

        repeat
            task.wait(0.2);
        until u4 ~= nil;

        for _, v in pairs(u1) do
            v:Disconnect();
        end;

        u5:Destroy();
        u1 = nil;
        local v30;

        if u13 and u4 then
            v30 = u22;
        else
            v30 = nil;
        end;

        return u4, v30;
    end
};