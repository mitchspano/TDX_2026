// ============================================================================
// Apex Debug Log Tracing & Management Demo
// ============================================================================
// Purpose: Demonstrate debug logging and savepoint rollback patterns
// Usage: Run anonymously in Developer Console or VS Code
// ============================================================================

System.debug('=== Starting Debug Tracing Demo ===');
System.debug('Timestamp: ' + System.now());

// Create a savepoint to rollback all changes
Savepoint sp = Database.setSavepoint();
System.debug('Savepoint created: ' + sp);

try {
    // ========================================================================
    // STEP 1: Create Contact
    // ========================================================================
    System.debug(LoggingLevel.INFO, '--- Step 1: Creating Contact ---');

    TriggerBase.bypass(Schema.Contact.SObjectType);
    System.debug('TriggerBase bypassed for Contact');

    Contact janeCoder = new Contact(
        FirstName = 'Jane',
        LastName = 'Coder',
        Email = 'Jane@example.com'
    );

    insert janeCoder;
    System.debug(LoggingLevel.INFO, 'Contact created successfully');
    System.debug('Contact Id: ' + janeCoder.Id);
    System.debug('Contact Name: ' + janeCoder.FirstName + ' ' + janeCoder.LastName);

    TriggerBase.clearBypass(Schema.Contact.SObjectType);
    System.debug('TriggerBase bypass cleared for Contact');

    // ========================================================================
    // STEP 2: Create Job Posting
    // ========================================================================
    System.debug(LoggingLevel.INFO, '--- Step 2: Creating Job Posting ---');

    TriggerBase.bypass(Schema.Job_Posting__c.SObjectType);
    System.debug('TriggerBase bypassed for Job_Posting__c');

    Job_Posting__c posting = new Job_Posting__c(
        Title__c = 'Director of Product Management',
        Location__c = 'San Francisco',
        Description__c = 'Help Salesforce to make the next generation of developer tooling',
        ExternalID__c = 'Job_12345'
    );

    insert posting;
    System.debug(LoggingLevel.INFO, 'Job Posting created successfully');
    System.debug('Posting Id: ' + posting.Id);
    System.debug('Posting Title: ' + posting.Title__c);
    System.debug('Posting Location: ' + posting.Location__c);

    TriggerBase.clearBypass(Schema.Job_Posting__c.SObjectType);
    System.debug('TriggerBase bypass cleared for Job_Posting__c');

    // ========================================================================
    // STEP 3: Create Job Application
    // ========================================================================
    System.debug(LoggingLevel.INFO, '--- Step 3: Creating Job Application ---');

    TriggerBase.bypass(Schema.Job_Application__c.SObjectType);
    System.debug('TriggerBase bypassed for Job_Application__c');

    Job_Application__c application = new Job_Application__c(
        Candidate__c = janeCoder.Id,
        Job_Posting__c = posting.Id,
        Years_of_Experience__c = 12
    );

    insert application;
    System.debug(LoggingLevel.INFO, 'Job Application created successfully');
    System.debug('Application Id: ' + application.Id);
    System.debug('Application Candidate: ' + application.Candidate__c);
    System.debug('Application Job Posting: ' + application.Job_Posting__c);
    System.debug('Years of Experience: ' + application.Years_of_Experience__c);

    TriggerBase.clearBypass(Schema.Job_Application__c.SObjectType);
    System.debug('TriggerBase bypass cleared for Job_Application__c');

    // ========================================================================
    // STEP 4: Query and Display Records
    // ========================================================================
    System.debug(LoggingLevel.INFO, '--- Step 4: Querying Created Records ---');

    List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Id = :janeCoder.Id];
    System.debug('Contact Query Result: ' + contacts);

    List<Job_Posting__c> postings = [SELECT Id, Title__c, Location__c FROM Job_Posting__c WHERE Id = :posting.Id];
    System.debug('Job Posting Query Result: ' + postings);

    List<Job_Application__c> applications = [
        SELECT Id, Candidate__c, Job_Posting__c, Years_of_Experience__c
        FROM Job_Application__c
        WHERE Id = :application.Id
    ];
    System.debug('Job Application Query Result: ' + applications);

    // ========================================================================
    // STEP 5: Display Governor Limits
    // ========================================================================
    System.debug(LoggingLevel.INFO, '--- Step 5: Governor Limits Check ---');
    System.debug('DML Statements Used: ' + Limits.getDmlStatements() + ' / ' + Limits.getLimitDmlStatements());
    System.debug('SOQL Queries Used: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
    System.debug('DML Rows Used: ' + Limits.getDmlRows() + ' / ' + Limits.getLimitDmlRows());
    System.debug('Heap Size Used: ' + Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());

    // ========================================================================
    // STEP 6: Rollback All Changes
    // ========================================================================
    System.debug(LoggingLevel.WARN, '--- Step 6: Rolling Back All Changes ---');
    Database.rollback(sp);
    System.debug(LoggingLevel.WARN, 'Rollback completed successfully');
    System.debug('All records have been removed from the database');

    // Verify rollback
    System.debug(LoggingLevel.INFO, '--- Step 7: Verifying Rollback ---');
    List<Contact> contactsAfterRollback = [SELECT Id FROM Contact WHERE Email = 'Jane@example.com'];
    System.debug('Contacts after rollback (should be empty): ' + contactsAfterRollback.size());

    System.debug('=== Debug Tracing Demo Completed Successfully ===');

} catch (Exception e) {
    System.debug(LoggingLevel.ERROR, '=== ERROR OCCURRED ===');
    System.debug(LoggingLevel.ERROR, 'Exception Type: ' + e.getTypeName());
    System.debug(LoggingLevel.ERROR, 'Exception Message: ' + e.getMessage());
    System.debug(LoggingLevel.ERROR, 'Stack Trace: ' + e.getStackTraceString());
    System.debug(LoggingLevel.ERROR, 'Line Number: ' + e.getLineNumber());

    // Rollback on error
    Database.rollback(sp);
    System.debug(LoggingLevel.WARN, 'Rollback completed due to error');
}

// ============================================================================
// NOTES FOR DEBUG LOG ANALYSIS:
// ============================================================================
// 1. Set debug log levels in Setup > Debug Logs > Trace Flags
// 2. Recommended settings for this demo:
//    - Apex Code: FINEST
//    - Database: FINER
//    - System: DEBUG
//    - Workflow: INFO
// 3. Look for these patterns in the log:
//    - DML operations (USER_DEBUG)
//    - SOQL queries (SOQL_EXECUTE_BEGIN/END)
//    - Governor limit usage
//    - Savepoint creation and rollback
// ============================================================================
