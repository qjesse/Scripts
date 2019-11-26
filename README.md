# Scripts
A collection of scripts for Powershell. Typically relating to Office 365.

### editUserInformation.ps1
---

Uses Connect-AzureAD to connect to your organization and from there prompts you for input of what you'd like to do for editing a particular user. Only supports being able to change phone extension, job title, and their password.

#### Usage

Follow the on-host prompts! 

### convertFirstAndLastNameToO365Fields.ps1
---

### **Web-help Script!**
For now I only have a script set up to help the web process. The problem was if you tried to add the only two fields you needed, User Name and Display Name, it wouldn't fill in the fields First Name and Last Name. I found this highly rude. 

This script takes a list of names provided by single-column CSV and converts them into these fields:

* First Name
* Last Name
* User Name (email)
* Display Name (full name)

And that's it. It does nothing else until you import it; but it should seamlessly import with no errors as long as everything is filled out correctly. It's up to you to make sure you don't mess up any user names or domain names using this method! You can't go back after an import into O365 or do this method to bulk edit in O365.

## Adding Bulk Users
---
To add bulk users, navigate to your Active Users page in the admin center. At the top next to ```+ Add a user``` you should see a ```more``` dropdown, and from there you should see ```+ Import multiple users```. After you run the script you should have a csv that's ready to be imported via file upload.

### Prerequisites for script:
>* A list of first and last names only in one single column in a CSV file. 
>* The full path of this CSV file. ex. c:\users\jstandridge\documents\users.csv
>* The domain you will be using for these users. ex. wowee.com

Enjoy! It should be pretty straight forward but if you have any questions, contact me (Jesse).

Output should always look like this (each case and formatting will reflect the same on each user in the end result csv):

| FirstName | LastName | Username | DisplayName |
|---|---|---|---|
|Jesse | Standridge | jesse.standridge@example.com | Jesse Standridge |


