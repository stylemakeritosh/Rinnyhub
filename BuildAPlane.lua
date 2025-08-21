-- hello
local name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local supportedVersion = "v1.5.2"
local supportedVersionp = 1399
local scriptversion = "v1"

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUI.lua"))()

-- Create Main Window
local Window = Library:Window({
    Title = "rinny hub - ".. name .. " " .. scriptversion,
    Desc = "rinny hub on top",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "rinny hub"
    }
})

local function modal(title, description, call)
    -- Use notification as fallback
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = description .. "\nContinue? (This is a fallback, proceed manually if needed)",
        Duration = 5
    })
    task.spawn(call) -- Proceed anyway, or adapt as needed
end
if isfile and readfile and listfiles and writefile and makefolder then
    if not isfolder("CandyHub\\Builds") then
        makefolder("CandyHub\\Builds")
    end
else
    print("filing system unsupported")
end
if not _G.candyhub then _G.candyhub = {
    autofarm = false,
    moon = false,
    x = 17000,
    y = 160,
    endpos = 100000,
    allitems = true,
    maxfps = 0,
    mode = "SuperFast",
    autotake = true,
    items = {
        propeller_2 = false,
        shield = false,
        fuel_1 = false,
        block_1 = false,
        wing_1 = false,
        missile_1 = false,
        tail_1 = false,
        tail_2 = false,
        fuel_3 = false,
        boost_1 = false,
        fuel_2 = false,
        balloon = false,
        seat_1 = false,
        wing_2 = false,
        propeller_1 = false,
    },
    custom = {
        fuel = {
            enabled = false,
            amount = 45
        },
        propeller = {
            enabled = false,
            amount = 5000,
            customfuel = false,
            fueluse = 0,
        },
        wing = {
            enabled = false,
            amount = 36,
        },
        rocket = {
            enabled = false,
            amount = 6,
        }, 
        missile = {
            enabled = false
        }, 
        shield = {
            enabled = false
        }
    },
    distance = 100000,
    autobuy = false,
    lags = false,
    gm = false,
    nofall = false,
    posy = 60,
    abs = false,
    afk = false,
    fillscreen = false,
    fpschanger = false,
}end

local autofarming = false
local automooning = false

local abs = function(num)
    if num ~= 0 then
        return -num
    end
    return num
end
local function getplot()
    local plots = workspace.Islands
    for i, plot in plots:GetChildren() do
        if plot.Important.OwnerID.Value == game.Players.LocalPlayer.UserId then
            return plot
        end
    end
end

local plot = getplot()
repeat task.wait(0.1) until plot:FindFirstChild("SpawnPart")
local spawnpart = plot:FindFirstChild("SpawnPart")
local spawnpartpos = spawnpart.Position
local spawnpartcfr = spawnpart.CFrame

local function getitems()
    local items = {}
    for i, item in game:GetService("Players").LocalPlayer.PlayerGui.Main.BlockShop.Shop.Container.ScrollingFrame:GetChildren() do
        if item.Name ~= "ExtraScrollPadding" and item.Name ~= "TemplateFrame" and item.ClassName == "Frame" then
            table.insert(items, item.Name)
        end
    end
    return items
end

_G.filetarget = ""

