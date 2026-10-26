-- [PATH] ReplicatedStorage / Modules / ButtonClass @Type ModuleScript


local RunService = game:GetService("RunService");
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local u1 = {};
u1.__index = u1;

function u1.new(u2, p3, u4, p5, p6, u7, p8) -- Line: 24
    -- upvalues: NumberUtil (copy), u1 (copy), RunService (copy)
    local v9 = p8 or u2;
    local v10 = {
        DoingLoop = false,
        Alpha = 0,
        Selected = false,
        MouseEntered = false,
        Enabled = true,
        Button = u2,
        Property = p3,
        OrigSize = u2.Size,
        OrigColor = v9[p3],
        CurColor = v9[p3],
        TargetColor = v9[p3],
        HoverMult = p5 or 1.25
    };

    if p6 == nil then
        p6 = Color3.fromRGB(30, 154, 206);
    else
        local v11 = type(p6) == "number" and NumberUtil:MultColor3ByNum(v9[p3], p6);

        if v11 then
            p6 = v11;
        elseif not p6 then
            p6 = Color3.fromRGB(30, 154, 206);
        end;
    end;

    v10.ClickColor = p6;
    v10.Connections = {};
    v10.GuiAffected = p8;
    local u12 = setmetatable(v10, u1);
    table.insert(u12.Connections, u2.MouseEnter:Connect(function() -- Line: 43
        -- upvalues: u12 (copy), NumberUtil (ref)
        if not u12.Enabled then
            return;
        end;

        u12.MouseEntered = true;
        local CurColor = u12.CurColor;
        u12.Alpha = 0;
        u12.TargetColor = NumberUtil:MultColor3ByNum(CurColor, u12.HoverMult);
        u12:DoLoop();
    end));
    table.insert(u12.Connections, u2.MouseLeave:Connect(function() -- Line: 51
        -- upvalues: u12 (copy)
        u12.MouseEntered = false;
        local CurColor = u12.CurColor;
        u12.Alpha = 0;
        u12.TargetColor = CurColor;
        u12:DoLoop();
    end));

    for i = 1, 2 do
        if i == 2 and not u7 then
            break;
        end;

        table.insert(u12.Connections, u2["MouseButton" .. i .. "Down"]:Connect(function() -- Line: 60
            -- upvalues: u12 (copy), u2 (copy), NumberUtil (ref), i (copy), RunService (ref)
            if not u12.Enabled then
                return;
            end;

            u2:TweenSize(NumberUtil:MultUDim2ByNum(u12.OrigSize, 0.75), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true);
            local u13 = false;
            local v14 = u2["MouseButton" .. i .. "Up"]:Connect(function() -- Line: 64
                -- upvalues: u13 (ref)
                u13 = true;
            end);
            task.wait(0.15);

            while not u13 and u12.MouseEntered do
                RunService.Heartbeat:Wait();
            end;

            v14:Disconnect();

            if u2.Parent ~= nil then
                u2:TweenSize(u12.OrigSize, Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.2, true);
            end;
        end));
        local _ = i;
    end;

    table.insert(u12.Connections, u2.Activated:Connect(function(...) -- Line: 77
        -- upvalues: u12 (copy), u4 (copy)
        if not u12.Enabled then
            return;
        end;

        u4(...);
    end));

    if u7 then
        table.insert(u12.Connections, u2.MouseButton2Click:Connect(function(...) -- Line: 82
            -- upvalues: u12 (copy), u7 (copy)
            if not u12.Enabled then
                return;
            end;

            u7(...);
        end));
    end;

    return u12;
end;

function u1.ToggleButton(p15, p16, p17) -- Line: 91
    -- upvalues: NumberUtil (copy)
    if p15.Selected ~= p16 then
        p15.Selected = p16;
        local v18 = p16 and p15.ClickColor or p15.OrigColor;
        p15.Alpha = 0;
        p15.CurColor = v18;
        p15.TargetColor = NumberUtil:MultColor3ByNum(v18, p15.MouseEntered and (p15.HoverMult or 1) or 1);
        p15:DoLoop(p17);
    end;
end;

function u1.UpdateBaseColor(p19, p20, p21) -- Line: 102
    p19.OrigColor = p20;
    p19.CurColor = p20;
    p19.TargetColor = p20;

    if p21 then
        p19.ClickColor = p21;
    end;
end;

function u1.DoLoop(p22, p23) -- Line: 111
    -- upvalues: NumberUtil (copy), RunService (copy)
    local v24 = p22.GuiAffected or p22.Button;
    local Property = p22.Property;

    if not p22.DoingLoop then
        if p23 then
            v24[Property] = p22.TargetColor;

            return;
        end;

        p22.DoingLoop = true;

        while math.abs(1 - p22.Alpha) > 0.001 do
            local v25 = task.wait() / 0.016666666666666666;

            if not v24.Parent then
                return;
            end;

            local math_clamp_ret = math.clamp(0.3 * v25, 0, 1);
            p22.Alpha = NumberUtil:Lerp(p22.Alpha, 1, math_clamp_ret);
            v24[Property] = v24[Property]:Lerp(p22.TargetColor, math_clamp_ret);
            RunService.Heartbeat:Wait();
        end;

        p22.DoingLoop = false;
    end;
end;

function u1.Destroy(p26) -- Line: 132
    for _, v in pairs(p26.Connections) do
        v:Disconnect();
    end;
end;

function u1.IsToggled(p27) -- Line: 139
    return p27.Selected;
end;

function u1.Enable(p28: table, p29: boolean) -- Line: 143
    p28.Enabled = p29;
end;

return u1;