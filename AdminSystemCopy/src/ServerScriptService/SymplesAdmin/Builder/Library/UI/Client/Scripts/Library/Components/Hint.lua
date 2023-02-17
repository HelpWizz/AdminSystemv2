local module = {}
module.__index = module

local modules = script.Parent.Parent.Modules
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)
local defaultDuration = 10

module.Init = function()
	local Theme = require(modules.Stylesheet)
	frame = script.Comp
	frame.BackgroundColor3  = Theme.ThemeColor
	frame.Content.TextColor3 = Theme.Hint.PrimaryTextColor
end


function module.new(from: string, content: string, duration: number?, parent: Instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Content.Text = content
	component.Parent = parent
	fade:Set(component, 0.5)
	return setmetatable({
		_object = component,
		interval = duration or defaultDuration,	
		dismissed = false
	}, module)
end

function module:dismiss()
	if self.dismissed then return end
	self.dismissed = true
	fade:Set(self._object, 1, tweeninfo.Linear(0.15))
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 0)
	})
	wait(0.3)
	self._object:Destroy()
end



function module:deploy()
	self._object.Visible = true
	self._object.Position = UDim2.new(0, 0, 0, 0)
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0, -36),
		AnchorPoint = Vector2.new(0, 0)
	})
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
end

return module