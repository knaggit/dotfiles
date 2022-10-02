// Finicky on GitHub: https://github.com/johnste/finicky
// Search for integration on GitHub: https://github.com/search?q=filename%3A.finicky.js+Spotify&type=Code

module.exports = {
  defaultBrowser: "Firefox",
  options: {
    hideIcon: true,
    checkForUpdate: false
  },
  handlers: [
    {
      match: "meet.google.com/*",
      browser: "Chromium"
    },
    {
      match: "open.spotify.com/*",
      browser: "Spotify",
    },
    {
      match: "linear.app/plan3t/*",
      browser: "Linear",
    },
    {
      match: "*.zoom.us/j/*",
      browser: "us.zoom.xos",
    },
    {
      match: /notion\.so\/.*[a-f0-9]{32}/,
      browser: "Notion"
    }
  ]
}
