/**
 *  The controller of sales representative page that displays
 *  the list of lead of particular owner.
 *
 *  Class : SalesRepresentativeController
 *  @author  Vaishali Varma
*/
public with sharing class SalesRepresentativeController {
    public string owner {get; set;}
    public list<selectOption> listOfOwner;
    public list<Lead> leadList {get; set;}
    public boolean renderpb{get; set;}
    public SalesRepresentativeController()
    {
        leadList = new list<Lead>();
        renderpb = false;
    }
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
    public void actionMethod()
    {
        system.debug('owner'+owner);
        system.debug('In action Method');
        renderpb = true;
        leadList = [SELECT Name,Company,Email,LeadSource FROM Lead WHERE Owner.Name = :owner];
        system.debug('leadList@@'+leadList);
    }
}