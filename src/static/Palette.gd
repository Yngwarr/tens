class_name Palette
extends Object

# via https://lospec.com/palette-list/vibe-20

static var colors := [
    Color.from_string("#ffeee5", Color.WHITE),

    Color.from_string("#ffd09c", Color.WHITE),
    Color.from_string("#07e5a0", Color.WHITE),
    Color.from_string("#a7ff19", Color.WHITE),
    Color.from_string("#660b61", Color.WHITE),
    Color.from_string("#0099db", Color.WHITE),
    Color.from_string("#84240f", Color.WHITE),
    Color.from_string("#f77622", Color.WHITE),
    Color.from_string("#ffb700", Color.WHITE),
    Color.from_string("#007a49", Color.WHITE),

    Color.from_string("#96a3b0", Color.WHITE),
    Color.from_string("#da2424", Color.WHITE),
    Color.from_string("#fee761", Color.WHITE),
    Color.from_string("#43bd35", Color.WHITE),
    Color.from_string("#ff7373", Color.WHITE),

    Color.from_string("#124e89", Color.WHITE),
    Color.from_string("#5a7088", Color.WHITE),
    Color.from_string("#3e4a6d", Color.WHITE),
    Color.from_string("#b94f38", Color.WHITE),
    Color.from_string("#1c162d", Color.WHITE),
]

static func color(id: int) -> Color:
    return colors[id % len(colors)]
