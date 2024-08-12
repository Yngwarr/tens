class_name Palette
extends Object

# via https://lospec.com/palette-list/vibe-20

static var colors := [
    Color.from_string("#ffeee5", Color.WHITE),

    Color.from_string("#68e4aa", Color.WHITE),
    Color.from_string("#001de4", Color.WHITE),
    Color.from_string("#e4c200", Color.WHITE),
    Color.from_string("#e43f32", Color.WHITE),
    Color.from_string("#e430d5", Color.WHITE),
    Color.from_string("#63bee4", Color.WHITE),
    Color.from_string("#e4891e", Color.WHITE),
    Color.from_string("#80e462", Color.WHITE),
    Color.from_string("#9832e4", Color.WHITE),

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
