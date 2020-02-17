global class BatchDailyProcessor implements Database.Batchable<SObject>,Database.stateful,Schedulable{
// test2
	// this is a generic batch process that run daily
	// it queries the custom object job queue and process using the taskhandler factory
    // a new comment
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new BatchDailyProcessor());
    }
     global Database.QueryLocator start(Database.BatchableContext BC) {
    	 system.debug('PK-->BatchDailyProcessor:start ');        
         return Database.getQueryLocator([SELECT Id,reference__c,Name,TaskHandler__c,Status__c from Job__c where  Status__c !='Complete']);
     }
    
    global void execute(Database.BatchableContext BC, List<Job__c> batch) {
        system.debug('PK-->BatchDailyProcessor:execute'+ batch);
         for(Job__c j:batch){
              TaskHandler.Job job= new TaskHandler.Job(j);
              TaskHandler handler = new TaskHandler(job);
              handler.execute(job);
          }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    
}