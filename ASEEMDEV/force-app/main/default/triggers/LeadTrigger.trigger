/*******************************************************************************************************
* 
* @ Name            :   LeadTrigger
* @ Purpose         :   trigger automation on Lead sObject
* @ Methods         :   
* @ Author          :   Aseem Doddamani
* @ Usage           :   Fire record trigger process 
* @ Test Class Name :   TriggerHelperTest
*
*   Date            |  Developer Name                 |  Version      |  Changes
* ======================================================================================================
*   21-04-2024      |  aseem.doddamani@gmail.com      |  1.0          |  Initial Version
*
*******************************************************************************************************/
trigger LeadTrigger on Lead (before INSERT, before UPDATE) {
    if(trigger.isInsert){
        LeadTriggerHelper.assignSalesRep(Trigger.New);
    }
    if(trigger.isUpdate){
        LeadTriggerHelper.validateLeadToOpportunityCreation(Trigger.New);
        LeadTriggerHelper.assignSalesRep(Trigger.New);
    }
}