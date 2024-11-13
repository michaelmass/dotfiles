// https://github.com/johnste/finicky
// Ideas https://github.com/johnste/finicky/wiki/Configuration-ideas
// Configuration https://github.com/johnste/finicky/wiki/Configuration

const personalProfile = "Profile 2";
const workProfile = "Profile 3";

const defaultBrowser = {
  name: "Google Chrome",
  profile: personalProfile,
};

const workBrowser = {
  name: "Google Chrome",
  profile: workProfile,
};

const workUrls = [
  "botpress.productboard.com",
  "botpress.grafana.net",
  "botpress-rm.sentry.io",
  "botpresshq.slack.com",
];

const workUrl = ({ url }) => {
  if (workUrls.includes(url.host)) {
    return true;
  }

  if (url.host === "linear.app" && url.pathname.startsWith("/botpress")) {
    return true;
  }

  return false;
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
      browser: workBrowser,
    },
    {
      match: workUrl,
      browser: workBrowser,
    },
  ],
};