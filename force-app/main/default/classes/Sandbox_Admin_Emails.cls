public class Sandbox_Admin_Emails {
    
    public void Sandbox_Admin_Emails() {        
        List<User> allUsers = new List<User>();
		
        List<User> userList = [select Id, Email, Profile.Name 
                               from User 
                               where Profile.Name = 'System Administrator'];
        
        for(User u: userList) {
            System.debug('***before u.Email = ' + u.Email);
            if(u.Email.Contains('=avetta.com') == TRUE) {
            u.Email = u.Email.substring(0, u.Email.indexOf('=avetta.com')) + '@avetta.com';
            System.debug('***after u.Email = ' + u.Email);
            allUsers.add(u);
            }
        }
        
        System.debug('allUsers = ' + allUsers);
        update allUsers;
    }
}