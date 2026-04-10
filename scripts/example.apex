Savepoint sp = Database.setSavepoint();

Contact janeCoder = new Contact(
  FirstName = 'Jane',
  LastName = 'Coder',
  Email = 'Jane@example.com'
);
insert janeCoder;

Job_Posting__c posting = new Job_Posting__c(
  Title__c = 'Director of Product Management',
  Location__c = 'San Francisco',
  Description__c = 'Help Salesforce to make the next generation of developer tooling',
  ExternalID__c = 'Job_12345'
);
insert posting;

Job_Application__c application = new Job_Application__c(
  Candidate__c = janeCoder.Id,
  Job_Posting__c = posting.Id,
  Years_of_Experience__c = 12
);
insert application;

Database.rollback(sp);