local function place(name,x,y,z)
    local args = {
        name,
        {
            target = plot:FindFirstChild("Plot"),
            hitPosition = vector.create(x,y,z), -- -6.59358024597168, 59, -312.9150390625
            targetSurface = Enum.NormalId.Top
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("PlaceBlock"):FireServer(unpack(args))
end

local function simulatetable()
    local zip = {}
    for i, item in plot:FindFirstChild("PlacedBlocks"):GetChildren() do
        table.insert(zip, 
            {
                item.Name,
                {
                    item.PrimaryPart.Position.X,
                    item.PrimaryPart.Position.Y,
                    item.PrimaryPart.Position.Z
                }
            }
        )
    end
    return zip
end

local function simulatetable2()
    local zip = {}
    for i, item in plot:FindFirstChild("PlacedBlocks"):GetChildren() do

        local plotn = plot.Name:gsub("Island","")
        local ploti = tonumber(plotn)-1
        
        local x,y,z = item.PrimaryPart.Position.X,item.PrimaryPart.Position.Y,item.PrimaryPart.Position.Z
        z = z + (85*ploti)

        table.insert(zip, 
            {
                item.Name,
                {
                    x,
                    y,
                    z
                }
            }
        )
    end
    return zip
end

local function simulatediff(plt)
    plt = plt or plot.Name
    local zip = {}
    for i, item in plt:FindFirstChild("PlacedBlocks"):GetChildren() do

        local plotn = plt.Name:gsub("Island","")
        local ploti = tonumber(plotn)-1
        
        local x,y,z = item.PrimaryPart.Position.X,item.PrimaryPart.Position.Y,item.PrimaryPart.Position.Z
        z = z + (85*ploti)

        table.insert(zip, 
            {
                item.Name,
                {
                    x,
                    y,
                    z
                }
            }
        )
    end
    return zip
end

local function readbuild(name)
    local fixedname = name:gsub("CandyHub\\Builds","")
    fixedname = fixedname:gsub("Candyhub/Builds","")
    fixedname = fixedname:gsub("/","")
    fixedname = fixedname:gsub("CandyHubBuilds", "")
    fixedname = fixedname:gsub(".json","")

    local path = "CandyHub\\Builds\\"..fixedname..".json"
    return readfile(path)
end

local function decode(table)
    if type(table) == "table" then return table else
        return game:GetService("HttpService"):JSONDecode(table)
    end
end

local function encode(table)
    if type(table) == "string" then return table else
        return game:GetService("HttpService"):JSONEncode(table)
    end
end

local function save(name,table)
    local path = "CandyHub\\Builds\\"..name..".json"
    writefile(path,encode(table))
end

local function load(name)

    local path = "CandyHub\\Builds\\"..name..".json"

    if isfile(path) then
        return decode(readfile(path))
    else
        return nil
    end
end

local function loadpath(path)

    local path = path..".json"

    if isfile(path) then
        return decode(readfile(path))
    else
        return nil
    end
end

local function takeall()
    for _, it in plot.PlacedBlocks:GetChildren() do
        local i = it.PrimaryPart
        local args = {
            {
                target = i,
                hitPosition = vector.create(i.CFrame.p.X, i.CFrame.p.Y, i.CFrame.p.Z),
                targetSurface = Enum.NormalId.Left
            }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("BuildingEvents"):WaitForChild("GrabBlock"):FireServer(unpack(args))
    end
end

local function getblocks(zip)
    local blocks = {}

    for _, res in ipairs(zip) do
        local name = res[1]
        blocks[name] = blocks[name] or {}
        table.insert(blocks[name], res)
    end

    return blocks
end

local function hasresources(zip)
    local blocks = getblocks(zip)

    for name, blockList in pairs(blocks) do
        local inventoryItem = game.Players.LocalPlayer.Important.Inventory:FindFirstChild(name)
        if not inventoryItem or inventoryItem.Value < #blockList then
            return false
        end
    end

    return true
end

local function loaddecoded(decoded)
    for i, item in decoded do
        task.spawn(function()

            local plotn = plot.Name:gsub("Island","")
            local ploti = tonumber(plotn)-1
            local itemname = item[1]
            local x = item[2][1]
            local y = item[2][2]
            local z = item[2][3] - (85*ploti)

            place(itemname,x,y,z)
        end)
    end
end

local function savecfg()

    local name = "Config"

    local fixedname = name:gsub("CandyHub","")
    fixedname = fixedname:gsub("Candyhub/Builds","")
    fixedname = fixedname:gsub("/","")
    fixedname = fixedname:gsub("\\","")
    fixedname = fixedname:gsub("CandyHub/", "")
    fixedname = fixedname:gsub(".json","")

    local path = fixedname..".json"

    writefile(path,encode(_G.candyhub))
end

local function loadcfg()


    local name = "Config"

    local fixedname = name:gsub("CandyHub","")
    fixedname = fixedname:gsub("Candyhub/Builds","")
    fixedname = fixedname:gsub("/","")
    fixedname = fixedname:gsub("\\","")
    fixedname = fixedname:gsub("CandyHub/", "")
    fixedname = fixedname:gsub(".json","")

    if isfile(name) then
        _G.candyhub = decode(readfile(name))
    end
end

loadcfg()

-- game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpectialEvents"):WaitForChild("PortalTouched"):FireServer()

local function getseat(blocks)
    local x = nil
    for i, item in blocks:GetChildren() do
        if string.find(item.Name, "driver_seat") then x = item end
    end
    return x
end

local function alive()
    if game.Players.LocalPlayer.Character then
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
                return true
            end
        end 
    end
    return false
end

local function char()
    if game.Players.LocalPlayer.Character then
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
                return game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
        end 
    end
    return nil
end

local function plane()
    local x = (plot.PlacedBlocks:FindFirstChild("driver_seat_1") or plot.PlacedBlocks:FindFirstChild("driver_seat_2") or plot.PlacedBlocks:FindFirstChild("driver_seat_3") or plot.PlacedBlocks:FindFirstChild("driver_seat_4")) or nil
    if x == nil then 
        return false
    elseif x:FindFirstChild("Hitbox") and x:FindFirstChildOfClass("VehicleSeat") then
        if x:FindFirstChildOfClass("VehicleSeat"):FindFirstChild("BodyGyro") then
            return true
        end
    end
    return false
end

local function getoffseat()
    local seat = seat or getseat(plot.PlacedBlocks)
    if seat and seat:FindFirstChildOfClass("VehicleSeat") then
        if seat:FindFirstChildOfClass("VehicleSeat").Occupant ~= nil then
            seat:FindFirstChildOfClass("VehicleSeat").Disabled = true
            seat:FindFirstChildOfClass("VehicleSeat").Disabled = false
        end
    end
end

-- Tab
local Main = Window:Tab({Title = "Main", Icon = "star"}) 
Main:Section({Title = "Main"})
local my1 = Main:Code({Title = "Money Earned: 0", Code = "Money Earned: 0"})
local my2 = Main:Code({Title = "Time: 0h 0m 0s", Code = "Time: 0h 0m 0s"})

Main:Toggle({
    Title = "Auto Fly (Default Map)",
    Value = _G.candyhub.autofarm,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.autofarm =v
            savecfg()

            if _G.candyhub.autofarm then
                local money = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
                local runnin= math.floor(tick())
                task.spawn(function()
                    while _G.candyhub.autofarm and task.wait(0.1) do
                        if ((not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value and _G.candyhub.moon) or not _G.candyhub.moon) then
                            my1:SetCode("Money Earned: " .. tostring(abs(money-game:GetService("Players").LocalPlayer.leaderstats.Cash.Value)))
                            my2:SetCode("Time: " .. tostring(math.floor((math.floor(tick())-runnin)/3600)) .. "h " .. tostring(math.floor(((math.floor(tick())-runnin)%3600)/60)) .. "m " .. tostring(math.floor((math.floor(tick())-runnin)%60)) .. "s")
                        end
                    end
                end)
            end

            while _G.candyhub.autofarm and task.wait(.1) do
                if ((not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value and _G.candyhub.moon) or not _G.candyhub.moon) then
                
                repeat task.wait(0.1) until not automooning

                autofarming = true
                
                local aplane = plot.PlacedBlocks
                local driver = (aplane:FindFirstChild("driver_seat_1") or aplane:FindFirstChild("driver_seat_2") or aplane:FindFirstChild("driver_seat_3"))
                local launched = plot.Important.Launched

                local x,z = spawnpartpos.X, spawnpartpos.Z

                if not alive() then
                    repeat task.wait(0.1) until alive()
                end

                if driver == nil then
                    repeat
                        task.wait(1) 
                    until (aplane:FindFirstChild("driver_seat_1") or aplane:FindFirstChild("driver_seat_2") or aplane:FindFirstChild("driver_seat_3")) ~= nil or not _G.candyhub.autofarm
                    driver = (aplane:FindFirstChild("driver_seat_1") or aplane:FindFirstChild("driver_seat_2") or aplane:FindFirstChild("driver_seat_3"))
                end

                if not driver:FindFirstChild("Hitbox") then
                    repeat 
                        task.wait(0.05) 
                    until driver:FindFirstChild("Hitbox") or not _G.candyhub.autofarm
                end
                repeat 
                    if not launched.Value and alive() then
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Launch"):FireServer()
                    end 
                    task.wait(1)
                until launched.Value or not _G.candyhub.autofarm
                task.wait(0.35)
                local abc = true
                while launched.Value and _G.candyhub.autofarm and (plane() and alive()) and abc and ((not game:GetService("ReplicatedStorage").ActiveEvents.BloodMoonActive.Value and _G.candyhub.moon) or not _G.candyhub.moon) do
                    if plane() and alive() then
                        local target = driver:FindFirstChild("Hitbox") or game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        target.CFrame = CFrame.new(
                            Vector3.new(
                                target.Position.X + (_G.candyhub.x / 100),
                                _G.candyhub.y,
                                z
                            ),
                            Vector3.new(
                                target.Position.X + ((_G.candyhub.x + 10) / 100),
                                _G.candyhub.y,
                                z
                            )
                        )

                        if (target.Position.X >= _G.candyhub.endpos) then
                            abc = false
                            autofarming = false
                        end
                    end
                    task.wait(0.001)
                end
                autofarming = false
                task.wait(1)
                repeat task.wait(0.1) game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LaunchEvents"):WaitForChild("Return"):FireServer() until not alive() or not launched.Value
                task.wait(0.01)
                end
            end

        end)
	end
})

Main:Toggle({
    Title = "GodMode",
    Value = _G.candyhub.gm,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.gm =v
            savecfg()

            while _G.candyhub.gm and task.wait(.4) do
                for i, item in plot:FindFirstChild("PlacedBlocks"):GetDescendants() do
                    if item.ClassName == "Part" or item.ClassName == "MeshPart" and (item.Parent.Name ~= "driver_seat_1" and item.Name ~= "Part") then
                        if item.CanTouch then
                            item.CanTouch = false
                        end
                    end
                end
            end
            for i, item in plot:FindFirstChild("PlacedBlocks"):GetDescendants() do
                if item.ClassName == "Part" or item.ClassName == "MeshPart" and (item.Parent.Name ~= "driver_seat_1" and item.Name ~= "Part") then
                    item.CanTouch = true
                end
            end
        end)
    end
})


local bu = require(game:GetService("ReplicatedStorage").Modules.Utilities.BlocksUtil)

local function updatedata(name,data,v)
    bu.BlockInfo[name][data] = v
end

Main:Section({Title = "Fuel Blocks"})

Main:Toggle({
    Title = "Custom Fuel",
    Value = _G.candyhub.custom.fuel.enabled or false,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.fuel.enabled =v
            savecfg()
            if not _G.candyhub.custom.fuel.enabled then
                updatedata("fuel_1", "Fuel", 5);
                updatedata("fuel_2", "Fuel", 10);
                updatedata("fuel_3", "Fuel", 15)
            else
                updatedata("fuel_1", "Fuel", _G.candyhub.custom.fuel.amount);
                updatedata("fuel_2", "Fuel", _G.candyhub.custom.fuel.amount);
                updatedata("fuel_3", "Fuel", _G.candyhub.custom.fuel.amount)
            end
        end)
	end
})

