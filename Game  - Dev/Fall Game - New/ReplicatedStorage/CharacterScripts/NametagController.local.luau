-- [PATH] ReplicatedStorage / CharacterScripts / NametagController @Type LocalScript


local Players = game:GetService("Players");
local v1 = { workspace:WaitForChild("Bases"), workspace:WaitForChild("Monuments") };
local os_clock_ret = os.clock();
local os_clock_ret2 = os.clock();
local v2 = {};

while true do
    if os.clock() - os_clock_ret >= 2 then
        os_clock_ret = os.clock();

        for i, v in v2 do
            if v and (v.Character and v.Character:FindFirstChild("HumanoidRootPart")) then
                local HumanoidRootPart = v.Character.HumanoidRootPart;
                local RaycastParams_new_ret = RaycastParams.new();
                RaycastParams_new_ret.FilterDescendantsInstances = v1;
                RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
                RaycastParams_new_ret.IgnoreWater = true;
                RaycastParams_new_ret.RespectCanCollide = true;
                workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, 3.1, 0), RaycastParams_new_ret);
                task.wait();
            else
                v2[i] = nil;
            end;
        end;
    end;

    if os.clock() - os_clock_ret2 >= 8 then
        os_clock_ret2 = os.clock();
        v2 = {};

        for _, child in Players:GetChildren() do
            table.insert(v2, child);
            task.wait();
        end;
    end;

    task.wait(0.15);
end;