-- [PATH] ReplicatedStorage / Modules / CameraShakeModule @Type ModuleScript


local u1 = {};
u1.__index = u1;
local debug_profilebegin = debug.profilebegin;
local debug_profileend = debug.profileend;
local CFrame_new = CFrame.new;
local CFrame_Angles = CFrame.Angles;
local math_rad = math.rad;
local Vector3_new_ret = Vector3.new();
local script_CameraShakeInstance = require(script.CameraShakeInstance);
local CameraShakeState = script_CameraShakeInstance.CameraShakeState;
u1.CameraShakeInstance = script_CameraShakeInstance;
u1.Presets = require(script.CameraShakePresets);

function u1.new(p2, p3) -- Line: 75
    -- upvalues: Vector3_new_ret (copy), u1 (copy)
    local v4 = type(p2) == "number";
    assert(v4, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)");
    local v5 = type(p3) == "function";
    assert(v5, "Callback must be a function");

    return setmetatable({
        _running = false,
        _renderName = "CameraShaker",
        _renderPriority = p2,
        _posAddShake = Vector3_new_ret,
        _rotAddShake = Vector3_new_ret,
        _camShakeInstances = {},
        _removeInstances = {},
        _callback = p3
    }, u1);
end;

function u1.Start(u6) -- Line: 96
    -- upvalues: debug_profilebegin (copy), debug_profileend (copy)
    if u6._running then
        return;
    end;

    u6._running = true;
    local _callback = u6._callback;
    game:GetService("RunService"):BindToRenderStep(u6._renderName, u6._renderPriority, function(p7) -- Line: 100
        -- upvalues: debug_profilebegin (ref), u6 (copy), debug_profileend (ref), _callback (copy)
        debug_profilebegin("CameraShakerUpdate");
        local v8 = u6:Update(p7);
        debug_profileend();
        _callback(v8);
    end);
end;

function u1.Stop(p9) -- Line: 109
    if not p9._running then
        return;
    end;

    game:GetService("RunService"):UnbindFromRenderStep(p9._renderName);
    p9._running = false;
end;

function u1.Update(p10, p11) -- Line: 116
    -- upvalues: Vector3_new_ret (copy), CameraShakeState (copy), CFrame_new (copy), CFrame_Angles (copy), math_rad (copy)
    local v12 = Vector3_new_ret;
    local v13 = Vector3_new_ret;
    local _camShakeInstances = p10._camShakeInstances;

    for i = 1, #_camShakeInstances do
        local v14 = _camShakeInstances[i];
        local State = v14:GetState();
        local v15;

        if State == CameraShakeState.Inactive and v14.DeleteOnInactive then
            p10._removeInstances[#p10._removeInstances + 1] = i;
            v15 = i;
        elseif State == CameraShakeState.Inactive then
            v15 = i;
        else
            v12 = v12 + v14:UpdateShake(p11) * v14.PositionInfluence;
            v13 = v13 + v14:UpdateShake(p11) * v14.RotationInfluence;
            v15 = i;
        end;
    end;

    for i = #p10._removeInstances, 1, -1 do
        table.remove(_camShakeInstances, p10._removeInstances[i]);
        p10._removeInstances[i] = nil;
        local _ = i;
    end;

    return CFrame_new(v12) * CFrame_Angles(0, math_rad(v13.Y), 0) * CFrame_Angles(math_rad(v13.X), 0, (math_rad(v13.Z)));
end;

function u1.Shake(p16, p17) -- Line: 152
    local v18;

    if type(p17) == "table" then
        v18 = p17._camShakeInstance;
    else
        v18 = false;
    end;

    assert(v18, "ShakeInstance must be of type CameraShakeInstance");
    p16._camShakeInstances[#p16._camShakeInstances + 1] = p17;

    return p17;
end;

function u1.ShakeSustain(p19, p20) -- Line: 159
    local v21;

    if type(p20) == "table" then
        v21 = p20._camShakeInstance;
    else
        v21 = false;
    end;

    assert(v21, "ShakeInstance must be of type CameraShakeInstance");
    p19._camShakeInstances[#p19._camShakeInstances + 1] = p20;
    p20:StartFadeIn(p20.fadeInDuration);

    return p20;
end;

function u1.ShakeOnce(p22, p23, p24, p25, p26, p27, p28) -- Line: 167
    -- upvalues: script_CameraShakeInstance (copy)
    local v29 = script_CameraShakeInstance.new(p23, p24, p25, p26);
    v29.PositionInfluence = typeof(p27) == "Vector3" and p27 and p27 or Vector3.new(0.15, 0.15, 0.15);
    v29.RotationInfluence = typeof(p28) == "Vector3" and p28 and p28 or Vector3.new(1, 1, 1);
    p22._camShakeInstances[#p22._camShakeInstances + 1] = v29;

    return v29;
end;

function u1.StartShake(p30, p31, p32, p33, p34, p35) -- Line: 176
    -- upvalues: script_CameraShakeInstance (copy)
    local v36 = script_CameraShakeInstance.new(p31, p32, p33);
    v36.PositionInfluence = typeof(p34) == "Vector3" and p34 and p34 or Vector3.new(0.15, 0.15, 0.15);
    v36.RotationInfluence = typeof(p35) == "Vector3" and p35 and p35 or Vector3.new(1, 1, 1);
    v36:StartFadeIn(p33);
    p30._camShakeInstances[#p30._camShakeInstances + 1] = v36;

    return v36;
end;

return u1;