-- [PATH] ReplicatedStorage / Modules / MilitaryState @Type ModuleScript


local v1 = {
    Entries = {}
};
local BindableEvent = Instance.new("BindableEvent");
v1.BossSpawned = BindableEvent.Event;

function v1.FireBossSpawned(p2) -- Line: 15
    -- upvalues: BindableEvent (copy)
    BindableEvent:Fire(p2);
end;

return v1;