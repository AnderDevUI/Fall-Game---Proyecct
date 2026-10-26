-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / ShopUIModule / CaseContentsModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UIConstants = require(script.Parent.Parent.Parent:WaitForChild("UIConstants"));
local PlayerDataModule = require(script.Parent.Parent.Parent:WaitForChild("PlayerDataModule"));
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Parent = script.Parent.Parent.Parent;
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local ShopModule = require(Modules:WaitForChild("ShopModule"));
local SoundModule = require(Parent:WaitForChild("SoundModule"));
local CaseScrollingFrame = UIConstants.SHOP_CASECONTENTS:WaitForChild("CaseScrollingFrame");
local Templates = CaseScrollingFrame:WaitForChild("Templates");
local UIGridLayout = CaseScrollingFrame:WaitForChild("UIGridLayout");
local CaseName = UIConstants.SHOP_CASECONTENTS:WaitForChild("CaseName");
local Close = UIConstants.SHOP_CASECONTENTS:WaitForChild("Close");
local Effect = Close.Detail.Frame:FindFirstChild("Effect");
local UIPadding = CaseScrollingFrame:FindFirstChild("UIPadding");
local CanvasSize = CaseScrollingFrame.CanvasSize;
local u1 = Effect and Effect.Color or Color3.new(1, 1, 1);
local Color3_new_ret = Color3.new(1, 1, 1);
local Size = Templates:FindFirstChildWhichIsA("ImageButton").Size;
local CellPadding = UIGridLayout.CellPadding;
local CellSize = UIGridLayout.CellSize;
local NavBar = UIConstants.SHOP_CASECONTENTS.Parent.Parent:FindFirstChild("NavBar");

if NavBar then
    NavBar = NavBar:FindFirstChild("Shop", true);
end;

if NavBar then
    NavBar = NavBar:FindFirstChild("Limited");
end;

local v2 = {};

