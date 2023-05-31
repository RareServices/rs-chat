if Config.UseOldEsx then
  ESX = nil
  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
  ESX = exports["es_extended"]:getSharedObject()
end

RegisterServerEvent('rs-chat:serverCommands')
AddEventHandler('rs-chat:serverCommands', function()
  local src = source
  local commands = GetRegisteredCommands()
  TriggerClientEvent('rs-chat:recieveCommands', src, commands)
end)

RegisterServerEvent('rs-chat:sendmsg')
AddEventHandler('rs-chat:sendmsg', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getInventoryItem('phone').count > 0 or xPlayer.getGroup() ~= "user" then
      MySQL.Async.fetchAll('SELECT phone_number, firstname, lastname FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.getIdentifier() }, function(result)
        sphone = result[1].phone_number
        sname = result[1].firstname
        slastname = result[1].lastname
        cmd = '['..src..'/'..GetPlayerName(src)..']'
					
        local info = {
            type = data.type,
            msg = data.msg,
            name = sname.. ' '..slastname,
            steam_name = GetPlayerName(src),
            phone = sphone,
            cmd = cmd,
            xp = xPlayer
        }
        if Config.ChatTypes[data.type] then 
          local cfg = Config.ChatTypes[data.type]
          local rank = Config.GroupRank
          if cfg.group or cfg.job then 
            if cfg.group and Config.GroupRank[xPlayer.getGroup()] >= Config.GroupRank[cfg.group] then
                TriggerEvent("rs-chat:sendall", info)
            else
              if cfg.job then 
                if xPlayer.getJob().name == cfg.job then
                  TriggerEvent("rs-chat:sendall", info)
                end
              end
            end
          else
            TriggerEvent("rs-chat:sendall", info)
          end
        end
      end)
    else
      TriggerClientEvent('esx:showNotification', source, 'You dont have phone!')
    end
end)

RegisterServerEvent('rs-chat:announce')
AddEventHandler('rs-chat:announce', function(msg)
  local data = { 
    type = 'announce',
    msg = msg
  }
  TriggerClientEvent("rs-chat:addmessage", source ,data )
end)

RegisterNetEvent('rs-chat:sendall')
AddEventHandler('rs-chat:sendall', function(data)
  TriggerEvent('rs-chat:logs',data,Config.Webhooks.chat)
  for _, v in pairs(ESX.GetPlayers()) do
    xPlayer = ESX.GetPlayerFromId(v)
    if xPlayer.getGroup() == "user" and data.type ~= "staff_chat"  then
      if xPlayer.getJob().name == "police" then
        if data.type ~= "dark_chat" then  
          local info = {
            type = data.type,
            msg = data.msg,
            name = data.name,
            steam_name = data.steam_name,
            phone = data.phone
          }
          TriggerClientEvent('rs-chat:addmessage', v, info)
        end
      else
        local info = {
          type = data.type,
          msg = data.msg,
          name = data.name,
          steam_name = data.steam_name,
          phone = data.phone
        }
        TriggerClientEvent('rs-chat:addmessage', v, info)
      end
    elseif xPlayer.getGroup() ~= "user" then
      if data.type ~= "staff_chat" then
        local info = {
          type = data.type,
          msg = data.msg,
          name = data.name,
          steam_name = data.steam_name,
          phone = data.phone
        }
        TriggerClientEvent('rs-chat:addmessage', v, info)
      else
        local info = {
          type = data.type,
          msg = data.cmd..' '..data.msg,
          name = data.name,
          steam_name = data.steam_name,
          phone = data.phone
        }
        TriggerClientEvent('rs-chat:addmessage', v, info)
      end
    end
  end 
end)

RegisterNetEvent('rs-chat:senstaff')
AddEventHandler('rs-chat:senstaff', function(data)
  local xPlayer = data.xp
  local info = {
      type = data.type,
      msg = data.msg,
      name = data.name,
      steam_name = data.steam_name,
      phone = data.phone
     }
    for _, v in pairs(ESX.GetPlayers()) do
      local xPlayer = ESX.GetPlayerFromId(v)
  
      if xPlayer.getGroup() ~= "user" then
        TriggerClientEvent('rs-chat:addmessage', v, info)
      end
  end
end)

RegisterNetEvent('rs-chat:logs')
AddEventHandler('rs-chat:logs', function(data, webhookMy)
 if data.cmd == nil then 
    data.cmd = '['..source..'/'..GetPlayerName(source)..']'
  end
  --local descriptions = 
  local content = {
    {
      author = {
        name = data.type,
        icon_url = ''--Your Server Icon
      },
      ["color"] = Config.ChatTypes[data.type.color] ,
      ["description"] = data.cmd..''..data.msg,
      ["footer"] = {
        ["text"] = os.date("%H:%M", os.time() + 1 * 60 * 60 )..os.date("%d/%m/%Y",os.time() + 1 * 60 * 60 ),
      },
    }
  }
  PerformHttpRequest(webhookMy, function() end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('rs-chat:getPlayerIdentifiers')
AddEventHandler('rs-chat:getPlayerIdentifiers', function()
    if GetPlayerIdentifiers(source) ~= nil then
        TriggerClientEvent('rs-chat:setPlayerIdentifiers', source, GetPlayerIdentifiers(source))
    end
end)

ESX.RegisterServerCallback('rs-chat:getGroup', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  cb(xPlayer.getGroup())
end)

RegisterCommand('r',function(source,args)
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(args[1])
  if Config.GroupRank [xPlayer.getGroup()] >= Config.GroupRank[Config.Reply.group] then 
    local msg = ""
    for i= 2,#args do 
      msg = msg.." "..args[i]
    end
    local data = {
      type = 'reply',
      msg = msg
    }
    TriggerClientEvent("rs-chat:addmessage",xTarget.source,data)
  end
end)
