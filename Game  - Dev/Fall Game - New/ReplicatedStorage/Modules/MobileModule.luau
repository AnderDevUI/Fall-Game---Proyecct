-- [PATH] ReplicatedStorage / Modules / MobileModule @Type ModuleScript


local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");
local u1 = PlayerScripts:FindFirstChild("PreferredInputController") or PlayerScripts:WaitForChild("PreferredInputController", 5);
local u3 = {
    IsTouch = function() -- Line: 16, Name: IsTouch
        -- upvalues: u1 (copy)
        local v2;

        if u1 == nil then
            v2 = false;
        else
            v2 = u1:GetAttribute("PreferredInput") == "Touch";
        end;

        return v2;
    end
};

function u3.IsTouchOnly() -- Line: 22
    -- upvalues: u3 (copy), UserInputService (copy)
    local v4 = u3.IsTouch() and UserInputService.PreferredInput == Enum.PreferredInput.Touch;

    return v4;
end;

function u3.IsTouchDevice() -- Line: 27
    -- upvalues: u1 (copy)
    local v5;

    if u1 == nil then
        v5 = false;
    else
        v5 = u1:GetAttribute("IsTouchDevice") == true;
    end;

    return v5;
end;

return u3;