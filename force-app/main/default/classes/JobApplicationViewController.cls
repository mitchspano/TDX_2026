public with sharing class JobApplicationViewController {
    @AuraEnabled(cacheable=true)
    public static JobApplicationData getJobApplicationDetails(Id recordId) {
        try {
            Job_Application__c application = [
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
                LIMIT 1
            ];

            return new JobApplicationData(application);
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving job application: ' + e.getMessage());
        }
    }

    public class JobApplicationData {
        @AuraEnabled public Id applicationId;
        @AuraEnabled public String applicationNumber;
        @AuraEnabled public Date applicationDate;
        @AuraEnabled public String status;
        @AuraEnabled public Decimal yearsOfExperience;
        @AuraEnabled public String coverLetter;
        @AuraEnabled public String resumeUrl;

        @AuraEnabled public Id candidateId;
        @AuraEnabled public String candidateName;
        @AuraEnabled public String candidateEmail;
        @AuraEnabled public String candidatePhone;
        @AuraEnabled public String candidateTitle;

        @AuraEnabled public Id jobPostingId;
        @AuraEnabled public String jobPostingNumber;
        @AuraEnabled public String jobTitle;
        @AuraEnabled public String jobDescription;
        @AuraEnabled public String department;
        @AuraEnabled public String location;
        @AuraEnabled public String salaryRange;
        @AuraEnabled public String employmentType;
        @AuraEnabled public String jobStatus;
        @AuraEnabled public Date postedDate;
        @AuraEnabled public Date closingDate;
        @AuraEnabled public Decimal numberOfOpenings;

        public JobApplicationData(Job_Application__c app) {
            this.applicationId = app.Id;
            this.applicationNumber = app.Name;
            this.applicationDate = app.Application_Date__c;
            this.status = app.Status__c;
            this.yearsOfExperience = app.Years_of_Experience__c;
            this.coverLetter = app.Cover_Letter__c;
            this.resumeUrl = app.Resume_URL__c;

            if (app.Candidate__r != null) {
                this.candidateId = app.Candidate__r.Id;
                this.candidateName = app.Candidate__r.FirstName + ' ' + app.Candidate__r.LastName;
                this.candidateEmail = app.Candidate__r.Email;
                this.candidatePhone = app.Candidate__r.Phone;
                this.candidateTitle = app.Candidate__r.Title;
            }

            if (app.Job_Posting__r != null) {
                this.jobPostingId = app.Job_Posting__r.Id;
                this.jobPostingNumber = app.Job_Posting__r.Name;
                this.jobTitle = app.Job_Posting__r.Title__c;
                this.jobDescription = app.Job_Posting__r.Description__c;
                this.department = app.Job_Posting__r.Department__c;
                this.location = app.Job_Posting__r.Location__c;
                this.salaryRange = app.Job_Posting__r.Salary_Range__c;
                this.employmentType = app.Job_Posting__r.Employment_Type__c;
                this.jobStatus = app.Job_Posting__r.Status__c;
                this.postedDate = app.Job_Posting__r.Posted_Date__c;
                this.closingDate = app.Job_Posting__r.Closing_Date__c;
                this.numberOfOpenings = app.Job_Posting__r.Number_of_Openings__c;
            }
        }
    }
}
