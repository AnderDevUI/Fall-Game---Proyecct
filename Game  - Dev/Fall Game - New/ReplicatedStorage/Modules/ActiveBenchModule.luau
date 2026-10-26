-- [PATH] ReplicatedStorage / Modules / ActiveBenchModule @Type ModuleScript


local CollectionService = game:GetService("CollectionService");
local u1 = {
    ActiveBenches = {}
};

function u1.SetServClientInfo(p2: table) -- Line: 31
    -- upvalues: u1 (copy)
    local BenchTag = p2.BenchTag;

    if not BenchTag then
        return;
    end;

    u1.ActiveBenches[BenchTag] = p2.Info;
end;

function u1.SetServClientInfos(p3: table) -- Line: 39
    -- upvalues: u1 (copy)
    for _, v in p3 do
        u1.SetServClientInfo(v);
    end;
end;

function u1.GetClientInfo(p4: userdata) -- Line: 46
    -- upvalues: u1 (copy)
    local ModelTag = u1.GetModelTag(p4);

    if ModelTag then
        return u1.GetClientInfoFromTag(ModelTag);
    end;
end;

function u1.GetClientInfoFromTag(p5: string) -- Line: 54
    -- upvalues: u1 (copy)
    return u1.ActiveBenches[p5];
end;

function u1.GetModelTag(p6: userdata) -- Line: 61
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTags(p6) do
        if #v == 36 then
            return v;
        end;
    end;
end;

function u1.GetModelFromTag(p7: string) -- Line: 70
    -- upvalues: CollectionService (copy)
    return CollectionService:GetTagged(p7)[1];
end;

function u1.GetAllClientInfos() -- Line: 76
    -- upvalues: u1 (copy)
    local v8 = {};

    for i, v in u1.ActiveBenches do
        local Model = v.Model;

        if not (Model and Model.Parent) then
            Model = u1.GetModelFromTag(i);
            v.Model = Model;
        end;

        if Model and Model.Parent then
            v8[Model] = v;
        end;
    end;

    return v8;
end;

function u1.GetAllRawClientInfos() -- Line: 92
    -- upvalues: u1 (copy)
    return u1.ActiveBenches;
end;

function u1.RemoveClientInfo(p9: string) -- Line: 97
    -- upvalues: u1 (copy)
    u1.ActiveBenches[p9] = nil;
end;

return u1;