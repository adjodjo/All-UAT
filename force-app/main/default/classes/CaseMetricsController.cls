public class CaseMetricsController {
    
    @AuraEnabled
    public static string getcaseCreatedTime(String recordId){
        Case caseRec;
        DateTime end_Date;
        //System.debug('recordId--->' + recordId);
        for(Case cas : [SELECT Id, CreatedDate, Status, ClosedDate  FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        
        If(caseRec.Status != 'Closed' ){
            end_Date = Datetime.now();
        }
        else{
            end_Date = caseRec.ClosedDate;
        } 
        
        BusinessHours bh = [SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE IsDefault=true];
        
        Long difference = BusinessHours.diff(bh.Id, caseRec.CreatedDate, end_Date);
        //system.debug('difference:::'+difference);
        Long milliseconds = difference;
        Long mins = milliseconds / 60000;
        Long days = mins / 60 / 8 ;
        Long dhours = (mins - days * 60 * 8) / 60 ;
        Long dmins = (mins - days * 60 * 8) - (dhours * 60) ;
        String timeSpentOnCase = days+'D '+dhours+'H '+dmins+'M ';
        
        //System.debug('timeSpentOnCase:::'+timeSpentOnCase);
        
        return timeSpentOnCase;
        
    }
    
       @AuraEnabled
    public static string getcaseAssignedTime(String recordId){
        Case caseRec;
        DateTime end_Date;
        String assignedTimeOnCase;
        //System.debug('recordId--->' + recordId);
        for(Case cas : [SELECT Id, Assignment_Start_Time__c, CreatedDate, Status, ClosedDate  FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        
        If(caseRec.Status != 'Closed' ){
            end_Date = Datetime.now();
        }
        else{
            end_Date = caseRec.ClosedDate;
        } 
        
        BusinessHours bh = [SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE IsDefault=true];
        If(caseRec.Assignment_Start_Time__c != null){
        Long difference = BusinessHours.diff(bh.Id, caseRec.Assignment_Start_Time__c, end_Date);
        //system.debug('difference:::'+difference);
        Long milliseconds = difference;
        Long mins = milliseconds / 60000;
        Long days = mins / 60 / 8 ;
        Long dhours = (mins - days * 60 * 8) / 60 ;
        Long dmins = (mins - days * 60 * 8) - (dhours * 60) ;
        assignedTimeOnCase = days+'D '+dhours+'H '+dmins+'M ';
        }else{
        assignedTimeOnCase = '0D 0H 0M';
        }
        
        //System.debug('assignedTimeOnCase:::'+assignedTimeOnCase);
        
        return assignedTimeOnCase;
        
    }
    
    @AuraEnabled
    public static string getcasePendingTime(String recordId){
        Case caseRec;
        DateTime end_Date;
        String pendingTimeOnCase;
        //System.debug('recordId--->' + recordId);
        for(Case cas : [SELECT Id, Assignment_Start_Time__c,Pending_Status_Start_Time__c,Pending_Status_End_Time__c, CreatedDate, Status, ClosedDate  FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        
        If(caseRec.Pending_Status_End_Time__c == null ){
            end_Date = Datetime.now();
        }
        else{
            end_Date = caseRec.Pending_Status_End_Time__c;
        } 
        
        BusinessHours bh = [SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE IsDefault=true];
        If(caseRec.Pending_Status_Start_Time__c != null){
        Long difference = BusinessHours.diff(bh.Id, caseRec.Pending_Status_Start_Time__c, end_Date);
        //system.debug('difference:::'+difference);
        Long milliseconds = difference;
        Long mins = milliseconds / 60000;
        Long days = mins / 60 / 8 ;
        Long dhours = (mins - days * 60 * 8) / 60 ;
        Long dmins = (mins - days * 60 * 8) - (dhours * 60) ;
        pendingTimeOnCase = days+'D '+dhours+'H '+dmins+'M ';
        }else{
        pendingTimeOnCase = '0D 0H 0M';
        }
        
        //System.debug('assignedTimeOnCase:::'+assignedTimeOnCase);
        
        return pendingTimeOnCase;
        
    }
    
    @AuraEnabled
    public static Decimal getCaseCreatedMetric(String recordId){
        Case caseRec;
        Decimal CreatedTime;
        DateTime end_Date;
        System.debug('recordId--->' + recordId);
        for(Case cas : [SELECT Id, CreatedDate, Status, ClosedDate  FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        
        If(caseRec.Status != 'Closed' ){
            end_Date = Datetime.now();
        }
        else{
            end_Date = caseRec.ClosedDate;
            
        } 
        
        BusinessHours bh = [SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE IsDefault=true];
        DateTime startTime = DateTime.newInstance(System.today(), bh.MondayStartTime);
        DateTime endTime = Datetime.newinstance(System.today(), bh.MondayEndTime);
        
        Long totalTime = endTime.getTime() - startTime.getTime();
        System.debug('totalTime' + totalTime);
        Double totalWorkTime = totalTime/3600000;
        System.debug('totalWorkTime' + totalWorkTime);
        
        // Double milliseconds = BusinessHours.diff(bh.Id, caseRec.CreatedDate, end_Date);                 
        Integer countDays = getBusinessDaysHours(caseRec.CreatedDate, end_Date,bh.Id);
        System.debug('countDays:::'+countDays);                //CreatedTime = (Decimal.valueOf(milliseconds)).Divide((60*60*1000), 2);
        CreatedTime = countDays * totalWorkTime;
        System.debug('date debut ---> '+caseRec.CreatedDate +'--- end_Date--->' + end_Date+ '--- CreatedTime --'+ CreatedTime);
        
        return CreatedTime;
    }
    
    private static Case getCaseRecord(String recordId){
        Case caseRec;
        Decimal CreatedTime;
        System.debug('recordId--->' + recordId);
        for(Case cas : [SELECT Id,CreatedDate, Assignment_Delay__c, Assign_Date__c,  Pending_Time__c, Status, ClosedDate  FROM Case WHERE Id =: recordId LIMIT 1]){
            caseRec = cas;
        }
        
        System.debug('caseRec--->' + caseRec);
        return caseRec;
    }
    
    Private static Decimal getCaseMetricRecord(String recordId){
        Case_Status_Metric__c caseRec;
        Decimal metricC = 0.0;
        String caseId, status='Pending';
        System.debug('recordId--->' + recordId);
        for(Case_Status_Metric__c caseMetric : [SELECT Id, Case__c, Case_Status__c, Status_Time__c  FROM Case_Status_Metric__c WHERE Case__c =: recordId AND Case_Status__c =:status]){
            metricC = metricC + caseMetric.Status_Time__c;
            caseId = caseMetric.Case__c;
            caseRec = caseMetric;
        }
        System.debug('caseRec pending--->' + metricC);
        return metricC;
    }
    
    Private static Decimal getCaseMetricOwner(String recordId){
        Case_Status_Metric__c caseRec;
        Decimal metricC = 0.0;
        String caseId, status='Pending';
        
        /*    for(Case_Status_Metric__c caseMetric : [SELECT Id, Case__c, Case_Status__c, Status_Time__c, Owner_Case__c FROM Case_Status_Metric__c 
WHERE Case__c =: recordId ]){
if(!(caseMetric.Owner_Case__c).contains('Queue')){
metricC = metricC + caseMetric.Status_Time__c;
caseId = caseMetric.Case__c;
caseRec = caseMetric;
}
}   */
        
        Case caseRecord = getCaseRecord(recordId);
        
        BusinessHours bh = [SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE IsDefault=true];
        DateTime startTime = DateTime.newInstance(System.today(), bh.MondayStartTime);
        DateTime endTime = Datetime.newinstance(System.today(), bh.MondayEndTime);
        
        Long totalTime = endTime.getTime() - startTime.getTime();
        Double totalWorkTime = totalTime/3600000;
        
        Double milliseconds = 0.0;
        Decimal AssTime = 0.0;
        Integer countDays = 0;
        If(caseRecord.Assign_Date__c != null){
            
            If(caseRecord.Status != 'Closed'){
                // milliseconds = BusinessHours.diff(bh.Id, caseRecord.Assign_Date__c, Datetime.now());
                countDays = getBusinessDaysHours(caseRecord.Assign_Date__c, Datetime.now(),bh.Id);
                //AssTime = (Decimal.valueOf(milliseconds)).Divide((60*60*1000), 2);
                AssTime = countDays * totalWorkTime;
            }
            else {
                //  milliseconds = BusinessHours.diff(bh.Id, caseRecord.Assign_Date__c, caseRecord.ClosedDate);                 
                countDays = getBusinessDaysHours(caseRecord.Assign_Date__c, caseRecord.ClosedDate,bh.Id);
                //AssTime = (Decimal.valueOf(milliseconds)).Divide((60*60*1000), 2);
                AssTime = countDays * totalWorkTime;  
            }
        } 
        
        
        System.debug('caseRec assign--->' + AssTime);
        return AssTime;
    }
    public static Integer getBusinessDaysHours(DateTime startDate,DateTime endDate,Id bHoursId){
        Integer countDays = 0;
        while(startDate <= endDate){
            if(BusinessHours.isWithin(bHoursId, startDate)){
                countDays++;
            }
            startDate = startDate.addDays(1);
        }
        System.debug('countDays' + countDays);
        return countDays;
    }
    
    @AuraEnabled
    public static String ConvertComputationDelay(String recordId){
        System.debug('124');
        Decimal d = 0.5/24; Decimal h = 1.00/24;
        Decimal c =0;
        Decimal m =0;
        Decimal CreatedTime = getCaseCreatedMetric(recordId);
        System.debug('CreatedTime avant--->' + CreatedTime + ' ---' );
        
        System.debug('CreatedTime apres--->' + CreatedTime + ' ---' );
        
        
        Decimal metricC =  getCaseMetricRecord(recordId);        
        Decimal OwnermetricC = getCaseMetricOwner(recordId);
        Case caseRecord = getCaseRecord(recordId);
        Integer countDaysForCreate = 0;
        Integer countDaysForAssigned = 0;
        Integer countDaysForPending = 0;
        String d1, d2,d3, dd1,dd2, dd3;
        Decimal Assd , creatd, pend; 
        System.debug('caseRecord create--->' + CreatedTime);
        BusinessHours bh = [SELECT Id,MondayStartTime,MondayEndTime FROM BusinessHours WHERE IsDefault=true];
        // calculate total days for creation
        If(caseRecord.Status != 'Closed'){
            countDaysForCreate = getBusinessDaysHours(caseRecord.CreatedDate, Datetime.now(),bh.Id);
        }
        else {
            countDaysForCreate = getBusinessDaysHours(caseRecord.CreatedDate, caseRecord.ClosedDate,bh.Id);
        }
        
        // calculate days for assigned time
        If(caseRecord.Assign_Date__c != null){
            If(caseRecord.Status != 'Closed'){
                countDaysForAssigned = getBusinessDaysHours(caseRecord.Assign_Date__c, Datetime.now(),bh.Id);
            }
            else {
                countDaysForAssigned = getBusinessDaysHours(caseRecord.Assign_Date__c, caseRecord.ClosedDate,bh.Id);
            }
        } 
        
        If(caseRecord.Assignment_Delay__c != null){
            assd = OwnermetricC ; // caseRecord.Assignment_Delay__c ;//
        }
        else assd =  00 + OwnermetricC; // caseRecord.Assignment_Delay__c ;//OwnermetricC;// ;//+ OwnermetricC;
        
        System.debug('les valeurs assd avant--->' + assd + ' ---'+d );
        
        If(caseRecord.Pending_Time__c != null){
            pend = metricC + caseRecord.Pending_Time__c; 
        }
        else pend = 00 + metricC;
        System.debug('pend avant--->' + pend + ' ---'+d );
        
        
        System.debug('pend apres--->' + pend);
        
        
        Decimal minutes_d1 = Math.Floor( ( assd - Math.Floor(assd) ) * 60 );
        Decimal heure_d1 = Math.round(Math.Floor(math.mod( assd.round() ,8)));
        if(minutes_d1 <= 30) heure_d1 = heure_d1; else heure_d1 = heure_d1 - 1;
        dd1 = String.valueOf( minutes_d1 );
        if(dd1.length() <= 1)dd1 = '0'+dd1;  else dd1=dd1;
        d1 =  countDaysForAssigned + ' Day ' + String.valueOf(heure_d1) +' H '+dd1 + ' Min ';   
        
        Decimal minutes_d2 = Math.Floor( ( CreatedTime - Math.Floor(CreatedTime) ) * 60 );
        System.debug('minutes_d2 %%' + minutes_d2);
        Decimal heure_d2 = Math.round(Math.Floor(math.mod( CreatedTime.round() ,8)));
        System.debug('heure_d2 %%' + heure_d2);
        
        if(minutes_d2 <= 30) heure_d2 = heure_d2; else heure_d2 = heure_d2 - 1;
        dd2 = String.valueOf( minutes_d2) ;
        if(dd2.length() <= 1)dd2 = '0'+dd2;  else dd2=dd2;
        d2 =  countDaysForCreate + ' Day ' + String.valueOf(heure_d2) +' H '+dd2 + ' Min ';
        
        Decimal minutes_d3 = Math.Floor( ( pend - Math.Floor(pend) ) * 60 );
        Decimal heure_d3 = Math.round(Math.Floor(math.mod( pend.round() ,24)));
        if(minutes_d3 <= 30) heure_d3 = heure_d3; else heure_d3 = heure_d3 -1;
        dd3 = String.valueOf( minutes_d3) ;
        if(dd3.length() <= 1)dd3 = '0'+dd3;  else dd3=dd3;
        d3 =  String.valueOf(heure_d3) +' H '+dd3 + ' Min ';
        
        
        String t = JSON.serialize(new CaseMetricsCustomResponse(d2, d1, d3));
        System.debug('t--->' + t);
        return t;
        
    }
    
    
    
    
    
}