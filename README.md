# NetStone
NetStone is a way to use a opencomputer network to send and recieve redstone in and outputs

## Host
The host pc is the pc that controls all the transceivers using the a local network and the NetStone api

### API
The netstone processor file can be used as an API for your own projects \
to use NetStone jus use: `netStone = require("./"netstone location"/netStoneProcessor")`

### Functions
netStone.setPCsNeeded(`number`) //set the pc amount of transceiver pcs \
netStone.setProtocol(`string`) //set the protocol the system comunicates over `(default: "networkRedstone")` \
netStone.setHost(`string`) // set the host name so the transceivers know which pc they need to respond to `(default: "Main PC")` \
netStone.connect() //runs the start function to get and connect to all transceivers \
netStone.getReceiverData() //gets data from all receivers.  \
example: \
`local data = netStone.getRecieverData()` \
`print(data.redstoneInputName) // returns true or false` \
netStone.sendTransmitterData(`redstone output name`, `true/false`) //sets the output to redstone strength 15 (true) or 0 (false)


## Transceivers
A transceiver can either be a receiver or transmitter \
A receiver gets only has redsone inputs \
A transmitter only has redstone outputs \
the transceivers do not have an api just a script that needs to be ran directly

### Setup
To setup a tranceiver you need to set : \
the type in `local type = "transmitter/receiver"` \
the sides and names `local sideAndName = ({` \
` side= "left/right/up/down/front/back"` \
` name = name to get/set it later`
`})`
## To Do
 - change getReceiverData() to a specific input \
 - create getAllReceiverData() to replace the old getRecieverData() \
 - add analog redstone mode \
 - set transceiver input and output per side instead of per pc