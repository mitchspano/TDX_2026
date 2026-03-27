/**
 * Prevents the same candidate from applying to the same job posting multiple times
 */
public inherited sharing class TA_JobApp_PreventDuplicates implements TriggerAction.BeforeInsert, TriggerAction.BeforeUpdate {
  @TestVisible
  private static TA_JobApp_PreventDuplicates.Selector selector {
    get {
      selector = selector ?? new TA_JobApp_PreventDuplicates.Selector();
      return selector;
    }
    set;
  }

  /**
   * Prevent duplicates before insert
   * @param triggerNew Newly inserted records
   */
  public void beforeInsert(List<Job_Application__c> triggerNew) {
    preventDuplicateApplications(triggerNew);
  }

  /**
   * Prevent duplicates before update
   * @param triggerNew New state of updated records
   * @param triggerOld Previous state of updated records
   */
  public void beforeUpdate(
    List<Job_Application__c> triggerNew,
    List<Job_Application__c> triggerOld
  ) {
    List<Job_Application__c> changedApps = filterToChangedApplications(
      triggerNew,
      triggerOld
    );
    if (!changedApps.isEmpty()) {
      preventDuplicateApplications(changedApps);
    }
  }

  private List<Job_Application__c> filterToChangedApplications(
    List<Job_Application__c> triggerNew,
    List<Job_Application__c> triggerOld
  ) {
    List<Job_Application__c> result = new List<Job_Application__c>();
    Map<Id, Job_Application__c> oldMap = new Map<Id, Job_Application__c>(
      triggerOld
    );
    for (Job_Application__c app : triggerNew) {
      Job_Application__c oldApp = oldMap.get(app.Id);
      if (
        app.Candidate__c != oldApp.Candidate__c ||
        app.Job_Posting__c != oldApp.Job_Posting__c
      ) {
        result.add(app);
      }
    }
    return result;
  }

  private void preventDuplicateApplications(
    List<Job_Application__c> applications
  ) {
    List<Set<Id>> parentIds = extractIds(applications);
    Set<Id> candidateIds = parentIds[0];
    Set<Id> jobPostingIds = parentIds[1];
    Set<Id> applicationIds = new Set<Id>();
    for (Job_Application__c a : applications) {
      applicationIds.add(a.id);
    }

    if (candidateIds.isEmpty() || jobPostingIds.isEmpty()) {
      return;
    }

    Map<String, Job_Application__c> existingApps = getJobApplicationsByCandidateAndPostingId(
      selector.getApplications(candidateIds, jobPostingIds, applicationIds)
    );

    addErrorToDuplicates(applications, existingApps);
  }

  private void addErrorToDuplicates(
    List<Job_Application__c> applications,
    Map<String, Job_Application__c> existingApps
  ) {
    for (Job_Application__c app : applications) {
      if (app.Candidate__c == null || app.Job_Posting__c == null) {
        continue;
      }
      Job_Application__c existingApp = existingApps.get(getKey(app));

      if (existingApp != null) {
        app.addError(
          'This candidate has already applied to this job posting. Application Number: ' +
          existingApp.Name
        );
      }
    }
  }

  private Map<String, Job_Application__c> getJobApplicationsByCandidateAndPostingId(
    List<Job_Application__c> existingApps
  ) {
    Map<String, Job_Application__c> result = new Map<String, Job_Application__c>();
    for (Job_Application__c existing : existingApps) {
      result.put(getKey(existing), existing);
    }
    return result;
  }

  private String getKey(Job_Application__c app) {
    return String.valueOf(app.Candidate__c) +
      ' | ' +
      String.valueOf(app.Job_Posting__c);
  }

  private List<Set<Id>> extractIds(List<Job_Application__c> applications) {
    List<Set<Id>> result = new List<Set<Id>>();
    result.add(new Set<Id>()); //candidate Ids
    result.add(new Set<Id>()); //job posting Ids
    for (Job_Application__c app : applications) {
      if (app.Candidate__c != null) {
        result.get(0).add(app.Candidate__c);
      }
      if (app.Candidate__c != null) {
        result.get(1).add(app.Job_Posting__c);
      }
    }
    return result;
  }

  @TestVisible
  private inherited sharing virtual class Selector {
    /**
     * Query Job_Application__c
     * @param candidateIds Contact Ids
     * @param jobPostingIds Job_Posting__c Ids
     * @param jobApplicationIds Job_Application__c Ids
     * @return query results
     */
    public virtual List<Job_Application__c> getApplications(
      Set<Id> candidateIds,
      Set<Id> jobPostingIds,
      Set<Id> jobApplicationIds
    ) {
      return [
        SELECT Id, Name, Candidate__c, Job_Posting__c
        FROM Job_Application__c
        WHERE
          Candidate__c IN :candidateIds
          AND Job_Posting__c IN :jobPostingIds
          AND Id NOT IN :jobApplicationIds
        WITH SYSTEM_MODE
      ];
    }
  }
}