Main:Slider({
    Title = "Fuel amount",
    Min = 0,
    Max = 45,
    Rounding = 1,
    Value = _G.candyhub.custom.fuel.amount or 0,
    Callback = function(v)
        task.spawn(function()
            if v == 0 then
                _G.candyhub.custom.fuel.amount = math.huge
            else
                _G.candyhub.custom.fuel.amount=v
            end
            if _G.candyhub.custom.fuel.enabled then
                updatedata("fuel_1", "Fuel", _G.candyhub.custom.fuel.amount);
                updatedata("fuel_2", "Fuel", _G.candyhub.custom.fuel.amount);
                updatedata("fuel_3", "Fuel", _G.candyhub.custom.fuel.amount)
            end
            savecfg() 
        end)
    end
})

Main:Section({Title = " 0 = infinite "})

Main:Section({Title = "Propeller Blocks"})

Main:Toggle({
    Title = "Custom Propeller",
    Value = _G.candyhub.custom.propeller.enabled or false,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.propeller.enabled =v
            savecfg()
            if not _G.candyhub.custom.propeller.enabled then
                updatedata("propeller_0", "Force", 4)
                updatedata("propeller_1", "Force", 20)
                updatedata("propeller_2", "Force", 35)
                updatedata("propeller_3", "Force", 42)
                updatedata("propeller_blood", "Force", 50)
            else
                updatedata("propeller_0", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_1", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_2", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_3", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_blood", "Force", _G.candyhub.custom.propeller.amount)
            end
        end)
	end
})

