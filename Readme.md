# ethers.js v5 -> v6 Migration Workflow

This repository contains a codemod workflow to help migrate from `ethers.js` v5 to v6 with the following approach:

- **deterministic first**
- **source-only**
- **whitelist-based**
- **audit/report** for edge cases

The target is not just a one-time demo, but a reusable workflow that can be applied to many public repositories.

## Where to Start

- Technical quickstart: [README codemod](codemods/ethers-v5-to-v6/README.md)
- Step-by-step demo: [demo-workflow-ethers-v5-ke-v6.md](docs/demo-workflow-ethers-v5-ke-v6.md)
- Idea context and scope: [ide-proyek.md](docs/ide-proyek.md)

## Currently Supported

The workflow is currently safe to use for the following subset of patterns:

- `ethers.utils.parseEther` -> `ethers.parseEther`
- `ethers.utils.parseUnits` -> `ethers.parseUnits`
- `ethers.utils.formatEther` -> `ethers.formatEther`
- `ethers.utils.formatUnits` -> `ethers.formatUnits`
- `ethers.utils.id` -> `ethers.id`
- `ethers.utils.getAddress` -> `ethers.getAddress`
- `ethers.utils.isAddress` -> `ethers.isAddress`
- `ethers.utils.keccak256` -> `ethers.keccak256`
- `ethers.providers.JsonRpcProvider` -> `ethers.JsonRpcProvider`
- `ethers.providers.AlchemyProvider` -> `ethers.AlchemyProvider`
- `ethers.providers.InfuraProvider` -> `ethers.InfuraProvider`
- `ethers.providers.EtherscanProvider` -> `ethers.EtherscanProvider`
- `ethers.providers.WebSocketProvider` -> `ethers.WebSocketProvider`
- `ethers.providers.StaticJsonRpcProvider` -> `ethers.StaticJsonRpcProvider`
- `ethers.providers.JsonRpcBatchProvider` -> `ethers.JsonRpcBatchProvider`
- `ethers.providers.FallbackProvider` -> `ethers.FallbackProvider`

## Not Automatically Changed

The following sections are intentionally not auto-fixed:

- `ethers.providers.Web3Provider` -> `ethers.BrowserProvider`
- `BigNumber` -> `BigInt`
- deploy flows that might need `waitForDeployment()`
- ESM/CJS and build config changes
- `ethers.utils.*` patterns that are not yet in the whitelist

## Minimum Requirements

- `Node.js` and `npx`
- `git`
- internet access to install `codemod` via `npx`
- a terminal that can run standard shell commands
- for the audit script: `PowerShell`

## Repository Structure

```text
.
├── codemods/
│   └── ethers-v5-to-v6/
├── docs/
│   ├── demo-workflow-ethers-v5-ke-v6.md
│   ├── etherjs-v5/
│   └── repo ethers v6/
├── README.md
└── push.sh
```

## Target Reference Repositories

- v5 repos for test targets: [ethersjs-v5-projects.md](docs/etherjs-v5/ethersjs-v5-projects.md)
- v6 repos for final result patterns: [repo-ethers-v6.md](docs/repo%20ethers%20v6/repo-ethers-v6.md)

## Current Status

This workflow has:

- passed workflow validation
- proven to apply cleanly on the first real target repo
- only touched source files, not `node_modules`
- generated audit reports for edge cases to guide manual/AI steps

## Complete Guide for New Users (Migration Steps)

By default, this main repository does not store migration target folders. You need to create a `targets` folder yourself and _clone_ the repository you want to migrate into it. Here is the complete flow:

### 1. Create a Target Directory

Prepare a `targets` folder in the _root_ directory of this repository to act as your workspace.

```bash
mkdir targets
cd targets
```

### 2. Clone the Target Repository

Choose and _clone_ a repository that still uses `ethers.js` v5 into the newly created `targets` folder. You can use your own repo or one from the test list.

For example, we will use the `alchemy-goerli-sample` demo repository:

```bash
git clone https://github.com/sangjunlim-dev/alchemy-goerli-sample
cd alchemy-goerli-sample
```

Install the project dependencies (`npm install` / `yarn install`) if the target repository requires them, then ensure your terminal returns to the _root_ directory using `cd ../..` (or adjust the path depending on your current terminal location).

### 3. Execute the Codemod Workflow

Run these commands from the _root_ of the main repository. Replace `<TARGET_REPO_NAME>` with the folder name of your target repository.

**1. Validate the workflow**

```bash
npx codemod workflow validate -w "./codemods/ethers-v5-to-v6/workflow.yaml"
```

**2. Dry-Run (Simulate Changes)**

```bash
npx codemod workflow run -w "./codemods/ethers-v5-to-v6/workflow.yaml" -t "./targets/<TARGET_REPO_NAME>" --dry-run
```

**3. Apply (Modify Files)**

```bash
npx codemod workflow run -w "./codemods/ethers-v5-to-v6/workflow.yaml" -t "./targets/<TARGET_REPO_NAME>"
```

**4. Audit Edge Cases (Check Unchanged Patterns)**
After the codemod is applied, run the audit script using PowerShell to detect patterns that have not been automatically fixed:

```powershell
powershell -ExecutionPolicy Bypass -File "./codemods/ethers-v5-to-v6/scripts/audit-edge-cases.ps1" -TargetPath "./targets/<TARGET_REPO_NAME>"
```

_The output report will be created inside the target repository folder at these paths:_

- `codemod-reports/ethers-v5-to-v6-edge-cases.md`
- `codemod-reports/ethers-v5-to-v6-edge-cases.json`

### 4. Review & Continue

- Go back to the root of the migrated target repo.
- Check with `git diff` to see all the code that was automatically replaced.
- Check the audit report files for APIs that were not mapped automatically and adjust them manually or using an AI bot.
- Proceed with the _compile/build/test_ stages for the target repository.
