@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest(testFor='ApexTrigger:JobPostingTrigger')
private class JobPostingTriggerTest {
  @IsTest
  private static void shouldBeAbleToPerformDml() {
    try {
      TriggerBase.bypass(Schema.Job_Posting__c.SObjectType);
      insert new Job_Posting__c(
        Title__c = 'Director of Product Management',
        Location__c = 'San Francisco',
        Description__c = 'Help Salesforce to make the next generation of developer tooling',
        ExternalID__c = 'Job_12345'
      );
    } catch (Exception e) {
      System.Assert.fail(
        'There should be no problems when performing DML on a "Job_Posting__c" record.'
      );
    }
  }
}
