/**
 * Test class for TA_JobApp_PreventDuplicates
 * Uses a mock selector to test duplicate prevention logic in memory
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest
private class TA_JobApp_PreventDuplicatesTest {
  // ═══════════════════════════════════════════════════════════════════════════
  //                             ERROR MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════
  private static final String ERRORS_EXPECTED = 'There should be an error added to the Application';
  private static final String NO_ERRORS_EXPECTED = 'An error should not be added to the application';

  // ═══════════════════════════════════════════════════════════════════════════
  //                           STATIC TEST DATA
  // ═══════════════════════════════════════════════════════════════════════════
  private static Contact con = new Contact(
    Id = TriggerTestUtility.getFakeId(Contact.SObjectType),
    FirstName = 'John',
    LastName = 'Doe'
  );

  private static Job_Posting__c posting = new Job_Posting__c(
    Id = TriggerTestUtility.getFakeId(Job_Posting__c.SObjectType)
  );

  private static List<Job_Application__c> existingApplications = new List<Job_Application__c>{
    new Job_Application__c(
      Id = TriggerTestUtility.getFakeId(Job_Application__c.SObjectType),
      Candidate__c = con.Id,
      Job_Posting__c = posting.Id
    )
  };

  private static TA_JobApp_PreventDuplicatesTest.MockSelector mockSelector = new TA_JobApp_PreventDuplicatesTest.MockSelector(
    existingApplications
  );

  private static Job_Application__c application = new Job_Application__c(
    Id = TriggerTestUtility.getFakeId(Job_Application__c.SObjectType),
    Candidate__c = con.Id,
    Job_Posting__c = posting.Id
  );

  private static List<Job_Application__c> triggerNew = new List<Job_Application__c>{
    application
  };

  private static List<Job_Application__c> triggerOld = new List<Job_Application__c>{
    application.clone(true)
  };

  private static TA_JobApp_PreventDuplicates action = new TA_JobApp_PreventDuplicates();

  // ═══════════════════════════════════════════════════════════════════════════
  //                    BEGINNING STATE OF THE DATABASE
  // ═══════════════════════════════════════════════════════════════════════════

  @TestSetup
  static void setup() {
    Contact johnDoe = new Contact(
      FirstName = 'John',
      LastName = 'Doe',
      Email = 'JohnDoe@test.com'
    );
    insert johnDoe;

    Job_Posting__c posting = new Job_Posting__c(
      Title__c = 'Director of Product Management',
      Location__c = 'San Francisco',
      Description__c = 'Help Salesforce to make the next generation of developer tooling',
      ExternalID__c = 'Job_12345'
    );

    insert posting;

    Job_Application__c application = new Job_Application__c(
      Candidate__c = johnDoe.Id,
      Job_Posting__c = posting.Id,
      Years_of_Experience__c = 12
    );
    insert application;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //                UNIT TESTS - PURELY OPERATE IN MEMORY
  // ═══════════════════════════════════════════════════════════════════════════

  @IsTest
  static void insertWithExistingApplicationForSameCandidateSamePostingShouldAddError() {
    TA_JobApp_PreventDuplicates.selector = mockSelector;

    action.beforeInsert(triggerNew);

    Assert.isTrue(triggerNew[0].hasErrors(), ERRORS_EXPECTED);
  }

  @IsTest
  static void insertWithNoOtherApplicationShouldDoNothing() {
    mockSelector.mockApplications = new List<Job_Application__c>();
    TA_JobApp_PreventDuplicates.selector = mockSelector;

    action.beforeInsert(triggerNew);

    Assert.isFalse(triggerNew[0].hasErrors(), NO_ERRORS_EXPECTED);
  }

  @IsTest
  static void updatedCandidateWithExistingApplicationForSameCandidateSamePostingShouldAddError() {
    TA_JobApp_PreventDuplicates.selector = mockSelector;
    triggerOld[0].Candidate__c = TriggerTestUtility.getFakeId(
      Contact.SObjectType
    );

    action.beforeUpdate(triggerNew, triggerOld);

    Assert.isTrue(triggerNew[0].hasErrors(), ERRORS_EXPECTED);
  }

  @IsTest
  static void updatedPostingWithExistingApplicationForSameCandidateSamePostingShouldAddError() {
    TA_JobApp_PreventDuplicates.selector = mockSelector;
    triggerOld[0].Job_Posting__c = TriggerTestUtility.getFakeId(
      Job_Posting__c.SObjectType
    );

    action.beforeUpdate(triggerNew, triggerOld);

    Assert.isTrue(triggerNew[0].hasErrors(), ERRORS_EXPECTED);
  }

  @IsTest
  static void updateWithNoChangeToPostingOrContactShouldDoNothing() {
    TA_JobApp_PreventDuplicates.selector = mockSelector;

    action.beforeUpdate(triggerNew, triggerOld);

    Assert.isFalse(triggerNew[0].hasErrors(), NO_ERRORS_EXPECTED);
  }

  @IsTest
  static void updatedPostingWithNoOtherApplicationShouldDoNothing() {
    mockSelector.mockApplications = new List<Job_Application__c>();
    TA_JobApp_PreventDuplicates.selector = mockSelector;
    triggerOld[0].Job_Posting__c = TriggerTestUtility.getFakeId(
      Job_Posting__c.SObjectType
    );

    action.beforeUpdate(triggerNew, triggerOld);

    Assert.isFalse(triggerNew[0].hasErrors(), NO_ERRORS_EXPECTED);
  }

  @IsTest
  static void updatedCandidateWithNoOtherApplicationShouldDoNothing() {
    mockSelector.mockApplications = new List<Job_Application__c>();
    TA_JobApp_PreventDuplicates.selector = mockSelector;
    triggerOld[0].Candidate__c = TriggerTestUtility.getFakeId(
      Contact.SObjectType
    );

    action.beforeUpdate(triggerNew, triggerOld);

    Assert.isFalse(triggerNew[0].hasErrors(), NO_ERRORS_EXPECTED);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //           INTEGRATION TESTS - ACTUALLY HIT THE DATABASE
  // ═══════════════════════════════════════════════════════════════════════════

  @IsTest
  private static void actualInsertWithExistingApplicationForSameCandidateSamePostingShouldAddError() {
    Contact johnDoe = [
      SELECT Id
      FROM Contact
      WHERE Email = 'JohnDoe@test.com'
      LIMIT 1
    ];
    Job_Posting__c posting = [
      SELECT Id
      FROM Job_Posting__c
      WHERE ExternalId__c = 'Job_12345'
      LIMIT 1
    ];

    Job_Application__c application = new Job_Application__c(
      Candidate__c = johnDoe.Id,
      Job_Posting__c = posting.Id,
      Years_of_Experience__c = 12
    );

    Database.SaveResult result = Database.insert(application, false);

    System.Assert.isFalse(
      result.success,
      'The save should not have been successful'
    );
    System.Assert.areEqual(
      1,
      result.errors.size(),
      'There should be one error added to the application'
    );
  }

  @IsTest
  private static void actualUpdateWithExistingApplicationForSameCandidateSamePostingShouldAddError() {
    Contact janeCoder = new Contact(
      FirstName = 'Jane',
      LastName = 'Coder',
      Email = 'JaneCoder@test.com'
    );
    insert janeCoder;

    Job_Posting__c previousPosting = new Job_Posting__c(
      Title__c = 'Principal Member of Technical Staff',
      Location__c = 'San Francisco',
      Description__c = 'Help Salesforce to make the next generation of developer tooling',
      ExternalID__c = 'Job_54321'
    );

    insert previousPosting;

    Job_Application__c application = new Job_Application__c(
      Candidate__c = janeCoder.Id,
      Job_Posting__c = previousPosting.Id
    );

    insert application;

    Contact johnDoe = [
      SELECT Id
      FROM Contact
      WHERE Email = 'JohnDoe@test.com'
      LIMIT 1
    ];
    Job_Posting__c posting = [
      SELECT Id
      FROM Job_Posting__c
      WHERE ExternalId__c = 'Job_12345'
      LIMIT 1
    ];

    application.Candidate__c = johnDoe.Id;
    application.Job_Posting__c = posting.Id;

    Database.SaveResult result = Database.update(application, false);

    System.Assert.isFalse(
      result.success,
      'The save should not have been successful'
    );
    System.Assert.areEqual(
      1,
      result.errors.size(),
      'There should be one error added to the application'
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //          MOCK SELECTOR FOR TESTING WITHOUT DATABASE QUERIES
  // ═══════════════════════════════════════════════════════════════════════════
  private class MockSelector extends TA_JobApp_PreventDuplicates.Selector {
    public List<Job_Application__c> mockApplications = new List<Job_Application__c>();

    /**
     * Constructor
     * @param mockApplications The mocked query results which will be returned.
     */
    public MockSelector(List<Job_Application__c> mockApplications) {
      this.mockApplications = mockApplications;
    }

    public override List<Job_Application__c> getApplications(
      Set<Id> candidateIds,
      Set<Id> jobPostingIds,
      Set<Id> jobApplicationIds
    ) {
      List<Job_Application__c> results = new List<Job_Application__c>();
      for (Job_Application__c app : mockApplications) {
        if (
          candidateIds.contains(app.Candidate__c) &&
          jobPostingIds.contains(app.Job_Posting__c) &&
          !jobApplicationIds.contains(app.Id)
        ) {
          results.add(app);
        }
      }
      return results;
    }
  }
}
