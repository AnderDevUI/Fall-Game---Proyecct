-- [PATH] ReplicatedStorage / Modules / ItemSearchModule @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local ItemSearch = LocalPlayer.PlayerGui:WaitForChild("ItemSearchMain"):WaitForChild("ItemSearch");
local TextBox = ItemSearch:WaitForChild("TextBox");
local List = ItemSearch:WaitForChild("List");
local Cancel = ItemSearch:WaitForChild("Cancel");
local AmountFrame = ItemSearch:WaitForChild("AmountFrame");
local Accept = AmountFrame:WaitForChild("Accept");
local Cancel2 = AmountFrame:WaitForChild("Cancel");
local TextBox2 = AmountFrame:WaitForChild("TextBox");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Values = ReplicatedStorage:WaitForChild("Values");
local Items = require(Modules:WaitForChild("Items"));
local v1 = {};
local u2 = nil;
local u3 = nil;

local function u6(p4: string) -- Line: 41
    -- upvalues: Items (copy), Values (copy)
    local v5 = {};

    for i, v in pairs(Items) do
        if (not v.Hidden or Values.ShowHiddenRecipes.Value) and v.Name:lower():find(p4:lower(), 1, true) then
            table.insert(v5, { i, v });

            if #v5 >= 8 then
                break;
            end;
        end;
    end;

    return v5;
end;

local u14 = {
    BeginSearch = function() -- Line: 53, Name: BeginSearch
        -- upvalues: UserInputService (copy), u2 (ref), u3 (ref), ItemSearch (copy), List (copy), AmountFrame (copy), TextBox (copy)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
        UserInputService.MouseIconEnabled = true;
        u2 = nil;
        u3 = nil;
        ItemSearch.Visible = true;
        List.Visible = true;
        AmountFrame.Visible = false;
        TextBox.Text = "";
        task.defer(function() -- Line: 64
            -- upvalues: ItemSearch (ref), List (ref), TextBox (ref)
            if ItemSearch.Visible and List.Visible then
                TextBox:CaptureFocus();
            end;
        end);

        while ItemSearch.Visible and not (u2 and u3) do
            task.wait();
        end;

        ItemSearch.Visible = false;

        return u2, u3;
    end,

    CancelSearch = function(p7: boolean) -- Line: 76, Name: CancelSearch
        -- upvalues: UserInputService (copy), ItemSearch (copy)
        if not p7 then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
            UserInputService.MouseIconEnabled = false;
        end;

        ItemSearch.Visible = false;
    end,

    UpdateSearch = function(p8: string) -- Line: 84, Name: UpdateSearch
        -- upvalues: u6 (copy), List (copy), ItemSearch (copy)
        local v9 = p8 == "" and {} or u6(p8);
        local v10 = false;

        for i = 1, 8 do
            local v11 = v9[i];
            local v12 = List:FindFirstChild(i);
            local v13;

            if v12 then
                if v11 then
                    v12.ItemName.Text = v11[2].Name;
                    v12.ItemDesc.Text = v11[2].Description;
                    v12.ItemImage.Image = typeof(v11[2].Image) == "table" and v11[2].Image.Default or v11[2].Image;
                    v12.Visible = true;
                    v12:SetAttribute("Id", v11[1]);
                    v13 = i;
                    v10 = true;
                else
                    v12.Visible = false;
                    v13 = i;
                end;
            else
                v13 = i;
            end;
        end;

        ItemSearch.NoResults.Visible = not v10;
    end,

    IsSearching = function() -- Line: 105, Name: IsSearching
        -- upvalues: ItemSearch (copy)
        return ItemSearch.Visible;
    end
};
TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 110
    -- upvalues: u14 (copy), TextBox (copy)
    u14.UpdateSearch(TextBox.Text);
end);
TextBox2:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 114
    -- upvalues: TextBox2 (copy)
    local Text = TextBox2.Text;

    if Text == "" then
        return;
    end;

    local u15 = 1;
    local _, _ = pcall(function() -- Line: 119
        -- upvalues: u15 (ref), Text (copy)
        u15 = tonumber(Text);
    end);

    if type(u15) == "number" then
        local math_floor_ret = math.floor(u15);
        local math_clamp_ret = math.clamp(math_floor_ret, 1, 100000);
        u15 = tostring(math_clamp_ret);

        if Text == u15 then
            return;
        end;

        TextBox2.Text = u15;
    else
        TextBox2.Text = "1";
    end;
end);
Accept.MouseButton1Click:Connect(function() -- Line: 132
    -- upvalues: TextBox2 (copy), u3 (ref), AmountFrame (copy), List (copy)
    local u16 = 1;
    local success, _ = pcall(function() -- Line: 134
        -- upvalues: u16 (ref), TextBox2 (ref)
        u16 = tonumber(TextBox2.Text);
    end);
    u3 = success and (type(u16) == "number" and (u16 > 1 and u16)) or 1;
    AmountFrame.Visible = false;
    List.Visible = true;
end);
TextBox2.FocusLost:Connect(function(p17) -- Line: 146
    -- upvalues: AmountFrame (copy), TextBox2 (copy), u3 (ref), List (copy)
    if p17 and AmountFrame.Visible then
        local u18 = 1;
        local success, _ = pcall(function() -- Line: 134
            -- upvalues: u18 (ref), TextBox2 (ref)
            u18 = tonumber(TextBox2.Text);
        end);
        u3 = success and (type(u18) == "number" and (u18 > 1 and u18)) or 1;
        AmountFrame.Visible = false;
        List.Visible = true;
    end;
end);
TextBox.FocusLost:Connect(function(p19) -- Line: 154
    -- upvalues: u14 (copy), TextBox (copy)
    if not p19 then
        return;
    end;

    u14.UpdateSearch(TextBox.Text);
end);
Cancel2.MouseButton1Click:Connect(function() -- Line: 159
    -- upvalues: AmountFrame (copy), List (copy)
    AmountFrame.Visible = false;
    List.Visible = true;
end);
Cancel.MouseButton1Click:Connect(function() -- Line: 164
    -- upvalues: u2 (ref), u3 (ref), ItemSearch (copy)
    u2 = nil;
    u3 = nil;
    ItemSearch.Visible = false;
end);

for _, child in pairs(List:GetChildren()) do
    if child:IsA("ImageButton") then
        v1[child] = child.MouseButton1Click:Connect(function() -- Line: 172
            -- upvalues: u2 (ref), child (copy), AmountFrame (copy), List (copy), TextBox2 (copy)
            u2 = child:GetAttribute("Id");
            AmountFrame.Visible = true;
            List.Visible = false;
            TextBox2.Text = "1";
            task.defer(function() -- Line: 178
                -- upvalues: AmountFrame (ref), TextBox2 (ref)
                if AmountFrame.Visible then
                    TextBox2:CaptureFocus();
                end;
            end);
        end);
    end;
end;

LocalPlayer.CharacterRemoving:Connect(function() -- Line: 186
    -- upvalues: u14 (copy)
    u14.CancelSearch();
end);

return u14;