global class ConfirmationRequest {
    
        global String ResourceName { get; set;} //Resources
        global String SystemId { get; set;} //vendorId / AccountId  in SF
        global String SystemSource { get; set;} //EIP.Core AccountSystemSource
        global String RequestedAction { get; set;}// create update export
        global String ErrorMessage { get; set;}
        global Boolean Succeeded { get; set;}

}