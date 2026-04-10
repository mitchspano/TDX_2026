/**
 * Cleanup script to delete all Job Applications, Job Postings, and Contacts
 * Execute anonymously with: sf apex run --file scripts/cleanup_data.apex --target-org TDX_2026
 */

System.debug('🧹 Starting data cleanup...');
System.debug('');

// Delete Job Applications (child records first)
System.debug('Deleting Job Applications...');
List<Job_Application__c> jobApps = [SELECT Id FROM Job_Application__c];
if (!jobApps.isEmpty()) {
    try {
        delete jobApps;
        System.debug('✓ Deleted ' + jobApps.size() + ' Job Applications');
    } catch (DmlException e) {
        System.debug('❌ Error deleting Job Applications: ' + e.getMessage());
    }
} else {
    System.debug('No Job Applications found');
}
System.debug('');

// Delete Job Postings
System.debug('Deleting Job Postings...');
List<Job_Posting__c> jobPostings = [SELECT Id FROM Job_Posting__c];
if (!jobPostings.isEmpty()) {
    try {
        delete jobPostings;
        System.debug('✓ Deleted ' + jobPostings.size() + ' Job Postings');
    } catch (DmlException e) {
        System.debug('❌ Error deleting Job Postings: ' + e.getMessage());
    }
} else {
    System.debug('No Job Postings found');
}
System.debug('');

// Delete Contacts
System.debug('Deleting Contacts...');
List<Contact> contacts = [SELECT Id FROM Contact];
if (!contacts.isEmpty()) {
    try {
        delete contacts;
        System.debug('✓ Deleted ' + contacts.size() + ' Contacts');
    } catch (DmlException e) {
        System.debug('❌ Error deleting Contacts: ' + e.getMessage());
    }
} else {
    System.debug('No Contacts found');
}
System.debug('');

// Show final record counts
System.debug('✅ Cleanup complete!');
System.debug('');
System.debug('Remaining record counts:');
System.debug('========================');
System.debug('Job Applications: ' + [SELECT COUNT() FROM Job_Application__c]);
System.debug('Job Postings: ' + [SELECT COUNT() FROM Job_Posting__c]);
System.debug('Contacts: ' + [SELECT COUNT() FROM Contact]);
