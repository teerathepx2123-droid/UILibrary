local httpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Client = Players.LocalPlayer

local InterfaceManager = {} do
	InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {
        Theme = "Midnight",
        Acrylic = true,
        Transparency = false,
        MenuKeybind = "LeftControl",
        Font = "GothamSSm",
    }

    local FontList = {
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

    local FontMap = {
        ["GothamSSm"]     = "rbxasset://fonts/families/GothamSSm.json",
        ["Gotham"]        = "rbxasset://fonts/families/Gotham.json",
        ["Arial"]         = "rbxasset://fonts/families/Arial.json",
        ["Code"]          = "rbxasset://fonts/families/Code.json",
        ["RobotoMono"]    = "rbxasset://fonts/families/RobotoMono.json",
        ["Ubuntu"]        = "rbxasset://fonts/families/Ubuntu.json",
        ["Nunito"]        = "rbxasset://fonts/families/Nunito.json",
        ["Merriweather"]  = "rbxasset://fonts/families/Merriweather.json",
        ["Oswald"]        = "rbxasset://fonts/families/Oswald.json",
        ["SourceSansPro"] = "rbxasset://fonts/families/SourceSansPro.json",
    }

    function InterfaceManager:ApplyFont(fontName)
        local fontPath = FontMap[fontName] or FontMap["GothamSSm"]
        local gui = CoreGui:FindFirstChild("Fracture Hub")
        if not gui then return end
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                pcall(function()
                    obj.FontFace = Font.new(fontPath, obj.FontFace.Weight, obj.FontFace.Style)
                end)
            end
        end
    end

    function InterfaceManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end

    function InterfaceManager:SetLibrary(library)
        self.Library = library
    end

    function InterfaceManager:BuildFolderTree()
        local paths = {}
        local parts = self.Folder:split("/")
        for idx = 1, #parts do
            paths[#paths + 1] = table.concat(parts, "/", 1, idx)
        end
        table.insert(paths, self.Folder)
        table.insert(paths, self.Folder .. "/settings")
        for i = 1, #paths do
            local str = paths[i]
            if not isfolder(str) then makefolder(str) end
        end
    end

    function InterfaceManager:SaveSettings()
        writefile(self.Folder .. "/options.json", httpService:JSONEncode(InterfaceManager.Settings))
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local data = readfile(path)
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)
            if success then
                for i, v in next, decoded do
                    InterfaceManager.Settings[i] = v
                end
            end
        end
    end

    function InterfaceManager:CreateFloatingButton()
        if CoreGui:FindFirstChild("FractureImageButton") then
            CoreGui.FractureImageButton:Destroy()
        end

        local ScreenGui = Instance.new("ScreenGui", CoreGui)
        ScreenGui.Name = "FractureImageButton"
        ScreenGui.ResetOnSpawn = false

        local ImageB = Instance.new("ImageButton", ScreenGui)
        ImageB.Size = UDim2.new(0, 55, 0, 55)
        ImageB.Position = UDim2.new(0.5, 0, 0.1, 0)
        ImageB.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        ImageB.BackgroundTransparency = 0.3
        ImageB.Image = "rbxassetid://83542549106889"
        ImageB.AutoButtonColor = false
        ImageB.ScaleType = Enum.ScaleType.Fit

        Instance.new("UICorner", ImageB).CornerRadius = UDim.new(0, 16)
        local UISt = Instance.new("UIStroke", ImageB)
        UISt.Color = Color3.fromRGB(40, 40, 40)
        UISt.Thickness = 1.5

        local Sc = Instance.new("UIScale", ImageB)
        local dr, ai, sp, ds = false, nil, nil, nil

        ImageB.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dr, ai, ds, sp = true, i, i.Position, ImageB.Position
                TS:Create(Sc, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Scale = 0.9}):Play()
            end
        end)

        UIS.InputChanged:Connect(function(i)
            if dr and i == ai then
                local d = i.Position - ds
                ImageB.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end
        end)

        UIS.InputEnded:Connect(function(i)
            if i == ai then
                dr = false
                TS:Create(Sc, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Scale = 1}):Play()
            end
        end)

        ImageB.MouseButton1Click:Connect(function()
            if self.Window then
                self.Window:Minimize()
            end
        end)
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
        local Library = self.Library
        local Settings = InterfaceManager.Settings

        InterfaceManager:LoadSettings()

        local gui = CoreGui:FindFirstChild("Fracture Hub")
        if gui then
            local windowRoot = gui:FindFirstChildWhichIsA("Frame", true)
            if windowRoot then
                task.spawn(function()
                    task.wait()
                    local tabHolder = windowRoot:FindFirstChild("TabHolder", true)
                    if tabHolder and tabHolder.Parent then
                        self:CreateProfileCard(tabHolder.Parent)
                    end
                end)
            end
        end

        local section = tab:AddSection("Interface")

        local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
            Title = "Select Theme",
            Values = Library.Themes,
            Default = Settings.Theme,
            Callback = function(Value)
                Library:SetTheme(Value)
                Settings.Theme = Value
                InterfaceManager:SaveSettings()
            end
        })
        InterfaceTheme:SetValue(Settings.Theme)

        section:AddToggle("TransparentToggle", {
            Title = "Transparency",
            Default = Settings.Transparency,
            Callback = function(Value)
                Library:ToggleTransparency(Value)
                Settings.Transparency = Value
                InterfaceManager:SaveSettings()
            end
        })

        section:AddDropdown("FontManager", {
            Title = "Font Manager",
            Description = "Changes the UI font.",
            Values = FontList,
            Default = Settings.Font or "GothamSSm",
            Callback = function(Value)
                Settings.Font = Value
                InterfaceManager:SaveSettings()
                task.spawn(function()
                    task.wait()
                    InterfaceManager:ApplyFont(Value)
                end)
            end
        })

        local MenuKeybind = section:AddKeybind("MenuKeybind", {
            Title = "Minimize Bind",
            Default = Settings.MenuKeybind
        })
        MenuKeybind:OnChanged(function()
            Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
        end)
        Library.MinimizeKeybind = MenuKeybind

        task.spawn(function()
            task.wait()
            if Settings.Font then
                InterfaceManager:ApplyFont(Settings.Font)
            end
        end)
    end
end

return InterfaceManager
