// Inspiration: https://github.com/denolfe/dotfiles/tree/main/phoenix

Phoenix.set({
  daemon: true,
  openAtLogin: true,
});

const hyperKey: Phoenix.ModifierKey[] = ["control", "shift", "option", "cmd"];

const bindApp = (key: string, appName: string) => {
  Key.on(key, hyperKey, () => {
    App.launch(appName, { focus: true });
  });
};

bindApp(";", "Ghostty");
bindApp("w", "Arc");
bindApp("e", "Zed");
bindApp("f", "Finder");
bindApp("c", "Beeper Desktop");
bindApp("a", "Notion Calendar");
bindApp("m", "Missive");
bindApp("t", "Microsoft Teams");
bindApp("g", "Chatwise");
