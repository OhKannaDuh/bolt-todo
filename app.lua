require('sloth.library')
require('sloth.modules.time')

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

-- Setup main window and settings
local app = EmbeddedBrowser(plugin, {
    x = plugin.config.data.window.app.x,
    y = plugin.config.data.window.app.y,
    width = plugin.config.data.window.app.width,
    height = plugin.config.data.window.app.height,
    showdevtools = plugin.config.data.window.app.showdevtools,
    scale = plugin.config.data.window.app.scale,
    path = "plugin://app/dist/index.html"
})

app:add_callback('reposition', function(event)
    local x, y, w, h = event:xywh()
    plugin.config.data.window.app.x = x
    plugin.config.data.window.app.y = y
    plugin.config.data.window.app.width = w
    plugin.config.data.window.app.height = h
    plugin:save_config()
end)

app:add_callback('after_close', function(event)
    plugin:save_config()
    plugin.bolt.close()
end)

local settings = Browser(plugin, {
    width = plugin.config.data.window.settings.width,
    height = plugin.config.data.window.settings.height,
    showdevtools = plugin.config.data.window.settings.showdevtools,
    scale = plugin.config.data.window.settings.scale,
    path = "plugin://app/dist/settings.html"
})

app:onmessage('ready', function()
    app:message('config', plugin.config.data)
end)

app:onmessage('tasks', function(data)
    plugin.config.data.tasks = data
    plugin:save_config()
end)

app:onmessage('settings', function()
    settings:toggle()
end)

settings:onmessage('ready', function()
    settings:message('config', plugin.config.data)
end)

settings:onmessage('update', function(data)
    plugin.config.data.tasks = data
    app:message('tasks', plugin.config.data.tasks)
    plugin:save_config()
end)

settings:onmessage('update-scale', function(data)
    plugin.config.data.window.app.scale = data.scale
    app:message('config', plugin.config.data)
    plugin:save_config()
end)

-- Add time module
local time = Time(plugin)
time:add_on_minute_changed_callback(function(plugin)
    plugin:save_config()
end)

time:add_on_day_changed_callback(function(plugin)
    for _, task in pairs(plugin.config.data.tasks.daily) do
        task.complete = false
    end

    app:message('tasks', plugin.config.data.tasks)
    plugin:save_config()
end)

time:add_on_weekly_reset_day_callback(function(plugin)
    for _, task in pairs(plugin.config.data.tasks.weekly) do
        task.complete = false
    end

    app:message('tasks', plugin.config.data.tasks)
    plugin:save_config()
end)

time:add_on_month_changed_callback(function(plugin)
    for _, task in pairs(plugin.config.data.tasks.monthly) do
        task.complete = false
    end

    app:message('tasks', plugin.config.data.tasks)
    plugin:save_config()
end)

plugin:add_module(time)

plugin:start()
app:open()
