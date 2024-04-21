/*******************************************************************************************************
* 
* @ Name            :   LeadTriggerHelper
* @ Purpose         :   Helper class for LeadTrigger.apxt
* @ Methods         :   1) assignSalesRep - To assign sales rep based on certain conditions
* @ Methods         :   2) validateLeadToOpportunityCreation - validate lead before it gets converted to an Opportunity
* @ Author          :   Aseem Doddamani
* @ Usage           :   
* @ Test Class Name :   TriggerHelperTest
*
*   Date            |  Developer Name                 |  Version      |  Changes
* ======================================================================================================
*   21-04-2024      |  aseem.doddamani@gmail.com      |  1.0          |  Initial Version
*
*******************************************************************************************************/
public class LeadTriggerHelper {
    
    public static void assignSalesRep(List<Lead> list_newLeads) {
        
        try{
            //Retrieve all Sales Rep with the least workload task
            Map<String,Sales_Representative__c> map_keyValuesBySalesRep = new Map<String,Sales_Representative__c>();
            List<Sales_Representative__c> list_SalesRep = [SELECT ID,Location__c,Source_Specialization__c,Industry_Specialization__c,Active_Leads__c
                                                           FROM Sales_Representative__c ORDER BY Active_Leads__c ASC];
            
            //creating unique key identifier for Sales rep to match criteria based on lead records
            for(Sales_Representative__c objSalesRep : list_SalesRep) {
                map_keyValuesBySalesRep.put(objSalesRep.Location__c+'-'+objSalesRep.Industry_Specialization__c+'-'+objSalesRep.Source_Specialization__c,
                                            objSalesRep);
            }
            
            Map<String,Lead> map_keyvaluesByLeadRecord = new Map<String,Lead>();
            Sales_Representative__c objSalesRepresentative = new Sales_Representative__c();
            List<Sales_Representative__c> list_updateSalesRepWorkCount = new List<Sales_Representative__c>();
            List<Lead> list_updateLeads = new List<Lead>();
            for(Lead objLead : list_newLeads) {
                map_keyvaluesByLeadRecord.put(objLead.Location__c+'-'+objLead.Industry+'-'+objLead.LeadSource,
                                              objLead);
                objSalesRepresentative = new Sales_Representative__c();
                //match and retrieve the key pair from the sales rep map
                objSalesRepresentative = map_keyValuesBySalesRep.get(objLead.Location__c+'-'+objLead.Industry+'-'+objLead.LeadSource);
                objSalesRepresentative.Active_Leads__c = objSalesRepresentative.Active_Leads__c + 1;
                objLead.Sales_Representative__c = objSalesRepresentative.ID;
                list_updateSalesRepWorkCount.add(objSalesRepresentative);
                list_updateLeads.add(objLead);
            }
            UPDATE list_updateSalesRepWorkCount;
        }
        catch(Exception ex) {
            //here we can log error messages
        }
    }
    
    public static void validateLeadToOpportunityCreation(List<Lead> list_newLeads) {
        
        try {
            for(Lead objLead : list_newLeads) {
                
                //Check if the lead is ready to be converted into an Opportunity
                if(objLead.Convert_to_Opportunity__c) {
                    
                    //Since Email and Phone field types are already validated through force.com
                    if(objLead.Email == NULL)
                        objLead.Email.addError('Email cannot be blank');
                    if(objLead.MobilePhone == NULL)
                        objLead.MobilePhone.addError('Mobile Number cannot be blank');
                    if(objLead.Industry == NULL)
                        objLead.Industry.addError('Industry cannot be blank');
                }
            }
        }
        catch(Exception ex) {
            //here we can log error messages
        }
    }
}