#!/bin/bash

# Build and Run Script for DailyMenu iOS App

set -e

echo "🍽️  Building DailyMenu iOS App..."

# Build the project
xcodebuild -project DailyMenu.xcodeproj \
  -scheme DailyMenu \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -derivedDataPath ./build \
  clean build

echo "✅ Build successful!"

# Find the built app
APP_PATH=$(find ./build/Build/Products/Debug-iphonesimulator -name "DailyMenu.app" -type d | head -n 1)

if [ -z "$APP_PATH" ]; then
    echo "❌ Could not find DailyMenu.app"
    exit 1
fi

echo "📱 Found app at: $APP_PATH"

# Boot the simulator if not already running
echo "🚀 Booting iOS Simulator..."
xcrun simctl boot "iPhone 17 Pro" 2>/dev/null || echo "Simulator already booted"

# Open Simulator app
open -a Simulator

# Install the app
echo "📲 Installing app..."
xcrun simctl install booted "$APP_PATH"

# Launch the app
echo "▶️  Launching DailyMenu..."
xcrun simctl launch --console booted com.example.DailyMenu

echo "✅ DailyMenu is now running!"
