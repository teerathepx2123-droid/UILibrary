local v1 = game:GetService("HttpService")
local v2 = game:GetService("CoreGui")
local v3 = game:GetService("TweenService")
local v4 = game:GetService("UserInputService")
local v5 = game:GetService("Players")
local v6 = game:GetService("RunService")
local v7 = v5.LocalPlayer
local v8 = {} do
    v8.Folder = "FractureHub"
    v8.Settings = {
        Theme = "Obsidian",
        Acrylic = true,
        Transparency = false,
        MenuKeybind = "LeftControl",
        Font = "GothamSSm",
        Language = "English",
    }
    local v9 = {
        "GothamSSm",
        "Gotham",
        "Arial",
        "Code",
        "RobotoMono",
        "Ubuntu",
        "Nunito",
        "Merriweather",
        "Oswald",
        "SourceSansPro",
    }
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
    local v11 = {
        "English",
        "Thai",
    }
    v8.Locales = {
        English = {},
        ["Thai"] = {},
    }
    local v12 = {}
    function v8:Translate(v13)
        local v14 = self.Settings.Language or "English"
        local v15 = self.Locales[v14]
        if v15 and v15[v13] then
            return v15[v13]
        end
        local v16 = self.Locales.English
        return (v16 and v16[v13]) or v13
    end
    function v8:Register(v17, v18, v19)
        if not v17 or not v18 then return end
        if v19 and not self.Locales.English[v18] then
            self.Locales.English[v18] = v19
        end
        table.insert(v12, {Control = v17, Key = v18})
        pcall(function()
            v17:SetTitle(self:Translate(v18))
        end)
        return v17
    end
    function v8:ApplyLanguage(v20)
        self.Settings.Language = v20
        for v21, v22 in ipairs(v12) do
            pcall(function()
                v22.Control:SetTitle(self:Translate(v22.Key))
            end)
        end
        self:SaveSettings()
    end
    function v8:ApplyFont(v23)
        local v24 = v10[v23] or v10["GothamSSm"]
        local v25 = v2:FindFirstChild("Fracture Hub")
        if not v25 then return end
        for v26, v27 in ipairs(v25:GetDescendants()) do
            if v27:IsA("TextLabel") or v27:IsA("TextButton") or v27:IsA("TextBox") then
                pcall(function()
                    v27.FontFace = Font.new(v24, v27.FontFace.Weight, v27.FontFace.Style)
                end)
            end
        end
    end
    function v8:SetFolder(v28)
        self.Folder = v28
        self:BuildFolderTree()
    end
    function v8:SetLibrary(v29)
        self.Library = v29
    end
    function v8:BuildFolderTree()
        local v30 = {}
        local v31 = self.Folder:split("/")
        for v32 = 1, #v31 do
            v30[#v30 + 1] = table.concat(v31, "/", 1, v32)
        end
        table.insert(v30, self.Folder)
        table.insert(v30, self.Folder .. "/settings")
        for v33 = 1, #v30 do
            local v34 = v30[v33]
            if not isfolder(v34) then makefolder(v34) end
        end
    end
    function v8:SaveSettings()
        writefile(self.Folder .. "/options.json", v1:JSONEncode(v8.Settings))
    end
    function v8:LoadSettings()
        local v35 = self.Folder .. "/options.json"
        if isfile(v35) then
            local v36 = readfile(v35)
            local v37, v38 = pcall(v1.JSONDecode, v1, v36)
            if v37 then
                for v39, v40 in next, v38 do
                    v8.Settings[v39] = v40
                end
            end
        end
    end
    function v8:CreateFloatingButton()
        if v2:FindFirstChild("FractureScreenGui") then
            v2.FractureScreenGui:Destroy()
        end
        local x99 = Instance.new("ScreenGui", v2)
        x99.Name = "FractureScreenGui"
        x99.ResetOnSpawn = false
        local y88 = Instance.new("Frame", x99)
        y88.Name = "FractureFrame"
        y88.Size = UDim2.fromOffset(55, 55)
        y88.Position = UDim2.new(0.5, 0, 0.12, 0)
        y88.AnchorPoint = Vector2.new(0.5, 0.5)
        y88.BackgroundTransparency = 1
        local z77 = Instance.new("ImageButton", y88)
        z77.Name = "FractureButton"
        z77.Size = UDim2.fromOffset(55, 55)
        z77.Position = UDim2.new(0.5, 0, 0.5, 0)
        z77.AnchorPoint = Vector2.new(0.5, 0.5)
        z77.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
        z77.Image = "rbxassetid://83542549106889"
        z77.ImageColor3 = Color3.fromRGB(220, 220, 220)
        z77.ScaleType = Enum.ScaleType.Fit
        z77.AutoButtonColor = false
        z77.ZIndex = 1
        local a66 = Instance.new("UICorner", z77)
        a66.CornerRadius = UDim.new(0, 18)
        local b55 = Instance.new("UIStroke", z77)
        b55.Color = Color3.fromRGB(45, 45, 48)
        b55.Thickness = 1.5
        b55.Transparency = 0.3
        local c44 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        z77.MouseEnter:Connect(function()
            v3:Create(z77, c44, {Size = UDim2.fromOffset(60, 60)}):Play()
        end)
        z77.MouseLeave:Connect(function()
            v3:Create(z77, c44, {Size = UDim2.fromOffset(55, 55)}):Play()
        end)
        z77.MouseButton1Down:Connect(function()
            v3:Create(z77, c44, {Size = UDim2.fromOffset(50, 50)}):Play()
        end)
        z77.MouseButton1Up:Connect(function()
            v3:Create(z77, c44, {Size = UDim2.fromOffset(60, 60)}):Play()
        end)
        local d33, e22, f11, g00, h99 = false, nil, nil, false, nil
        z77.InputBegan:Connect(function(i88)
            if i88.UserInputType == Enum.UserInputType.MouseButton1 or i88.UserInputType == Enum.UserInputType.Touch then
                d33, e22, h99, f11 = true, i88, i88.Position, y88.Position
                g00 = false
            end
        end)
        v4.InputChanged:Connect(function(j77)
            if d33 and j77 == e22 then
                local k66 = j77.Position - h99
                if k66.Magnitude > 6 then g00 = true end
                y88.Position = UDim2.new(f11.X.Scale, f11.X.Offset + k66.X, f11.Y.Scale, f11.Y.Offset + k66.Y)
            end
        end)
        v4.InputEnded:Connect(function(l55)
            if l55 == e22 then d33 = false end
        end)
        z77.MouseButton1Click:Connect(function()
            if not g00 and self.Window then
                self.Window:Minimize()
            end
        end)
    end
    function v8:BuildInterfaceSection(v53)
        assert(self.Library, "Must set InterfaceManager.Library")
        local v54 = self.Library
        local v55 = v8.Settings
        v8:LoadSettings()
        local v56 = v2:FindFirstChild("Fracture Hub")
        if v56 then
            local v57 = v56:FindFirstChildWhichIsA("Frame", true)
            if v57 then
                task.spawn(function()
                    task.wait()
                    local v58 = v57:FindFirstChild("TabHolder", true)
                    if v58 and v58.Parent then
                        self:CreateProfileCard(v58.Parent)
                    end
                end)
            end
        end
        local v59 = v53:AddSection("Interface")
        local v60 = v59:AddDropdown("InterfaceTheme", {
            Title = "Select Theme",
            Description = "เลือกธีม",
            Values = v54.Themes,
            Default = v55.Theme,
            Callback = function(v61)
                v54:SetTheme(v61)
                v55.Theme = v61
                v8:SaveSettings()
            end
        })
        v60:SetValue(v55.Theme)
        v59:AddToggle("TransparentToggle", {
            Title = "Transparency",
            Description = "ความโปร่งใส",
            Default = v55.Transparency,
            Callback = function(v62)
                v54:ToggleTransparency(v62)
                v55.Transparency = v62
                v8:SaveSettings()
            end
        })
        v59:AddDropdown("FontManager", {
            Title = "Select Font Manager",
            Values = v9,
            Default = v55.Font or "GothamSSm",
            Callback = function(v63)
                v55.Font = v63
                v8:SaveSettings()
                task.spawn(function()
                    task.wait()
                    v8:ApplyFont(v63)
                end)
            end
        })
        local v64 = v59:AddKeybind("MenuKeybind", {
            Title = "Minimize Bind",
            Default = v55.MenuKeybind
        })
        v64:OnChanged(function()
            v55.MenuKeybind = v64.Value
            v8:SaveSettings()
        end)
        v54.MinimizeKeybind = v64
        local v65 = v59:AddDropdown("InterfaceLanguage", {
            Title = "Select Language",
            Description = "เลือกภาษา",
            Values = v11,
            Default = v55.Language or "English",
            Callback = function(v66)
                v8:ApplyLanguage(v66)
            end
        })
        v65:SetValue(v55.Language or "English")
        task.spawn(function()
            task.wait()
            if v55.Font then
                v8:ApplyFont(v55.Font)
            end
        end)
    end
end
return v8
