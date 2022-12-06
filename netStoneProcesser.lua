local modem = peripheral.find("modem")
rednet.open(peripheral.getName(modem))

-- local args = {...}
-- local debug = false

-- if args[1] == "debug" then
--     debug = true
-- end

local protocol = "networkRedstone"
local host = "Main PC"

local computers = {rednet.lookup(protocol)}
local transmitters = {}
local receivers = {}

local PCsNeeded = 2

local function setPCsNeeded(amount)
    PCsNeeded = amount
end
local function setProtocol(newProtocol)
    protocol = newProtocol
end
local function setHost(newHost)
    host = newHost
end

local function connect()
    while #computers < PCsNeeded do
        computers = {rednet.lookup(protocol)}
        print("<NETSTONE> " .. #computers .. " computers loaded (need " .. PCsNeeded .. ")")
        sleep(1)
    end
    print("<NETSTONE> " .. #computers .. " computers available to chat")
    for _, computer in pairs(computers) do
        print("<NETSTONE> " .. "Computer #" .. computer)
        print("<NETSTONE> " .. "sending message")
        rednet.send(computer, "This IS Main PC #" .. computer .. "!", protocol)
        local id, setupInfo = rednet.receive(protocol, 5)
        if setupInfo.type == "transmitter" then
            transmitters[#transmitters + 1] = setupInfo
            for _, side in pairs(transmitters[#transmitters].sideData) do
                print("<NETSTONE> " .. transmitters[#transmitters].type .. " " .. side.name .. " " .. side.side)
            end
        elseif setupInfo.type == "receiver" then
            receivers[#receivers + 1] = setupInfo
            for _, side in pairs(receivers[#receivers].sideData) do
                print("<NETSTONE> " .. receivers[#receivers].type .. " " .. side.name .. " " .. side.side)
            end
        end
    end
end

local function getReceiverData()
    local data = {}
    for _, pc in pairs(receivers) do
        local recievingData = true
        -- send request for all input data
        rednet.send(pc.id, "get", protocol)
        while recievingData do
            local id, message = rednet.receive(protocol)
            if message == "done" then
                recievingData = false
                break
            end
            data[#data + 1] = message
        end
    end
    return data
end

local function sendTransmitterData(name, setState)
    print("<NETSTONE> " .. "Transmitting " .. name .. " " .. tostring(setState))
    for _, pc in pairs(transmitters) do
        for _, side in pairs(pc.sideData) do
            if side.name == name then
                rednet.send(pc.id, {
                    name = name,
                    state = setState
                }, protocol)
                return
            end
        end
    end
end

-- if debug then
--     connect()
--     local curOn = 1
--     while true do
--         local data = getReceiverData()
--         for _, side in pairs(data) do
--             print("<NETSTONE> " .. side.name .. " " .. tostring(side.state))
--         end
--         if #transmitters > 0 then
--             for i = 1, #transmitters do
--                 if curOn == i then
--                     sendTransmitterData(transmitters[1].sideData[i].name, true)
--                 else
--                     sendTransmitterData(transmitters[1].sideData[i].name, false)
--                 end
--             end
--         end
--         curOn = curOn + 1
--         if curOn > #transmitters then
--             curOn = 1
--         end
--         sleep(1)
--     end
-- end

return {
    connect = connect,
    getReceiverData = getReceiverData,
    sendTransmitterData = sendTransmitterData,
    setPCsNeeded = setPCsNeeded,
    setProtocol = setProtocol,
    setHost = setHost
}
