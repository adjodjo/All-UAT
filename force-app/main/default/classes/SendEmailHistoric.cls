global class SendEmailHistoric {
    
    global static SendCustomResponse getSendHistoric( SettingSendHistoric S_Historic){
        
            Map<String, Object> response;
        String err_Msg=null, histId, histObj, result, hid, hobj, hnum;
        String HistoricType = S_Historic.EIP_HistoricType;
        try{
        if(HistoricType == 'Invoice'){
            
            system.debug('HistoricType '+ HistoricType);
            
            if(S_Historic.SF_HistoryId != null){
                hobj = 'Historic_Invoice';
                result = SendEmailDocument.DocumentEmail(S_Historic.SF_HistoryId, hobj ,S_Historic,HistoricType);
                
                response = (Map<String, Object>) JSON.deserializeUntyped(result);
                        
                        err_Msg = (String)response.get('API_Error_Msg');
                        histId = (String)response.get('HistoryId');
                        histObj = (String)response.get('HistoryObj');
            }
            else{
                    
                    err_Msg = 'Historic is not availble';
                    histId = null;
                    histObj = null;
                    
                }
            
        }
        else if(HistoricType == 'Letters'){
            
            system.debug('SF_ParentHistoriId '+S_Historic.SF_ParentHistoryId);
            
            if(S_Historic.SF_ParentHistoryId != null){
                
                system.debug('SF_ParentHistoriId '+S_Historic.SF_ParentHistoryId);
                List<Historic__c> selectHistoric = [SELECT id, Historic_Document_Type__c, Historic_Detail_Number__c , Object_Name__c  FROM Historic__c WHERE id = :S_Historic.SF_ParentHistoryId];
                
                if(selectHistoric.size() >0){
                    
                    for(Historic__c h : selectHistoric){
                        hid = h.Id;
                        hobj = h.Object_Name__c;
                        hnum = h.Historic_Detail_Number__c;
                    }
                    
                    if(hnum != null){
                        
                        system.debug('S_Historic.DMS_FileName '+S_Historic.DMS_FileName+ ' S_Historic.EIP_ContentType '+S_Historic.DMS_DocType+' Hobj '+hobj);
                        system.debug(' S_Historic '+S_Historic);
                        
                        result = SendEmailDocument.DocumentEmail(hnum, hobj ,S_Historic, HistoricType);
                        
                        response = (Map<String, Object>) JSON.deserializeUntyped(result);
                        
                        err_Msg = (String)response.get('API_Error_Msg');
                        histId = (String)response.get('HistoryId');
                        histObj = (String)response.get('HistoryObj');
                        
                    }
                    
                    
                }
                else{
                    
                    err_Msg = 'Parent Historic is not availble';
                    histId = null;
                    histObj = null;
                    
                }
            }
        }
    }catch(Exception ex){
        err_Msg = ex.getStackTraceString();
    }
        return new SendCustomResponse( err_Msg);
         
    }
}