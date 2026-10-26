-- [PATH] ServerScriptService / Library / TestLibrary @Type ModuleScript


local TestService = game:GetService("TestService");
local RunService = game:GetService("RunService");

return {
    GetTestAttribute = function(p1, p2) -- Line: 7, Name: GetTestAttribute
        -- upvalues: RunService (copy), TestService (copy)
        if not RunService:IsStudio() then
            return nil;
        end;

        local v3;

        while true do
            v3 = TestService:GetAttribute(p2);

            if v3 ~= nil then
                break;
            end;

            warn("TestService attribute not found, waiting for", p2);
            wait(1);
        end;

        if v3 == "" then
            return nil;
        end;

        return v3;
    end
};