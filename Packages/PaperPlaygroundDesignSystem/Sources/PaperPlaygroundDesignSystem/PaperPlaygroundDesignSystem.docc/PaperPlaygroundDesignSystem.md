# ``PaperPlaygroundDesignSystem``

A SwiftUI-first design system for the Paper Playground visual language.

## Overview

`PaperPlaygroundDesignSystem` provides reusable foundations for:

- semantic color and gradient usage
- typography and scalar tokens
- reusable components and modifiers
- shared motion presets
- opt-in navigation and tab styling helpers
- UIKit appearance bootstrapping on iOS

Use this module to keep visual semantics centralized and feature code clean.

## Topics

### Getting Started

- <doc:ThemeAndAppearance>

### Tokens

- <doc:UsingTokens>
- ``PaperPlaygroundTokens``
- ``Font``
- ``Color``
- ``LinearGradient``
- ``Animation``

### Components

- <doc:UsingComponents>
- ``SectionHeader``
- ``PaletteSwatch``
- ``StickerStatePill``
- ``ProgressDot``
- ``SpiralNotebookCard``
- ``PaperGrainOverlay``

### Styling

- ``StickerDepthButtonStyle``
- ``PaperCardModifier``
- ``NotebookShadowModifier``
- ``View/paperCard()``
- ``View/notebookShadow()``
- ``View/paperPlaygroundTabBarStyle()``
- ``View/paperPlaygroundNavigationLargeTitleStyle(_:)``

### UIKit Integration

- ``PaperPlaygroundThemeInstaller``
- ``PaperPlaygroundThemeInstaller/installUIKitAppearance()``
