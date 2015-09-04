 global with sharing class SearchResultFromGoogleController {
    
    public string query{get; set;}
    public list<Search_Result__c> resultsFromQuery;
    public list<QueryFromMail__c> listOfQueries;
    public boolean renderHistory{get; set;}
    public boolean renderResult{get; set;}
    public Integer noOfRecords{get; set;}
    public Integer size{get;set;}
    public integer limitSize;
    public integer offset;
    public integer totalRecords;
    
    public ApexPages.StandardSetController controllerInstance {
        get {
            if(controllerInstance == null) {
                size = 2;
                controllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Link_Detail__c,Actual_Link__c,Description__c
                       FROM Search_Result__c 
                      WHERE QueryFromMail__r.Name = :query]));
                    controllerInstance.setPageSize(size);
                    noOfRecords = controllerInstance.getResultSize();
            }
            return controllerInstance;
        }
        set;
    }
    
    public ApexPages.StandardSetController controllerInstanceForQuery {
        get {
            if(controllerInstanceForQuery == null) {
                size = 1;
                controllerInstanceForQuery = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name 
                       FROM QueryFromMail__c]));
                    controllerInstanceForQuery.setPageSize(size);
                    noOfRecords = controllerInstanceForQuery.getResultSize();
            }
            return controllerInstanceForQuery;
        }
        set;
    }
     
    public SearchResultFromGoogleController()
    {
        resultsFromQuery = new list<Search_Result__c>();
        listOfQueries = new list<QueryFromMail__c>();
        renderHistory = false;
        renderResult = false;
    }
    
    public boolean hasNext
    {
        get{
            return controllerInstance.getHasNext();
        }
        set;
    }
    
    public boolean hasPrevious
    {
        get{
            return controllerInstance.getHasprevious();
        }
        set;
    }
    
    public void first()
    {
        controllerInstance.first();
    }
    
    public void last()
    {
        controllerInstance.last();
    }
    
    public void previous()
    {
        controllerInstance.previous();
    }
    
    public void next()
    {
        controllerInstance.next();
    }
    
    public integer pageNumber
    {
        get{
            return controllerInstance.getPageNumber();
        }
        set;
    }
    
    public pageReference refresh() {
        controllerInstance = null;
        getlistOfQueries();
        controllerInstance.setPageNumber(1);
        return null;
    }
/*-------------------------------------------------------------------------------------------------*/
    public void showQueries()
    {
        renderHistory = true; 
    }
    
    public void showResult()
    {
        renderResult = true;
    }
    /*To get the list of queries from QueryFromMail__c object */
    public list<QueryFromMail__c> getlistOfQueries()
    {
        listOfQueries = [
            SELECT Name 
              FROM QueryFromMail__c];
        system.debug('#### listOfQueries'+listOfQueries);
        return listOfQueries;
    } 
    
    /*Get the search results of the associated query and display it on the page.*/
    public list<Search_Result__c> getresultsFromQuery()
    {
        system.debug('###### query'+query);
        return (List<Search_Result__c>) controllerInstance.getRecords();
        //totalRecords = resultsFromQuery.size();
    }
   
} 