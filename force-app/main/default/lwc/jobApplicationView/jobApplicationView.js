import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getJobApplicationDetails from '@salesforce/apex/JobApplicationViewController.getJobApplicationDetails';

export default class JobApplicationView extends NavigationMixin(LightningElement) {
    @api recordId;
    applicationData;
    error;
    isLoading = true;
    isEditMode = false;
    wiredResult;

    @wire(getJobApplicationDetails, { recordId: '$recordId' })
    wiredApplication(result) {
        this.wiredResult = result;
        const { error, data } = result;
        this.isLoading = false;
        if (data) {
            this.applicationData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.applicationData = undefined;
        }
    }

    get hasData() {
        return this.applicationData != null;
    }

    get formattedApplicationDate() {
        return this.applicationData?.Application_Date__c
            ? new Date(this.applicationData.Application_Date__c).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
              })
            : '';
    }

    get formattedPostedDate() {
        return this.applicationData?.Job_Posting__r?.Posted_Date__c
            ? new Date(this.applicationData.Job_Posting__r.Posted_Date__c).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
              })
            : '';
    }

    get formattedClosingDate() {
        return this.applicationData?.Job_Posting__r?.Closing_Date__c
            ? new Date(this.applicationData.Job_Posting__r.Closing_Date__c).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
              })
            : '';
    }

    get statusClass() {
        const status = this.applicationData?.Status__c?.toLowerCase() || '';
        return `status-badge status-${status.replace(/\s+/g, '-')}`;
    }

    get jobStatusClass() {
        const status = this.applicationData?.Job_Posting__r?.Status__c?.toLowerCase() || '';
        return `job-status-badge status-${status.replace(/\s+/g, '-')}`;
    }

    get yearsExperienceDisplay() {
        const years = this.applicationData?.Years_of_Experience__c;
        if (!years) return 'Not specified';
        return years === 1 ? '1 year' : `${years} years`;
    }

    get candidateEmailLink() {
        return this.applicationData?.Candidate__r?.Email
            ? `mailto:${this.applicationData.Candidate__r.Email}`
            : '';
    }

    get candidatePhoneLink() {
        return this.applicationData?.Candidate__r?.Phone
            ? `tel:${this.applicationData.Candidate__r.Phone}`
            : '';
    }

    get candidateName() {
        const candidate = this.applicationData?.Candidate__r;
        if (!candidate) return '';
        return `${candidate.FirstName || ''} ${candidate.LastName || ''}`.trim();
    }

    navigateToRecord(event) {
        const recordId = event.currentTarget.dataset.recordId;
        if (recordId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: recordId,
                    actionName: 'view'
                }
            });
        }
    }

    openResume() {
        if (this.applicationData?.Resume_URL__c) {
            window.open(this.applicationData.Resume_URL__c, '_blank');
        }
    }

    handleEdit() {
        this.isEditMode = true;
    }

    handleCancel() {
        this.isEditMode = false;
    }

    handleSuccess(event) {
        this.isEditMode = false;

        const toast = new ShowToastEvent({
            title: 'Success',
            message: 'Job Application updated successfully',
            variant: 'success'
        });
        this.dispatchEvent(toast);

        // Refresh the data
        return refreshApex(this.wiredResult);
    }

    handleError(event) {
        const toast = new ShowToastEvent({
            title: 'Error',
            message: 'Error updating Job Application',
            variant: 'error',
            mode: 'sticky'
        });
        this.dispatchEvent(toast);
    }
}
