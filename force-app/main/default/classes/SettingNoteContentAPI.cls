global class SettingNoteContentAPI {
    
    global String SF_NoteId;
    global String SF_AccountId;
    global String x_ActiveDirectoryName;
    global String EIP_NoteSubject;
    global String EIP_NoteText;
     public SettingNoteContentAPI(String SF_NoteId, String SF_AccountId, String x_ActiveDirectoryName, String EIP_NoteSubject, String EIP_NoteText){
        
        this.SF_NoteId = SF_NoteId;
        this.SF_AccountId = SF_AccountId;
        this.x_ActiveDirectoryName = x_ActiveDirectoryName;
        this.EIP_NoteSubject = EIP_NoteSubject;
        this.EIP_NoteText = EIP_NoteText;
    }
 
}