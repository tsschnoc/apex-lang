/* ============================================================
 * This code is part of the "apex-lang" open source project avaiable at:
 * 
 *      http://code.google.com/p/apex-lang/
 *
 * This code is licensed under the Apache License, Version 2.0.  You may obtain a 
 * copy of the License at:
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * ============================================================
 */
@IsTest
private class UserUtilsTest {

    private static testmethod void testIsCurrentUserSysAdminPositive(){
        //test: global static Boolean isCurrentUserSysAdmin(){
        try{
            User usr = [select id from user where profile.name = 'System Administrator' and isactive=true limit 1];
            System.runAs(usr){
                System.assertEquals(true,UserUtils.isCurrentUserSysAdmin());
            }
        }catch(QueryException e){
            System.assert(false,'Environment Dependency: at least one System Administrator user needs to exist');
        }
    }
    
    private static testmethod void testIsCurrentUserSysAdminNegative(){
        //test: global static Boolean isCurrentUserSysAdmin(){
        User usr = null;
        try{
            usr = [select id from user where profile.name != 'System Administrator' and IsActive=true limit 1];
        }catch(QueryException qe){
            usr = [select id from user where profile.name = 'System Administrator' limit 1];
            usr.ProfileId = [select id from profile where name != 'System Administrator' limit 1].id;
            try{
                update usr;
            }catch(DmlException e){
                usr = new User(
                    Username= RandomStringUtils.randomAlphabetic(20)+ '@' + RandomStringUtils.randomAlphabetic(20) + '.com',
                    Alias = 'test123', 
                    Email='test123@salesforce.com', 
                    FirstName='John', 
                    LastName='Doe123', 
                    ProfileId = [select id from profile where name != 'System Administrator' limit 1].id, 
                    LanguageLocaleKey='en_US', 
                    LocaleSidKey='en_US', 
                    EmailEncodingKey='UTF-8', 
                    TimeZoneSidKey='America/Los_Angeles');
                try{
                    insert usr;
                }catch(DmlException e2){}
            }
        }
        if(usr != null){
            System.runAs(usr){
                System.assertEquals(false,UserUtils.isCurrentUserSysAdmin());
            }
        }    
    }

    private static testmethod void testIsCurrentUserPortalUserPositive(){
        //test: global static Boolean isCurrentUserPortalUser(){
        System.assertEquals(false,UserUtils.isCurrentUserPortalUser());
    }
    
}