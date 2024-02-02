-- Formatting the item(s) correctly, no matter what the input is
-- Used for item checking, adding and removing
function Functions.FormatItems(item, amount)
    local formatted = {}

    if (Framework == "QBCore") then
        if (type(item) == "string") then
            formatted[item] = amount or 1
        else
            if (item.name) or (item.item) then
                item = {item}
            end

            for k,v in pairs(item) do
                local _item = (type(v) == "number" and k) or v.name or v.item
                local _amount = (type(v) == "number" and v) or v.amount or v.count or 1

                formatted[_item] = formatted[_item] and formatted[_item] + _amount or _amount
            end
        end
    else
        if (type(item) == "string") then
            table.insert(formatted, {
                name = item,
                count = amount or 1
            })
        else
            if (item.name) or (item.item) then
                item = {item}
            end

            for k,v in pairs(item) do
                local _item = (type(v) == "number" and k) or v.name or v.item
                local _amount = (type(v) == "number" and v) or v.amount or v.count or 1

                table.insert(formatted, {
                    name = _item,
                    count = _amount
                })
            end
        end
    end

    return formatted
end

-- Add for offline characters
function Functions.FormatCharacterDetails(character, online)
    local formatted = {}

    if (Framework == "QBCore") then
        if (not character?.PlayerData) then
            return {}
        end

        formatted.identifier = character.PlayerData.citizenid
        formatted.source = character.PlayerData.source
        formatted.firstname = character.PlayerData.charinfo.firstname
        formatted.lastname = character.PlayerData.charinfo.lastname
        formatted.dateofbirth = character.PlayerData.charinfo.birthdate
        formatted.phonenumber = character.PlayerData.charinfo.phone
        formatted.nationality = character.PlayerData.charinfo.nationality
        formatted.backstory = character.PlayerData.charinfo.backstory
        formatted.cash = character.PlayerData.money["cash"] or 0
        formatted.bank = character.PlayerData.money["bank"] or 0
        formatted.dirty_cash = character.PlayerData.money["dirty_cash"] or 0
        formatted.online = online or false
        -- TODO: Match ESX (Future proofing)
    elseif (Framework == "ESX") then
        formatted.identifier = character.identifier
        formatted.source = character.source
        formatted.firstname = character.firstname or character?.variables?.firstName
        formatted.lastname = character.lastname or character?.variables?.lastName
        formatted.dateofbirth = character.dateofbirth or character?.variables?.dateofbirth
        formatted.phonenumber = character.phone_number or character?.variables?.phoneNumber
        formatted.backstory = nil -- By default there is none
        formatted.cash = character.accounts.money
        formatted.bank = character.accounts.bank
        formatted.dirty_cash = character.accounts.black_money
        formatted.online = online or false

        -- Unused, future proofing
        formatted.gender = character.sex or character?.variables?.sex
        formatted.height = character.height or character?.variables?.height
        formatted.jobName = character.job or character?.job?.name
        formatted.jobLabel = character?.job?.label or "NON-EXISTENT"
        formatted.jobGrade = character.job_grade or character?.job?.grade
        formatted.salary = character?.job?.grade_salary or 0
    end

    return formatted
end

---@class FormattingOptions
---@field exclude? table -- Array of identifiers that should be excluded {"identifier1", "identifier2"}, set to nil/{} to disable
---@field includeServerId? boolean
---@field sortServerId? boolean -- Sort by server id, only works if includeServerId is true
---@field removeIfNil? boolean -- Simply remove if the value is nil, sometimes the list may contain values that are not players, instead of having to manually remove them and then add them, this removes them and you can later re-add them
---@field allowRepeatedIdentifiers? boolean -- Set to true to allow the same identifier to be added multiple times

