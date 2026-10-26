-- [PATH] ReplicatedStorage / Modules / SkinTagModule @Type ModuleScript


local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local Color3_fromRGB_ret = Color3.fromRGB(255, 150, 2);
local u5 = {
    GetTags = function(p1: string) -- Line: 16, Name: GetTags
        -- upvalues: SkinsModule (copy)
        local SkinInfo = SkinsModule:GetSkinInfo(p1);

        if not SkinInfo then
            return nil;
        end;

        local string_split_ret = string.split(p1, "/");
        local Info = SkinInfo.Info;
        local v2 = {
            ItemName = string_split_ret[1],
            SkinName = string_split_ret[2]
        };
        local v3;

        if type(Info) == "table" then
            v3 = Info[6] or nil;
        else
            v3 = nil;
        end;

        v2.Bundle = v3;
        local v4;

        if type(Info) == "table" then
            v4 = Info[7] or nil;
        else
            v4 = nil;
        end;

        v2.Descriptions = v4;

        return v2;
    end
};

function u5.ApplyToFrame(p6: userdata, p7: string) -- Line: 32
    -- upvalues: u5 (copy), Color3_fromRGB_ret (copy)
    local Tags = u5.GetTags(p7);

    if not Tags then
        return;
    end;

    p6.ItemName.Text = Tags.ItemName;
    p6.SkinName.Text = Tags.SkinName;
    local Bundle = p6:FindFirstChild("Bundle");

    if not Bundle then
        Bundle = p6.ItemName:Clone();
        Bundle.LayoutOrder = 3;
        Bundle.Name = "Bundle";
        Bundle.TextColor3 = Color3_fromRGB_ret;
        Bundle.Parent = p6;
    end;

    if Tags.Bundle then
        Bundle.Text = `{Tags.Bundle} Bundle`;
        Bundle.Visible = true;
    else
        Bundle.Visible = false;
    end;

    for _, child in p6:GetChildren() do
        if child.Name:match("^_") then
            child:Destroy();
        end;
    end;

    if Tags.Descriptions then
        for i, v in Tags.Descriptions do
            local v8 = p6.Template:Clone();
            v8.LayoutOrder = 3 + i;
            v8.Name = `_Desc{i}`;
            v8.Text = `● {v}`;
            v8.Parent = p6;
            v8.Visible = true;
        end;
    end;

    p6.Template.Visible = false;
end;

function u5.ApplyLabelsToFrame(p9: userdata, p10: string) -- Line: 77
    -- upvalues: u5 (copy), Color3_fromRGB_ret (copy)
    local Tags = u5.GetTags(p10);

    if not Tags then
        return;
    end;

    for _, child in p9:GetChildren() do
        if child.Name:match("^_") then
            child:Destroy();
        end;
    end;

    local v11 = 0;

    if Tags.Bundle then
        local v12 = p9.Template:Clone();
        v11 = v11 + 1;
        v12.LayoutOrder = v11;
        v12.Name = "_Bundle";
        v12.TextColor3 = Color3_fromRGB_ret;
        v12.Text = `{Tags.Bundle} Bundle`;
        v12.Parent = p9;
        v12.Visible = true;
    end;

    if Tags.Descriptions then
        for i, v in Tags.Descriptions do
            local v13 = p9.Template:Clone();
            v11 = v11 + 1;
            v13.LayoutOrder = v11;
            v13.Name = `_Desc{i}`;
            v13.Text = `● {v}`;
            v13.Parent = p9;
            v13.Visible = true;
        end;
    end;

    p9.Template.Visible = false;
end;

return u5;