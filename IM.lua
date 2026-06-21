local v1 = game:GetService("HttpService")
local v2 = game:GetService("CoreGui")
local v3 = game:GetService("TweenService")
local v4 = game:GetService("UserInputService")
local v5 = game:GetService("Players")
local v6 = game:GetService("RunService")

local v7 = v5.LocalPlayer

local v8 = {} do
    v8.Folder = "FluentSettings"
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
        if v2:FindFirstChild("FractureImageButton") then
            v2.FractureImageButton:Destroy()
        end

        local v41 = Instance.new("ScreenGui", v2)
        v41.Name = "FractureImageButton"
        v41.ResetOnSpawn = false

        local v42 = Instance.new("ImageButton", v41)
        v42.Size = UDim2.new(0, 55, 0, 55)
        v42.Position = UDim2.new(0.5, 0, 0.1, 0)
        v42.AnchorPoint = Vector2.new(0.5, 0.5)
        v42.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        v42.BackgroundTransparency = 0.3
        v42.Image = "rbxassetid://83542549106889"
        v42.AutoButtonColor = false
        v42.ScaleType = Enum.ScaleType.Fit

        Instance.new("UICorner", v42).CornerRadius = UDim.new(0, 16)
        local v43 = Instance.new("UIStroke", v42)
        v43.Color = Color3.fromRGB(40, 40, 40)
        v43.Thickness = 1.5

        local v44 = Instance.new("UIScale", v42)
        local v45, v46, v47, v48 = false, nil, nil, nil

        v42.InputBegan:Connect(function(v49)
            if v49.UserInputType == Enum.UserInputType.MouseButton1 or v49.UserInputType == Enum.UserInputType.Touch then
                v45, v46, v48, v47 = true, v49, v49.Position, v42.Position
                v3:Create(v44, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = 0.9}):Play()
            end
        end)

        v4.InputChanged:Connect(function(v50)
            if v45 and v50 == v46 then
                local v51 = v50.Position - v48
                v42.Position = UDim2.new(v47.X.Scale, v47.X.Offset + v51.X, v47.Y.Scale, v47.Y.Offset + v51.Y)
            end
        end)

        v4.InputEnded:Connect(function(v52)
            if v52 == v46 then
                v45 = false
                v3:Create(v44, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Scale = 1}):Play()
            end
        end)

        v42.MouseButton1Click:Connect(function()
            if self.Window then
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
            Default = v55.Transparency,
            Callback = function(v62)
                v54:ToggleTransparency(v62)
                v55.Transparency = v62
                v8:SaveSettings()
            end
        })

        v59:AddDropdown("FontManager", {
            Title = "Font Manager",
            Description = "Changes the UI font.",
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
            Description = "Changes the UI text language.",
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
