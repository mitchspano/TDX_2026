/**
 * Test class for JobApplicationViewController
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest
private class JobApplicationViewControllerTest {
  // ═══════════════════════════════════════════════════════════════════════════
  //                             EXPECTED MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════
  private static final String RESULT_SHOULD_NOT_BE_NULL = 'Result should not be null';
  private static final String CANDIDATE_NAME_SHOULD_MATCH = 'Candidate name should match';
  private static final String STATUS_SHOULD_MATCH = 'Status should match';
  private static final String YEARS_EXPERIENCE_SHOULD_MATCH = 'Years of experience should match';
  private static final String EMAIL_SHOULD_MATCH = 'Email should match';
  private static final String JOB_TITLE_SHOULD_MATCH = 'Job title should match';
  private static final String DEPARTMENT_SHOULD_MATCH = 'Department should match';
  private static final String LOCATION_SHOULD_MATCH = 'Location should match';
  private static final String ERROR_MESSAGE_SHOULD_INDICATE_FAILURE = 'Error message should indicate retrieval failure';
  private static final String EXCEPTION_EXPECTED = 'Expected an AuraHandledException';
  private static final String OPTIONAL_FIELD_SHOULD_BE_NULL = 'Optional field should be null';

  // ═══════════════════════════════════════════════════════════════════════════
  //                           STATIC TEST DATA
  // ═══════════════════════════════════════════════════════════════════════════
  private static Contact candidate = new Contact(
    Id = TriggerTestUtility.getFakeId(Contact.SObjectType),
    FirstName = 'Jane',
    LastName = 'Doe',
    Email = 'jane.doe@test.com',
    Phone = '555-0123',
    Title = 'Senior Software Engineer'
  );

  private static Job_Posting__c posting = new Job_Posting__c(
    Id = TriggerTestUtility.getFakeId(Job_Posting__c.SObjectType),
    Title__c = 'Lead Developer',
    Description__c = '<p>We are looking for an experienced developer...</p>',
    Department__c = 'Engineering',
    Location__c = 'San Francisco, CA',
    Salary_Range__c = '$120,000 - $160,000',
    Employment_Type__c = 'Full-Time',
    Status__c = 'Open',
    Posted_Date__c = Date.today().addDays(-30),
    Closing_Date__c = Date.today().addDays(30),
    Number_of_Openings__c = 2
  );

  private static Job_Application__c application = new Job_Application__c(
    Id = TriggerTestUtility.getFakeId(Job_Application__c.SObjectType),
    Candidate__c = candidate.Id,
    Job_Posting__c = posting.Id,
    Application_Date__c = Date.today().addDays(-7),
    Status__c = 'Under Review',
    Years_of_Experience__c = 8,
    Cover_Letter__c = '<p>I am excited to apply for this position...</p>',
    Resume_URL__c = 'https://example.com/resume.pdf'
  );

  private static JobApplicationViewControllerTest.MockSelector mockSelector = new JobApplicationViewControllerTest.MockSelector(
    application,
    candidate,
    posting
  );

  // ═══════════════════════════════════════════════════════════════════════════
  //                    BEGINNING STATE OF THE DATABASE
  // ═══════════════════════════════════════════════════════════════════════════

  @TestSetup
  static void setup() {
    Contact janeDoe = new Contact(
      FirstName = 'Jane',
      LastName = 'Doe',
      Email = 'jane.doe@example.com',
      Phone = '555-0123',
      Title = 'Senior Software Engineer'
    );
    insert janeDoe;

    Job_Posting__c leadDevPosting = new Job_Posting__c(
      Title__c = 'Lead Developer',
      Description__c = '<p>We are looking for an experienced developer...</p>',
      Department__c = 'Engineering',
      Location__c = 'San Francisco, CA',
      Salary_Range__c = '$120,000 - $160,000',
      Employment_Type__c = 'Full-Time',
      Status__c = 'Open',
      Posted_Date__c = Date.today().addDays(-30),
      Closing_Date__c = Date.today().addDays(30),
      Number_of_Openings__c = 2
    );
    insert leadDevPosting;

    Job_Application__c application = new Job_Application__c(
      Candidate__c = janeDoe.Id,
      Job_Posting__c = leadDevPosting.Id,
      Application_Date__c = Date.today().addDays(-7),
      Status__c = 'Under Review',
      Years_of_Experience__c = 8,
      Cover_Letter__c = '<p>I am excited to apply for this position...</p>',
      Resume_URL__c = 'https://example.com/resume.pdf'
    );
    insert application;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //                UNIT TESTS - PURELY OPERATE IN MEMORY
  // ═══════════════════════════════════════════════════════════════════════════

  @IsTest
  static void getJobApplicationDetailsWithMockDataShouldReturnCompleteData() {
    JobApplicationViewController.selector = mockSelector;

    Test.startTest();
    Job_Application__c result = JobApplicationViewController.getJobApplicationDetails(
      application.Id
    );
    Test.stopTest();

    Assert.isNotNull(result, RESULT_SHOULD_NOT_BE_NULL);
    Assert.areEqual('Under Review', result.Status__c, STATUS_SHOULD_MATCH);
    Assert.areEqual(
      8,
      result.Years_of_Experience__c,
      YEARS_EXPERIENCE_SHOULD_MATCH
    );
    Assert.areEqual(
      'Jane',
      result.Candidate__r.FirstName,
      'Candidate first name should match'
    );
    Assert.areEqual(
      'Doe',
      result.Candidate__r.LastName,
      'Candidate last name should match'
    );
    Assert.areEqual(
      'jane.doe@test.com',
      result.Candidate__r.Email,
      EMAIL_SHOULD_MATCH
    );
    Assert.areEqual(
      'Senior Software Engineer',
      result.Candidate__r.Title,
      'Candidate title should match'
    );
    Assert.areEqual(
      'Lead Developer',
      result.Job_Posting__r.Title__c,
      JOB_TITLE_SHOULD_MATCH
    );
    Assert.areEqual(
      'Engineering',
      result.Job_Posting__r.Department__c,
      DEPARTMENT_SHOULD_MATCH
    );
    Assert.areEqual(
      'San Francisco, CA',
      result.Job_Posting__r.Location__c,
      LOCATION_SHOULD_MATCH
    );
  }

  @IsTest
  static void getJobApplicationDetailsWithQueryExceptionShouldThrowAuraException() {
    mockSelector.throwException = true;
    JobApplicationViewController.selector = mockSelector;

    Test.startTest();
    try {
      JobApplicationViewController.getJobApplicationDetails(application.Id);
      Assert.fail(EXCEPTION_EXPECTED);
    } catch (AuraHandledException e) {
      Assert.isTrue(
        e.getMessage().contains('Error retrieving job application'),
        ERROR_MESSAGE_SHOULD_INDICATE_FAILURE
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void getJobApplicationDetailsWithNullCandidateShouldHandleGracefully() {
    Job_Application__c appWithoutCandidate = new Job_Application__c(
      Id = TriggerTestUtility.getFakeId(Job_Application__c.SObjectType),
      Job_Posting__c = posting.Id,
      Status__c = 'New'
    );
    JobApplicationViewController.selector = new JobApplicationViewControllerTest.MockSelector(
      appWithoutCandidate,
      null,
      posting
    );

    Test.startTest();
    Job_Application__c result = JobApplicationViewController.getJobApplicationDetails(
      appWithoutCandidate.Id
    );
    Test.stopTest();

    Assert.isNotNull(result, RESULT_SHOULD_NOT_BE_NULL);
    Assert.areEqual('New', result.Status__c, STATUS_SHOULD_MATCH);
    Assert.isNull(result.Candidate__r, 'Candidate should be null');
  }

  @IsTest
  static void getJobApplicationDetailsWithNullJobPostingShouldHandleGracefully() {
    Job_Application__c appWithoutPosting = new Job_Application__c(
      Id = TriggerTestUtility.getFakeId(Job_Application__c.SObjectType),
      Candidate__c = candidate.Id,
      Status__c = 'New'
    );
    JobApplicationViewController.selector = new JobApplicationViewControllerTest.MockSelector(
      appWithoutPosting,
      candidate,
      null
    );

    Test.startTest();
    Job_Application__c result = JobApplicationViewController.getJobApplicationDetails(
      appWithoutPosting.Id
    );
    Test.stopTest();

    Assert.isNotNull(result, RESULT_SHOULD_NOT_BE_NULL);
    Assert.areEqual('New', result.Status__c, STATUS_SHOULD_MATCH);
    Assert.isNull(result.Job_Posting__r, 'Job Posting should be null');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //           INTEGRATION TESTS - ACTUALLY HIT THE DATABASE
  // ═══════════════════════════════════════════════════════════════════════════

  @IsTest
  static void getJobApplicationDetailsWithValidIdShouldReturnCompleteData() {
    Job_Application__c application = [
      SELECT Id
      FROM Job_Application__c
      LIMIT 1
    ];

    Test.startTest();
    Job_Application__c result = JobApplicationViewController.getJobApplicationDetails(
      application.Id
    );
    Test.stopTest();

    Assert.isNotNull(result, RESULT_SHOULD_NOT_BE_NULL);
    Assert.areEqual('Under Review', result.Status__c, STATUS_SHOULD_MATCH);
    Assert.areEqual(
      8,
      result.Years_of_Experience__c,
      YEARS_EXPERIENCE_SHOULD_MATCH
    );
    Assert.areEqual(
      'Jane',
      result.Candidate__r.FirstName,
      'Candidate first name should match'
    );
    Assert.areEqual(
      'Doe',
      result.Candidate__r.LastName,
      'Candidate last name should match'
    );
    Assert.areEqual(
      'jane.doe@example.com',
      result.Candidate__r.Email,
      EMAIL_SHOULD_MATCH
    );
    Assert.areEqual(
      'Senior Software Engineer',
      result.Candidate__r.Title,
      'Candidate title should match'
    );
    Assert.areEqual(
      'Lead Developer',
      result.Job_Posting__r.Title__c,
      JOB_TITLE_SHOULD_MATCH
    );
    Assert.areEqual(
      'Engineering',
      result.Job_Posting__r.Department__c,
      DEPARTMENT_SHOULD_MATCH
    );
    Assert.areEqual(
      'San Francisco, CA',
      result.Job_Posting__r.Location__c,
      LOCATION_SHOULD_MATCH
    );
    Assert.areEqual(
      'Open',
      result.Job_Posting__r.Status__c,
      'Job status should match'
    );
  }

  @IsTest
  static void getJobApplicationDetailsWithInvalidIdShouldThrowException() {
    Test.startTest();
    try {
      JobApplicationViewController.getJobApplicationDetails(application.Id);
      Assert.fail(EXCEPTION_EXPECTED);
    } catch (AuraHandledException e) {
      Assert.isTrue(
        e.getMessage().contains('Error retrieving job application'),
        ERROR_MESSAGE_SHOULD_INDICATE_FAILURE
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void getJobApplicationDetailsWithAllFieldsShouldMapCorrectly() {
    Job_Application__c application = [
      SELECT
        Id,
        Name,
        Application_Date__c,
        Status__c,
        Years_of_Experience__c,
        Cover_Letter__c,
        Resume_URL__c,
        Candidate__r.FirstName,
        Candidate__r.LastName,
        Candidate__r.Email,
        Candidate__r.Phone,
        Candidate__r.Title,
        Job_Posting__r.Name,
        Job_Posting__r.Title__c,
        Job_Posting__r.Description__c,
        Job_Posting__r.Department__c,
        Job_Posting__r.Location__c,
        Job_Posting__r.Salary_Range__c,
        Job_Posting__r.Employment_Type__c,
        Job_Posting__r.Status__c,
        Job_Posting__r.Posted_Date__c,
        Job_Posting__r.Closing_Date__c,
        Job_Posting__r.Number_of_Openings__c
      FROM Job_Application__c
      LIMIT 1
    ];

    Test.startTest();
    Job_Application__c result = JobApplicationViewController.getJobApplicationDetails(
      application.Id
    );
    Test.stopTest();

    Assert.areEqual(application.Id, result.Id, 'Application ID should match');
    Assert.areEqual(
      application.Name,
      result.Name,
      'Application number should match'
    );
    Assert.areEqual(
      application.Status__c,
      result.Status__c,
      STATUS_SHOULD_MATCH
    );
    Assert.areEqual(
      application.Resume_URL__c,
      result.Resume_URL__c,
      'Resume URL should match'
    );
    Assert.isNotNull(result.Candidate__r, 'Candidate should not be null');
    Assert.isNotNull(result.Job_Posting__r, 'Job Posting should not be null');
  }

  @IsTest
  static void getJobApplicationDetailsWithMinimalDataShouldHandleNullFields() {
    Contact johnSmith = new Contact(
      FirstName = 'John',
      LastName = 'Smith',
      Email = 'john.smith@example.com'
    );
    insert johnSmith;

    Job_Posting__c juniorDevPosting = new Job_Posting__c(
      Title__c = 'Junior Developer',
      Status__c = 'Open'
    );
    insert juniorDevPosting;

    Job_Application__c minimalApplication = new Job_Application__c(
      Candidate__c = johnSmith.Id,
      Job_Posting__c = juniorDevPosting.Id,
      Status__c = 'New'
    );
    insert minimalApplication;

    Test.startTest();
    Job_Application__c result = JobApplicationViewController.getJobApplicationDetails(
      minimalApplication.Id
    );
    Test.stopTest();

    Assert.isNotNull(result, RESULT_SHOULD_NOT_BE_NULL);
    Assert.areEqual('New', result.Status__c, STATUS_SHOULD_MATCH);
    Assert.isNull(result.Years_of_Experience__c, OPTIONAL_FIELD_SHOULD_BE_NULL);
    Assert.isNull(result.Resume_URL__c, OPTIONAL_FIELD_SHOULD_BE_NULL);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //          MOCK SELECTOR FOR TESTING WITHOUT DATABASE QUERIES
  // ═══════════════════════════════════════════════════════════════════════════
  @TestVisible
  private class MockSelector extends JobApplicationViewController.Selector {
    public Boolean throwException = false;
    private Job_Application__c mockApplication;
    private Contact mockCandidate;
    private Job_Posting__c mockPosting;

    /**
     * Constructor
     * @param mockApplication The mocked Job Application record
     * @param mockCandidate The mocked Contact record
     * @param mockPosting The mocked Job Posting record
     */
    public MockSelector(
      Job_Application__c mockApplication,
      Contact mockCandidate,
      Job_Posting__c mockPosting
    ) {
      this.mockApplication = mockApplication;
      this.mockCandidate = mockCandidate;
      this.mockPosting = mockPosting;
    }

    public override Job_Application__c getApplicationById(Id recordId) {
      if (throwException) {
        throw new System.QueryException(
          'List has no rows for assignment to SObject'
        );
      }
      if (mockCandidate != null) {
        mockApplication.Candidate__r = mockCandidate;
      }
      if (mockPosting != null) {
        mockApplication.Job_Posting__r = mockPosting;
      }
      return mockApplication;
    }
  }
}
