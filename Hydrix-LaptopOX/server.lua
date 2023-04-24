local OX = exports['ox-lib']
local OXMenu = exports['ox-menu']
local OXInv = exports['ox-inventory']

-- // Server Events // --
OX.Inv.RegisterUsableItem('practicelaptop', function(source, item)
    local src = source
    local Player = OX.GetPlayer(src)
    OXMenu.OpenMenu(src, {
        {
            header = "Practice Laptop",
            txt = "Choose an option",
            params = {
                event = "hydrix-laptop:client:practiceLaptop"
            }
        },
    })
end)

-- // Events // --

OX.Menu.RegisterType('laptop_menu', function()
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

RegisterServerEvent('transfer_money')
AddEventHandler('transfer_money', function(amount, accountNumber)
    local src = source
    local player = OX.Players[src]

    -- Check if player has enough money to transfer
    if player:GetMoney() < amount then
        TriggerClientEvent('notify', src, 'Error', 'Insufficient funds', 'error')
        return
    end

    -- Check if account number is valid
    if not IsAccountNumberValid(accountNumber) then
        TriggerClientEvent('notify', src, 'Error', 'Invalid account number', 'error')
        return
    end

    -- Deduct money from player's account
    player:TakeMoney(amount)

    -- Add money to recipient's account
    local recipient = GetPlayerFromAccountNumber(accountNumber)
    if recipient then
        recipient:GetCharacter():AddMoney(amount)
        TriggerClientEvent('notify', recipient:GetId(), 'Success', 'Money transferred', 'success')
    else
        TriggerClientEvent('notify', src, 'Error', 'Recipient not found', 'error')
    end
end)

-- // Functions // --

function IsAccountNumberValid(accountNumber)
    -- Check if account number is valid (e.g. length, format, etc.)
    return true
end

function GetPlayerFromAccountNumber(accountNumber)
    -- Look up player with matching account number
    return OX.GetPlayers()[1] -- Return first player for testing purposes
end

-- // Callbacks // --
OX.RegisterServerCallback("laptop:server:check", function(source, cb)
    local src = source
    local Player = OX.GetPlayer(src)
    if not Player then return cb(false) end
    if Player.Functions.RemoveItem("practicelaptop", 1) then
        OXInv.ItemNotify(source, "practicelaptop", "remove")
        cb(true)
    else
        cb(false)
    end
end)

-- // Commands // --
if Config.Debug then
    OX.RegisterCommand("practicelaptop", "Give yourself a laptop", {}, function(source, args)
        local Player = OX.GetPlayer(source)
        Player.Functions.AddItem("practicelaptop", 1)
        OXInv.ItemNotify(source, "practicelaptop", "add")
    end, "admin")
end

-- // Event Handlers // --
AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    print("^5Hydrix Laptop Started ^7")
   end
end)

-- // Callbacks // --

OX.RegisterServerEvent('hydrix-laptop:server:getCustomHackTime')
AddEventHandler('hydrix-laptop:server:getCustomHackTime', function()
    local src = source
    OXMenu.OpenMenu(src, {
        {
            header = "Custom Hack Time",
            txt = "Set the custom hack time in seconds",
            params = {
                event = "hydrix-laptop:client:setCustomHackTime"
            }
        },
    })
end)

OX.RegisterServerEvent('hydrix-laptop:server:confiscateLaptop')
AddEventHandler('hydrix-laptop:server:confiscateLaptop', function()
    local src = source
    local xPlayer = OX.GetPlayer(src)
    local item = xPlayer.getInventoryItem("practicelaptop")

    if item ~= nil and item.count > 0 then
        xPlayer.removeInventoryItem("practicelaptop", 1)
        OX.Notify(src, "Your laptop was confiscated due to a failed hack attempt.", "error")
    end
end)