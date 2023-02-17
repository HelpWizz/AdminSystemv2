local module = {}
local items = {}

function module.fetch()
	return items
end

function module.new(client: string, action: string, attachment)
	table.insert(items, {
		Client = client,
		Action = action,
		Attachments = attachment,
		Timestamp = os.time()
	})
end

return module
