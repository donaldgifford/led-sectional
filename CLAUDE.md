# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LED Sectional is an ESP8266-based Arduino project that displays real-time aviation weather (METAR) data on a physical sectional map using addressable LEDs. Each LED represents an airport and is colored according to flight conditions (VFR, MVFR, IFR, LIFR).

## Build and Upload

This project uses mise to manage arduino-cli. Run `mise install` to set up the toolchain.

```bash
# Compile
mise exec -- arduino-cli compile --fqbn esp8266:esp8266:d1_mini led-sectional.ino

# Upload to connected ESP8266
mise exec -- arduino-cli upload -p /dev/cu.usbserial-* --fqbn esp8266:esp8266:d1_mini led-sectional.ino
```

**Important**: Use ESP8266 Core version 2.7.4 or earlier for compatibility.

### Required Libraries
- ESP8266WiFi (included with ESP8266 core)
- FastLED@3.6.0 (newer versions incompatible with ESP8266 core 2.7.4)
- Adafruit_Sensor and Adafruit_TSL2561_U (only if using TSL2561 light sensor)

## Architecture

The project is a single-file Arduino sketch (`led-sectional.ino`) with these main components:

1. **Configuration Block (lines 8-50)**: All user-configurable settings including:
   - `NUM_AIRPORTS`: Number of LEDs in the strip
   - `airports` vector: Maps LED positions to airport identifiers (ICAO codes) or special values (NULL, VFR, MVFR, etc. for legend LEDs)
   - WiFi credentials, brightness, wind thresholds, update intervals
   - Light sensor configuration (analog or TSL2561 digital)

2. **Main Loop**: Manages WiFi connection, triggers METAR fetches at `REQUEST_INTERVAL`, and handles lightning animation for airports with thunderstorms.

3. **`getMetars()`**: Fetches METAR data via HTTPS from aviationweather.gov, parses XML response incrementally (memory-constrained), extracts flight category, wind, and weather conditions.

4. **`doColor()`**: Maps flight conditions to LED colors:
   - Green = VFR
   - Yellow = VFR with high winds (>25kt) or WVFR (legend)
   - Blue = MVFR
   - Red = IFR
   - Magenta = LIFR

## Key Configuration Notes

- The `airports` vector index corresponds to LED position (0-indexed internally, but comments show 1-indexed)
- Use "NULL" for unused LED positions
- Use "VFR", "MVFR", "IFR", "LIFR", "WVFR" entries to create a color legend on the map
- `DATA_PIN 14` for kits shipped after March 2019; use `5` for earlier kits
- WiFi credentials must be set in the source file before upload
