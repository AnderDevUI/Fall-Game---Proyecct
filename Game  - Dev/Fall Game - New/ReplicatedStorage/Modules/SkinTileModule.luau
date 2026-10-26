-- [PATH] ReplicatedStorage / Modules / SkinTileModule @Type ModuleScript


local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));

return {
    Populate = function(p1: userdata, p2: string, p3: boolean?) -- Line: 18, Name: Populate
        -- upvalues: SkinsModule (copy)
        local Frame = p1:FindFirstChild("Frame");

        if not Frame then
            return nil;
        end;

        local SkinInfo = SkinsModule:GetSkinInfo(p2);

        if type(SkinInfo) ~= "table" then
            warn((`[SkinTileModule] no skin info found for "{p2}"`));

            return nil;
        end;

        local v4, v5 = unpack(string.split(p2, "/"));
        local ItemImage = Frame:FindFirstChild("ItemImage");

        if ItemImage then
            ItemImage.Image = SkinInfo.Image;
        end;

        local SkinName = Frame:FindFirstChild("SkinName");

        if SkinName then
            SkinName.Text = v5;
        end;

        local ItemName = Frame:FindFirstChild("ItemName");

        if ItemName then
            if p3 then
                v4 = "● " .. v4;
            end;

            ItemName.Text = v4;
        end;

        return SkinInfo;
    end
};