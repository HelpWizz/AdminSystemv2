local module = {}
module.__index = module
module.stopDismissing = false

local modules = script.Parent.Parent.Modules
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)

module.Init = function()
	local Theme = require(modules.Stylesheet)
	local frame = script.Comp
	frame.BackgroundColor3  = Theme.ThemeColor
	frame.Top.BackgroundColor3 = Theme.Countdown.TopFrameColor
	frame.Top.Accent.BackgroundColor3 = Theme.Countdown.AccentColor
	frame.Top.Title.TextColor3 = Theme.Countdown.AccentTextColor
	frame.Container.ImageColor3 = Theme.ThemeColor
	frame.Container.Body.Content.TextColor3 = Theme.Countdown.PrimaryTextColor
end

function module:new(from, content: number, parent: Instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Top.Title.Text =  "<font face=\"Gotham\" color=\"rgb(200,200,200)\">Countdown from </font>" .. from.Name
	component.Container.UISizeConstraint.MaxSize = Vector2.new(209, 83)
	component.Container.Body.Content.Text = content
	component.Parent = parent
	fade:Set(component, 1)
	return setmetatable({
		_object = component,
		onDismiss = Instance.new("BindableEvent"),
		dismissed = false,
		duration = content
	}, module)
end

function module:dismiss(arguments)
	if self.dismissed or module.stopDismissing then return end
	self.payload:cancel()
	self.dismissed = true
	self.onDismiss:Fire(arguments)
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
	fade:Set(self._object.Container, 0.5, tweeninfo.Linear(0.15))
	tween.new(self._object.Container, tweeninfo.Quint(0.3), {
		Position = UDim2.new(-1, 0, 0, 0),
	})
	task.wait(0.3)
	self._object:Destroy()
end

function module:payload(number: number)
	self.payload = promise.new(function(resolve, reject)
		if self.dismissed then reject("Object is already dismissed.") end
		local title = self._object.Container.Body.Content
		for i = self.duration, 0, -1 do
			self._object.Container.Body.Content.Text = i
			task.wait(1)
		end

		resolve()
	end)

	return self.payload
end



function module:deploy()
	self._object.Visible = true
	self._object.Position = UDim2.new(0, 0, 0.4, 0)
	
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0.5, 0)
	})
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
	self:payload():andThen(function()
		self:dismiss()
	end):catch(function(argument)
		warn(argument)
	end)
	self._object.Top.Exit.Button.MouseButton1Click:Connect(function()
		self:dismiss()
	end)
end

return module