Main:Slider({
    Title = "Custom Propeller SPD",
    Min = 1,
    Max = 5000,
    Rounding = 1,
    Value = _G.candyhub.custom.propeller.amount or 5000,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.propeller.amount=v;savecfg() 
            if _G.candyhub.custom.propeller.enabled then
                updatedata("propeller_0", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_1", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_2", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_3", "Force", _G.candyhub.custom.propeller.amount)
                updatedata("propeller_blood", "Force", _G.candyhub.custom.propeller.amount)
            end
        end)
    end
})


Main:Toggle({
    Title = "Custom Propeller Fuel Usage",
    Value = _G.candyhub.custom.propeller.customfuel or false,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.propeller.customfuel =v
            savecfg()
            if not _G.candyhub.custom.propeller.customfuel then
                updatedata("propeller_0", "FuelUsage", 0.12)
                updatedata("propeller_1", "FuelUsage", 0.20)
                updatedata("propeller_2", "FuelUsage", 0.40)
                updatedata("propeller_3", "FuelUsage", 0.60)
                updatedata("propeller_blood", "FuelUsage", 1.00)
            else
                updatedata("propeller_0", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_1", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_2", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_3", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_blood", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
            end
        end)
	end
})

Main:Slider({
    Title = "Custom Propeller FuelUsage",
    Min = 0,
    Max = 3,
    Rounding = 1,
    Value = _G.candyhub.custom.propeller.fueluse or 0,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.propeller.fueluse=v;savecfg() 
            if _G.candyhub.custom.propeller.customfuel then
                updatedata("propeller_0", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_1", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_2", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_3", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
                updatedata("propeller_blood", "FuelUsage", _G.candyhub.custom.propeller.fueluse)
            end
        end)
    end
})

