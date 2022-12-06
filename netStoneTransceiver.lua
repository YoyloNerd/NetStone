local modem = peripheral.find("modem")
rednet.open(peripheral.getName(modem))

local localID = os.getComputerID()

local protocol = "networkRedstone"
local host = "Main PC"

rednet.host(protocol, protocol .. ":" .. localID)

local type = "transmitter"
local sideAndName = {{
    side = "",
    name = ""
}}

local HostPC = 0
local hostPCSet = false

local function connect()
    -- await host PC
    print("Awaiting host PC")
    while not hostPCSet do
        -- await starting message
        local id, message = rednet.receive(protocol, 5)
        if message == ("This IS " .. host .. " #" .. localID .. "!") then
            -- set host PC
            HostPC = id
            hostPCSet = true
            -- send configured data
            rednet.send(HostPC, {
                id = localID,
                type = type,
                sideData = sideAndName
            }, protocol)
        end
    end
    print("Connected to host PC:" .. HostPC)
end

local function update()
    -- main loop
    local id, message = rednet.receive(protocol, 5)
    if id == HostPC then
        if message == nil then
            return
        end
        if type == "transmitter" then
            -- get data end set output
            for _, side in pairs(sideAndName) do
                if side.name == message.name then
                    redstone.setOutput(side.side, message.state)
                end
            end
        elseif type == "receiver" then
            if message == "get" then
                -- get input and send data
                for _, side in pairs(sideAndName) do
                    rednet.send(id, {
                        name = side.name,
                        state = redstone.getInput(side.side)
                    }, protocol)
                end
                rednet.send(id, "done", protocol)
            end
        end
    end
    return 1
end

connect()

while true do
    update()
end
