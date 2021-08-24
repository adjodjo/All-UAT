@RestResource(urlMapping='/Note/EIP/*')

global class Note_Create_WS {
    
    @HttpPost
    global static void CreatContentNote(SettingNoteContentAPI noteContent){
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        String noteId;
        
     
        
        try{
            
            system.debug(' -- l entree est --'+noteContent);
            
       //     SettingNoteContentAPI note_Params = Note_Content_Parameters.Parameters_Deserialize(noteContent);
            
            if(noteContent.SF_AccountId != null){
                noteId = Note_CreateNewContent.CreateNote(noteContent);
                
                if(noteId != null){
                    
                    String jsonResult = JSON.serialize(noteId);
                  response.responseBody = Blob.valueOf( jsonResult);
                    response.statusCode = 200;
                }
              /* else{
                    
                   // Account_WS_Msg Err = VendorHelper.Build_Msg('Error -- Missing create note');
                    String jsonResult = JSON.serialize('Error -- Missing create note');
                    response.responseBody = Blob.valueOf( jsonResult);
                    response.statusCode = 400;
                    
                }  */
            }
            
            
        }catch(Exception ex){
            
          
            String jsonResult = JSON.serialize(String.valueOf(ex));
            response.responseBody = Blob.valueOf(jsonResult);
            response.statusCode = 500;
        }
        
        
    }

}