({
	doSearchBuyout : function(component, event, helper) {
        console.log('test...')
        var hcontact = component.get("v.historycontact");
        var haccount = component.get("v.historyaccount");
        var hNumber = component.get("v.historyBuyoutNum");
        var hContract = component.get("v.historycontract");
        
        var hvariance = component.get("v.historyvariance");
        
        var hamount = component.get("v.historyamount");
      
        console.log('test...')
        var hsdate = component.get("v.historystartdate");
        var hedate = component.get("v.historyenddate");
        var withInvoice = component.get("v.historyinvoice");
        console.log('account...'+haccount)        
        console.log('avec invoice...'+withInvoice)
        // String account, String contact, Decimal amount1, Decimal amount2, Date d1, Date d2
        var action = component.get("c.historicSearch");
        action.setParams({
            "bNumber":hNumber,
            "bContract":hContract,
            "account":haccount,
            "contact":hcontact,
            "amount":hamount,
            "variance":hvariance,
            "sdate":hsdate,
            "edate":hedate,
            "invoice":withInvoice
        });
        console.log('haccount...'+haccount)
        

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('envoie...'+state)
             if (state == "SUCCESS") {
                var items = response.getReturnValue();
               //  var item = items.remove('\"');
                 console.log("items", response.getReturnValue())
             //    console.log("item", item)
                 
                 if(items.length <= 0 ){
                     component.set("v.HistoriesBuyout",items);
                     component.set("v.isExist", true);
                 }
                 else {
                   //  console.log("HistoriesBuyout", JSON.parse(JSON.stringify(response.getReturnValue()).Id))
                      component.set("v.HistoriesBuyout",response.getReturnValue());
                     component.set("v.isExist", false);
                     
                 }
                 
               //  var parsed2 = JSON.parse(response.getReturnValue());
                 
          //       var his = parsed2.get("history");
                 
            //     console.log("his", his)

                 
                // var items = response.getReturnValue();
              //   var parsed = JSON.stringify(response.getReturnValue());
                 
               //  console.log($A.util.json.encode( JSON.parse(response.getReturnValue()) ));
                 
             //    console.log("items1", JSON.parse(parsed).Id)
                 
                 
                 
                 //var parsed2 = JSON.parse(response.getReturnValue());
                 
              //   console.log("items2", response.getReturnValue().Id)
                 
                
             //    component.set('v.historycode',parsed2);
                 
             }
            else{
                console.log('aucune offre ...')
            }
            
        /*    var state = response.getState();
            if (state == "SUCCESS") {
                console.log('envoie...'+msg)
                
               // items = response.getReturnValue();
                
               // console.log('items...'+items)
            }*/
        
    });
        $A.enqueueAction(action);
		
	}
    
    
})