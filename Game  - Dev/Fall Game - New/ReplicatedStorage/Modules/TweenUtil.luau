-- [PATH] ReplicatedStorage / Modules / TweenUtil @Type ModuleScript


local TweenService = game:GetService("TweenService");

return {
    Tween = function(p1: table, p2: userdata, p3: any, p4: any, p5: number?, p6: string?, p7: string?, p8: boolean?) -- Line: 13, Name: Tween
        -- upvalues: TweenService (copy)
        local TweenInfo_new_ret = TweenInfo.new(p5, Enum.EasingStyle[p6 or "Quad"], Enum.EasingDirection[p7 or "Out"]);
        local v9 = type(p4) == "table" and p4 and p4 or { p4 };
        local v10 = {};

        for i, v in pairs(type(p3) == "table" and p3 and p3 or { p3 }) do
            v10[v] = v9[i];
        end;

        local v11 = TweenService:Create(p2, TweenInfo_new_ret, v10);

        if not p8 then
            v11:Play();
        end;

        return v11;
    end
};