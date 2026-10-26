-- [PATH] ReplicatedStorage / Modules / Spring @Type ModuleScript


local u1 = {};

function u1.new(p2) -- Line: 42
    -- upvalues: u1 (copy)
    local v3 = p2 or 0;
    local v4 = {
        _damper = 1,
        _speed = 1,
        _time0 = tick(),
        _position0 = v3,
        _velocity0 = 0 * v3,
        _target = v3
    };

    return setmetatable(v4, u1);
end;

function u1.Impulse(p5, p6) -- Line: 57
    p5.Velocity = p5.Velocity + p6;
end;

function u1.TimeSkip(p7, p8) -- Line: 63
    local v9 = tick();
    local v10, v11 = p7:_positionVelocity(v9 + p8);
    p7._position0 = v10;
    p7._velocity0 = v11;
    p7._time0 = v9;
end;

function u1.__index(p12, p13) -- Line: 71
    -- upvalues: u1 (copy)
    if u1[p13] then
        return u1[p13];
    end;

    if p13 == "Value" or (p13 == "Position" or p13 == "p") then
        local v14, _ = p12:_positionVelocity(tick());

        return v14;
    end;

    if p13 == "Velocity" or p13 == "v" then
        local _, v15 = p12:_positionVelocity(tick());

        return v15;
    end;

    if p13 == "Target" or p13 == "t" then
        return p12._target;
    end;

    if p13 == "Damper" or p13 == "d" then
        return p12._damper;
    end;

    if p13 == "Speed" or p13 == "s" then
        return p12._speed;
    end;

    error(("%q is not a valid member of Spring"):format((tostring(p13))), 2);
end;

function u1.__newindex(p16, p17, p18) -- Line: 91
    local v19 = tick();

    if p17 == "Value" or (p17 == "Position" or p17 == "p") then
        local _, v20 = p16:_positionVelocity(v19);
        p16._position0 = p18;
        p16._velocity0 = v20;
    elseif p17 == "Velocity" or p17 == "v" then
        local v21, _ = p16:_positionVelocity(v19);
        p16._position0 = v21;
        p16._velocity0 = p18;
    elseif p17 == "Target" or p17 == "t" then
        local v22, v23 = p16:_positionVelocity(v19);
        p16._position0 = v22;
        p16._velocity0 = v23;
        p16._target = p18;
    elseif p17 == "Damper" or p17 == "d" then
        local v24, v25 = p16:_positionVelocity(v19);
        p16._position0 = v24;
        p16._velocity0 = v25;
        p16._damper = math.clamp(p18, 0, 1);
    elseif p17 == "Speed" or p17 == "s" then
        local v26, v27 = p16:_positionVelocity(v19);
        p16._position0 = v26;
        p16._velocity0 = v27;
        p16._speed = math.max(p18, 0);
    else
        error(("%q is not a valid member of Spring"):format((tostring(p17))), 2);
    end;

    p16._time0 = v19;
end;

function u1._positionVelocity(p28, p29) -- Line: 124
    local _position0 = p28._position0;
    local _velocity0 = p28._velocity0;
    local _target = p28._target;
    local _damper = p28._damper;
    local _speed = p28._speed;
    local v30 = _speed * (p29 - p28._time0);
    local v31 = _damper * _damper;
    local v32, v33, v34;

    if v31 < 1 then
        v32 = math.sqrt(1 - v31);
        local v35 = math.exp(-_damper * v30) / v32;
        v33 = v35 * math.cos(v32 * v30);
        v34 = v35 * math.sin(v32 * v30);
    elseif v31 == 1 then
        v32 = 1;
        v33 = math.exp(-_damper * v30) / v32;
        v34 = v33 * v30;
    else
        v32 = math.sqrt(v31 - 1);
        local v36 = math.exp((-_damper + v32) * v30) / (2 * v32);
        local v37 = math.exp((-_damper - v32) * v30) / (2 * v32);
        v33 = v36 + v37;
        v34 = v36 - v37;
    end;

    return (v32 * v33 + _damper * v34) * _position0 + (1 - (v32 * v33 + _damper * v34)) * _target + v34 / _speed * _velocity0, -_speed * v34 * _position0 + _speed * v34 * _target + (v32 * v33 - _damper * v34) * _velocity0;
end;

return u1;