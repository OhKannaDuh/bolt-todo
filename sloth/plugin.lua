Object = require('sloth.external.object')
Json = require('sloth.external.json')

require('sloth.config')
require('sloth.browser')
require('sloth.embedded_browser')

Plugin = Object:extend()

function Plugin:new()
    self.ready = false
    self.tick_callbacks = {}
    self.config = Config(self)
    self.bolt = require('bolt')

    self.bolt.onswapbuffers(function()
        if self.ready ~= true then
            return
        end

        for _, callback in pairs(self.tick_callbacks) do
            callback(self)
        end
    end)
end

function Plugin:start()
    self.ready = true
end

function Plugin:load_config(deafult)
    self.config:add_data(deafult)
    self.config:load(self.bolt)
end

function Plugin:save_config()
    self.config:save(self.bolt)
end

