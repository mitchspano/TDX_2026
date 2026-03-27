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
        return this.applicationData?.applicationDate
            ? new Date(this.applicationData.applicationDate).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
              })
            : '';
    }

    get formattedPostedDate() {
        return this.applicationData?.postedDate
            ? new Date(this.applicationData.postedDate).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
              })
            : '';
    }

    get formattedClosingDate() {
        return this.applicationData?.closingDate
            ? new Date(this.applicationData.closingDate).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
              })
            : '';
    }

    get statusClass() {
        const status = this.applicationData?.status?.toLowerCase() || '';
        return `status-badge status-${status.replace(/\s+/g, '-')}`;
    }

    get jobStatusClass() {
        const status = this.applicationData?.jobStatus?.toLowerCase() || '';
        return `job-status-badge status-${status.replace(/\s+/g, '-')}`;
    }

    get yearsExperienceDisplay() {
        const years = this.applicationData?.yearsOfExperience;
        if (!years) return 'Not specified';
        return years === 1 ? '1 year' : `${years} years`;
    }

    get candidateEmailLink() {
        return this.applicationData?.candidateEmail
            ? `mailto:${this.applicationData.candidateEmail}`
            : '';
    }

    get candidatePhoneLink() {
        return this.applicationData?.candidatePhone
            ? `tel:${this.applicationData.candidatePhone}`
            : '';
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
        if (this.applicationData?.resumeUrl) {
            window.open(this.applicationData.resumeUrl, '_blank');
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
