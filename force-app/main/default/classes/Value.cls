public class Value {
    
    public Object ItemValue { get; set; }
    public Boolean IsValid { get; set; }
    public String Reason { get; set; }
    
    public Value(Object itemValue, Boolean isValid, String reason)
    {
    	this.ItemValue = itemvalue;    
        this.IsValid = isValid;
        this.Reason = reason;
    }

}