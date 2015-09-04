public with sharing class SearchQueryFromGoogleHandler {
    public static string response;
    public static void initialiseQueryList(list<QueryFromMail__c> queryReceiverList)
    {
        list<String> getQueryResult = new list<String>();
        system.debug('#### getQueryResult'+getQueryResult);
        for(QueryFromMail__c queryInstance : queryReceiverList)
        {
            system.debug('#### queryInstance'+queryInstance);
            string addQuery = queryInstance.Name;
            getQueryResult.add(addQuery);
        } 
        searchQuery(getQueryResult);
    }
    
    /*Since the @future method takes primitive data as parameter hence list<string>
      is passed as a parameter and the list contains the query whose response is to be fetched*/
    @future(callout=true)
    public static void searchQuery(List<String> listOfQuery)
    {
        for(String queryListInstance : listOfQuery)
        {
            system.debug('##########Inside Handler method');
            HttpRequest httpRequestInstance = new HttpRequest();
            httpRequestInstance.setEndpoint('https://www.google.com/search?q='+EncodingUtil.urlEncode(queryListInstance, 'UTF-8'));
            HttpRequestInstance.setHeader('Content-Type','application/json');
            HttpRequestInstance.setHeader('accept','application/json');
            HttpRequestInstance.setMethod('GET');
            Http httpInstance = new Http(); 
            HttpResponse httpResponseInstance = new HttpResponse();
            httpResponseInstance = httpInstance.send(HttpRequestInstance);
            response = httpResponseInstance.getBody();
            system.debug('######### Response' +httpResponseInstance.getBody());
            /*string firstBlock = response.substringBetween('<li class="g"','</li>');
            system.debug('############# firstBlock : '+firstBlock);
            string actualLink = response.substringBetween('<a href="','">');
            system.debug('######### actualLink'+actualLink);
            string link = response.substringBetween('<cite>','</cite>');
            system.debug('######## link : '+link);
            string detail = response.substringBetween('<span>','</span>');
            system.debug('######## detail : ' +detail);*/
            string str;
            //response = response.replace('<a href="','LinkStart');
            //response = response.replace('$amp;','linkEnd');
            response = response.replace('<a href="/url?q=', 'LinkStart[');
            response = response.replace('&amp;sa=U&amp;ved=', ']LinkEnd <a href="/url?q=');
            response = response.replace('<cite>','ActualLink[');
             response = response.replace('</cite>',']ActualLinkend DetailStart[ '); 
             response = response.replace('</div></li>', ']DetailEnd');
             System.debug('######String : '+response);
             
             String str1 = response.stripHtmlTags();
             System.debug('#### String2 : '+str1);
             List<String> strList = new List<String>();
             List<String> strListUpdated = new List<String>();
             strList = str1.split('DetailEnd');
             
             strList.remove(0);
             strList.remove(strList.size()-1);
            system.debug('###### strlist'+strList);
            
            QueryFromMail__c RecordThatContainsQuery =[
                SELECT Name,Sender_Address__c
                  FROM QueryFromMail__c 
                 WHERE Name = :queryListInstance];

            list<Search_Result__c> newSearchResultList = new list<Search_Result__c>();
            for(string stringInstance : strList)
            {
                Search_Result__c searchResultInstance = new Search_Result__c();
                searchResultInstance.Actual_Link__c = stringInstance.substringBetween('LinkStart[',']LinkEnd');
                system.debug('#############searchResultInstance.Actual_Link__c : '+searchResultInstance.Actual_Link__c);
                        
                searchResultInstance.Link_Detail__c = stringInstance.substringBetween(']LinkEnd','ActualLink[');
                system.debug('#############searchResultInstance.Link_Detail__c : '+searchResultInstance.Link_Detail__c);

                searchResultInstance.Description__c = stringInstance.substringBetween('DetailStart[',']');
                system.debug('#############searchResultInstance.Description__c : '+searchResultInstance.Description__c);
                
                searchResultInstance.QueryFromMail__c = RecordThatContainsQuery.Id;
                searchResultInstance.Sender_Email__c = RecordThatContainsQuery.Sender_Address__c;
                system.debug('searchResultInstance.QueryFromMail__c'+searchResultInstance.QueryFromMail__c);
                newSearchResultList.add(searchResultInstance);
            } 
            insert newSearchResultList;
        }
    }
}