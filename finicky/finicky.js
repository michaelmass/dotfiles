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
  "app.botpress.cloud",
  "app.botpress.dev",
  "botpress-aws.awsapps.com",
  "botpress-rm.sentry.io",
  "botpress.bamboohr.com",
  "botpress.grafana.net",
  "botpress.pagerduty.com",
  "botpress.productboard.com",
  "botpress.retool.com",
  "botpresshq.slack.com",
  "sauron.botpress.cloud",
  "sauron.botpress.dev",
  "studio.botpress.cloud",
  "studio.botpress.dev",
  "app.krisp.ai",
  "cursor.com",
  "device.sso.us-east-1.amazonaws.com",
  "google.zoom.us",
  "meet.google.com",
  "www.cursor.com",
  "us-east-1.console.aws.amazon.com",
  "app.floatfinancial.com",
];

const workOrgUrls = {
  "cloud.digitalocean.com": "e869a5",
  "console.anthropic.com": "#botpress",
  "dashboard.heroku.com": "/botpress-internal/",
  "dnsimple.com": "/78774/",
  "github.com": "/botpress/",
  "insights.hotjar.com": "#botpress",
  "linear.app": "/botpress/",
  "supabase.com": "zxuehanuqnemevxljlpy",
  "trello.com": "/botpress1/",
  "vercel.com": "botpress-team",
  "platform.openai.com": "#botpress",
  "huggingface.co": "/botpress-hq/",
  "admin.atlassian.com": [
    "907bakbd-da41-19ab-k502-2c857bj2kd6b",
    "d58c9551-127c-475c-a274-1b645601c099",
  ],
  "grafana.com": "botpress",
  "dash.cloudflare.com": "1bf6525091ec55ebe4935a38ab001420",
  "app.segment.com": "/botpress-production/",
  "mixpanel.com": "2313408",
  "depot.dev": "w8z3zskrwb",
  "manage.statuspage.io": "dxgcnnf1xq2r",
  "miro.com": ["3458764561695270325", "3458764558992614189"],
  "console.upstash.com": "fe84ae13-9b27-4071-bae8-3157c5f8623c",
};

const workUrl = ({ url }) => {
  if (url.username === "botpress") {
    return true;
  }

  if (workUrls.includes(url.host)) {
    return true;
  }

  const org = workOrgUrls[url.host];

  if (org) {
    const fullpath =
      url.pathname + (url.hash ? `#${url.hash}` : "") + url.search;

    const orgs = typeof org === "string" ? [org] : org;

    for (const org of orgs) {
      console.log(fullpath, org);

      if (fullpath.includes(org)) {
        return true;
      }
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
