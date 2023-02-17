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
	frame.Top.BackgroundColor3 = Theme.Notification.TopFrameColor
	frame.Top.Accent.BackgroundColor3 = Theme.Notification.AccentColor
	frame.Top.Title.TextColor3 = Theme.Notification.AccentTextColor
	frame.Container.ImageColor3 = Theme.ThemeColor
	frame.Container.Body.Content.TextColor3 = Theme.Notification.PrimaryTextColor
end


function module.new(from: string, content: string, parent: Instance, checkPm, timed: boolean?)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Top.Title.Text = from
	component.Container.UISizeConstraint.MaxSize = Vector2.new(math.huge, 120)
	if checkPm and checkPm == "pm" then
		component.Container.Body.Content.Text = content.. "\n\n Tap to reply"
	else
		component.Container.Body.Content.Text = content
	end
	if timed then
		component.Top.Time.Visible = true
	else
		component.Top.Time.Visible = false
	end
	component.Parent = parent
	return setmetatable({
		_object = component,
		onDismiss = Instance.new("BindableEvent"),
		dismissed = false,
		duration = 10
	}, module)
end

function module:dismiss(arguments)
	if self.dismissed or module.stopDismissing then return end
	self.dismissed = true
	self.onDismiss:Fire(arguments)
	fade:Set(self._object.Container, 0.5, tweeninfo.Linear(0.15))
	tween.new(self._object.Container, tweeninfo.Quint(0.3), {
		Position = UDim2.new(1, 0, 0, 0),
	})
	task.wait(0.3)
	self._object:Destroy()
end

function module:payload()
	self.payload = promise.new(function(resolve, reject)
		if self.dismissed then reject("Object is already dismissed.") end
		local title = self._object.Top.Time
		for i = self.duration, 0, -1 do
			title.Text = i
			task.wait(1)
		end

		resolve()
	end)

	return self.payload
end



function module:deploy(timed)
	self._object.Visible = true
	self._object.Container.Position = UDim2.new(1, 0, 0, 0)
	
	tween.new(self._object.Container, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0, 0, 0, 0)
	})
	fade:Set(self._object.Container, 0, tweeninfo.Linear(0.15))
	
	self._object.Container.MouseButton1Click:Connect(function()
		self:dismiss(true)
	end)
	if timed then
		print(timed)
		self:payload():andThen(function()
			self:dismiss()
		end):catch(function(argument)
			warn(argument)
		end)
	end
	self._object.Top.Exit.Button.MouseButton1Click:Connect(function()
		self:dismiss(false)
	end)
end

return module
