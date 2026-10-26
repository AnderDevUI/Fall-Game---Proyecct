-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / ShopUIModule / CasesScrollModule @Type ModuleScript


local RunService = game:GetService("RunService");
local SHOP_CASESCROLL = require(script.Parent.Parent.Parent:WaitForChild("UIConstants")).SHOP_CASESCROLL;
local UIGridLayout = SHOP_CASESCROLL:WaitForChild("UIGridLayout");
local UIPadding = SHOP_CASESCROLL:FindFirstChild("UIPadding");
local CellSize = UIGridLayout.CellSize;
local CellPadding = UIGridLayout.CellPadding;
local CanvasSize = SHOP_CASESCROLL.CanvasSize;
local u1 = 0;

for _, child in ipairs(SHOP_CASESCROLL:GetChildren()) do
    if child:IsA("ImageButton") then
        local v2 = child:FindFirstChildOfClass("UIStroke");

        if v2 then
            u1 = v2.Thickness;
        end;

        break;
    end;
end;

local u3 = nil;
local u4 = nil;
local u5 = false;

local function ApplyFixedCellSizing() -- Line: 38
    -- upvalues: SHOP_CASESCROLL (copy), CanvasSize (copy), CellSize (copy), CellPadding (copy), UIGridLayout (copy)
    local AbsoluteSize = SHOP_CASESCROLL.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local v6 = CanvasSize.X.Scale * AbsoluteSize.X + CanvasSize.X.Offset;
    local v7 = CanvasSize.Y.Scale * AbsoluteSize.Y + CanvasSize.Y.Offset;

    if v6 == 0 then
        v6 = AbsoluteSize.X;
    end;

    if v7 == 0 then
        v7 = AbsoluteSize.Y;
    end;

    local v8 = CellPadding.X.Scale * v6 + CellPadding.X.Offset;
    local v9 = CellPadding.Y.Scale * v7 + CellPadding.Y.Offset;
    UIGridLayout.CellSize = UDim2.fromOffset(CellSize.X.Scale * v6 + CellSize.X.Offset, CellSize.Y.Scale * v7 + CellSize.Y.Offset);
    UIGridLayout.CellPadding = UDim2.fromOffset(v8, v9);
end;

local function RefreshCanvas() -- Line: 58
    -- upvalues: SHOP_CASESCROLL (copy), RunService (copy), UIPadding (copy), UIGridLayout (copy), u1 (ref)
    local AbsoluteSize = SHOP_CASESCROLL.AbsoluteSize;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local Y = SHOP_CASESCROLL.CanvasSize.Y;
    SHOP_CASESCROLL.CanvasSize = UDim2.new(UDim.new(0, 0), Y);
    RunService.Heartbeat:Wait();
    local v10, v11;

    if UIPadding then
        v10 = UIPadding.PaddingLeft.Scale * AbsoluteSize.X + UIPadding.PaddingLeft.Offset + (UIPadding.PaddingRight.Scale * AbsoluteSize.X + UIPadding.PaddingRight.Offset);
        v11 = UIPadding.PaddingTop.Scale * AbsoluteSize.Y + UIPadding.PaddingTop.Offset + (UIPadding.PaddingBottom.Scale * AbsoluteSize.Y + UIPadding.PaddingBottom.Offset);
    else
        v10 = 0;
        v11 = 0;
    end;

    local AbsoluteContentSize = UIGridLayout.AbsoluteContentSize;
    SHOP_CASESCROLL.CanvasSize = UDim2.new(0, AbsoluteContentSize.X + v10, 0, AbsoluteContentSize.Y + v11 + (UIGridLayout.AbsoluteCellSize.Y * 0.25 + u1));
end;

local function ScheduleRelayout() -- Line: 85
    -- upvalues: u3 (ref), SHOP_CASESCROLL (copy), ApplyFixedCellSizing (copy), RefreshCanvas (copy)
    if u3 then
        task.cancel(u3);
    end;

    u3 = task.delay(0.1, function() -- Line: 87
        -- upvalues: u3 (ref), SHOP_CASESCROLL (ref), ApplyFixedCellSizing (ref), RefreshCanvas (ref)
        u3 = nil;
        local v12 = SHOP_CASESCROLL.AbsoluteCanvasSize.Y - SHOP_CASESCROLL.AbsoluteWindowSize.Y;
        local v13 = v12 <= 0 and 0 or SHOP_CASESCROLL.CanvasPosition.Y / v12;
        ApplyFixedCellSizing();
        RefreshCanvas();
        SHOP_CASESCROLL.CanvasPosition = Vector2.new(0, math.max(SHOP_CASESCROLL.CanvasSize.Y.Offset - SHOP_CASESCROLL.AbsoluteWindowSize.Y, 0) * v13);
    end);
end;

return {
    Init = function() -- Line: 100
        -- upvalues: u5 (ref), SHOP_CASESCROLL (copy), ApplyFixedCellSizing (copy), u4 (ref), ScheduleRelayout (copy), RefreshCanvas (copy)
        if u5 then
            return;
        end;

        u5 = true;
        local Vector2_zero = Vector2.zero;
        local v14 = os.clock() + 5;

        while true do
            local AbsoluteSize = SHOP_CASESCROLL.AbsoluteSize;

            if AbsoluteSize.X > 1 and (AbsoluteSize.Y > 1 and AbsoluteSize == Vector2_zero) or v14 < os.clock() then
                break;
            end;

            task.wait();
            Vector2_zero = AbsoluteSize;
        end;

        ApplyFixedCellSizing();
        u4 = SHOP_CASESCROLL:GetPropertyChangedSignal("AbsoluteSize"):Connect(ScheduleRelayout);
        RefreshCanvas();
    end,

    RefreshCanvas = RefreshCanvas
};