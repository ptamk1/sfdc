public class PRF_TriggerInternalImp implements  PRF_TriggerHelperV2.PRF_TriggerService{
   
    public  void handleBeforeInsert(List<Project_Request_Form__c> prfs) {
    
    }
    
    public  void handleBeforeUpdate(List<Project_Request_Form__c> prfs, Map<Id, Project_Request_Form__c> oldMap) {
        system.debug('PK--> PRF_TriggerInternalImp:handleBeforeUpdate');
        checkProjectNumberChanged(prfs, oldMap);
        checkProjNumberFinalApproval(prfs);
      
    }
    
    public  void handleAfterInsert(List<Project_Request_Form__c> prfs) {
       commonHandleAfter(prfs);
    }
    
    public  void handleAfterUpdate(List<Project_Request_Form__c> prfs) {
       commonHandleAfter(prfs);
    }
    
     private void commonHandleAfter(List<Project_Request_Form__c> prfs){
        // this method inserts a record into the job object for processing by the batch daily processor
        map<id,boolean> relatedJobs = new map<id,boolean>();
        set<id> prfIds = new set<id>();
        for(Project_Request_Form__c prf:prfs){
				prfIds.add(prf.id);             
        }
        for(job__c j:[select id,reference__c from job__c where Status__c='Scheduled' and reference__c in:prfIds]){
             relatedJobs.put(j.reference__c,true);
        }
         
        list<job__c> myjobs =  new list<job__c>();
        for(Project_Request_Form__c prf:prfs){
            if(prf.status__c =='Unapproved' && !relatedJobs.containskey(prf.id)){
                myjobs.add(new job__c(Status__c='Scheduled',reference__c=prf.id,TaskHandler__c='PRF_ReminderImpl'));
            }
        }
        if(myjobs.size()>0){
            insert myjobs;
        }
    }
    
    
    
    /**
     * checkProjectNumberChanged()
     *  - checks if the Project Number of the PRF has changed - used to drive email alerts
     */
    private  void checkProjectNumberChanged(List<Project_Request_Form__c> prfs, Map<Id, Project_Request_Form__c> oldMap) {
        for (Project_Request_Form__c prf : prfs) {
            // check the project number has changed
            if (prf.Project_Number_and_Name__c != oldMap.get(prf.Id).Project_Number_and_Name__c) {
                prf.ProjectNumberChanged__c = true;
                prf.Project_Number_Date_Set__c = system.today();
            } else {
                
                prf.ProjectNumberChanged__c = false;
            }
        }
    }
    
    /**
     * checkProjNumberFinalApproval()
     *  - checks the internal PRF for a Project Number once the Status is Final Approval
     */
    private  void checkProjNumberFinalApproval(List<Project_Request_Form__c> prfs) {
        for (Project_Request_Form__c prf : prfs) {
            // check to see if the project number has been set before final approval
            if (prf.Status__c == 'Final Approval' && prf.Project_Number_and_Name__c == null) {
                prf.addError('You need to set the Project Number, before final approval.');
            }
        }
    }
    
  
}