BOARD = esp8266:esp8266:d1_mini
PORT = /dev/cu.usbserial-*
BAUDRATE = 74880

.PHONY: compile upload monitor clean

compile:
	mise exec -- arduino-cli compile --fqbn $(BOARD) led-sectional.ino

upload: compile
	mise exec -- arduino-cli upload -p $(PORT) --fqbn $(BOARD) led-sectional.ino

monitor:
	mise exec -- arduino-cli monitor -p $(PORT) -c baudrate=$(BAUDRATE)

clean:
	rm -rf build/
