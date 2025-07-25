import type { Config } from './.ghf.type'

export default {
  extends: ['https://michaelmass.github.io/ghf/ghf.default.json'],
  rules: [
    {
      type: 'delete',
      path: 'biome.json',
    },
  ],
} satisfies Config
