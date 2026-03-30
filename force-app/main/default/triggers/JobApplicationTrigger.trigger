/**
 * Trigger on Job_Application__c
 */
trigger JobApplicationTrigger on Job_Application__c(
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
