 public with sharing class SearchResultDisplayController {
    public Id queryToGet{get; set;}
    public list<Search_Result__c> searchResultList = new list<Search_Result__c>();
    public list<Search_Result__c> getsearchResultList()
    {
        searchResultList = [
            SELECT Actual_Link__c,Description__c,Link_Detail__c,QueryFromMail__c,Sender_Email__c 
              FROM Search_Result__c 
             WHERE QueryFromMail__c = :queryToGet];
             return searchResultList;
    }
    
}
