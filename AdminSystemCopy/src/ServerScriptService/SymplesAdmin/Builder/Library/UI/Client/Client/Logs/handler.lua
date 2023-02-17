local module = {}
--module.Remotes = {}
module.Init = function()
	module.Remotes.Event.OnClientEvent:Connect(function(Type, Title, Attachment)
		local newUi = script.Parent:Clone() 
		if Type == "JoinLogs" or Type == "ChatLogs" or Type == "CommandLogs" then
			local info = Attachment
			for _, v in ipairs(info) do
				local template = script.Template:Clone()
				template.Container.Content.Text = v
				template.LayoutOrder = _
				template.Parent = newUi.Container.Body.Body
			end
			
			newUi.Parent= game:GetService("Players").LocalPlayer.PlayerGui.Client

			--UI
			local Container = newUi.Container
			local Body = Container.Body
			local Top = Container.Top
			
			Body.Body.CanvasSize = UDim2.new(0, 0, 0, Body.Body.UIListLayout.AbsoluteContentSize.Y)
			Body.Body.CanvasPosition = Vector2.new(0, math.huge)
			Top.Title.Text = Title
			
			Top.Right.Exit.Trigger.MouseButton1Click:Connect(function()
				Container.Parent:Destroy()
			end)
			
			if Top.Right.Exit.Trigger then
				Top.Right.Exit.Trigger.MouseEnter:Connect(function()
					Top.Right.Exit.Hover.UIScale.Scale = 1
				end)
				Top.Right.Exit.Trigger.MouseLeave:Connect(function()
					Top.Right.Exit.Hover.UIScale.Scale = 0
				end)
			end

		
		elseif Type == "CommandList" then
			local info = Attachment
			local newUi = script.Parent:Clone() 
			for name, v in pairs(info) do
				local number = 0
				local template = script.Template2:Clone()
				template.Container.Content.Text = v
				template.Container.CommandName.Text = name
				template.LayoutOrder = number
				template.Parent = newUi.Container.Body.Body
				number = number + 1
			end
			
		
			newUi.Parent= game:GetService("Players").LocalPlayer.PlayerGui.Client

				--UI
			local Container = newUi.Container
			local Body = Container.Body
			local Top = Container.Top
			
			Body.Body.CanvasSize = UDim2.new(0, 0, 0, Body.Body.UIListLayout.AbsoluteContentSize.Y)
			Body.Body.CanvasPosition = Vector2.new(0, math.huge)
			Top.Title.Text = Title

			Top.Right.Exit.Trigger.MouseButton1Click:Connect(function()
				Container.Parent:Destroy()
			end)

			if Top.Right.Exit.Trigger then
				Top.Right.Exit.Trigger.MouseEnter:Connect(function()
					Top.Right.Exit.Hover.UIScale.Scale = 1					
				end)
				Top.Right.Exit.Trigger.MouseLeave:Connect(function()
					Top.Right.Exit.Hover.UIScale.Scale = 0
				end)
			end
		elseif Type == "AdminList" then
			local info = Attachment
			local newUi = script.Parent:Clone() 
			for count, v in ipairs(info) do
				if v == "Creator" or v == "HeadAdmin" or v == "Admin" or v == "Moderator" then
					local clone = script:WaitForChild("Title"):Clone()
					clone.Text = v
					clone.LayoutOrder = count
					clone.Parent = newUi.Container.Body.Body
				else
					local clone = script:WaitForChild("info"):Clone()
					clone.Text = v
					clone.LayoutOrder = count
					clone.Parent = newUi.Container.Body.Body
				end
			end


			newUi.Parent= game:GetService("Players").LocalPlayer.PlayerGui.Client

			--UI
			local Container = newUi.Container
			local Body = Container.Body
			local Top = Container.Top

			Body.Body.CanvasSize = UDim2.new(0, 0, 0, Body.Body.UIListLayout.AbsoluteContentSize.Y)
			Body.Body.CanvasPosition = Vector2.new(0, math.huge)
			Top.Title.Text = Title

			Top.Right.Exit.Trigger.MouseButton1Click:Connect(function()
				Container.Parent:Destroy()
			end)

			if Top.Right.Exit.Trigger then
				Top.Right.Exit.Trigger.MouseEnter:Connect(function()
					Top.Right.Exit.Hover.UIScale.Scale = 1					
				end)
				Top.Right.Exit.Trigger.MouseLeave:Connect(function()
					Top.Right.Exit.Hover.UIScale.Scale = 0
				end)
			end
		end
	end)
end

module.Theme = function()
	local Theme = module.Stylesheet
	
	script.Parent.Container.BackgroundColor3 = Theme.ThemeColor
	script.Parent.Container.Top.BackgroundColor3 = Theme.logs.TopFrameColor 
	script.Parent.Container.Top.Title.TextColor3 = Theme.logs.PrimaryTextColor
	script.Parent.Container.Top.Right.Exit.Hover.BackgroundColor3 = Theme.logs.HoverColor
end


return module
