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
  "app.floatfinancial.com",
  "app.krisp.ai",
  "botpress-aws.awsapps.com",
  "botpress-rm.sentry.io",
  "botpress.bamboohr.com",
  "botpress.grafana.net",
  "botpress.pagerduty.com",
  "botpress.productboard.com",
  "botpress.retool.com",
  "botpress.workable.com",
  "botpresshq.slack.com",
  "cursor.com",
  "dashboard.ngrok.com",
  "device.sso.us-east-1.amazonaws.com",
  "google.zoom.us",
  "meet.google.com",
  "sauron.botpress.cloud",
  "sauron.botpress.dev",
  "studio.botpress.cloud",
  "studio.botpress.dev",
  "us-east-1.console.aws.amazon.com",
  "www.cursor.com",
];

const workOrgUrls = {
  "admin.atlassian.com": [
    "907bakbd-da41-19ab-k502-2c857bj2kd6b",
    "d58c9551-127c-475c-a274-1b645601c099",
  ],
  "app.docker.com": "botpress",
  "app.segment.com": "/botpress-production/",
  "cloud.digitalocean.com": "e869a5",
  "console.anthropic.com": "#botpress",
  "console.cloud.google.com": "782387313636",
  "console.upstash.com": "fe84ae13-9b27-4071-bae8-3157c5f8623c",
  "dash.cloudflare.com": "1bf6525091ec55ebe4935a38ab001420",
  "dashboard.heroku.com": "/botpress-internal/",
  "depot.dev": "w8z3zskrwb",
  "dnsimple.com": "/78774/",
  "github.com": "/botpress/",
  "grafana.com": "botpress",
  "groups.google.com": "botpress.com",
  "huggingface.co": "/botpress-hq/",
  "insights.hotjar.com": "#botpress",
  "linear.app": "/botpress/",
  "manage.statuspage.io": "dxgcnnf1xq2r",
  "miro.com": [
    "3458764561695270325",
    "3458764558992614189",
    "3458764559398815584",
  ],
  "mixpanel.com": "2313408",
  "platform.openai.com": "#botpress",
  "supabase.com": "zxuehanuqnemevxljlpy",
  "trello.com": "/botpress1/",
  "vercel.com": "botpress-team",
  "www.figma.com": "1086003688753602071",
  "zapier.com": ["3761911"],
  "developer.zapier.com": "179950",
  "healthchecks.io": "016ab399-0bcf-4f0f-a7fe-0ae299edb1d6",
};

const workUrl = ({ url }) => {
  if (url.username === "botpress") {
    return true;
  }

  if (workUrls.includes(url.host)) {
    return true;
  }

  const fullpath = url.pathname + (url.hash ? `#${url.hash}` : "") + url.search;

  if (fullpath.includes("#botpress")) {
    return true;
  }

  const org = workOrgUrls[url.host];

  if (org) {
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
