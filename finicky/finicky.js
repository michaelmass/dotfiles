// https://github.com/johnste/finicky
// Ideas https://github.com/johnste/finicky/wiki/Configuration-ideas
// Configuration https://github.com/johnste/finicky/wiki/Configuration

const personalProfile = "Default";
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
  "botpress-aws.awsapps.com",
  "device.sso.us-east-1.amazonaws.com",
  "app.botpress.cloud",
  "app.botpress.dev",
  "app.krisp.ai",
  "botpress.bamboohr.com",
  "meet.google.com",
  "linear.app/botpress",
  "google.zoom.us",
  "sauron.botpress.cloud",
  "sauron.botpress.dev",
  "www.cursor.com",
  "botpress.retool.com",
];

const workOrgUrls = {
  "vercel.com": "botpress-team",
  "supabase.com": "zxuehanuqnemevxljlpy",
  "github.com": "/botpress/",
  "cloud.digitalocean.com": "e869a5",
};

const workUrl = ({ url }) => {
  if (url.username === "botpress") {
    return true;
  }

  if (workUrls.includes(url.host)) {
    return true;
  }

  if (workOrgUrls[url.host]) {
    const fullpath = url.pathname + url.hash + url.search;

    if (fullpath.includes(workOrgUrls[url.host])) {
      return true;
    }
  }

  if (url.host === "linear.app" && url.pathname.startsWith("/botpress")) {
    return true;
  }

  return false;
};

export default {
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
      match: ({ url }) => workUrl({ url }),
      browser: workBrowser,
    },
  ],
};
