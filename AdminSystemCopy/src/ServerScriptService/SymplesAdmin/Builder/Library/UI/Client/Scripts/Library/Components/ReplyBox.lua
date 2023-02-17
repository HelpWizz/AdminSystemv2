local module = {}
module.__index = module

local modules = script.Parent.Parent.Modules
local promise = require(modules.Promise)
local tween = require(modules.Tween)
local fade = require(modules.Fade)
local tweeninfo = require(modules.TweenInfo)


module.Init = function()
	local Theme = require(modules.Stylesheet)
	frame = script.Comp
	frame.BackgroundColor3  = Theme.ThemeColor

	frame.Container.Body.Content.TextColor3 = Theme.Reply.PrimaryTextColor
	frame.Container.Top.Accent.BackgroundColor3 = Theme.Reply.AccentColor
	frame.Container.Top.Title.TextColor3 = Theme.Reply.AccentTextColor
	frame.Container.ImageColor3 = Theme.ThemeColor

	frame.Bottom.Primary.ImageColor3 = Theme.ThemeColor
	frame.Bottom.Primary.Content.TextColor3 = Theme.Reply.TertiaryTextColor
end

function module.new(from: string, parent: Instance)
	local component = script.Comp:Clone()
	component.Name = script.Name
	component.Container.Top.Title.Text = "<font face=\"Gotham\" color=\"rgb(200,200,200)\">Replying to </font>" .. from
	component.Parent = parent
	fade:Set(component, 1)
	return setmetatable({
		_object = component,
		onDismiss = Instance.new("BindableEvent"),
		dismissed = false
	}, module)
end

function module:dismiss(arguments)
	if self.dismissed then return end
	self.dismissed = true
	self.onDismiss:Fire(arguments)
	if arguments == false then
		fade:Set(self._object, 1, tweeninfo.Linear(0.15))
		tween.new(self._object, tweeninfo.Quint(0.3), {
			Position = UDim2.new(0.5, 0, 0.9, 0)
		})
		wait(0.3)
	else
		tween.new(self._object, tweeninfo.Back(1.2), {
			Position = UDim2.new(0.5, 0, 0, -36),
			AnchorPoint = Vector2.new(0.5, 1)
		})
	end
	self._object:Destroy()
end

function module:deploy()
	self._object.Visible = true
	self._object.Position = UDim2.new(0.5, 0, 0.3, 0)
	tween.new(self._object, tweeninfo.Quint(0.3), {
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	fade:Set(self._object, 0, tweeninfo.Linear(0.15))
	
	self._object.Bottom.Primary.Button.MouseButton1Click:Connect(function()
		self:dismiss(self._object.Container.Body.Content.Text)
	end)
	
end

return module