@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest(testFor='ApexTrigger:JobApplicationTrigger')
private class JobApplicationTriggerTest {
  @IsTest
  private static void shouldBeAbleToPerformDml() {
    TriggerBase.bypass(Schema.Contact.SObjectType);
    Contact janeCoder = new Contact(
      FirstName = 'Jane',
      LastName = 'Coder',
      Email = 'Jane@example.com'
    );
    insert janeCoder;
    TriggerBase.clearBypass(Schema.Contact.SObjectType);

    TriggerBase.bypass(Schema.Job_Posting__c.SObjectType);
    Job_Posting__c posting = new Job_Posting__c(
      Title__c = 'Director of Product Management',
      Location__c = 'San Francisco',
      Description__c = 'Help Salesforce to make the next generation of developer tooling',
      ExternalID__c = 'Job_12345'
    );
    insert posting;
    TriggerBase.clearBypass(Schema.Job_Posting__c.SObjectType);

    try {
      TriggerBase.bypass(Schema.Job_Application__c.SObjectType);
      Job_Application__c application = new Job_Application__c(
        Candidate__c = janeCoder.Id,
        Job_Posting__c = posting.Id,
        Years_of_Experience__c = 12
      );
      insert application;
    } catch (Exception e) {
      System.Assert.fail(
        'There should be no problems when performing DML on a "Job_Application__c" record.'
      );
    }
  }
}
