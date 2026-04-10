/**
 * Controller for the jobApplicationView LWC
 */
public with sharing class JobApplicationViewController {
  @TestVisible
  private static JobApplicationViewController.Selector selector {
    get {
      selector = selector ?? new JobApplicationViewController.Selector();
      return selector;
    }
    set;
  }

  /**
   * Get the Job application with all of its details including job
   * posting and candidate information.
   * @param recordId Id of the Job_Application__c record
   * @return The fully populated Job_Application__c
   * @throws AuraHandledException when the query fails
   */
  @AuraEnabled(cacheable=true)
  public static Job_Application__c getJobApplicationDetails(Id recordId) {
    try {
      return selector.getApplicationById(recordId);
    } catch (Exception e) {
      String message = 'Error retrieving job application: ' + e.getMessage();
      AuraHandledException toThrow = new AuraHandledException(message);
      toThrow.setMessage(message);
      throw toThrow;
    }
  }

  @TestVisible
  private inherited sharing virtual class Selector {
    /**
     * Query Job Application by Id with all related fields
     * @param recordId The Job Application Id
     * @return Job_Application__c with related Contact and Job Posting data
     */
    public virtual Job_Application__c getApplicationById(Id recordId) {
      return [
        SELECT
          Id,
          Name,
          Application_Date__c,
          Status__c,
          Years_of_Experience__c,
          Cover_Letter__c,
          Resume_URL__c,
          Candidate__r.Id,
          Candidate__r.FirstName,
          Candidate__r.LastName,
          Candidate__r.Email,
          Candidate__r.Phone,
          Candidate__r.Title,
          Job_Posting__r.Id,
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
        WHERE Id = :recordId
        WITH USER_MODE
        LIMIT 1
      ];
    }
  }
}
