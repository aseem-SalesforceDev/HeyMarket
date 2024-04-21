/*******************************************************************************************************
* 
* @ Name            :   OpportunityTrigger
* @ Purpose         :   trigger automation on Opportunity sObject
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
trigger OpportunityTrigger on Opportunity (before INSERT, before UPDATE) {
	OpportunityTriggerHelper.oppStageUpdate(Trigger.New);
}