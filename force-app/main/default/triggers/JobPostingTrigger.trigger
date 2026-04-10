/**
 * Trigger on Job_Posting__c
 */
trigger JobPostingTrigger on Job_Posting__c(
  before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete,
  after undelete
) {
  new MetadataTriggerHandler().run();
}
