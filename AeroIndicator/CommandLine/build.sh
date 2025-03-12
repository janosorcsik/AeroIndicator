#/bin/sh

swiftc -target arm64-apple-macos12 main.swift ../Socket.swift -o aeroIndicator_arm64
swiftc -target x86_64-apple-macos12 main.swift ../Socket.swift -o aeroIndicator_x86_64

lipo -create -output aeroIndicator_universal aeroIndicator_x86_64 aeroIndicator_arm64
