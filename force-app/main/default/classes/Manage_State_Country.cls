public class Manage_State_Country {
    
     public static String manage_State(String eipState){
         String state;
          String userLanguage = UserInfo.getLanguage();
         
    //     if(userLanguage == 'en_US'){
             if(eipState == 'QC' || eipState == 'Quebec' || eipState == 'Québec') state = 'Quebec';             
             if(eipState == 'ON' || eipState == 'Ontario') state = 'Ontario';
             if(eipState == 'SL' || eipState == 'SK'|| eipState == 'Saskatchewan') state = 'Saskatchewan';
             if(eipState == 'AB' ||  eipState == 'Alberta') state = 'Alberta';
             
             if(eipState == 'BC' || eipState == 'British Columbia' || eipState == 'Colombie-Britannique') state = 'British Columbia';             
             if(eipState == 'MB' || eipState == 'Manitoba') state = 'Manitoba';
             if(eipState == 'NB' || eipState == 'New Brunswick' || eipState == 'Nouveau-Brunswick') state = 'New Brunswick';
             if(eipState == 'NF' || eipState == 'NL' ||  eipState == 'Newfoundland and Labrador' ||  eipState == 'Terre-Neuve-et-Labrador') state = 'Newfoundland and Labrador';
                
             if(eipState == 'NT' || eipState == 'Northwest Territories' || eipState == 'Territoires du Nord-Ouest') state = 'Northwest Territories';   
             if(eipState == 'NE' || eipState == 'NS' || eipState == 'Nova Scotia' || eipState == 'Nouvelle-Écosse') state = 'Nova Scotia';
             if(eipState == 'NU' || eipState == 'Nunavut') state = 'Nunavut';
             if(eipState == 'PE' || eipState == 'Prince Edward Island' || eipState == 'Île-du-Prince-Édouard') state = 'Prince Edward Island'; //Île-du-Prince-Édouard
             if(eipState == 'YT' ||  eipState =='Yukon') state = 'Yukon';
             
    
         return State;
         
     }
    
    
    public static String manage_Country(String eipCountry){
         String Country;
         String userLanguage = UserInfo.getLanguage();
       
         if(eipCountry == 'CA' || eipCountry == 'CAN' || eipCountry == 'Canada') Country = 'Canada';
         if(eipCountry == 'US' || eipCountry == 'USA' || eipCountry == 'United States' || eipCountry == 'États Unis' || eipCountry == 'États-Unis') Country = 'United States';
      
         return Country;
         
     }


}