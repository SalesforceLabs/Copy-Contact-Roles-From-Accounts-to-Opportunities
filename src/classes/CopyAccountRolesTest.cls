/*
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors 
    may be used to endorse or promote products derived from this software 
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
@isTest
private class CopyAccountRolesTest {

    static testMethod void copyRolesTest() {
        Account acc = new Account();
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';
        acc.BillingState = 'IL';        
        acc.Name = 'Test Acc';
        insert acc;
        Account acc2 = new Account();
        acc2.BillingCountry = 'US';
        acc2.ShippingCountry = 'US';
        acc2.BillingState = 'IL';        
        acc2.Name = 'Test Acc 2';
        insert acc2;     
          
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Jane';
        con.LastName = 'Doe';
        insert con;

        AccountContactRole acr = new AccountContactRole();
        acr.AccountId = acc.Id;
        acr.ContactId = con.Id;
        acr.Role = 'Economic Buyer';
        insert acr;
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.Name = 'test opp';
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today();
        insert opp;
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'test opp2';
        opp2.StageName = 'Prospecting';
        opp2.CloseDate = System.today();
        insert opp2;       
       
       List<OpportunityContactRole> ocrs = new List<OpportunityContactRole>();
       ocrs = [Select Id From OpportunityContactRole where OpportunityId=:opp.Id];
       System.assertEquals(0, ocrs.size());
        
       ApexPages.Standardcontroller con1 = new ApexPages.Standardcontroller(opp);
	   CopyAccountRolesController carc = new CopyAccountRolesController(con1);
	   
	   carc.save();
       ocrs = [Select Id From OpportunityContactRole where OpportunityId=:opp.Id];
       System.assertEquals(1, ocrs.size());	   
	   
       con1 = new ApexPages.Standardcontroller(opp2);
	   carc = new CopyAccountRolesController(con1);	      
	      
	   opp2.AccountId = acc2.Id;
	   update opp2;  
       
       con1 = new ApexPages.Standardcontroller(opp2);
	   carc = new CopyAccountRolesController(con1);	  
	           
    }
}