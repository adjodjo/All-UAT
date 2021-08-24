trigger EmailMessage_Trigger on EmailMessage (after insert, Before insert, after update, Before update) {
    
    
    IF( trigger.isAfter){
         system.debug('TRIGGER IS AFTER');
        EmailMessage_Trigger_Handler.EmailMessageManage(Trigger.new);    
    }
    
    IF( trigger.isBefore){
         system.debug('TRIGGER IS BEFORE');
        EmailMessage_Trigger_Handler.EmailMessageManageBefore(Trigger.new);    
    }

}