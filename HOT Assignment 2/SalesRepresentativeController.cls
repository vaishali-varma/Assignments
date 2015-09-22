/**
 *  The controller of sales representative page that displays
 *  the list of lead of particular owner.
 *
 *  Class : SalesRepresentativeController
 *  @author  Vaishali Varma
*/
public with sharing class SalesRepresentativeController {
    //displaying the list of user with role sales representatives.
    public list<selectOption> listOfOwner;

    //for displaying the list of leads assigned to representatives.
    public list<Lead> leadList {get; set;}
    public boolean renderpb{get; set;}
    public string owner {get; set;}

    //Constructor
    public SalesRepresentativeController()
    {
        leadList = new list<Lead>();
        renderpb = false;
    }

    //Displaying the list of owner that have roles as sales representatives
    public list<selectOption> getlistOfOwner()
    {
        listOfOwner = new list<selectOption>();
        listOfOwner.add(new selectOption('', '- None -'));
        for (User users : [SELECT Name FROM User where UserRole.Name=: 'Sales Representative']) 
        { 
            listOfOwner.add(new selectOption(users.Name, users.Name));
        }
        return listOfOwner;
    }

    //Displaying the list of leads assigned to the sales representative
    public void actionMethod()
    {
        system.debug('owner'+owner);
        system.debug('In action Method');
        renderpb = true;
        leadList = [SELECT Name
                          , Company
                          , Email
                          , LeadSource 
                       FROM Lead 
                      WHERE Owner.Name = :owner];
        system.debug('leadList@@'+leadList);
    }
}