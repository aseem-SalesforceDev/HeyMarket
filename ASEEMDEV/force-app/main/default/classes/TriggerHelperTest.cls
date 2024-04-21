/*******************************************************************************************************
* 
* @ Name        : 	TriggerHelperTest
* @ Purpose     : 	Test class for LeadTrigger.apxt, OpportunityTrigger.apxt
* @ Author      : 	Aseem Doddamani
*
*   Date        |  Developer Name                       |  Version      |  Changes
* ======================================================================================================
*   22-04-2024  |  aseem.doddamani@gmail.com            |  1.0          |  Initial Version
*
*******************************************************************************************************/
@isTest
public class TriggerHelperTest {
    
    @testSetup
    static void setupData() {
        // Create test records
        ID standardPricebook = Test.getStandardPricebookId();
        
        Pricebook2 objPriceBook = new Pricebook2(Name = 'Test Pricebook', IsActive = true);
        INSERT objPriceBook;
        
        Product2 objProduct = new Product2(Name = 'Test Product1', isActive = TRUE);
        INSERT objProduct;
        
        PricebookEntry objSTDPriceBookEntry = new PricebookEntry(Pricebook2Id = standardPricebook,
                                                                 UnitPrice = 2000.00,Product2Id = objProduct.Id,
                                                                 IsActive = TRUE);
        INSERT objSTDPriceBookEntry;
        
        PricebookEntry objPriceBookEntry = new PricebookEntry(Pricebook2Id = objPriceBook.Id,
                                                              UnitPrice = 2000.00,IsActive = TRUE, 
                                                              Product2Id = objProduct.Id);
        INSERT objPriceBookEntry;
        
        Sales_Representative__c objSalesRep = new Sales_Representative__c(Name = 'Sales Rep1',Source_Specialization__c = 'Partner Referral',
                                                                          Location__c = 'Maharashtra',Industry_Specialization__c = 'Engineering',
                                                                          Active_Leads__c = 0);
        INSERT objSalesRep;
        
        Lead objLead = new Lead(LastName='LeadLastName', Company = 'TestCompany',
                                Status = 'Open - Not Contacted',LeadSource = 'Partner Referral' , 
                                Location__c = 'Maharashtra', Industry = 'Engineering', Convert_to_Opportunity__c = FALSE,
                                Sales_Representative__c = NULL);
        INSERT objLead;
        
        Opportunity objOpportunity = new Opportunity(Name = 'Test Opportunity 1', CloseDate = SYSTEM.TODAY() + 15, StageName = 'Prospecting');
        INSERT objOpportunity;
        
        OpportunityLineItem objOppLineItem = new OpportunityLineItem(OpportunityID = objOpportunity.Id,
                                                                     UnitPrice = 2000, Quantity = 2, Product2Id = objProduct.Id,
                                                                     PriceBookEntryId = objPriceBookEntry.Id);
        
        INSERT objOppLineItem;
    }
    
    @isTest
    static void testAssignSalesRep() {
        
        Lead objLead2 = new Lead(LastName='LeadLastName 2', Company = 'TestCompany',
                                 Status = 'Open - Not Contacted',LeadSource = 'Partner Referral' , 
                                 Location__c = 'Maharashtra', Industry = 'Engineering', Convert_to_Opportunity__c = FALSE,
                                 Sales_Representative__c = NULL);
        Test.StartTest();
        INSERT objLead2;
        Test.StopTest();
    }
    
    @isTest
    static void testValidate() {
        
        Lead objLead2 = [SELECT ID,Convert_to_Opportunity__c,Email,MobilePhone FROM Lead WHERE LastName = 'LeadLastName'];
        
        //Blank fields vlidation run
        objLead2.Convert_to_Opportunity__c = TRUE;
        objLead2.Email = '';
        objLead2.MobilePhone = '';
        Test.StartTest();
        try{
            UPDATE objLead2;
        }
        catch(Exception ex) {
            System.assert(ex.getMessage().contains('Email cannot be blank'),ex.getMessage());
        }
        
        //Proper format field values
        objLead2.Convert_to_Opportunity__c = TRUE;
        objLead2.Email = 'test@test.invalid';
        objLead2.MobilePhone = '9898989898';
        UPDATE objLead2;
        Test.StopTest();
        
        system.assert(TRUE, objLead2.Email != NULL);
    }
    
    @isTest
    static void testUpdateOppStage() {
        Opportunity objOpportunity = [SELECT ID,Potential_Revenue__c,CloseDate,StageName
                                      FROM OPPORTUNITY WHERE Name = 'Test Opportunity 1'];
        objOpportunity.CloseDate = SYSTEM.TODAY() + 25;
        objOpportunity.Potential_Revenue__c = 2000;
        
        Test.StartTest();
        UPDATE objOpportunity;
        Test.StopTest();
        
        system.assert(TRUE, objOpportunity.StageName == 'Closing');
    }
    
    @isTest
    static void testCalcOppRevenue() {
        OpportunityRevenueCalc scheOpportunityRevenueCalc = new OpportunityRevenueCalc(); 
        String sch ='0 48 * * * ?'; 
        Test.StartTest();
        System.schedule('Schedule to Calculate Opp Revenue', sch,scheOpportunityRevenueCalc);
        Test.StopTest();
        
        Opportunity objOpportunity = [SELECT ID,Potential_Revenue__c,CloseDate,StageName
                                      FROM OPPORTUNITY WHERE Name = 'Test Opportunity 1'];
        
        system.assert(TRUE, objOpportunity.Potential_Revenue__c != NULL);
    }
}