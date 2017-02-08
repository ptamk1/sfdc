@isTest(seealldata=false)
public class BatchDailyProcessor_Test {
    static testMethod void BatchTest(){
      
        // create a PRF
        /* PRFNewCont cont = new PRFNewCont(new ApexPages.StandardController(new Project_Request_Form__c()));
        cont.selectedPrfType = UTH_RecordTypes.getInstance().getRecordTypeByName('Internal Complete','Project_Request_Form__c');
        cont.Proceed();
        
        // ensure requestor and project name is complete
        Project_Request_Form__c prf = [select id,project_name__c,createdDate,name,Requestor__c,status__c from Project_Request_Form__c limit 1];
        prf.Requestor__c = UserInfo.getUserId();
        prf.project_name__c = 'Test1';
        update prf;
        */
        test.startTest();
        // this batch queries the job__c records and executes the identified taskhandler class, which ultimately sends an email
        database.executeBatch(new BatchDailyProcessor());
        test.stopTest();
        
        
        
        
    }
     
     
}