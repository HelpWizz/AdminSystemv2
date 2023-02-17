local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Remotes = {
	Event = ReplicatedStorage:WaitForChild("sz_Tolu Remotes"):WaitForChild("RemoteEvent"),
	Function = ReplicatedStorage:WaitForChild("sz_Tolu Remotes"):WaitForChild("RemoteFunction"),
}
local CurrentCamera = workspace.CurrentCamera

-- UI elements
local Elements = script.Parent.Parent.Elements
local Library = script.Parent.Library
local Hint = require(Library.Components.Hint)
local Notification = require(Library.Components.Notification)
local Countdown = require(Library.Components.CountDown)
local ExpandedNotification = require(Library.Components.ExpandedNotification)
local ReplyBox = require(Library.Components.ReplyBox)
local ServerMessage = require(Library.Components.ServerMessage)
local activeElements = {}

local Bindable = Elements.Event


local function onCall(Type: string, Protocol: string?, Attachment)
	pcall(coroutine.wrap(function()
		local supportedTypes = {"newNotify", "newMessage", "newHint", "newNotifyWithAction", "Countdown"}
		if table.find(supportedTypes, Type) then
		end
	end))
	
	if Type == "newHint" then
		if activeElements.Hint then
			activeElements.Hint:dismiss()
		end
		if Attachment.Content == "Server is now unlocked" then
			activeElements.Hint:dismiss()
			return 
		end
		activeElements.Hint = Hint.new(Attachment.From, Attachment.Content, Attachment.Duration, Elements)
		activeElements.Hint:deploy()
		
	elseif Type == "ServerMessage" then
		if activeElements.ServerMessage then
			activeElements.ServerMessage:dismiss()
		end

		activeElements.ServerMessage = ServerMessage.new(Attachment.From, Attachment.Content, Attachment.Duration, Elements)
		activeElements.ServerMessage:deploy()
	elseif Type == "Countdown" then
		local countdown =  Countdown:new(Attachment.From, Attachment.Content, Elements.List2)
		countdown:deploy()
		
	elseif Type == "newNotify" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List, "", Attachment.Timed)
		notification:deploy(Attachment.Timed)
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = "Okay"
			expanded:deploy()
			
			Notification.stopDismissing = true
			expanded.onDismiss.Event:Wait()
			Notification.stopDismissing = false
		end
	elseif Type == "newNotifyWithAction" then
		local notification = Notification.new(Attachment.From, Attachment.Content, Elements.List, "pm")
		notification:deploy()
		
		local interacted = notification.onDismiss.Event:Wait()
		if interacted then		
			local expanded = ExpandedNotification.new(Attachment.From, Attachment.Content, Elements)
			expanded._object.Bottom.Primary.Content.Text = Protocol.Type
			expanded:deploy()
			
			Notification.stopDismissing = true
			local response = expanded.onDismiss.Event:Wait()
			Notification.stopDismissing = false
			Remotes.Function:InvokeServer("notifyCallback", Protocol.GUID, response)
		end
	elseif Type == "setCoreGuiEnabled" then
		StarterGui:SetCoreGuiEnabled(Attachment.Type, Attachment.Status)
	elseif Type == "setCamera" then
		CurrentCamera.CFrame = Attachment.CFrame or CurrentCamera.CFrame
		CurrentCamera.CameraSubject = Attachment.CameraSubject or CurrentCamera.CameraSubject
		CurrentCamera.CameraType = Attachment.CameraType or CurrentCamera.CameraType
		CurrentCamera.FieldOfView = Attachment.FieldOfView or CurrentCamera.FieldOfView
		CurrentCamera.MaxAxisFieldOfView = Attachment.MaxAxisFieldOfView or CurrentCamera.MaxAxisFieldOfView
		CurrentCamera.DiagonalFieldOfView = Attachment.DiagonalFieldOfView or CurrentCamera.DiagonalFieldOfView
		CurrentCamera.FieldOfViewMode = Attachment.FieldOfViewMode or CurrentCamera.FieldOfViewMode
		CurrentCamera.HeadScale = Attachment.HeadScale or CurrentCamera.HeadScale
	end
end

Remotes.Event.OnClientEvent:Connect(onCall)
Bindable.Event:Connect(onCall)