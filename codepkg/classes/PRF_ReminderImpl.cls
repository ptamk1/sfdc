public class PRF_ReminderImpl implements TaskHandler.TaskService{
	    // This is called from the BatchDailyProcessor
    	
    	private Project_Request_Form__c prf;
        public void Execute(TaskHandler.job job){
                  
           // take reference id of the record to be processed
           String prfId = job.details.reference__c;
             
           // query the PRF and check to see that its still unapproved
            if(prfId != null){
                 this.prf = [select id,project_name__c,createdDate,name,Requestor__c,status__c from Project_Request_Form__c where id=:prfId ];
                if(this.prf.status__c !='Unapproved'){
                     // if its not unapproved then mark the job as complete
                    job.details.status__c = 'Complete';
                    update job.details;
                }else{
                     // send the reminder 
                     SendReminder();
                }
            }
        }

        private void SendReminder(){
            // CANT Use USER and WHAT ID so cant use a template
        
            OrgWideEmailAddress owe = [SELECT ID,IsAllowAllProfiles,DisplayName,Address FROM OrgWideEmailAddress WHERE Address = 'sfdc-system@aciworldwide.com'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.setTargetObjectId(this.prf.Requestor__c );
        	//mail.setTemplateID(this.prfreminderTemplate.ID);
        	
        	//mail.setWhatId(this.prf.id);
        	mail.setSaveAsActivity(false);
            //mail.setFromAddress()
           
            String link = System.Url.getSalesforceBaseURL().toExternalForm() + '/'+this.prf.id;
            String body = '<body>';
            body = body + 'You created '+this.prf.name +' for '+ this.prf.project_name__c + ' on ' + this.prf.CreatedDate +' but did not submit it for approval yet. ';
            body = body + '<BR/><BR/>Please be sure to complete the capitalization questions if you have not done so already and then click the SUBMIT button on the PRF record.';
            body = body + '<BR/>If you no longer require this project in Oracle, please click the CANCEL PRF button to remove this item from the list of outstanding project requests.';
            body = body + '<BR/><BR/>Please click on the <a href="' + link + '">Link</a> to review';
            body = body + '<BR/>Many Thanks';
			body = body + '<BR/>Project Request Form - Team';

            body = body +'</body>';
            //mail.setToAddresses(new String[] {'sfdc-system@aciworldwide.com'});
            //mail.setReplyTo('salesforce-no-reply@aciworldwide.com');
            mail.setSubject('Internal Project Request Form '+ this.prf.name + ' Reminder: Not Submitted for Approval');
            mail.setHtmlBody(body);
            mail.setReplyTo('salesforce-no-reply@aciworldwide.com');
            mail.setOrgWideEmailAddressId(owe.Id);
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }        
        
        
          
   }