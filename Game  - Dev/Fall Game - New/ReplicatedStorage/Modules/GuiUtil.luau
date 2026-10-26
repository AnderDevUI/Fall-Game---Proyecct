-- [PATH] ReplicatedStorage / Modules / GuiUtil @Type ModuleScript


local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local u1 = {};

return {
    AddScrollToFrame = function(u2: table, u3: userdata, p4: number, p5: number, p6: number?, p7: number?) -- Line: 26, Name: AddScrollToFrame
        -- upvalues: UserInputService (copy), u1 (copy)
        local Frame = u3:FindFirstChild("Frame");
        local v8 = assert(Frame, "\"FRAME\" COMPONENT NOT FOUND");
        local v9 = p7 or 1;
        local u10 = p6 or 0.1;
        local u11 = nil;
        local v12 = {};
        local u13 = {
            Held = false,
            Looping = false,
            Connections = v12,
            Delta = Vector3.new(),
            Frame = v8,
            Scale = v9,
            TargetScale = v9,
            MinZoom = p4,
            MaxZoom = p5
        };
        v8.Size = UDim2.new(u13.Scale, 0, u13.Scale, 0);
        table.insert(v12, u3.InputBegan:Connect(function(p14) -- Line: 50
            -- upvalues: u3 (copy), u13 (copy), u11 (ref), u2 (copy)
            if not u3.Visible then
                return;
            end;

            local UserInputType = p14.UserInputType;
            local v15;

            if UserInputType == Enum.UserInputType.MouseButton1 then
                v15 = true;
            elseif UserInputType == Enum.UserInputType.MouseButton2 then
                v15 = u13.RightDrag;
            else
                v15 = false;
            end;

            if v15 and not u13.Held then
                if u13.Blocked and u13.Blocked(p14) then
                    return;
                end;

                u11 = p14.Position;
                u13.Held = true;
                u13.HeldBy = UserInputType;
                u2:StartZoomLoop(u3);
            end;
        end));
        table.insert(v12, UserInputService.InputChanged:Connect(function(p16) -- Line: 63
            -- upvalues: u3 (copy), u13 (copy), u11 (ref), u10 (ref), u2 (copy)
            if not (u3.Visible and u3.Parent) then
                return;
            end;

            local UserInputType = p16.UserInputType;

            if UserInputType ~= Enum.UserInputType.MouseMovement or not (u13.Held and u11) then
                if UserInputType == Enum.UserInputType.MouseWheel then
                    if u13.Blocked and u13.Blocked(p16) then
                        return;
                    end;

                    local Z = p16.Position.Z;
                    local v17;

                    if u13.WheelFactor then
                        v17 = u13.TargetScale * u13.WheelFactor ^ math.sign(Z);
                    else
                        v17 = u13.TargetScale + Z * u10;
                    end;

                    u13.TargetScale = math.clamp(v17, u13.MinZoom, u13.MaxZoom);

                    if u13.ZoomAboutCursor then
                        local AbsoluteSize = u3.AbsoluteSize;

                        if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
                            u13.ZoomAnchor = (Vector2.new(p16.Position.X, p16.Position.Y) - u3.AbsolutePosition) / AbsoluteSize;
                        end;
                    end;

                    u2:StartZoomLoop(u3);
                end;

                return;
            end;

            local Position = p16.Position;
            u13.Delta = Position - u11;
            u11 = Position;
        end));
        table.insert(v12, UserInputService.InputEnded:Connect(function(p18) -- Line: 85
            -- upvalues: u13 (copy), u11 (ref)
            if p18.UserInputType ~= (u13.HeldBy or Enum.UserInputType.MouseButton1) or not u13.Held then
                return;
            end;

            u13.Held = false;
            u13.HeldBy = nil;
            u13.Delta = p18.Position == u11 and Vector3.new() or u13.Delta;
        end));
        u1[u3] = u13;
        table.insert(v12, u3.Destroying:Connect(function() -- Line: 96
            -- upvalues: u2 (copy), u3 (copy)
            u2:ClearScrollFrame(u3);
        end));
    end,

    StartZoomLoop = function(p19: table, p20: userdata) -- Line: 101, Name: StartZoomLoop
        -- upvalues: u1 (copy), RunService (copy), NumberUtil (copy)
        local v21 = u1[p20];

        if not v21 or v21.Looping then
            return;
        end;

        v21.Looping = true;

        while v21.Held or (v21.Scale ~= v21.TargetScale or v21.Delta.Magnitude >= 0.01) do
            local Delta = v21.Delta;
            local v22 = RunService.Heartbeat:Wait();
            local Frame = v21.Frame;

            if not (Frame and Frame.Parent) then
                return;
            end;

            local v23 = v21.Delta ~= Delta;

            if not v21.Held then
                v21.Delta = v21.Delta:Lerp(Vector3.new(), (math.min(v22 * 10, 1)));
                v23 = true;
            end;

            local v24 = v21.Scale ~= v21.TargetScale;
            local Position = Frame.Position;

            if v24 then
                local Scale = v21.Scale;
                v21.Scale = math.abs(v21.Scale - v21.TargetScale) <= 0.01 * v21.Scale and v21.TargetScale or NumberUtil:Lerp(v21.Scale, v21.TargetScale, (math.min(v22 * 15, 1)));
                Frame.Size = UDim2.new(v21.Scale, 0, v21.Scale, 0);
                local ZoomAnchor = v21.ZoomAnchor;

                if ZoomAnchor and Scale > 0 then
                    local v25 = v21.Scale / Scale;
                    Position = UDim2.fromScale(ZoomAnchor.X - (ZoomAnchor.X - Position.X.Scale) * v25, ZoomAnchor.Y - (ZoomAnchor.Y - Position.Y.Scale) * v25);
                end;

                if v21.Scale == v21.TargetScale then
                    v21.ZoomAnchor = nil;
                    v24 = true;
                else
                    v24 = true;
                end;
            end;

            if v23 or v24 then
                local Delta2 = v21.Delta;
                local AbsoluteSize = p20.AbsoluteSize;
                local v26 = v24 and not v23 and 0 or 1;
                local v27, v28 = p19:ClampPosition(p20, Position.X.Scale + Delta2.X / AbsoluteSize.X * v26, Position.Y.Scale + Delta2.Y / AbsoluteSize.Y * v26, v21.Scale);
                Frame.Position = UDim2.new(v27, 0, v28, 0);
            end;
        end;

        v21.ZoomAnchor = nil;
        v21.Looping = false;
    end,

    ClearScrollFrame = function(p29: table, p30: userdata) -- Line: 150, Name: ClearScrollFrame
        -- upvalues: u1 (copy)
        local v31 = u1[p30];

        if not v31 then
            return;
        end;

        v31.Delta = Vector3.new();
        v31.Held = false;

        for _, v in pairs(v31.Connections) do
            v:Disconnect();
        end;

        u1[p30] = nil;
    end,

    GetZoomInfo = function(p32: table, p33: userdata) -- Line: 160, Name: GetZoomInfo
        -- upvalues: u1 (copy)
        return u1[p33];
    end,

    ClampPosition = function(p34: table, p35: userdata, p36: number, p37: number, p38: number) -- Line: 166, Name: ClampPosition
        -- upvalues: u1 (copy)
        local v39 = u1[p35];

        if v39 and v39.Clamp then
            return v39.Clamp(p36, p37, p38);
        end;

        local math_max_ret = math.max(p38 * 0.5 - 0.5, 0);

        return math.clamp(p36, 0.5 - math_max_ret, math_max_ret + 0.5), math.clamp(p37, 0.5 - math_max_ret, math_max_ret + 0.5);
    end
};