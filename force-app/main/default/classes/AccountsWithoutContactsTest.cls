@isTest
public class AccountsWithoutContactsTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(Name='Account '));
          
        }
        insert accounts;     
    }
    @isTest static void test() {
        Test.startTest();
        AccountsWithoutContacts acc = new AccountsWithoutContacts();
        Id batchId = Database.executeBatch(acc);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [SELECT count() FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact) ]);
    }
}