---@param players table -- Array of player identifiers
---@param options FormattingOptions
---@return table -- Array of formatted players
function Functions.FormatPlayers(players, options)
    if ((not players) or (type(players) ~= "table")) then error("Players must be a table") end

    local playerDetails = Functions.GetPlayerDetails(players or {})
    local formattedPlayers = {}
    local addedIdentifiers = {}

    for _, playerDetail in pairs(playerDetails) do
        if (not playerDetail) then goto setToEnd end

        if (not options?.allowRepeatedIdentifiers) then
            if (addedIdentifiers[playerDetail.identifier]) then goto setToEnd end
            addedIdentifiers[playerDetail.identifier] = true
        end

        if (options?.removeIfNil) then
            if (playerDetail.firstname == nil) then goto setToEnd end
            if (playerDetail.lastname == nil) then goto setToEnd end
        end

        if ((options?.exclude) and (#options?.exclude > 0)) then
            local shouldBeExcluded = Functions.Contains(options?.exclude, playerDetail.identifier)
            if (shouldBeExcluded) then goto setToEnd end
        end

        local firstname = playerDetail.firstname or "NOT FOUND"
        local lastname = playerDetail.lastname or "NOT FOUND"
        local label = firstname .. " " .. lastname

        if (options?.includeServerId) then
            label = ("(%s) "):format(playerDetail.source or "X") .. label
        end

        table.insert(formattedPlayers, {
            label = label,
            name = playerDetail.identifier,
            value = playerDetail.identifier,
        })

        ::setToEnd::
    end

    if (options?.includeServerId and options?.sortServerId) then
        table.sort(formattedPlayers, function(a, b)
            return tonumber(a.label:match("%((%d+)%)")) < tonumber(b.label:match("%((%d+)%)"))
        end)
    end

    return formattedPlayers
end

---@param details table
---@return table
function Functions.FormatJob(details)
    if (Framework == "QBCore") then
        local job = {
            name = details?.name or "NAME NOT FOUND",
            label = details?.label or "LABEL NOT FOUND",
            grade = {
                level = details?.grade?.level or "GRADE LEVEL NOT FOUND",
                name = details?.grade?.name or "GRADE NAME NOT FOUND"
            }
        }

        return job
    elseif (Framework == "ESX") then
        -- Untested
    end

    return {}
end

---@param details table
---@return table | nil
function Functions.FormatGang(details)
    if (Framework == "QBCore") then
        local gang = {
            name = details?.name or "NAME NOT FOUND",
            label = details?.label or "LABEL NOT FOUND",
            grade = {
                level = details?.grade?.level or "GRADE LEVEL NOT FOUND",
                name = details?.grade?.name or "GRADE NAME NOT FOUND"
            }
        }

        return gang
    elseif (Framework == "ESX") then
        if (Config.GangScript == "zyke_gangphone") then
            local plyRank, index = exports["zyke_gangphone"]:GetRank()
            local gang = {
                name = details?.id or "NAME NOT FOUND",
                label = details?.name or "LABEL NOT FOUND",
                grade = {
                    name = plyRank?.name or "GRADE LEVEL NOT FOUND",
                    level = index or "GRADE NAME NOT FOUND"
                }
            }

            return gang
        end

        return nil
    end
end

---@param details table
---@return table
-- Note that the grade level is one higher, this is to fit the indexing for LUA
function Functions.FormatJobDetails(details)
    if (Framework == "QBCore") then
        local grades = {}

        for key, value in pairs(details.grades) do
            grades[tonumber(key) + 1] = {
                name = value.name,
                label = value.name, -- No label, just set the name
                boss = value.isboss
            }
        end

        return {
            name = details.name,
            label = details.label,
            grades = grades,
        }
    elseif (Framework == "ESX") then
        -- Untested (Not needed for any active releases)
    end

    return {}
end

---@param details table
---@return table
-- Note that the grade level is one higher, this is to fit the indexing for LUA
function Functions.FormatGangDetails(details)
    if (Framework == "QBCore") then
        local grades = {}

        for key, value in pairs(details.grades) do
            grades[tonumber(key) + 1] = {
                name = value.name,
                label = value.name, -- No label, just set the name
                boss = value.isboss
            }
        end

        return {
            name = details.name,
            label = details.label,
            grades = grades,
        }
    elseif (Framework == "ESX") then
        -- Untested (Not needed for any active releases)
    end

    return {}
end

--[[
    Supports the following structure:

    {name = "test", label = "Test"}
    {{name = "test", label = "Test"}, {name = "test2", label = "Test2"}}
]]

---@param tbl table
---@param disableBundling boolean? -- Set to false to disable amount bundling, if you leave it as is or set to true, it will bundle the amounts together for all your items
---@return table
function Functions.FormatItemsFetch(tbl, disableBundling)
    local formatted = {}
    local itemIndexes = {} -- Key, index of items in the formatted table, keeps track and optimizes performance for bundling
    local isStarter = #tbl > 0
    local useBundle = disableBundling ~= true

    if (isStarter) then
        for _, itemData in pairs(tbl) do
            local item = Functions.FormatItemsFetch(itemData, disableBundling)
            local couldBundle = false

            if (useBundle) then
                local index = itemIndexes[item.name]
                if (index) then
                    formatted[index].amount = formatted[index].amount + item.amount
                    couldBundle = true
                end
            end

            if (not couldBundle) then
                if (useBundle) then
                    itemIndexes[item.name] = #formatted + 1
                end

                formatted[#formatted+1] = item
            end
        end

        return formatted
    end

    if (Framework == "QBCore") then
        formatted = {
            name = tbl.name,
            label = tbl.label,
            weight = tbl.weight,
            amount = tbl.amount,
        }
    elseif (Framework == "ESX") then
        -- Untested (Not needed for any active releases)
    end

    return formatted
end