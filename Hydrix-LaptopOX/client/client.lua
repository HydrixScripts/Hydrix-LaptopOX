local LaptopOpen = false
local laptopMenu = false

-- // Events // --

RegisterNetEvent('hydrix-laptop:client:practiceLaptop')
AddEventHandler('hydrix-laptop:client:practiceLaptop', function()
    OpenLaptop()
end)

-- // Functions // --

function OpenLaptop()
    if not LaptopOpen then
        OX.Menu.OpenMenu('laptop_menu')
        LaptopOpen = true
    end
end

function CloseLaptop()
    if LaptopOpen then
        OX.Menu.CloseMenu('laptop_menu')
        LaptopOpen = false
    end
end

function OX.Menu.RegisterMenu(id, generator)
    OX.Menu.Menus[id] = generator
end

function OX.Menu.RegisterType(id, generator)
    OX.Menu.RegisterMenu(id, function()
        return {
            title = '',
            subtitle = '',
            items = generator()
        }
    end)
end

function OX.Menu.OpenMenu(id)
    if OX.Menu.Menus[id] ~= nil then
        local menu = OX.Menu.Menus[id]()
        OX.Menu.CurrentMenu = menu
        return menu
    end
end

function OX.Menu.CloseMenu(menu)
    if OX.Menu.CurrentMenu == menu then
        OX.Menu.CurrentMenu = nil
    end
end


-- // Menu // --

local laptopMenu = false

function OpenLaptop()
    laptopMenu = OX.Menu.OpenMenu('laptop_menu')
end

function CloseLaptop()
    OX.Menu.CloseMenu(laptopMenu)
end

OX.Menu.RegisterMenu('laptop_menu', function()
    return {
        title = "Laptop",
        subtitle = "Use your laptop to hack or transfer money",
        items = {
            {
                title = "Hack",
                type = "button",
                onSelected = function()
                    OX.Menu.OpenMenu('hack_menu')
                end
            },
            {
                title = "Transfer Money",
                type = "button",
                onSelected = function()
                    OX.Menu.OpenMenu('transfer_money_menu')
                end
            },
            {
                title = "Close Laptop",
                type = "button",
                onSelected = function()
                    CloseLaptop()
                end
            }
        }
    }
end)

OX.Menu.RegisterType('hack_menu', function()
    return {
        title = "Hack",
        subtitle = "Select a company to hack into",
        items = {
            {
                title = "Fleeca Bank",
                type = "button",
                onSelected = function()
                    OX.TriggerServerCallback('hydrix-laptop:server:hack', function(success)
                        if success then
                            OX.Notify('Success', 'Hack successful', 'success')
                        else
                            OX.Notify('Error', 'Hack failed', 'error')
                        end
                    end, 'lifeinvader')
                end
            },
            {
                title = "Paleto Bank",
                type = "button",
                onSelected = function()
                    OX.TriggerServerCallback('hydrix-laptop:server:hack', function(success)
                        if success then
                            OX.Notify('Success', 'Hack successful', 'success')
                        else
                            OX.Notify('Error', 'Hack failed', 'error')
                        end
                    end, 'maze')
                end
            },
            {
                title = "Back",
                type = "button",
                onSelected = function()
                    OX.Menu.OpenMenu('laptop_menu')
                end
            }
        }
    }
end)

OX.Menu.RegisterType('transfer_money_menu', function()
    return {
        title = "Transfer Money",
        subtitle = "Enter the amount to transfer and the account number",
        items = {
            {
                title = "Amount",
                type = "custom_input",
                id = "amount"
            },
            {
                title = "Account Number",
                type = "custom_input",
                id = "account_number"
            },
            {
                title = "Transfer",
                type = "button",
                onSelected = function(data)
                    local amount = tonumber(data.amount)
                    local accountNumber = tonumber(data.account_number)

                    if not amount or not accountNumber then
                        OX.Notify('Error', 'Invalid amount or account number', 'error')
                        return
                    end

                    OX.TriggerServerCallback('hydrix-laptop:server:transferMoney', function(success)
                        if success then
                            OX.Notify('Success', 'Money transferred successfully', 'success')
                            return
                        end
                    end, amount, accountNumber)
                end
            }
        }
    }
end)

