if Config.UseOldEsx then    
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    ESX = exports["es_extended"]:getSharedObject()
end

local isRDR = not TerraingridActivate and true or false
local loaded = false
local cmd = {}
local opened = false

Citizen.CreateThread(function()
    while ESX == nil do
        if Config.UseOldEsx then
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function (xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.GetPlayerData().job = job
    PlayerData.job = job
end)

RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(data)
    SendNUIMessage({
        action = 'msg',
        type= 'server',
        msg = data.args[2],
        sender_data = {rp_name = 'auto', steam_name = 'auto', phone_number = '00000'}
    })
end)

RegisterNetEvent('rc-chat:addCommands')
AddEventHandler('rc-chat:addCommands', function(commands)
    local registeredCommands = GetRegisteredCommands()

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) then
            table.insert(cmd, {
                command.name
            })
        end
    end

    TriggerServerEvent('rc-chat:serverCommands')

    loaded = true

end)


RegisterNetEvent('rc-chat:recieveCommands')
AddEventHandler('rc-chat:recieveCommands', function(commands)

    for _, command in ipairs(commands) do

        table.insert(cmd, {
            command.name
        })
        
    end
end) 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if Config.close and (not opened) then
            Citizen.Wait(Config.time)
            if (not opened) then
                SendNUIMessage({action = 'hide_messages'})  
            end
        end   
    end 
end)

RegisterNUICallback("chatout", function(data)
    if opened then
        opened = false
    end
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)
    TriggerEvent('rc-chat:addCommands')
    if loaded then
        while true do
            Citizen.Wait(0)
            if IsControlPressed(0, isRDR and `INPUT_MP_TEXT_CHAT_ALL` or 245) then
                SetNuiFocus(true, true)
                opened = true
                local chatType = {}
                ESX.TriggerServerCallback('rc-chat:getGroup', function(group)
                    for k,v in pairs(Config.ChatTypes) do
                        if v.group or v.job then 
                            
                            if v.group and Config.GroupRank[v.group] <= Config.GroupRank[group] then 
                                chatType[k] = v
                            elseif v.job and v.job == ESX.GetPlayerData().job.name then
                                chatType[k] = v
                            end
                        else
                            if k == "dark_chat" and ESX.GetPlayerData().job.name == "police" then 
                            elseif (k == "job" or k =="ad") and ESX.GetPlayerData().job.name == "unemployed" then 
                            else
                                chatType[k] = v
                            end
                        end
                    end
                    SendNUIMessage({
                        action = 'show',
                        chat_types = chatType,
                        commands = cmd
                    })
                end)
            end

        end
    end          

end)

RegisterNetEvent('rc-chat:addmessage')
AddEventHandler('rc-chat:addmessage', function(data)
    SendNUIMessage({
        action = 'msg',
        type = data.type,
        msg = data.msg,
        sender_data = {rp_name = data.name, steam_name = data.steam_name, phone_number = data.phone}
    })
end)

RegisterNUICallback("mobile", function(data)
    if data.action == 'sms' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'onSms', {
            title = "Send SMS"
        }, function(data, menu)
            TriggerServerEvent(Config.Phone.sms, number, data.value)
            --TriggerServerEvent('gcPhone:sendMessage', number, data.value)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    elseif type == 'call' then
        TriggerServerEvent(Config.Phone.call, data.number , '', '')
        --TriggerServerEvent('gcPhone:startCall', data.number , '', '')
    end
end)

RegisterNUICallback("send", function(data)
    
    if data.msg:sub(1, 1) == '/' then
        TriggerServerEvent('rc-chat:logs', data ,Config.Webhooks.commands)
        ExecuteCommand(data.msg:sub(2))
    else
        TriggerServerEvent('rc-chat:sendmsg', data)
    end

end)

RegisterNUICallback("hide", function(data)
    SetNuiFocus(false, false)
end)


local playerIdentifiers
local enableMessages = true
local timeout = Config.delay * 60000 -- from ms, to sec, to min
local playerOnIgnore = false
RegisterNetEvent('rc-chat:setPlayerIdentifiers')
AddEventHandler('rc-chat:setPlayerIdentifiers', function(identifiers)
    playerIdentifiers = identifiers
end)
Citizen.CreateThread(function()
    while playerIdentifiers == {} or playerIdentifiers == nil do
        Citizen.Wait(1000)
        TriggerServerEvent('rc-chat:getPlayerIdentifiers')
    end
    for iid in pairs(Config.ignore) do
        for pid in pairs(playerIdentifiers) do
            if Config.ignore[iid] == playerIdentifiers[pid] then
                playerOnIgnore = true
                break
            end
        end
    end
    --print(playerOnIgnore)
    if not playerOnIgnore then
        while true do
            for i in pairs(Config.messages) do
                if enableMessages then
                    chat(i)
                end
                
                Citizen.Wait(0)
            end
            
            Citizen.Wait(timeout)
        end
    else
        print('[pAnnounce] Player is on ignore list, no announcements will be received.')
    end
end)
function chat(i)
    TriggerServerEvent('rc-chat:announce', Config.prefix .. Config.messages[i])
end
RegisterCommand(Config.CommandOnOffAutoChat, function()
    enableMessages = not enableMessages
    if enableMessages then
        status = 'enabled.'
    else
        status = 'disabled.'
    end
    TriggerServerEvent('rc-chat:announce', '[pAnnounce] automessages are now ' .. status)
    TriggerEvent('chatMessage', '', {255, 255, 255}, '^5[pAnnounce] automessages are now ' .. status)
end, false)