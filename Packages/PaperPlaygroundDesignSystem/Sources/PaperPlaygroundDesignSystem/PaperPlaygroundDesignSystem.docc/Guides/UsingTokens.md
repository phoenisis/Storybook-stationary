# Using Tokens

Build layouts and typography with semantic tokens instead of hard-coded values.

## Scalar Tokens

Use `CGFloat` and `Double` conveniences from ``PaperPlaygroundTokens``:

```swift
VStack(spacing: .l) {
  Text("Paper Playground")
    .font(.appTitle)

  RoundedRectangle(tokenRadius: .cornerXXL)
    .fill(Color.surface)
    .frame(height: .swatchHeight)
}
.padding(.horizontal, .xxl)
.padding(.vertical, .l)
```

## Typography Tokens

Available font aliases include:

- ``Font/appTitle``
- ``Font/sectionTitle``
- ``Font/displayHero``
- ``Font/headingL``
- ``Font/metricValue``
- ``Font/bodyM``
- ``Font/bodyS``
- ``Font/labelM``
- ``Font/labelS``

## Color And Gradient Tokens

Prefer semantic aliases:

```swift
Color.appPrimary
Color.appSecondary
Color.tertiary
Color.background
Color.onSurface
```

And gradients:

```swift
LinearGradient.paperSurfaceFade
LinearGradient.primarySticker
LinearGradient.tertiarySticker
```

## Convenience Initializers

Use token-native initializers for readability:

- ``EdgeInsets/init(horizontal:vertical:)``
- ``RoundedRectangle/init(tokenRadius:style:)``
- ``StrokeStyle/init(tokenLineWidth:dash:)``
