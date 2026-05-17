.pragma library

var palettes = {
    green:  {fg: "#79ff66", dim: "#3e8f37", bg: "#061407", accent: "#a8ff88"},
    amber:  {fg: "#ffd66f", dim: "#9b7f38", bg: "#1a1203", accent: "#ffe4a3"},
    blue:   {fg: "#73c8ff", dim: "#3a6990", bg: "#04111a", accent: "#9adaff"},
    white:  {fg: "#e8f5e8", dim: "#8a9a8a", bg: "#0a0c0a", accent: "#ffffff"},
    red:    {fg: "#ff7f7f", dim: "#9a4141", bg: "#1b0606", accent: "#ffabab"},
    pink:   {fg: "#ff9fd0", dim: "#9a5a7d", bg: "#1a0811", accent: "#ffd1e9"}
};

function palette(name) {
    return palettes[name] || palettes.green;
}

