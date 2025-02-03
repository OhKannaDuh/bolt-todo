require('sloth.plugin')

local plugin = Plugin()

plugin.bolt.checkversion(1, 0)

plugin:load_config({
    window = {
        app = EmbeddedBrowser.default_config(),
        settings = Browser.default_config()
    },
    tasks = {
        daily = {},
        weekly = {},
        monthly = {}
    }
})

local app = EmbeddedBrowser(plugin, {
    x = plugin.config.data.window.app.x,
    y = plugin.config.data.window.app.y,
    width = plugin.config.data.window.app.width,
    height = plugin.config.data.window.app.height,
    showdevtools = plugin.config.data.window.app.showdevtools,
    path = "file://app/app.html"
})

local settings = Browser(plugin, {
    width = plugin.config.data.window.settings.width,
    height = plugin.config.data.window.settings.height,
    showdevtools = plugin.config.data.window.settings.showdevtools,
    path = "file://app/settings.html"
})

app:onmessage('close', function()
    plugin.bolt.close()
end)

app:onmessage('ready', function()
    app:message('config', plugin.config.data)
end)

app:onmessage('tasks', function(data)
    print(dump(app.browser))
    plugin.config.data.tasks = data
    plugin:save_config()
end)

app:onmessage('settings', function()
    settings:toggle()
end)

settings:onmessage('ready', function()
    settings:message('config', plugin.config.data)
end)

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

print(dump(plugin.config.data))

settings:onmessage('update', function(data)
    plugin.config.data.tasks = data
    print('Sending tasks...')
    app:message('tasks', plugin.config.data.tasks)
    plugin:save_config()
end)

plugin:start()
app:open()
-- settings:open()
