public class AccountsWithoutContacts implements Database.Batchable<sObject>, Database.stateful {
    public integer total_used;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)]);
    }


    public void execute(Database.BatchableContext context, List<Account> accList) {
        AsyncApexJob objAsyncJob = [SELECT Id, CreatedDate FROM AsyncApexJob WHERE Id = :context.getJobId()];
        
        for(Account acc : accList) {        
            acc.Batch_Start_Time__c	 = objAsyncJob.CreatedDate;
        }
        
        update accList;
    }
    

    public void finish(Database.BatchableContext context) {
        List<AggregateResult> results = [SELECT COUNT(Id) FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)];
        total_used = (Integer) results[0].get('expr0');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'lizabezzubenko2712@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Processing ');
        mail.setPlainTextBody('Number of processed records: ' + total_used);
        list<Messaging.SendEmailResult> lstEmailResult = Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
         }  

}