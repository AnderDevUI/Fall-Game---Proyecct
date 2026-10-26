-- [PATH] ReplicatedStorage / CharacterScripts / ClanLeaderboardController @Type LocalScript


local LocalPlayer = game:GetService("Players").LocalPlayer;
local Leaderboard = game:GetService("ReplicatedStorage"):WaitForChild("ClientSignals"):WaitForChild("Leaderboard");
local Update = script:WaitForChild("Update");
local u1 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Inventory"):WaitForChild("Benches"):WaitForChild("Clan Table");
local u2 = {};

local function u7(p3) -- Line: 29
    -- upvalues: u1 (copy), u2 (ref), LocalPlayer (copy)
    local ScrollingFrame = u1:WaitForChild("ScrollingFrame");
    local t = ScrollingFrame:WaitForChild("t");
    local UIGridLayout = ScrollingFrame:WaitForChild("UIGridLayout");
    local math_ceil_ret = math.ceil(#u2 / 4);
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, math_ceil_ret * 1, 0);
    UIGridLayout.CellPadding = UDim2.new(0, 0, 0.05 / math_ceil_ret, 0);
    UIGridLayout.CellSize = UDim2.new(0.9, 0, 0.2 / math_ceil_ret, 0);
    local v4 = false;

    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "t" then
            child:Destroy();
        end;
    end;

    for i, v in pairs(u2) do
        local v5 = t:Clone();
        local v6 = v[1];

        if v6 then
            v6 = v6:GetAttribute("ClanTag");
        end;

        if v6 then
            v5.Name = i;
            v5.PositionLabel.Text = i;
            v5.ClanTag.Text = v6;
            v5.ClanName.Text = v[2];
            v5.ClanDecal.Image = "rbxassetid://" .. v[3];
            v5.Score.Text = v[4];
            v5.Visible = true;
            v5.Parent = ScrollingFrame;

            if v6 == LocalPlayer:GetAttribute("ClanTag") then
                local YourClan = u1.YourClan;
                YourClan.PositionLabel.Text = i;
                YourClan.ClanTag.Text = v6;
                YourClan.ClanName.Text = v[2];
                YourClan.ClanDecal.Image = "rbxassetid://" .. v[3];
                YourClan.Score.Text = v[4];
                v4 = true;
            end;
        end;
    end;

    u1.YourClan.Visible = v4;
    u1.NoClan.Visible = not v4;
end;

Leaderboard.OnClientEvent:Connect(function(p8) -- Line: 78
    -- upvalues: u2 (ref)
    u2 = p8;
end);
Update.Event:Connect(function(p9) -- Line: 82
    -- upvalues: u7 (copy)
    u7(p9);
end);

while true do
    u7();
    task.wait(15);
end;