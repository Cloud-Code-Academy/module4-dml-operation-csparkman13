/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Christine Sparkman
 */

public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and insert it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        // Set some fields on the Account
        Account newAccount = new Account(
            Name = 'Sparkman Consulting',
            Phone = '847-309-4101',
            Website = 'https://www.sparkmanconsulting.com',
            Industry = 'Consulting'
        );

        // Insert the Account into the database
        insert newAccount;

        // Return the Id of the newly created Account
        return newAccount.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account acc = new Account(
            Name = name,
            Industry = industry
        );

        // Insert the Account
        insert acc;
    }

    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        Contact newContact = new Contact(
            FirstName = 'Christine',
            LastName = 'Sparkman',
            Email = 'costrander13@gmail.com',
            AccountId = accountId
        );

        // Insert the Contact into the database
        insert newContact;

        // Return the Id of the newly created Contact
        return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact contactToUpdate = [
            SELECT Id 
            FROM Contact 
            WHERE Id = :contactId
        ];

        // Update the Contact's last name
        contactToUpdate.LastName = newLastName;

        // Update the Contact in the database
        update contactToUpdate;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity opptyToUpdate = [
            SELECT Id 
            FROM Opportunity 
            WHERE Id = :oppId
        ];

        // Update the Opportunity's stage
        opptyToUpdate.StageName = newStage;

        // Update the Opportunity in the database
        update opptyToUpdate;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account accToUpdate = [
            SELECT Id 
            FROM Account 
            WHERE Id = :accountId
        ];

        // Update the Account with the given Id with the new name and industry
        accToUpdate.Name = newName;
        accToUpdate.Industry = newIndustry;

        update accToUpdate;
    }

    /**
     * Question 7
     * Create or updates an Opportunities.
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000
        for (Opportunity oppty : opportunities) {
            oppty.StageName = 'Qualification';
            oppty.CloseDate = Date.today().addMonths(3);
            oppty.Amount = 50000;
        }

        // Upsert the opportunities List so that records are either updated or created
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * HINT: There should not be duplicate opportunites based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Query for the Account to satisfy above requirements
        List<Account> acc = [
            SELECT Id 
            FROM Account 
            WHERE Name = :accountName
            ];

        // Declare the Account ID variable
        Id accId; 
        
        // If the Account does not exist, create it - if it doesn't find the accountName from Query above, create it, so it can be associated with the Opportunity later
        // Store the new Id in accId
        if (acc.size() == 0) {
            Account newAcc = new Account(Name = accountName);
            insert newAcc;
            accId = newAcc.Id;
        }
        // If the Account does exist, store the Id in accId
            else {
                accId = acc[0].Id;
            }

        // Loop through each Opportunity name
        List<Opportunity> opptys = new List<Opportunity>();

        // Find existing Opportunities (in the oppName) List with the same names
        // Checks for duplicates, so none get created
        List<Opportunity> existingOpptys = [
            SELECT Id, Name
            FROM   Opportunity
            WHERE Name IN : oppNames
            ];

        // Map the Opportunity names to Ids (key to value [Opportunity Name to Opportunity Id])
        // Lets you check later if an Opportunity with a given name already exists
        Map<String, Id> oppNameToId = new Map<String, Id>();
        for (Opportunity opp : existingOpptys) {
            // Now I'm assigning the key to value to the Map
            oppNameToId.put(opp.Name, opp.Id); 
        }

        // Loop through provided names in the List and build new Opportunities
        for (String oppName : oppNames) {
            if (oppNameToId.containsKey(oppName)) {
                // If the Opportunity name already exists in the Map, skip it
                continue;
            }
            // Create an Opportunity with the given Opportunity Name, Stage, and Close Date (required Fields)
            Opportunity opp = new Opportunity();
            opp.Name = oppName;
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            // Associate the Opportunity with the Account
            opp.AccountId = accId;
            // Add the Opportunity to the List of Opportunities to Insert
            opptys.add(opp);
        }

        insert opptys;
    }

    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the (existing) Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

        Account acc;
        // Checks if the accounts List has any records
        if (!accounts.isEmpty()) {
            //Gets the first Account from the List
            // If the Account exists, update the description
            acc = accounts[0];
            acc.Description = 'Updated Account';
        }
            else {
                // Otherwise, create a new Account and set the description
                acc = new Account(Name = accountName, Description = 'New Account');
            }

		// Upsert the Account - update if it exists, insert if it's new
        upsert acc;
		return acc;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        // Check if List is null or empty
        if (contactsToUpsert == null || contactsToUpsert.isEmpty()) {
            return;
        }

        // Make a List of Contacts with associated Accounts
        List<Contact> contactsToSave = new List<Contact>();
		// Loop through each Contact
        // Extract the Account Name from Contact's LastName
        for (Contact con : contactsToUpsert) {
            if (String.isNotBlank(con.LastName)) {
                String accountName = con.LastName;
		// Get the account based on the name or create one if it doesn't exist
                Account acc = upsertAccount(accountName);
		// Link the Contact to its Account using the Account Id
                con.AccountId = acc.Id;
                contactsToSave.add(con);
            }
        }

		// Upsert the Contacts
        if (!contactsToSave.isEmpty()) {
            upsert contactsToSave;
        }
	}

    /**
     * Question 11
     * Insert a list of Leads and then delete them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Check if the List is null or empty
        if (leadNames == null || leadNames.isEmpty()) {
            return;
        }

        // Create a List to hold new Leads (that will be inserted into the system later on)
        List<Lead> leadsToInsert = new List<Lead>();

        // Loop through each Lead name (name is Last Name) in the leadNames List and create Leads
        for (String name : leadNames) {
            Lead newLead = new Lead(
                FirstName = 'Test',
                LastName = name,
                Company = 'Test Company',
                Status = 'Open - Not Contacted'
            );
            // Add the newly created Lead to the leadsToInsert List
            leadsToInsert.add(newLead);
        }

        // Insert the Leads
        insert leadsToInsert;

        // Delete the Leads
        delete leadsToInsert;
    }

    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then delete them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Check if the accountId is null or empty and that numOfCases is a positive integer
        if (String.isBlank(accountId) || numOfCases == null || numOfCases <= 0) {
            return;
        }

        // Create a List to hold the Cases 
        List<Case> casesToInsert = new List<Case>();
        
        // Loop through the total numOfCases and creates that many Cases and relates each to an Account 
        for (Integer i = 0; i < numOfCases; i++) {
            Case c = new Case(
                Subject = 'Test Case' + (i + 1),
                Status = 'New',
                Origin = 'Web',
                AccountId = accountId
            );
            // Add the Cases to the List
            casesToInsert.add(c);
        }

        // Insert the Cases
        insert casesToInsert;

        // Delete the Cases
        delete casesToInsert;
    }
}