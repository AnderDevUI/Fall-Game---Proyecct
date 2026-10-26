-- [PATH] ReplicatedStorage / CharacterScripts / AutoTurretController @Type LocalScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Bases = workspace:WaitForChild("Bases");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local LocalPlayer = game.Players.LocalPlayer;
local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local HumanoidRootPart = v1:WaitForChild("HumanoidRootPart");
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local u2 = {};
local u3 = {};

local function CalculateStepsWait(p4) -- Line: 44
    local v5 = p4 + 1;

    if v5 >= 5 then
        task.wait();
        v5 = 1;
    end;

    return v5;
end;

local function StartTurretTraceLoop(p6) -- Line: 53
    -- upvalues: u3 (copy), u2 (copy), Players (copy)
    if u3[p6] then
        return;
    end;

    if not u2[p6] then
        warn("[AutoTurretController] - StartTurretTraceLoop ran without turret model in nearby turrets");

        return;
    end;

    u3[p6] = true;

    if u2[p6][2] ~= nil then
        u2[p6][2]:Stop();
    end;

    local MotorPart = p6:FindFirstChild("MotorPart");
    local v7;

    if MotorPart then
        v7 = MotorPart:FindFirstChild("Motor6D");
    else
        v7 = MotorPart;
    end;

    local Top = p6:FindFirstChild("Top");

    while p6 and (p6:FindFirstChild("Main") and (MotorPart and (v7 and (Top and p6:GetAttribute("S") ~= nil)))) do
        task.wait(0.2);
        local v8 = p6:GetAttribute("S") and Players:FindFirstChild(p6:GetAttribute("S"));

        if v8 then
            v8 = v8.Character;
        end;

        if v8 then
            v8 = v8:FindFirstChild("HumanoidRootPart");
        end;

        if v8 and (Top and v7) then
            local v9 = v7.Part0.CFrame * v7.C0;
            local v10 = v8.Position - v9.Position;

            if v10.Magnitude >= 0.01 and math.abs(v10.Unit.Y) <= 0.999 then
                local CFrame_lookAt_ret = CFrame.lookAt(v9.Position, v8.Position);
                v7.C1 = CFrame.new(0, -0.7, -0.1) * CFrame.Angles(0, -1.5707963267948966, 0) * CFrame_lookAt_ret:Inverse().Rotation * v9.Rotation;
            end;
        end;
    end;

    u3[p6] = false;

    if v7 then
        v7.C1 = CFrame.new(0, -0.7, -0.1);
    end;
end;

while v1 and v1:FindFirstChild("HumanoidRootPart") do
    task.wait(6);
    local v11 = 1;

    if not (v1 and (v1.Parent and v1.PrimaryPart)) then
        break;
    end;

    for _, child in Bases:GetChildren() do
        if child:FindFirstChild("Auto Turret") then
            for _, child2 in child:FindFirstChild("Auto Turret"):GetChildren() do
                local Main = child2:FindFirstChild("Main");
                local Animation = child2:FindFirstChild("Animation");
                local AnimationController = child2:FindFirstChild("AnimationController");

                if child2.Name == "Auto Turret" and (Main and (Animation and (AnimationController and (NumberUtil:IsWithin(Main.Position, v1.HumanoidRootPart.Position, 300) and u2[child2] == nil)))) then
                    u2[child2] = { child2.AttributeChanged:Connect(function(p12) -- Line: 113
                            -- upvalues: child2 (copy), StartTurretTraceLoop (copy)
                            if child2:GetAttribute("S") then
                                StartTurretTraceLoop(child2);
                            end;
                        end), AnimationController:LoadAnimation(Animation) };
                end;

                v11 = v11 + 1;

                if v11 >= 5 then
                    task.wait();
                    v11 = 1;
                end;
            end;

            v11 = v11 + 1;

            if v11 >= 5 then
                task.wait();
                v11 = 1;
            end;
        end;
    end;

    for i, v in u2 do
        if i and (i:FindFirstChild("Main") and NumberUtil:IsWithin(i.Main.Position, HumanoidRootPart.Position, 300)) then
            if i and not (i:GetAttribute("S") or (not v[2] or v[2].IsPlaying)) then
                local Top = i:FindFirstChild("Top");

                if Top then
                    Top = Top:FindFirstChild("Laser");
                end;

                if Top and Top.Enabled then
                    v[2]:Play();
                end;
            end;
        else
            u3[i] = nil;

            if v[1] then
                v[1]:Disconnect();
            end;

            if v[2] then
                v[2]:Stop();
            end;

            u2[i] = nil;
        end;

        v11 = v11 + 1;

        if v11 >= 5 then
            task.wait();
            v11 = 1;
        end;
    end;
end;