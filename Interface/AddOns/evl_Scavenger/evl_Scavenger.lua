local evl_Scavenger = CreateFrame("Frame", nil, UIParent)

local onEvent = function(self)
	local bag, slot

	for bag = 0, 4 do
    	if GetContainerNumSlots(bag) > 0 then
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
			
				if link then
					local itemName, itemLink, itemRarity = GetItemInfo(link)
				
					if itemRarity == 0 then
						UseContainerItem(bag, slot)
					end
				end
			  end
	    end
	end
end


evl_Scavenger:SetScript("OnEvent", onEvent)
evl_Scavenger:RegisterEvent("MERCHANT_SHOW")
