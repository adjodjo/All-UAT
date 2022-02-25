/*
 
Build by Alban Tagnitsap (15/01/2022)
 */

public class ControllingPicklist {
    
    
    public static Integer getFieldDependencies(String objectName, String controllingField, String dependentField, String myValue)
{
    Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
    
    List<String> myListDependentValue = new List<String>();

    Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

    Schema.DescribeSObjectResult describeResult = objType.getDescribe();
    Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
    Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();

    List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
    List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
   
    
    
    try{
    for(Schema.PicklistEntry currControllingValue : controllingValues) 
    {
        System.debug('ControllingField: Label:' + currControllingValue.getLabel());
        controllingInfo.put(currControllingValue.getLabel(), new List<String>());
    
        if( currControllingValue.getLabel() == myValue ){
            
             System.debug('la valleur du picklist parent est :' + currControllingValue.getLabel());

    for(Schema.PicklistEntry currDependentValue : dependentValues) 
    {
        
     //   System.debug('currDependentValue: ' + currDependentValue);
        String jsonString = JSON.serialize(currDependentValue);

        MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);

        String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();

       // System.debug('DependentField: Label:' + currDependentValue.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);

        Integer baseCount = 0;

        for(Integer curr : hexString.getChars())
        {
            Integer val = 0;

            if(curr >= 65)
            {
                val = curr - 65 + 10;
            }
            else
            {
                val = curr - 48;
            }

            if((val & 8) == 8)
            {
                System.debug('Dependent Field 1: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 0].getLabel());
                if(controllingValues[baseCount + 0].getLabel() == myValue ){
                    myListDependentValue.add(currDependentValue.getLabel());
               // controllingInfo.put(currControllingValue.getLabel(), myListDependentValue);
             //   if(currDependentValue != null )
                  //  controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                    
                    
                }
                
            }
            if((val & 4) == 4)
            {
                System.debug('Dependent Field 2: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 1].getLabel());
               if(controllingValues[baseCount + 1].getLabel() == myValue )
                    myListDependentValue.add(currDependentValue.getLabel());
                // controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
            }
            if((val & 2) == 2)
            {
                System.debug('Dependent Field 3: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 2].getLabel());
               if(controllingValues[baseCount + 2].getLabel() == myValue )
                    myListDependentValue.add(currDependentValue.getLabel());
                
                // controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
            }
            if((val & 1) == 1)
            {
                System.debug('Dependent Field 4: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 3].getLabel());
               
                if(controllingValues[baseCount + 3].getLabel() == myValue )
                    myListDependentValue.add(currDependentValue.getLabel());
                
                // controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
            }

            baseCount += 4;
        }            
    } 
        }///// IF
} ////////////////// FOR

    System.debug('ControllingInfo: ' + controllingInfo);

   
    
}catch(Exception ex){
    
    system.debug(' exception est ===== '+ex.getStackTraceString());
    system.debug(' exception est ===== '+ex.getMessage());
}
    
    System.debug('la taille Dependent Field est : '+myListDependentValue.size());
     return myListDependentValue.size(); //controllingInfo;
}
    
    
    
     public class MyPickListInfo
   {
        public String validFor;
   }

}