Main:Section({Title = "Wing Blocks"})

Main:Toggle({
    Title = "Custom Wing  Usage",
    Value = _G.candyhub.custom.wing.enabled or false,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.wing.enabled =v
            savecfg()
            if not _G.candyhub.custom.wing.enabled then
                updatedata("wing_1", "Lift", 4)
                updatedata("wing_2", "Lift", 8)
                updatedata("wing_blood", "Lift", 12)
            else
                updatedata("wing_1", "Lift", _G.candyhub.custom.wing.amount)
                updatedata("wing_2", "Lift", _G.candyhub.custom.wing.amount)
                updatedata("wing_blood", "Lift", _G.candyhub.custom.wing.amount)
            end
        end)
	end
})

Main:Slider({
    Title = "Custom Wing Lift",
    Min = 0,
    Max = 36,
    Rounding = 1,
    Value = _G.candyhub.custom.wing.amount or 0,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.custom.wing.amount=v;savecfg() 
            if _G.candyhub.custom.wing.enabled then
                updatedata("wing_1", "Lift", _G.candyhub.custom.wing.amount)
                updatedata("wing_2", "Lift", _G.candyhub.custom.wing.amount)
                updatedata("wing_blood", "Lift", _G.candyhub.custom.wing.amount)
            end
        end)
    end
})


Main:Slider({
    Title = "Y",
    Min = -50,
    Max = 500,
    Rounding = 1,
    Value = _G.candyhub.y,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.y=v;savecfg() 
        end)
    end
})

Main:Slider({
    Title = "UnNatural SpeedUP",
    Min = 0,
    Max = 20000,
    Rounding = 1,
    Value = _G.candyhub.x,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.x=v;savecfg() 
        end)
    end
})

Main:Textbox({
    Title = "Distance To End",
    Placeholder = "Enter distance",
    Value = "",
    ClearTextOnFocus = false,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.endpos=tonumber(v);savecfg()
        end)
    end
})

Main:Section({Title = "\n RECCOMENDED SPEEDUP: 17500+-\n IF SPEEDUP IS DETECTED YOU WONT GET REWARDS\n NEED MORE PROPELLERS FOR MORE SPD \n"})

Main:Section({Title = "Auto Buy"})

Main:Toggle({
    Title = "Auto Buy Items",
    Value = _G.candyhub.autobuy,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.autobuy=v;savecfg()
            while _G.candyhub.autobuy and task.wait(0.1) do
                if _G.candyhub.allitems then
                    local items = getitems()
                    for i, item in ipairs(items) do
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock"):FireServer(
                            item
                        )
                    end
                else
                    for i, item in _G.candyhub.items do
                        if item then
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ShopEvents"):WaitForChild("BuyBlock"):FireServer(
                                i
                            )
                        end
                    end
                end
            end
        end)
	end
})

Main:Toggle({
    Title = "All Blocks",
    Value = _G.candyhub.allitems,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.allitems=v;savecfg()
        end)
	end
})

