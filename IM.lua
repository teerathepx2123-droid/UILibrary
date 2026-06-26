local v1 = game:GetService("HttpService")
local v2 = game:GetService("CoreGui")
local v3 = game:GetService("TweenService")
local v4 = game:GetService("UserInputService")
local v5 = game:GetService("Players")
local v6 = game:GetService("RunService")
local v7 = v5.LocalPlayer

local v8 = {} do
    v8.Folder = "FractureHub/Ui Config"
    v8.Settings = {
        Theme = "Obsidian",
        Acrylic = true,
        Transparency = false,
        MenuKeybind = "LeftControl",
        Font = "GothamSSm",
        Language = "English",
    }
    
    local v9 = {"GothamSSm", "Gotham", "Arial", "Code", "RobotoMono", "Ubuntu", "Nunito", "Merriweather", "Oswald", "SourceSansPro"}
    local v10 = {
        ["GothamSSm"] = "rbxasset://fonts/families/GothamSSm.json",
        ["Gotham"] = "rbxasset://fonts/families/Gotham.json",
        ["Arial"] = "rbxasset://fonts/families/Arial.json",
        ["Code"] = "rbxasset://fonts/families/Code.json",
        ["RobotoMono"] = "rbxasset://fonts/families/RobotoMono.json",
        ["Ubuntu"] = "rbxasset://fonts/families/Ubuntu.json",
        ["Nunito"] = "rbxasset://fonts/families/Nunito.json",
        ["Merriweather"] = "rbxasset://fonts/families/Merriweather.json",
        ["Oswald"] = "rbxasset://fonts/families/Oswald.json",
        ["SourceSansPro"] = "rbxasset://fonts/families/SourceSansPro.json",
    }
    local v11 = {"English", "Thai"}
    v8.Locales = {English = {}, ["Thai"] = {}}
    local v12 = {}

    function v8:Translate(v13)
        local v14 = self.Settings.Language or "English"
        local v15 = self.Locales[v14]
        return (v15 and v15[v13]) or (self.Locales.English and self.Locales.English[v13]) or v13
    end

    function v8:BuildFolderTree()
        if not isfolder("FractureHub") then makefolder("FractureHub") end
        if not isfolder(v8.Folder) then makefolder(v8.Folder) end
    end
    v8:BuildFolderTree()

    function v8:SaveSettings()
        writefile(v8.Folder .. "/options.json", v1:JSONEncode(v8.Settings))
    end

    function v8:LoadSettings()
        local path = v8.Folder .. "/options.json"
        if isfile(path) then
            local success, data = pcall(function() return v1:JSONDecode(readfile(path)) end)
            if success then
                for i, v in next, data do v8.Settings[i] = v end
            end
        end
    end
    v8:LoadSettings()

    function v8:ApplyFont(v23)
        local v24 = v10[v23] or v10["GothamSSm"]
        local hub = v2:FindFirstChild("Fracture Hub")
        if not hub then return end
        for _, obj in ipairs(hub:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                pcall(function() obj.FontFace = Font.new(v24, obj.FontFace.Weight, obj.FontFace.Style) end)
            end
        end
    end

    function v8:CreateFloatingButton()
        if v2:FindFirstChild("FractureScreenGui") then v2.FractureScreenGui:Destroy() end
        local gui = Instance.new("ScreenGui", v2)
        gui.Name = "FractureScreenGui"
        gui.ResetOnSpawn = false
        
        local container = Instance.new("Frame", gui)
        container.Name = "FractureFrame"
        container.Size = UDim2.fromOffset(55, 55)
        container.Position = UDim2.new(0.5, 0, 0.12, 0)
        container.AnchorPoint = Vector2.new(0.5, 0.5)
        container.BackgroundTransparency = 1
        
        local button = Instance.new("ImageButton", container)
        button.Name = "FractureButton"
        button.Size = UDim2.fromOffset(55, 55)
        button.Position = UDim2.new(0.5, 0, 0.5, 0)
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
        button.Image = "rbxassetid://83542549106889"
        button.ImageColor3 = Color3.fromRGB(220, 220, 220)
        button.ScaleType = Enum.ScaleType.Fit
        button.AutoButtonColor = false
        button.ZIndex = 1
        
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 18)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = Color3.fromRGB(45, 45, 48)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.3
        
        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        button.MouseEnter:Connect(function() v3:Create(button, ti, {Size = UDim2.fromOffset(60, 60)}):Play() end)
        button.MouseLeave:Connect(function() v3:Create(button, ti, {Size = UDim2.fromOffset(55, 55)}):Play() end)
        button.MouseButton1Down:Connect(function() v3:Create(button, ti, {Size = UDim2.fromOffset(50, 50)}):Play() end)
        button.MouseButton1Up:Connect(function() v3:Create(button, ti, {Size = UDim2.fromOffset(60, 60)}):Play() end)
        
        local drag, startPos, dragInput, startGuiPos, moved = false, nil, nil, nil, false
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag, startPos, startGuiPos, moved = true, input.Position, container.Position, false
                dragInput = input
            end
        end)
        v4.InputChanged:Connect(function(input)
            if drag and input == dragInput then
                local delta = input.Position - startPos
                if delta.Magnitude > 6 then moved = true end
                container.Position = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X, startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
            end
        end)
        v4.InputEnded:Connect(function(input) if input == dragInput then drag = false end end)
        button.MouseButton1Click:Connect(function() if not moved and self.Window then self.Window:Minimize() end end)
    end

    function v8:BuildInterfaceSection(v53)
        assert(self.Library, "Must set InterfaceManager.Library")
        local v54, v55 = self.Library, v8.Settings
        local section = v53:AddSection("Interface")
        
        section:AddDropdown("InterfaceTheme", {Title = "Select Theme", Values = v54.Themes, Default = v55.Theme, Callback = function(v) v54:SetTheme(v) v55.Theme = v v8:SaveSettings() end})
        section:AddToggle("TransparentToggle", {Title = "Transparency", Default = v55.Transparency, Callback = function(v) v54:ToggleTransparency(v) v55.Transparency = v v8:SaveSettings() end})
        section:AddDropdown("FontManager", {Title = "Select Font", Values = v9, Default = v55.Font, Callback = function(v) v55.Font = v v8:SaveSettings() v8:ApplyFont(v) end})
        
        local bind = section:AddKeybind("MenuKeybind", {Title = "Minimize Bind", Default = v55.MenuKeybind})
        bind:OnChanged(function() v55.MenuKeybind = bind.Value v8:SaveSettings() end)
        v54.MinimizeKeybind = bind
        
        section:AddDropdown("InterfaceLanguage", {Title = "Select Language", Values = v11, Default = v55.Language, Callback = function(v) v55.Language = v v8:SaveSettings() end})
        task.spawn(function() task.wait(1) v8:ApplyFont(v55.Font) end)
    end
end
return v8
