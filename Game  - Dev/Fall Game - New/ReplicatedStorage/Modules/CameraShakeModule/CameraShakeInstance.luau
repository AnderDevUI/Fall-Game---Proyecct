-- [PATH] ReplicatedStorage / Modules / CameraShakeModule / CameraShakeInstance @Type ModuleScript


local u1 = {};
u1.__index = u1;
local Vector3_new = Vector3.new;
local math_noise = math.noise;
u1.CameraShakeState = {
    FadingIn = 0,
    FadingOut = 1,
    Sustained = 2,
    Inactive = 3
};

function u1.new(p2, p3, p4, p5) -- Line: 30
    -- upvalues: Vector3_new (copy), u1 (copy)
    local v6 = p4 == nil and 0 or p4;
    local v7 = p5 == nil and 0 or p5;
    local v8 = type(p2) == "number";
    assert(v8, "Magnitude must be a number");
    local v9 = type(p3) == "number";
    assert(v9, "Roughness must be a number");
    local v10 = type(v6) == "number";
    assert(v10, "FadeInTime must be a number");
    local v11 = type(v7) == "number";
    assert(v11, "FadeOutTime must be a number");
    local v12 = {
        DeleteOnInactive = true,
        roughMod = 1,
        magnMod = 1,
        _camShakeInstance = true,
        Magnitude = p2,
        Roughness = p3,
        PositionInfluence = Vector3_new(),
        RotationInfluence = Vector3_new(),
        fadeOutDuration = v7,
        fadeInDuration = v6,
        sustain = v6 > 0,
        currentFadeTime = v6 > 0 and 0 or 1,
        tick = Random.new():NextNumber(-100, 100)
    };

    return setmetatable(v12, u1);
end;

function u1.UpdateShake(p13, p14) -- Line: 61
    -- upvalues: math_noise (copy), Vector3_new (copy)
    local tick = p13.tick;
    local currentFadeTime = p13.currentFadeTime;
    local v15 = Vector3_new(math_noise(tick, 0) * 0.5, math_noise(0, tick) * 0.5, math_noise(tick, tick) * 0.5);

    if p13.fadeInDuration > 0 and p13.sustain then
        if currentFadeTime < 1 then
            currentFadeTime = currentFadeTime + p14 / p13.fadeInDuration;
        elseif p13.fadeOutDuration > 0 then
            p13.sustain = false;
        end;
    end;

    if not p13.sustain then
        currentFadeTime = currentFadeTime - p14 / p13.fadeOutDuration;
    end;

    if p13.sustain then
        p13.tick = tick + p14 * p13.Roughness * p13.roughMod;
    else
        p13.tick = tick + p14 * p13.Roughness * p13.roughMod * currentFadeTime;
    end;

    p13.currentFadeTime = currentFadeTime;

    return v15 * p13.Magnitude * p13.magnMod * currentFadeTime;
end;

function u1.StartFadeOut(p16, p17) -- Line: 97
    if p17 == 0 then
        p16.currentFadeTime = 0;
    end;

    p16.fadeOutDuration = p17;
    p16.fadeInDuration = 0;
    p16.sustain = false;
end;

function u1.StartFadeIn(p18, p19) -- Line: 107
    if p19 == 0 then
        p18.currentFadeTime = 1;
    end;

    p18.fadeInDuration = p19 or p18.fadeInDuration;
    p18.fadeOutDuration = 0;
    p18.sustain = true;
end;

function u1.GetScaleRoughness(p20) -- Line: 117
    return p20.roughMod;
end;

function u1.SetScaleRoughness(p21, p22) -- Line: 122
    p21.roughMod = p22;
end;

function u1.GetScaleMagnitude(p23) -- Line: 127
    return p23.magnMod;
end;

function u1.SetScaleMagnitude(p24, p25) -- Line: 132
    p24.magnMod = p25;
end;

function u1.GetNormalizedFadeTime(p26) -- Line: 137
    return p26.currentFadeTime;
end;

function u1.IsShaking(p27) -- Line: 142
    return p27.currentFadeTime > 0 and true or p27.sustain;
end;

function u1.IsFadingOut(p28) -- Line: 147
    return not p28.sustain and p28.currentFadeTime > 0;
end;

function u1.IsFadingIn(p29) -- Line: 152
    local v30;

    if p29.currentFadeTime < 1 then
        v30 = p29.sustain and p29.fadeInDuration > 0;
    else
        v30 = false;
    end;

    return v30;
end;

function u1.GetState(p31) -- Line: 157
    -- upvalues: u1 (copy)
    if p31:IsFadingIn() then
        return u1.CameraShakeState.FadingIn;
    end;

    if p31:IsFadingOut() then
        return u1.CameraShakeState.FadingOut;
    end;

    if p31:IsShaking() then
        return u1.CameraShakeState.Sustained;
    end;

    return u1.CameraShakeState.Inactive;
end;

return u1;