public class SystemValue {
    
    public String Id { get; set; }
    public Integer SystemType { get; set; }
    
    public SystemValue(String Id, Integer SystemType)
    {
    	this.Id = Id;    
        this.SystemType = SystemType;
        
    }

}