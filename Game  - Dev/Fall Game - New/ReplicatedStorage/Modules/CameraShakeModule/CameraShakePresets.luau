-- [PATH] ReplicatedStorage / Modules / CameraShakeModule / CameraShakePresets @Type ModuleScript


local CameraShakeInstance = require(script.Parent.CameraShakeInstance);
local u8 = {
    Bump = function() -- Line: 28, Name: Bump
        -- upvalues: CameraShakeInstance (copy)
        local v1 = CameraShakeInstance.new(2.5, 4, 0.1, 0.75);
        v1.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
        v1.RotationInfluence = Vector3.new(1, 1, 1);

        return v1;
    end,

    Explosion = function() -- Line: 38, Name: Explosion
        -- upvalues: CameraShakeInstance (copy)
        local v2 = CameraShakeInstance.new(5, 10, 0, 1.5);
        v2.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v2.RotationInfluence = Vector3.new(4, 1, 1);

        return v2;
    end,

    Earthquake = function() -- Line: 48, Name: Earthquake
        -- upvalues: CameraShakeInstance (copy)
        local v3 = CameraShakeInstance.new(0.6, 3.5, 2, 10);
        v3.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v3.RotationInfluence = Vector3.new(1, 1, 4);

        return v3;
    end,

    BadTrip = function() -- Line: 58, Name: BadTrip
        -- upvalues: CameraShakeInstance (copy)
        local v4 = CameraShakeInstance.new(10, 0.15, 5, 10);
        v4.PositionInfluence = Vector3.new(0, 0, 0.15);
        v4.RotationInfluence = Vector3.new(2, 1, 4);

        return v4;
    end,

    HandheldCamera = function() -- Line: 68, Name: HandheldCamera
        -- upvalues: CameraShakeInstance (copy)
        local v5 = CameraShakeInstance.new(1, 0.25, 5, 10);
        v5.PositionInfluence = Vector3.new(0, 0, 0);
        v5.RotationInfluence = Vector3.new(1, 0.5, 0.5);

        return v5;
    end,

    Vibration = function() -- Line: 78, Name: Vibration
        -- upvalues: CameraShakeInstance (copy)
        local v6 = CameraShakeInstance.new(0.4, 20, 2, 2);
        v6.PositionInfluence = Vector3.new(0, 0.15, 0);
        v6.RotationInfluence = Vector3.new(1.25, 0, 4);

        return v6;
    end,

    RoughDriving = function() -- Line: 88, Name: RoughDriving
        -- upvalues: CameraShakeInstance (copy)
        local v7 = CameraShakeInstance.new(1, 2, 1, 1);
        v7.PositionInfluence = Vector3.new(0, 0, 0);
        v7.RotationInfluence = Vector3.new(1, 1, 1);

        return v7;
    end
};

return setmetatable({}, {
    __index = function(p9, p10) -- Line: 100, Name: __index
        -- upvalues: u8 (copy)
        local v11 = u8[p10];

        if type(v11) == "function" then
            return v11();
        end;

        error("No preset found with index \"" .. p10 .. "\"");
    end
});