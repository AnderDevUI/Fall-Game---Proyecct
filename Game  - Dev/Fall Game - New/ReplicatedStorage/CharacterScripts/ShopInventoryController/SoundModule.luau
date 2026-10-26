-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / SoundModule @Type ModuleScript


local LocalSounds = game:GetService("ReplicatedStorage"):WaitForChild("LocalSounds");

return {
    PlaySound = function(p1) -- Line: 13
        -- upvalues: LocalSounds (copy)
        local v2 = LocalSounds:FindFirstChild(p1);

        if v2 then
            v2:Play();
        end;
    end
};