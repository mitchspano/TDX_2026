# TDX 2026 Booth Demo: Salesforce Developer Productivity

**Streamline development with the CLI and IDE Extensions**
**Turn Context into Code with Agentforce Vibes**

This repository contains demo materials for the TDX 2026 booth showcasing the latest innovations in Salesforce developer tooling. Our focus is on features that dramatically improve developer productivity, reduce friction, and accelerate the development lifecycle.

## Featured Innovations

### Apex Log Extension & Trace Flag Management
We’ve extracted logging into a dedicated Apex Log extension. Developers can now search for any user in the org to create Trace Flags, define reusable Debug Levels, and monitor active traces via a new Status Bar indicator—all without leaving the IDE.

**Key Benefits:**
- Unified logging management directly in VS Code
- Quick user search for Trace Flag creation
- Reusable Debug Level templates
- Real-time trace monitoring via Status Bar

### "RunRelevantTests" Deployment Level
Stop waiting for hours for global test suites. Using `sf project deploy start --test-level RunRelevantTests`, the CLI uses dependency analysis to identify and run only the Apex tests impacted by your specific metadata changes.

**Key Benefits:**
- Dramatically reduced deployment times
- Smart dependency analysis
- Run only what matters
- Faster CI/CD pipelines

### Query Plan & SOQL Editor Enhancements
Performance tuning is now native to the IDE. The Query Plan view is now available directly in the SOQL text editor, allowing developers to see query costs and index usage immediately. Plus, the new `SFDX: Create SOQL Query` command streamlines the "scratchpad" querying experience.

**Key Benefits:**
- Inline query performance metrics
- Real-time index usage visibility
- Integrated Query Plan analysis
- Streamlined query development workflow

### Redesigned Apex Test Explorer
A complete modernization of the Test Explorer. Tests are now organized in a clear hierarchy (Namespace → Package → Class → Method). It handles 1GP and 2GP package resolution automatically, making it significantly easier to manage testing in complex, multi-package architectures.

**Key Benefits:**
- Intuitive hierarchical organization
- Automatic package resolution (1GP & 2GP)
- Simplified navigation in large codebases
- Better support for modular architectures

### 8. JIT Lightning Local Dev
Local development is now "Just-In-Time." When you run `sf lightning dev`, the CLI automatically installs the necessary plugins if they are missing. Combined with the Salesforce Live Preview extension, it provides the fastest way to iterate on LWCs.

**Key Benefits:**
- Zero-config local development
- Automatic plugin installation
- Instant LWC iteration
- Seamless developer onboarding

### New Org Browser & Refreshed Org Picker
The "Legacy" org browser is officially gone, replaced by a faster, more stable version. The Org Picker has also been refreshed with visual indicators (tree for Dev Hub, leaf for Scratch Org) and better categorization to help developers manage dozens of connections effortlessly.

**Key Benefits:**
- Improved performance and stability
- Visual org type indicators
- Better multi-org management
- Intuitive categorization

### Metadata XML Hover & Documentation
To help with the "toil" of manual XML editing, the IDE now features hover documentation and autocomplete for metadata XML files. It’s powered by a weekly scrape of the Metadata API Developer Guide, ensuring the documentation in your IDE is always up to date.

**Key Benefits:**
- Context-aware XML editing
- Inline documentation on hover
- Intelligent autocomplete
- Always current with latest API docs

## Getting Started

To explore these features yourself:

1. Install the latest [Salesforce Extensions for VS Code](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode)
2. Update to the latest [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli)
3. Clone this repository and authorize to your scratch org or sandbox

## Resources

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)

## Booth Contact

Mitch Spano - [mspano@salesforce.com](mailto:mspano@salesforce.com)
