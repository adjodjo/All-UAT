public class getEmailTemplate {
    
    public Static String EmailTemplate(String TempName, String infoLId, String lang){
        
        String templateName = null;
        
        // The process is for Invoice then choice the invoice templates for sending email
        if(TempName == 'Invoice'){
            
            
            if(lang == 'FR'){
                if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060')  templateName=TempName+'_HCC_FR'; 
                
                else 
                    if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName=TempName+'_CLE_FR'; 
                
                else {
                    
                    templateName=TempName+'_Invoice';
                }
                
            }
            else 
            {
                if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060')  templateName=TempName+'_HCC_EN'; 
                
                else 
                    if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName=TempName+'_CLE_EN'; 
                
                else {
                    
                    templateName=TempName+'_Invoice';
                }
            }
        }
        else{
            
            if(lang == 'FR'){
                if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060')  templateName=TempName+'_Letter_HCC_FR'; 
                
                else 
                    if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName=TempName+'_Letter_CLE_FR'; 
                
                else {
                    
                    templateName = null;
                }
                
            }
            else 
            {
                if(infoLId == '025'|| infoLId == '026'||infoLId == '027'|| infoLId == '060')  templateName=TempName+'_Letter_HCC_EN'; 
                
                else 
                    if (infoLId == '051'|| infoLId == '052'||infoLId == '065') templateName=TempName+'_Letter_CLE_EN'; 
                
                else {
                    
                    templateName = null;
                }
            }
        }
        
        
        
        return templateName;
    }
    
   
    
}