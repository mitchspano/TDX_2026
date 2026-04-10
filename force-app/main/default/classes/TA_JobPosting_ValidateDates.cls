/**
 * Ensures Closing_Date is after Posted_Date.
 */
public with sharing class TA_JobPosting_ValidateDates implements TriggerAction.BeforeInsert, TriggerAction.BeforeUpdate {
  /**
   * Validate dates before insert
   * @param triggerNew Newly inserted records
   */
  public void beforeInsert(List<Job_Posting__c> triggerNew) {
    for (Job_Posting__c posting : triggerNew) {
      validateDates(posting);
    }
  }

  /**
   * Validate dates before update
   * @param triggerNew New state of updated records
   * @param triggerOld Previous state of updated records
   */
  public void beforeUpdate(
    List<Job_Posting__c> triggerNew,
    List<Job_Posting__c> triggerOld
  ) {
    Map<Id, Job_Posting__c> oldMap = new Map<Id, Job_Posting__c>(triggerOld);

    for (Job_Posting__c posting : triggerNew) {
      Job_Posting__c oldPosting = oldMap.get(posting.Id);

      if (
        posting.Posted_Date__c != oldPosting.Posted_Date__c ||
        posting.Closing_Date__c != oldPosting.Closing_Date__c
      ) {
        validateDates(posting);
      }
    }
  }

  private void validateDates(Job_Posting__c posting) {
    if (posting.Posted_Date__c == null || posting.Closing_Date__c == null) {
      return;
    }
    if (posting.Closing_Date__c <= posting.Posted_Date__c) {
      posting.addError(
        Job_Posting__c.Closing_Date__c,
        'Closing Date must be after Posted Date.'
      );
    }
  }
}
