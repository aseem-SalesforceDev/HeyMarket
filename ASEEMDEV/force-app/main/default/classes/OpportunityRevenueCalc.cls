/*******************************************************************************************************
* 
* @ Name            :   OpportunityRevenueCalc
* @ Purpose         :   Schedule apex to calculate revenue
* @ Methods         :   1) execute - Execute the 
* @ Methods         :   2) OppCalc - Calculate potential revenue for newly created revenue
* @ Author          :   Aseem Doddamani
* @ Usage           :   
* @ Test Class Name :   TriggerHelperTest
*
*   Date            |  Developer Name                 |  Version      |  Changes
* ======================================================================================================
*   21-04-2024      |  aseem.doddamani@gmail.com      |  1.0          |  Initial Version
*
*******************************************************************************************************/
public class OpportunityRevenueCalc Implements Schedulable{
    
    public void execute(SchedulableContext sc)
    {
        OppCalc();
    }
    
    //Calculate revenue for newly created Opportunities
    public void OppCalc()
    {
        //Retrieve newly created opportunities with line items 
        List<Opportunity> list_Opportunities = [SELECT ID,Potential_Revenue__c,
                                                (SELECT ID,UnitPrice,Quantity FROM OpportunityLineItems)
                                                FROM 
                                                OPPORTUNITY
                                                WHERE Opportunity.CreatedDate = TODAY];
        List<Opportunity> list_updateOpportunities = new List<Opportunity>();
        
        Decimal decProductTotalPrice = 0;
        for(Opportunity objOpp : list_Opportunities) {
            decProductTotalPrice = 0;
            
            if(objOpp.OpportunityLineItems != NULL) {
                for(OpportunityLineItem objOppLineItem : objOpp.OpportunityLineItems) {
                    Decimal decTempProductTotalPrice = 0;
                    decTempProductTotalPrice = objOppLineItem.UnitPrice * objOppLineItem.Quantity;
                    decProductTotalPrice = decProductTotalPrice + decTempProductTotalPrice;
                }
            }
            objOpp.Potential_Revenue__c = decProductTotalPrice;
            list_updateOpportunities.add(objOpp);
        }
        UPDATE list_updateOpportunities;
    }
}