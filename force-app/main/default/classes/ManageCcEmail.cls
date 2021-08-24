public class ManageCcEmail {
    
    public static List<String> ManageCcEmal(String ccEmail){
        
        List<String> ccEmailList = new  List<String>();
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // CC Email Adresses
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
       
        
        if(ccEmail != null || String.isNotBlank(ccEmail)){
            
            String delimiter1 = ',',delimiter2 = ';', firstSplit= null, lastSplits= null, copiEmail = ccEmail, myDelimiteur = null;
            system.debug('le cc entré est '+ccEmail);
            // Test délimiteur
            String firstSplit1= null, firstSplit2= null, lastSplits1= null, lastSplits2= null;
            firstSplit1 = copiEmail.substringBefore(delimiter1); 
            system.debug('firstSplit1 '+firstSplit1);
            lastSplits1 = copiEmail.substringAfter(delimiter1);
            system.debug('lastSplits1 '+lastSplits1.length());
            firstSplit2 = copiEmail.substringBefore(delimiter2); 
            system.debug('firstSplit2 '+firstSplit2);
            lastSplits2 = copiEmail.substringAfter(delimiter2);
            system.debug('lastSplits2 '+lastSplits2);
            
            if((lastSplits1.length() > 0) ){
                
                myDelimiteur = delimiter1;
                system.debug('firstSplit1 '+firstSplit1);
                system.debug('cei délimiteur 1 '+delimiter1);
            }
            else if(lastSplits2.length() > 0  ){
                
                myDelimiteur = delimiter2;
                system.debug('firstSplit2 '+firstSplit2);
                system.debug('cei délimiteur 2 '+delimiter2);
            }
            else{
                ccEmailList.add(ccEmail);
            }
            
            if(myDelimiteur != null){
                system.debug('le délimiteur est '+myDelimiteur);
                do{
                    
                    firstSplit = '';  lastSplits = '';  
                    if(ccEmail.length() > 0){ // check if the cc email in not null before used CC email field value
                        
                        firstSplit = copiEmail.substringBefore(myDelimiteur); // 'this'
                        lastSplits = copiEmail.substringAfter(myDelimiteur);
                        
                        if( lastSplits.length() == 0 && copiEmail.length() > 0){
                            ccEmailList.add(copiEmail);
                            copiEmail = '';
                        }
                        else{
                            if(firstSplit.length() > 0 && lastSplits.length() > 0){
                                ccEmailList.add(firstSplit);
                                copiEmail = lastSplits;
                            }
                        }
                    } 
                    system.debug('la liste des cc email est '+ccEmailList);
                }While(String.isNotBlank(copiEmail));
            }                       
        }
    
        return ccEmailList;
    }
    
}