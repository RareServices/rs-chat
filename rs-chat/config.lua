Config = {}

Config.UseOldEsx = false -- (1.1 - 1.2 = true) (for 1.7 and higher false) 
Config.MaxMessageLength = 750
Config.close = true
Config.time = 12000

Config.ChatTypes = {
    ["twitter"]         = { js_switch = 'twitter',          color = "rgba(0,210,255,1)",       group = false,          job = false}, 
    ["ad"]              = { js_switch = 'ad',               color = "rgba(255,220,60,1)",      group = false,          job = false},
    ["staff_announce"]  = { js_switch = 'staff_announce',   color = "rgba(250,60,60,1)",       group = "admin",        job = false},
    ["staff_chat"]      = { js_switch = 'staff_chat',       color = "rgba(250,60,60,1)",       group = "admin",        job = false}, 
    ["police"]          = { js_switch = 'police',           color = "rgba(0,21,255,1)",        group = false,          job = "police"},
    ["ambulance"]       = { js_switch = 'ambulance',        color = "rgba(252, 28, 3,1)",      group = false,          job = "ambulance"},
    ["robb"]            = { js_switch = 'robb',             color = "rgba(250,100,60,1)",      group = false,          job = false},
    ["dark_chat"]       = { js_switch = 'dark_chat',        color = "rgba(140,100,255,1)",     group = false,          job = false}, 
    ["anon"]            = { js_switch = 'anon',             color = "rgba(220,220,220,1)",     group = false,          job = false},
    ["job"]             = { js_switch = 'job',              color = "rgba(250,190,60,1)",      group = false,          job = false},
    ["support"]         = { js_switch = 'support',          color = "rgba(60,255,90,1)",       group = "admin",        job = false},
    ["event"]           = { js_switch = 'event',            color = "rgba(255,60,140,1)",      group = "admin",        job = false},
    ["info"]            = { js_switch = 'info',             color = "rgba(0,150,0,1)",         group = "admin",        job = false},    
    ["developer"]       = { js_switch = 'developer',        color = "rgba(0,150,0,1)",         group = "developer",    job = false}
}

Config.GroupRank = {
    ["user"]= 0,
    ["helper"] = 1,
    ["mod"] = 2,
    ["event"] = 3,
    ["admin"] = 4,
    ["superadmin"] = 5,
    ["owner"] = 6,
    ["developer"] = 7
    --here add your custom rank 
}

Config.Reply ={
    ['js_switch'] = 'reply',
    ['color'] = 'rgba(250,60,60,1)',
    ['group'] = 'helper',
    ['activated'] = true
}


Config.Triggers = {
    ['msg'] = 'gcPhone:sendMessage',
    ['call'] = 'gcPhone:startCall'
}

Config.Webhooks = {
    ['chat'] = '',
    ['commands'] = ''
}
--AutoMessage Configs

-----------[ CONFIG ]---------------------------------------------------

-- Delay in minutes between messages
Config.delay = 59


Config.prefix = '[Rare Services] '

Config.messages = {   
    'For All Problems - Question submit a Report',
    'Restart Server Hours : 04:00, 10:30, 17:00',
    -- 'Για να δείτε τα ATM της πόλης γράψτε /atms',
}

Config.ignore = { 
    --'ip:127.0.0.1',
    --'steam:123456789123456',
    --'license:123456789',
}

Config.CommandOnOffAutoChat = 'onoffautomsg'
