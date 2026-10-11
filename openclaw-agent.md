# OpenClaw Agent: Token Scanner

Scores one token contract from Hive Mind. The web app stays the place you paste
an address by hand. This wrapper asks that same app to run the scan, including
its plain-English summary.

## Run

```
powershell -File run_trust.ps1 -Command status
powershell -File run_trust.ps1 -Command scan 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
```

`status` checks that the app is up. `scan` needs the app already running at
http://100.118.254.40:5179 and scores one address. A scan reads market, holder,
and X data, then asks the language model for the short brief.

## Isolation

API keys stay in `trust-score/.env.local`. Do not print them. Do not send that
file to other agents.