local shopItems = getitems()
local selectedItems = {}
for _, item in ipairs(shopItems) do
    if _G.candyhub.items[item] then
        table.insert(selectedItems, item)
    end
end

Main:Dropdown({
    Title = "Items",
    List = shopItems,
    Value = selectedItems[1] or "",
    Callback = function(selection)
        for k in pairs(_G.candyhub.items) do _G.candyhub.items[k] = false end
        _G.candyhub.items[selection] = true
        savecfg()
    end
})

Window:Line()

local Build = Window:Tab({Title = "Build", Icon = "tag"}) 
Build:Section({Title = "Build"})

if not (isfile and writefile and readfile and listfiles and makefolder) then
    Build:Section({Title = "your executor doesnt support\nfiles/file system"})
end


if isfile and writefile and readfile and listfiles and makefolder then
Build:Textbox({
    Title = "File Name",
    Placeholder = "file name. . .",
    Value = "",
    ClearTextOnFocus = false,
    Callback = function(v)
        _G.filetarget=v;savecfg()
    end
})

if not isfolder("CandyHub\\Builds") then
    makefolder("CandyHub\\Builds")
end
if not isfolder("CandyHub/Builds") then
    makefolder("CandyHub/Builds")
end
if not isfolder("CandyHub/Builds") then
    writefile("CandyHub\\Builds\\test.json","[]")
end
if not isfolder("CandyHub/Builds") then
    makefolder("CandyHub/Builds/test.json","[]")
end

local fileOptions = {}
if isfolder("CandyHub\\Builds") then
    for ___, item in ipairs(listfiles("CandyHub\\Builds")) do
        local fixedname = item:gsub("CandyHub\\Builds\\","")
        fixedname = fixedname:gsub("CandyHub/Builds","")
        fixedname = fixedname:gsub("\\","");fixedname=fixedname:gsub("/","")
        fixedname = fixedname:gsub("CandyHubBuilds", "")
        fixedname = fixedname:gsub(".json","")
        table.insert(fileOptions, fixedname)
    end
end

Build:Dropdown({
    Title = "Files",
    List = fileOptions,
    Value = "",
    Callback = function(v)
        _G.filetarget = v
    end
})

Build:Button({
    Title = "load build",
    Callback = function()
        local items = {}
        for i, item in listfiles("CandyHub\\Builds\\") do
            local fixedname = item:gsub("CandyHub\\Builds\\","")
            fixedname = fixedname:gsub("CandyHub/Builds","")
            fixedname = fixedname:gsub("\\","");fixedname=fixedname:gsub("/","")
            fixedname = fixedname:gsub("CandyHubBuilds", "")
            fixedname = fixedname:gsub(".json","")
            table.insert(items,fixedname)
        end

        if table.find(items,_G.filetarget) then
            if hasresources(load(_G.filetarget)) then
                if _G.candyhub.autotake then
                    takeall()
                    repeat task.wait() until #plot.PlacedBlocks:GetChildren() == 0
                end
                loaddecoded(load(_G.filetarget))
            else
                local blocks = getblocks(load(_G.filetarget))
                local hasAny = false
                for _ in pairs(blocks) do
                    hasAny = true
                    break
                end
                if type(blocks) == "table" and hasAny then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Need More Blocks.",
                        Text = "Check console for details",
                        Duration = 5
                    })
                    for name, blockList in pairs(blocks) do
                        print(name..": [" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value) .. "/" .. tostring(#blockList) .. "]")
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Save Error",
                        Text = "This Save Doesnt contain any blocks.",
                        Duration = 5
                    })
                end
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "This Save Doesnt Exist",
                Duration = 5
            })
        end
	end
})


Build:Button({
    Title = "save",
    Callback = function()
        save(_G.filetarget,simulatetable2())
	end
})

Build:Button({ 
    Title = "copy selected file",
    Callback = function()
        setclipboard(readbuild(_G.filetarget))
	end
})

_G.json = ""
Build:Textbox({
    Title = "json",
    Placeholder = '[["driver_seat_1",[1,2,3]]]',
    Value = "",
    ClearTextOnFocus = false,
    Callback = function(v)
        _G.json = v
    end
})