local function WipeTiles() -- Line: 52
    -- upvalues: CaseScrollingFrame (copy)
    for _, child in pairs(CaseScrollingFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            child:Destroy();
        end;
    end;
end;

local function CloneTemplate(p3: string) -- Line: 60
    -- upvalues: Templates (copy)
    local v4 = Templates:FindFirstChild("Template" .. p3);

    if not v4 then
        return nil;
    end;

    local v5 = v4:Clone();
    v5.Visible = true;

    return v5;
end;

local function SetChance(p6: userdata, p7: number, p8: boolean?) -- Line: 68
    local Chance = p6:FindFirstChild("Chance", true);

    if Chance then
        local v9 = math.round(p7 * 1000) / 1000;
        Chance.Text = tostring(v9) .. "%";

        if p8 ~= nil then
            local v10;

            if p8 then
                v10 = Color3.fromRGB(255, 188, 143);
            else
                v10 = Color3.fromRGB(255, 255, 255);
            end;

            Chance.TextColor3 = v10;
        end;
    end;
end;

local function PopulateTile(p11: userdata, p12: string, p13: any) -- Line: 78
    -- upvalues: PlayerDataModule (copy)
    local Frame = p11:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local v14, v15 = unpack(string.split(p12, "/"));
    local ItemImage = Frame:FindFirstChild("ItemImage");

    if ItemImage then
        ItemImage.Image = p13.Image;
    end;

    local SkinName = Frame:FindFirstChild("SkinName");

    if SkinName then
        SkinName.Text = v15;
    end;

    local ItemName = Frame:FindFirstChild("ItemName");

    if ItemName then
        ItemName.Text = "● " .. v14;
    end;

    local Owned = p11:FindFirstChild("Owned");

    if Owned then
        Owned.Visible = table.find(PlayerDataModule and PlayerDataModule.Skins or {}, p12) and true or false;
    end;
end;

local function LockCells() -- Line: 104
    -- upvalues: CaseScrollingFrame (copy), Size (copy), CellPadding (copy), UIGridLayout (copy)
    local AbsoluteSize = CaseScrollingFrame.AbsoluteSize;
    local v16 = CellPadding.X.Scale * AbsoluteSize.X + CellPadding.X.Offset;
    local v17 = CellPadding.Y.Scale * AbsoluteSize.Y + CellPadding.Y.Offset;
    UIGridLayout.CellSize = UDim2.fromOffset(Size.X.Scale * AbsoluteSize.X + Size.X.Offset, Size.Y.Scale * AbsoluteSize.Y + Size.Y.Offset);
    UIGridLayout.CellPadding = UDim2.fromOffset(v16, v17);
end;

local function FitCanvas() -- Line: 114
    -- upvalues: CaseScrollingFrame (copy), RunService (copy), UIGridLayout (copy), UIPadding (copy)
    CaseScrollingFrame.CanvasSize = UDim2.new(UDim.new(0, 0), CaseScrollingFrame.CanvasSize.Y);
    RunService.Heartbeat:Wait();
    local AbsoluteContentSize = UIGridLayout.AbsoluteContentSize;
    local AbsoluteSize = CaseScrollingFrame.AbsoluteSize;
    local v18;

    if UIPadding then
        v18 = UIPadding.PaddingLeft.Scale * AbsoluteSize.X + UIPadding.PaddingLeft.Offset + UIPadding.PaddingRight.Scale * AbsoluteSize.X + UIPadding.PaddingRight.Offset;
        local _ = UIPadding.PaddingTop.Scale * AbsoluteSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Scale * AbsoluteSize.Y + UIPadding.PaddingBottom.Offset;
    else
        v18 = 0;
    end;

    local AbsolutePosition = CaseScrollingFrame.AbsolutePosition;
    local Y = CaseScrollingFrame.CanvasPosition.Y;
    local v19 = 0;

    for _, child in ipairs(CaseScrollingFrame:GetChildren()) do
        if child:IsA("ImageButton") then
            local v20 = child.AbsolutePosition.Y - AbsolutePosition.Y + child.AbsoluteSize.Y + Y;

            if v19 < v20 then
                v19 = v20;
            end;
        end;
    end;

    CaseScrollingFrame.CanvasSize = UDim2.new(0, AbsoluteContentSize.X + v18, 0, v19 + (UIPadding and UIPadding.PaddingBottom.Scale * AbsoluteSize.Y + UIPadding.PaddingBottom.Offset or 0) + UIGridLayout.CellSize.Y.Offset * 0.65);
end;

local u38 = {
    Open = function(p21: string, p22: string?) -- Line: 147
        -- upvalues: ShopModule (copy), WipeTiles (copy), LockCells (copy), Templates (copy), SetChance (copy), CaseScrollingFrame (copy), SkinsModule (copy), PopulateTile (copy), FitCanvas (copy), CaseName (copy), UIConstants (copy), NavBar (copy)
        local v23 = ShopModule[p21];

        if not v23 or v23.Type ~= "Crate" then
            return;
        end;

        WipeTiles();
        LockCells();
        local v24 = v23.BoostedMythics == true;
        local v25 = {};
        local v26 = {};

        for i, v in pairs(v23.Items) do
            local v27 = v[1];
            local v28 = v[2];
            local v29 = i == 1;

            if typeof(v28) == "string" then
                warn("nonono");
                local v30 = Templates:FindFirstChild("Template" .. v28);
                local v31;

                if v30 then
                    v31 = v30:Clone();
                    v31.Visible = true;
                else
                    v31 = nil;
                end;

                if v31 then
                    local Frame = v31:FindFirstChild("Frame");

                    if Frame then
                        Frame = Frame:FindFirstChild("ItemName");
                    end;

                    if Frame then
                        Frame.Visible = false;
                    end;

                    SetChance(v31, v27, false);
                    v31.Parent = CaseScrollingFrame;
                end;
            elseif typeof(v28) == "table" then
                for _, v3 in pairs(v28) do
                    local SkinInfo = SkinsModule:GetSkinInfo(v3);

                    if SkinInfo then
                        local v32 = v25[v3];
                        local v33;

                        if v32 then
                            v33 = true;
                        else
                            local v34 = Templates:FindFirstChild("Template" .. SkinInfo.Rarity);

                            if v34 then
                                v32 = v34:Clone();
                                v32.Visible = true;
                            else
                                v32 = nil;
                            end;

                            v33 = false;
                        end;

                        if v32 then
                            local v35 = v26[v3];
                            local v36;

                            if v24 and SkinInfo.Rarity == "Mythical" then
                                v36 = v35 or (v29 and 0.4 or 0.3);
                            else
                                v36 = (v35 or 0) + v27;
                            end;

                            v26[v3] = v36;

                            if v33 then
                                local Chance = v32:FindFirstChild("Chance", true);

                                if Chance then
                                    local v37 = math.round(v36 * 1000) / 1000;
                                    Chance.Text = tostring(v37) .. "%";
                                end;
                            else
                                PopulateTile(v32, v3, SkinInfo);
                                SetChance(v32, v36, v24 and v29);
                                v32.Parent = CaseScrollingFrame;
                            end;

                            v25[v3] = v32;
                        end;
                    end;
                end;
            end;
        end;

        FitCanvas();

        if p22 then
            CaseName.Text = p22;
        end;

        UIConstants.SHOP_CASECONTENTS.Limited.Visible = v24;

        if NavBar then
            NavBar.Visible = false;
        end;

        UIConstants.SHOP_CASECONTENTS.Visible = true;
    end,

    Close = function() -- Line: 219
        -- upvalues: NavBar (copy), UIConstants (copy), CaseScrollingFrame (copy), CanvasSize (copy), UIGridLayout (copy), CellSize (copy), CellPadding (copy)
        if NavBar and UIConstants.SHOP_CASECONTENTS.Visible then
            NavBar.Visible = true;
        end;

        UIConstants.SHOP_CASECONTENTS.Visible = false;
        CaseScrollingFrame.CanvasSize = CanvasSize;
        UIGridLayout.CellSize = CellSize;
        UIGridLayout.CellPadding = CellPadding;
    end
};

if true then
    Close.MouseButton1Click:Connect(function() -- Line: 231
        -- upvalues: SoundModule (copy), u38 (copy)
        SoundModule.PlaySound("Click");
        u38.Close();
    end);

    if Effect then
        table.insert(v2, Close.MouseEnter:Connect(function() -- Line: 236
            -- upvalues: SoundModule (copy), Effect (copy), Color3_new_ret (copy)
            SoundModule.PlaySound("Hover");
            Effect.Color = Color3_new_ret;
        end));
        table.insert(v2, Close.MouseLeave:Connect(function() -- Line: 240
            -- upvalues: Effect (copy), u1 (copy)
            Effect.Color = u1;
        end));
    end;
end;

local u39 = nil;
CaseScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 248
    -- upvalues: u39 (ref), UIConstants (copy), CaseScrollingFrame (copy), LockCells (copy), FitCanvas (copy)
    if u39 then
        task.cancel(u39);
    end;

    u39 = task.delay(0.1, function() -- Line: 250
        -- upvalues: u39 (ref), UIConstants (ref), CaseScrollingFrame (ref), LockCells (ref), FitCanvas (ref)
        u39 = nil;

        if not UIConstants.SHOP_CASECONTENTS.Visible then
            return;
        end;

        local v40 = CaseScrollingFrame.AbsoluteCanvasSize.Y - CaseScrollingFrame.AbsoluteWindowSize.Y;
        local v41 = v40 <= 0 and 0 or CaseScrollingFrame.CanvasPosition.Y / v40;
        LockCells();
        FitCanvas();
        CaseScrollingFrame.CanvasPosition = Vector2.new(0, math.max(CaseScrollingFrame.CanvasSize.Y.Offset - CaseScrollingFrame.AbsoluteWindowSize.Y, 0) * v41);
    end);
end);

return u38;