// https://github.com/johnste/finicky
// Ideas https://github.com/johnste/finicky/wiki/Configuration-ideas
// Configuration https://github.com/johnste/finicky/wiki/Configuration

const personalProfile = "Profile 2";
const workProfile = "Profile 3";

const defaultBrowser = {
  name: "Google Chrome",
  profile: personalProfile,
};

module.exports = {
  defaultBrowser,
  options: {
    hideIcon: false,
    checkForUpdate: false,
  },
  handlers: [
    {
      match: ({ url }) => url.username === "personal",
      browser: defaultBrowser,
    },
    {
      match: ({ url }) => url.username === "botpress",
      browser: {
        name: "Google Chrome",
        profile: workProfile,
      },
    },
  ],
};
