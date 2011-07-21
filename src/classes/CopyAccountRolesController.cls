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
public with sharing class CopyAccountRolesController {
public Opportunity opp {get;set;}
public Account acc {get;set;}
public List<AccountContactRole> accRoles {get;set;}
public Boolean isEditable {get;set;}
 
public CopyAccountRolesController(ApexPages.StandardController controller){
  isEditable = false;
  accRoles = new List<AccountContactRole>();
  
  opp = (Opportunity)controller.getRecord();
  opp = [select AccountId,Id,Name From Opportunity where Id=:opp.Id];
  if(opp.AccountId ==  null)
  {
  	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'This Opportunity has no Account to copy from.  Please set an account on the Opportunity to use this feature.'));
  	return;
  }
  
  acc = [Select Name, Id From Account where Id=:opp.AccountId];
  accRoles = [Select AccountId, ContactId, Contact.FirstName, Contact.LastName, isPrimary, Role, Id From AccountContactRole where AccountId=:opp.AccountId];

  if (accRoles.size() == 0)
  {
  	  	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'This account has no contact roles.  Please add account contact roles to use this feature.'));
  	return;
  }
  
  isEditable = true;
}

public PageReference save()
{
	List<OpportunityContactRole> oppRoles = new List<OpportunityContactRole>();
	OpportunityContactRole oppRole = new OpportunityContactRole();
	for (AccountContactRole accRole : accRoles)
	{
		oppRole = new OpportunityContactRole();
		oppRole.ContactId = accRole.ContactId;
		oppRole.OpportunityId = opp.Id;
		oppRole.isPrimary = accRole.isPrimary;
		oppRole.Role = accRole.Role;
		oppRoles.add(oppRole);
	}
	insert oppRoles;
	return cancel();
}

public PageReference cancel()
{
	return new PageReference('/' + opp.Id);
}
}