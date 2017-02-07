public class TaskHandler {
    public class Job{
        public Job__c  Details;
        public Job(Job__c j){
            this.Details = j;
        }
        
    }
    
	 public class TaskHandlerException extends Exception{}
     private TaskService strategy;
     
    
     public TaskHandler(Job j){
         	  System.debug('PK--> TaskHandler');
            try{
               //Type T = Type.forName('TaskHandler.'+name );
               Type T = Type.forName(j.details.TaskHandler__c );
               System.debug('PK--> T '+t);
               strategy = (TaskService)T.newInstance();
            }catch(exception e){
               throw new TaskHandlerException(j.details.TaskHandler__c + ' not found ' + e.getMessage());
            } 
         
     }
     public void Execute(Job j){
             strategy.Execute(j);
     }
    
    // this is the interface for implementing each of the task handlers
    public interface TaskService{
    	void Execute(Job j);
	}
    
 
   
    
    
    
    
}