-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / ShopUIModule / CapsRowsModule @Type ModuleScript


local u1 = false;

return {
    Init = function(u2: userdata) -- Line: 13
        -- upvalues: u1 (ref)
        if u1 then
            return;
        end;

        u1 = true;
        local u3 = {};

        local function Track(p4: userdata) -- Line: 18
            -- upvalues: u3 (copy)
            if p4:IsA("GuiObject") and (p4.Size.Y.Scale == 0 and p4.Size.Y.Offset > 0) then
                u3[p4] = p4.Size.Y.Offset;
            end;
        end;

        local u5 = {};

        for _, child in ipairs(u2:GetChildren()) do
            if child:IsA("GuiObject") and (child.Size.Y.Scale == 0 and child.Size.Y.Offset > 0) then
                u3[child] = child.Size.Y.Offset;
            end;

            local v6 = child:FindFirstChildOfClass("UIListLayout");

            if u3[child] and v6 then
                u5[child] = v6;

                for _, child2 in ipairs(child:GetChildren()) do
                    if child2:IsA("GuiObject") and (child2.Size.Y.Scale == 0 and child2.Size.Y.Offset > 0) then
                        u3[child2] = child2.Size.Y.Offset;
                    end;
                end;
            end;
        end;

        local function Apply() -- Line: 31
            -- upvalues: u2 (copy), u3 (copy), u5 (copy)
            local X = u2.AbsoluteSize.X;

            if X <= 0 then
                return;
            end;

            local v7 = X / 1311;

            for i, v in pairs(u3) do
                if not u5[i] then
                    i.Size = UDim2.new(i.Size.X, UDim.new(0, (math.round(v * v7))));
                end;
            end;

            for i, v in pairs(u5) do
                local v8 = i;
                local v9 = 0;
                local v10 = 0;

                for _, child in ipairs(i:GetChildren()) do
                    if u3[child] and child.Visible then
                        v9 = v9 + child.Size.Y.Offset;
                        v10 = v10 + 1;
                    end;
                end;

                v8.Size = UDim2.new(v8.Size.X, UDim.new(0, v9 + v.Padding.Offset * math.max(v10 - 1, 0)));
            end;
        end;

        u2:GetPropertyChangedSignal("AbsoluteSize"):Connect(Apply);
        Apply();
    end
};