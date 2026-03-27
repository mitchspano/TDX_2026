# RunRelevantTests

## Overview

The `RunRelevantTests` test level is an intelligent testing option that automatically runs only the tests that cover the code being deployed. This provides faster feedback than running all tests while still maintaining code coverage requirements.

### Step 1: Modify the Files

Add a comment to the [Contact Trigger](../../force-app/main/default/triggers/ContactTrigger.trigger)

Add a comment to the [TA_JobApp_PreventDuplicates Class](../../force-app/main/default/classes/TA_JobApp_PreventDuplicates.cls)

Add a comment to the [JobApplicationTriggerTest Class](../../force-app/main/default/classes/JobApplicationTriggerTest.cls)

### Step 2: Run Validation Deploy

Perform a validate only deploy with `RunRelevantTests` level:

```sh
sf project deploy start \
  --source-dir "force-app/main/default/triggers/ContactTrigger.trigger" \
  --source-dir "force-app/main/default/classes/TA_JobApp_PreventDuplicates.cls" \
  --source-dir "force-app/main/default/classes/JobApplicationTriggerTest.cls" \
  --test-level RunRelevantTests \
  --dry-run \
  --json
```

### Step 3: Review Test Results

The command output shows which tests were automatically selected and run. Key information includes:

- **Total Tests Run**: Found at `result.details.runTestResult.numTestsRun`
- **Test Class Names**: Found in `result.details.runTestResult.successes[].name`
- **Test Methods**: Found in `result.details.runTestResult.successes[].methodName`
- **Execution Time**: Each test's runtime in milliseconds

To extract just the test class names that ran:

```sh
sf project deploy start \
  --source-dir "force-app/main/default/triggers/ContactTrigger.trigger" \
  --source-dir "force-app/main/default/classes/TA_JobApp_PreventDuplicates.cls" \
  --source-dir "force-app/main/default/classes/JobApplicationTriggerTest.cls" \
  --test-level RunRelevantTests \
  --dry-run \
  --json | jq -r '.result.details.runTestResult.successes[].name' | sort -u
```

We would expect to see:

- `ContactTriggerTest` # @IsTest(testFor=...) something in the payload
- `TA_JobApp_PreventDuplicatesTest` # Discovered by Salesforce
- `JobApplicationTriggerTest` # Test in the payload

### Features

- **Automatic Test Selection**: Salesforce determines which tests to run based on code coverage data
- **Faster Deployments**: Only relevant tests are executed, reducing deployment time
- **Coverage Validation**: Ensures deployed code meets the 75% code coverage requirement
- **Dry Run Support**: Use `--dry-run` flag to validate without actually deploying

### FAQs

| Question                                         | Response                                                                                                                                         |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| What does RunRelevantTests do?                   | It runs only the Apex tests that cover the classes and triggers being deployed, as determined by Salesforce's code coverage tracking             |
| What happens if my code has no test coverage?    | The deployment will fail because Salesforce requires 75% code coverage for production deployments. You'll need to write tests first.             |
| How is this different from RunLocalTests?        | RunLocalTests runs all tests in your org except managed package tests. RunRelevantTests only runs tests that directly cover your deployed code.  |
| Does it work for all metadata types?             | RunRelevantTests only applies to Apex classes and triggers. Other metadata types don't require test coverage.                                    |
| Can I see which tests will run before deploying? | Yes, use the `--dry-run` flag to perform a validation-only deploy that shows which tests ran and their results without making changes to the org |
