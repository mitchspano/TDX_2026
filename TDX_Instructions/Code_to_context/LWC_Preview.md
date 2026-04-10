# LWC Dev and Live Preview

## Overview

Preview Lightning Web Components locally with hot reload, seeing changes instantly without deploying. Test components in your org or directly in the IDE with real-time updates.

## Setup

Install lightning dev plugin

```sh
sf plugins install @salesforce/plugin-lightning-dev@latest
```

Enable Local Dev

From Setup, in the Quick Find box, enter Local Dev and then select Local Dev. Select Enable Local Dev to turn on the feature for all org users.

![local dev](../images/enable_local_dev.png)

## Preview a component in the org with hot reload

```sh
sf lightning dev app --name TDX_2026 --device-type desktop
```

Navigate to a `Job_Application__c` record.

Now, make a minor modification to the [`jobApplicationView.html`](../../force-app/main/default/lwc/jobApplicationView/jobApplicationView.html) and it should be immediately visible without a deploy.

![local dev in org](../images/local_dev_org.png)

Now open up Agentforce vibes and ask it to make a modification to the LWC and play with it live!

Press `command + c` to stop the preview.

## Preview a component in the IDE

Right click [`minesweeper.html`](../../force-app/main/default/lwc/minesweeper/minesweeper.html) and click `SFDX: Open in Lightning Preview`.

This should open a preview of the minesweeper component

![local dev in org](../images/local_minesweeper.png)

Now open up Agentforce vibes and ask it to make a modification to the LWC and play with it live!

## FAQs

| Question                                     | Response                                                                                     |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Do I need to deploy changes to see previews? | No, HTML/CSS/basic JS updates automatically. Wire adapters and @api properties need redeploy |
| What types of changes reload automatically?  | HTML attributes, CSS, new component references, JavaScript logic, new files (Spring '25+)    |
| What changes require manual refresh?         | @api properties, wire adapters, .js-meta.xml, @salesforce imports, service component library |
| Can I preview Aura components?               | No, Local Dev only supports Lightning Web Components                                         |
| Can I use Local Dev on production orgs?      | No, only sandboxes and scratch orgs are supported                                            |
| How do I preview on mobile devices?          | iOS: `--device-type ios` (Mac/Xcode only), Android: `--device-type android` (Android Studio) |
| Why isn't my preview updating?               | Run `sf update` to get latest CLI, or redeploy complex changes and restart preview           |
| Can I preview multiple components at once?   | Yes, run multiple `sf lightning dev` commands in separate terminals                          |
