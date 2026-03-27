@isTest
private class JobApplicationViewControllerTest {
    @testSetup
    static void setupTestData() {
        // Create test Contact
        Contact testContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'jane.doe@example.com',
            Phone = '555-0123',
            Title = 'Senior Software Engineer'
        );
        insert testContact;

        // Create test Job Posting
        Job_Posting__c testPosting = new Job_Posting__c(
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
        insert testPosting;

        // Create test Job Application
        Job_Application__c testApplication = new Job_Application__c(
            Candidate__c = testContact.Id,
            Job_Posting__c = testPosting.Id,
            Application_Date__c = Date.today().addDays(-7),
            Status__c = 'Under Review',
            Years_of_Experience__c = 8,
            Cover_Letter__c = '<p>I am excited to apply for this position...</p>',
            Resume_URL__c = 'https://example.com/resume.pdf'
        );
        insert testApplication;
    }

    @isTest
    static void testGetJobApplicationDetailsSuccess() {
        // Get test data
        Job_Application__c testApp = [
            SELECT Id
            FROM Job_Application__c
            LIMIT 1
        ];

        Test.startTest();
        JobApplicationViewController.JobApplicationData result =
            JobApplicationViewController.getJobApplicationDetails(testApp.Id);
        Test.stopTest();

        // Assert application data
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('Under Review', result.status, 'Status should match');
        System.assertEquals(8, result.yearsOfExperience, 'Years of experience should match');

        // Assert candidate data
        System.assertEquals('Jane Doe', result.candidateName, 'Candidate name should match');
        System.assertEquals('jane.doe@example.com', result.candidateEmail, 'Email should match');
        System.assertEquals('Senior Software Engineer', result.candidateTitle, 'Title should match');

        // Assert job posting data
        System.assertEquals('Lead Developer', result.jobTitle, 'Job title should match');
        System.assertEquals('Engineering', result.department, 'Department should match');
        System.assertEquals('San Francisco, CA', result.location, 'Location should match');
        System.assertEquals('Open', result.jobStatus, 'Job status should match');
    }

    @isTest
    static void testGetJobApplicationDetailsWithInvalidId() {
        // Create a fake ID that doesn't exist
        Id fakeId = Schema.Job_Application__c.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12);

        Test.startTest();
        try {
            JobApplicationViewController.JobApplicationData result =
                JobApplicationViewController.getJobApplicationDetails(fakeId);
            System.assert(false, 'Expected an AuraHandledException');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Error retrieving job application'),
                'Error message should indicate retrieval failure');
        }
        Test.stopTest();
    }

    @isTest
    static void testJobApplicationDataConstructor() {
        // Get test data
        Job_Application__c testApp = [
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
        JobApplicationViewController.JobApplicationData data =
            new JobApplicationViewController.JobApplicationData(testApp);
        Test.stopTest();

        // Verify all fields are properly mapped
        System.assertEquals(testApp.Id, data.applicationId);
        System.assertEquals(testApp.Name, data.applicationNumber);
        System.assertEquals(testApp.Status__c, data.status);
        System.assertEquals(testApp.Resume_URL__c, data.resumeUrl);

        System.assertNotEquals(null, data.candidateName);
        System.assertNotEquals(null, data.jobTitle);
    }

    @isTest
    static void testWithMinimalData() {
        // Create a minimal application (optional fields null)
        Contact minContact = new Contact(
            FirstName = 'John',
            LastName = 'Smith',
            Email = 'john.smith@example.com'
        );
        insert minContact;

        Job_Posting__c minPosting = new Job_Posting__c(
            Title__c = 'Junior Developer',
            Status__c = 'Open'
        );
        insert minPosting;

        Job_Application__c minApp = new Job_Application__c(
            Candidate__c = minContact.Id,
            Job_Posting__c = minPosting.Id,
            Status__c = 'New'
        );
        insert minApp;

        Test.startTest();
        JobApplicationViewController.JobApplicationData result =
            JobApplicationViewController.getJobApplicationDetails(minApp.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals('New', result.status);
        System.assertEquals(null, result.yearsOfExperience, 'Optional field should be null');
        System.assertEquals(null, result.resumeUrl, 'Optional field should be null');
    }
}
