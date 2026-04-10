@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest(testFor='ApexTrigger:ContactTrigger')
private class ContactTriggerTest {
  @IsTest
  private static void shouldBeAbleToPerformDml() {
    try {
      TriggerBase.bypass(Schema.Contact.SObjectType);
      insert new Contact(
        FirstName = 'Jane',
        LastName = 'Coder',
        Email = 'Jane@example.com'
      );
    } catch (Exception e) {
      System.Assert.fail(
        'There should be no problems when performing DML on a "Contact" record.'
      );
    }
  }
}
