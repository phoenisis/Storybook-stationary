# Using Components

Compose screens quickly with reusable Paper Playground components.

## Available Components

- ``SectionHeader``
- ``PaletteSwatch``
- ``StickerStatePill``
- ``ProgressDot``
- ``SpiralNotebookCard``
- ``PaperGrainOverlay``

## Example

```swift
VStack(alignment: .leading, spacing: .l) {
  SectionHeader(icon: "paintpalette.fill", title: "Theme", color: .tertiary)

  PaletteSwatch(name: "Primary", color: .appPrimary, textColor: .white)

  HStack(spacing: .m) {
    ProgressDot(state: .filled)
    ProgressDot(state: .current)
    ProgressDot(state: .empty)
  }

  SpiralNotebookCard(
    title: "Lesson",
    description: "Tokenized spacing, typography, and semantic color usage."
  )
}
.padding(.xxl)
.paperCard()
.background(Color.background)
```

## Style Combinators

Combine components with style utilities:

- ``StickerDepthButtonStyle``
- ``View/paperCard()``
- ``View/notebookShadow()``
- ``Animation/appButtonPress``
- ``Animation/appNavigation``
