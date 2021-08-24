public class CaseOwnerAfterEscalated {
    @future
    public static void UpdateOwner(String cId, String cStatus, String cOwner){
        
        List<String> oldStatuses = new List<String>();
        String status, owner, caseId;
        
        
        if(cStatus == 'Escalated'){
            

            Case updateCase = new Case(Id = cId, OwnerId = cOwner);
            System.debug('owner to ubdate after escalated -- '+updateCase);
            Update updateCase;
        }
        
        
    }

}