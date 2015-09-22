/**
 *  The handler of PostOnChatterOnLeadInsertion trigget that posts the
 *  update on the chatter group of sales representative.
 *
 *  Class : PostOnChatterOnLeadInsertionHandler
 *  @author  Vaishali Varma
*/
public with sharing class PostOnChatterOnLeadInsertionHandler {
    public static string status;
    public static map<Id,string> userMap = new map<Id,string>();
    public static void PostOnChatter(list<Lead> leadList)
    {
        system.debug('### Lead List'+leadList);
        list<FeedItem> posts = new list<FeedItem>();
        CollaborationGroup chatterGroup = [
            SELECT Id 
              FROM CollaborationGroup 
             WHERE Name = :System.Label.label_for_sales_representative 
        ];

        list<User> ownerInstance = [
                SELECT Id
                     , Name 
                  FROM User 
            ];
        for(User userInstance : ownerInstance)
        {
            if(!userMap.containsKey(userInstance.Id))
            {
                userMap.put(userInstance.Id,userInstance.Name);
            }
        }
        system.debug('#### userMap'+userMap);

        for(Lead leadInstance : leadList)
        {
            system.debug('### LEadList'+leadList);
            system.debug('### Lead name'+leadInstance.FirstName);
            system.debug('###### Lead Owner '+leadInstance.OwnerId);

            if(userMap.containsKey(leadInstance.OwnerId))
            {
                system.debug('####Lead owner Id'+leadInstance.OwnerId);
                system.debug('###### Inside if');
                system.debug('##### Lead Name '+leadInstance.Name);
                system.debug('@@@@@ Map value'+userMap.get(leadInstance.Id));
                status = 'New lead '+'" '+leadInstance.FirstName +' '+ leadInstance.LastName +' "'+ ' inserted and is assigned to ' +'" ' + userMap.get(leadInstance.OwnerId) + ' "' + ' !';
                FeedItem post = new FeedItem(
                    ParentId = chatterGroup.Id,
                        Body = status,
                       Title = system.label.Title_for_feed_item
                );
                system.debug('######### post '+post);
                posts.add(post);
                system.debug('######### post '+posts);
            }
        }
        insert posts;
    }
}