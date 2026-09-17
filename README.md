## Things to add

- Send WaL packet to PC
- Connect to PC to send diagnostics to ESP32 or Oracle Server
- Make something to connect to from Oracle server so I can say turn PC on
- Connect to Oracle server to send info when PC stops responding

## Oracle Server
- Esp32 establishes the connection with the server
- Authorises it is the device it expects
- Then Esp32 waits for commands from the server
- The server is then requested by some other thing to say send wake to esp32

### Further Future

- Design PCB board that can connect to motherboard POWER/RESET Header so ESP32 can send those signals instead
- Buy basics Breabdoard and resistors and other parts needed (Octocouplers/Transistory (Find pros/cons, also how octocouplers work))
- CAD design a PCIE holder thing I forget the name to print so wires can be fed through that 
- Find headers on the motherboard

### Niceties

- A screen from the ESP32 with diags of the PC
- Ethernet for the ESP32 so internet connection is less risky 