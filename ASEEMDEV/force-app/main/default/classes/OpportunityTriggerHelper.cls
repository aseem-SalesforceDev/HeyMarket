/*******************************************************************************************************
* 
* @ Name            :   OpportunityTriggerHelper
* @ Purpose         :   Helper class for OpportunityTrigger.apxt
* @ Methods         :   1) oppStageUpdate - To update the Opportunity stage when certain condistions are met
* @ Author          :   Aseem Doddamani
* @ Usage           :   
* @ Test Class Name :   TriggerHelperTest
*
*   Date            |  Developer Name                 |  Version      |  Changes
* ======================================================================================================
*   21-04-2024      |  aseem.doddamani@gmail.com      |  1.0          |  Initial Version
*
*******************************************************************************************************/
public class OpportunityTriggerHelper {
    
    public static void oppStageUpdate(List<Opportunity> list_Opportunity) {
        
        try{
            List<Opportunity> list_updateOpportunities = new List<Opportunity>();
            
            //custom label to dynamically configure the values if needed
            Integer intMinDayDifferenceLimit = Integer.ValueOf(SYSTEM.LABEL.DaysDifferenceValue);
            Integer intMinOppThresholdAmount = Integer.ValueOf(SYSTEM.LABEL.StandardOpportunityThresholdAmount);
            
            Date dtCloseDate, dtTodaysDate;
            Integer dtDaysDifference = 0;
            for(Opportunity objOpportunity : list_Opportunity) {
                dtDaysDifference = 0;
                dtCloseDate = objOpportunity.CloseDate;
                dtTodaysDate = SYSTEM.TODAY();
                dtDaysDifference = dtTodaysDate.daysBetween(dtCloseDate);
                if(dtDaysDifference < intMinDayDifferenceLimit && 
                   objOpportunity.Potential_Revenue__c > intMinOppThresholdAmount) {
                       objOpportunity.StageName = 'Closing'; 
                       list_updateOpportunities.add(objOpportunity);
                   }
            }
            UPDATE list_updateOpportunities;
        }
        catch(Exception ex){
            //error logging
        }
    }
}