Build:Button({
    Title = "load from json",
    Callback = function()
        if hasresources(decode(_G.json)) then
            if _G.candyhub.autotake then
                takeall()
                repeat task.wait() until #plot.PlacedBlocks:GetChildren() == 0
            end
            loaddecoded(decode(_G.json))
        else
            local blocks = getblocks(decode(_G.json))
            local hasAny = false
            for _ in pairs(blocks) do
                hasAny = true
                break
            end
            if type(blocks) == "table" and hasAny then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Need More Blocks.",
                    Text = "Check console for details",
                    Duration = 5
                })
                for name, blockList in pairs(blocks) do
                    print(name..": [" .. tostring(game:GetService("Players").LocalPlayer.Important.Inventory:FindFirstChild(name).Value) .. "/" .. tostring(#blockList) .. "]")
                end
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Save Error",
                    Text = "This Save Doesnt contain any blocks.",
                    Duration = 5
                })
            end
        end
	end
})

Build:Button({
    Title = "save from json",
    Callback = function()
        save(_G.filetarget,decode(_G.json))
	end
})

Build:Button({
    Title = "Take All Blocks",
    Callback = function()
        takeall()
	end
})

Build:Toggle({
    Title = "Auto Take Blocks",
    Value = true,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.autotake=v;savecfg()
        end)
	end
})
end

Build:Section({Title = "Copy Build"})

_G.choosenisland = ""
local islandOptions = {}
for ___, island in workspace.Islands:GetChildren() do
    if island.Important.OwnerID.Value ~= 0 and island.Name ~= plot.Name then table.insert(islandOptions,island.Name) end
end
Build:Dropdown({
     Title = "Islands (Right to Left)",
     List = islandOptions,
     Value = "",
     Callback = function(v)
        _G.choosenisland = v
    end
})

Build:Button({
    Title = "build",
    Callback = function()
        if not workspace.Islands:FindFirstChild(_G.choosenisland).Important.Launched.Value then
            if _G.autotake then takeall() task.wait(0.5) end

            local sd = simulatediff(workspace.Islands:FindFirstChild(_G.choosenisland))
            loaddecoded(sd)
        else warn("plane of selected island is flying, cant copy build.") end
    end
})

Window:Line()

local Events = Window:Tab({Title = "Events", Icon = "wrench"}) 
Events:Section({Title = "Events"})

Events:Toggle({
    Title = "OP FARMER ( USEBEFOREPATCHED )",
    Value = _G.candyhub.superfarmer or false,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.superfarmer=v;savecfg()
            game:GetService("CoreGui").PurchasePromptApp.Enabled = not _G.candyhub.superfarmer
            task.spawn(function() 
                for i = 1, 300 do
                    task.spawn(function() 
                        while _G.candyhub.superfarmer and task.wait() do
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EventEvents"):WaitForChild("SpawnEvilEye"):InvokeServer()
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EventEvents"):WaitForChild("KillEvilEye"):InvokeServer()
                        end
                    end)
                end 
            end)
            task.spawn(function()
                for i = 1,80 do
                    task.spawn(function()
                        while _G.candyhub.superfarmer and task.wait() do
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PurchaseSpin"):InvokeServer()
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PerformSpin"):InvokeServer()
                        end
                    end)
                end
            end)
        end)
	end
})

Events:Toggle({
    Title = "Auto Buy Spins",
    Value = _G.candyhub.abs,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.abs=v;savecfg()
            while _G.candyhub.abs and task.wait(0.01) do
                if game:GetService("Players").LocalPlayer.Important.RedMoons.Value >= 10 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PurchaseSpin"):InvokeServer()
                end
            end
        end)
	end
})

Events:Toggle({
    Title = "Auto Spin",
    Value = _G.candyhub.abs2,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.abs2=v;savecfg()
            while _G.candyhub.abs2 and task.wait(0.01) do
                if game:GetService("Players").LocalPlayer.replicated_data.available_spins.Value >= 1 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PerformSpin"):InvokeServer()
                end
            end
        end)
	end
})



Events:Toggle({
    Title = "Auto Unlock Machine",
    Value = _G.candyhub.machine,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.abs=v;savecfg()
            while _G.candyhub.abs and not game:GetService("Players").LocalPlayer.Important.Eclipse.Value and task.wait(1) do
                if game:GetService("Players").LocalPlayer.Important.Eclipse.Value ~= false then
                    game:GetService("ReplicatedStorage").Remotes.SpectialEvents.MachineActivated:FireServer()
                end
            end
        end)
	end
})

