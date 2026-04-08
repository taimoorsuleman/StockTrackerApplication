# StockPriceTrackerApp

StockPriceTrackerApp is a SwiftUI iOS application that simulates live stock price updates using a WebSocket echo service. The app displays multiple stock symbols, supports sorting, and keeps the list and detail screens synchronized through a shared data source.


## Table of Contents

- [Demo](#demo)
- [Features](#features)
- [Architecture](#architecture)
- [Design Choices](#design-choices)
- [Prerequisites](#prerequisites)
- [Building and Running](#building-and-running)
- [Tests](#Tests)

## Demo
[Watch the demo here](https://drive.google.com/file/d/17NE58QFIe6v5tfkIawMyfE8lDBUMgrrR/view?usp=sharing)
_Watch the demo video to see the core features of Stock Tracker App in action._



## Features

- Display 25 stock symbols in a scrollable list
- Simulated live price updates
- Sort by Stock, Price, Change, and Change %
- Start Feed and Stop Feed controls
- Connection status indicator
- Stock detail screen with live synced data
- Inline error messaging for feed related issues

## Architecture

The app follows MVVM with protocol based dependency injection and a layered structure.

### Main Layers

- App  
  Entry point and dependency container

- Presentation  
  SwiftUI views, ViewModels, UI components, and layout models

- Domain  
  Core entities and repository contracts

- Data  
  Repository implementation, stock catalog, feed service, and random price generator

- Core  
  WebSocket client abstraction and implementation

## Design Choices

1. **Shared Repository**
   A single shared repository keeps the list and detail screens synchronized during live updates.

2. **WebSocket Echo Flow**
   Simulated price ticks are generated locally, sent to the echo socket, and applied back to the repository from the echoed response.

3. **Protocol Oriented Design**
   Protocols are used for the repository, feed service, WebSocket client, random price generator, and catalog data source to improve testability and separation of concerns.

4. **Inline Status Messaging**
   Connection states such as Connected, Connecting..., and Disconnected are shown inline instead of using repeated popups.
   
   
## Prerequisites

- **Xcode:** Version 26.3 or later.
- **iOS Deployment Target:** iOS 26.2 or later.
- **Swift:** Version 5.


## Building and Running

1. Open the project in Xcode
2. Select an iOS simulator
3. Build and run the app
4. Tap Start Feed to begin live updates

## Tests

Unit tests currently cover:

- Stock price calculations
- Random price generation rules
- Stock catalog loading