Window:Line()

local Misc = Window:Tab({Title = "Misc", Icon = "tag"}) 
Misc:Section({Title = "Misc"})

Misc:Toggle({
    Title = "Anti AFK",
    Value = _G.candyhub.afk,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.afk=v;savecfg()
        end)
	end
})

local scren = game.CoreGui:FindFirstChild("CandyHub_Performance") or Instance.new("ScreenGui",game.CoreGui);scren.Name = "CandyHub_Performance"
scren.IgnoreGuiInset = true
scren.Enabled = false
local frame = scren:FindFirstChild("Frame") or Instance.new("Frame",scren)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

Misc:Toggle({
    Title = "Fill Screen",
    Value = _G.candyhub.fillscreen,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.fillscreen=v;savecfg()
            scren.Enabled = _G.candyhub.fillscreen
        end)
	end
})

Misc:Slider({
    Title = "FPS Cap",
    Min = 4,
    Max = 1024,
    Rounding = 1,
    Value = _G.candyhub.maxfps,
    Callback = function(v)
        task.spawn(function()
            if setfpscap and _G.candyhub.fpschanger then
                _G.candyhub.maxfps=v;savecfg()
                setfpscap(_G.candyhub.maxfps)
            end
        end)
    end
})

Misc:Toggle({
    Title = "FPS Cap Changer",
    Value = _G.candyhub.fpschanger,
    Callback = function(v)
        task.spawn(function()
            _G.candyhub.fpschanger=v;savecfg()
            if _G.candyhub.fpschanger then
                setfpscap(_G.candyhub.maxfps)
                if _G.candyhub.maxfps == 1024 then
                    setfpscap(0)
                end 
            end
        end)
	end
})

Misc:Section({Title = " 1024 = inf "})

Misc:Toggle({
    Title = "Resized Inventory (WIP)",
    Value = false,
    Callback = function(v)
        task.spawn(function()
            --
        end)
	end
})

Misc:Toggle({
    Title = "Add Icons to items in inventory (WIP)",
    Value = false,
    Callback = function(v)
        task.spawn(function()
            --
        end)
	end
})

Window:Line()

local Info = Window:Tab({Title = "Info", Icon = "wrench"}) 
Info:Section({Title = "Info"})

local serverVersion = game:GetService("Players").LocalPlayer.PlayerGui.Main.ServerVersion.Text

local bb1,bb2,security = 0,0,""

if supportedVersionp >= game.PlaceVersion then
    bb1 = 0
    bb2 = 255
    security = "Fully Secure, unlikely to get banned.\n"
elseif supportedVersion == serverVersion then
    bb1 = 200
    bb2 = 200
    security = "Secure, likely to get banned.\n"
else
    bb1 = 255
    bb2 = 0
    security = "Insecure, more likely to get banned.\n"
end

Info:Section({Title = "Made by rin & rinny hub\nCredits to rintoshiii\ndiscord: rinny hub || discord.gg/znrepmbSuu\n"})
Info:Section({Title = "Supported Version:   ".. supportedVersion .." | " .. tostring(supportedVersionp) .. "\nServer/Game Version: " .. serverVersion .. " | " .. tostring(game.PlaceVersion) .. "\n"})
Info:Section({Title = security})

Info:Button({
    Title = "Join Discord!",
    Callback = function()

        modal("Join Discord?", "do you want to join\nrinny hub discord?",function()
                local discordInvite = "discord.gg/znrepmbSuu"
                local status = "Discord Invite Link: "..discordInvite
                if request then
                    request({
                        Url = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"] = "https://discord.com"
                        },
                        Body = game:GetService("HttpService"):JSONEncode({
                            cmd = "INVITE_BROWSER",
                            args = {code = string.match(discordInvite, "discord%.com/invite/(%w+)")},
                            nonce = game:GetService("HttpService"):GenerateGUID(false)
                        })
                    })
                    status = "Invited You to discord server. . ."
                elseif setclipboard then
                    setclipboard(discordInvite)
                    status = "Copied invite link to clipboard"
                end

                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Discord",
                    Text = status,
                    Duration = 5
                })
            end
        )
	end
})

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if _G.candyhub.afk then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

-- Final Notification
Window:Notify({
    Title = "rinny hub",
    Desc = "All components loaded successfully! Credits leak: @rintoshiii",
    Time = 4
})