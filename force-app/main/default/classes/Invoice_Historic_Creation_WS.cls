@RestResource(urlMapping='/Historic_INVOICE__c/*')

global with sharing class Invoice_Historic_Creation_WS {
    
    @HttpPut
    global static Invoice_HistoryCustomResponse createHistoriqueInvoice( String InvoiceParam){
        
       Invoice_HistoryCustomResponse newInvoice;
        
       System.debug('InvoiceParam = '+InvoiceParam);
            SettingInvoiceHistoric InvoiceSettings = Invoice_History_Parameters.Parameters_Deserialize(InvoiceParam);
            
            newInvoice = CreateNew_Invoice.CreateInvoice(InvoiceSettings);
                        
     
        return newInvoice;
    }

}

/*

/services/apexrest/Historic_Invoice__c/Send/*

{
"S_Historic":{
"SF_ParentHistoryId": "a012D0000023SzLQAU",
"SF_HistoryId": "a072i000000fSXRAA2",
"IL_Langue": "EN",
"x_ActiveDirectoryName": "adjodjo",
"IL_Contact": "David Granger",
"SendEmail": "alban.tagnitsap@analystik.ca",
"CcSendEmail": " ",
"DMS_FileName": "027-0102262-002.pdf",
"DMS_File": "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OCA0OTggNDk4IDQ2MyA4OTQgNTc4IDU0MyA1MzMgNjE1IDQ4OCA0NTkgNjMwIDYyMyAyNTEgMzE4IDUxOSA0MjAgODU0IDY0NSA2NjIgNTE2IDY3MiA1NDIgNDU5IDQ4NyA2NDEgNTY3IDg4OSA1MTkgNDg3IDQ2OCAzMDYgMzg2IDMwNiA0OTggNDk4IDI5MSA0NzkgNTI1IDQyMiA1MjUgNDk3IDMwNSA0NzAgNTI1IDIyOSAyMzkgNDU0IDIyOSA3OTggNTI1IDUyNyA1MjUgNTI1IDM0OCAzOTEgMzM0IDUyNSA0NTEgNzE0IDQzMyA0NTIgMzk1IDMxNCA0NjAgMzE0IDQ5OCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAyMjYgMzI1IDQ5OCA1MDYgNDk4IDUwNiA0OTggNDk4IDM5MiA4MzQgNDAyIDUxMiA0OTggMzA2IDUwNiAzOTQgMzM4IDQ5OCAzMzUgMzM0IDI5MSA1NDkgNTg1IDI1MiAzMDcgMjQ2IDQyMiA1MTIgNjM2IDY3MSA2NzUgNDYzIDU3OCA1NzggNTc4IDU3OCA1NzggNTc4IDc2MyA1MzMgNDg4IDQ4OCA0ODggNDg4IDI1MSAyNTEgMjUxIDI1MSA2MjQgNjQ1IDY2MiA2NjIgNjYyIDY2MiA2NjIgNDk4IDY2MyA2NDEgNjQxIDY0MSA2NDEgNDg3IDUxNiA1MjcgNDc5IDQ3OSA0NzkgNDc5IDQ3OSA0NzkgNzcyIDQyMiA0OTcgNDk3IDQ5NyA0OTcgMjI5IDIyOSAyMjkgMjI5IDUyNSA1MjUgNTI3IDUyNyA1MjcgNTI3IDUyNyA0OTggNTI5IDUyNSA1MjUgNTI1IDUyNSA0NTIgNTI1IDQ1MiBdDQovRW5jb2RpbmcgL1dpbkFuc2lFbmNvZGluZw0KL0ZvbnREZXNjcmlwdG9yIDE0IDAgUg0KPj4NCmVuZG9iag0KDQoxNCAwIG9iag0KPDwNCi9UeXBlIC9Gb250RGVzY3JpcHRvcg0KL0ZvbnROYW1lIC9DYWxpYnJpDQovRmxhZ3MgMzINCi9Gb250QkJveCBbLTUwMiAtMjUwIDEyNDAgOTcwXQ0KL0FzY2VudCA5NzANCi9EZXNjZW50IC0yNTANCi9DYXBIZWlnaHQgNjMxDQovSXRhbGljQW5nbGUgMA0KL1N0ZW1WIDgwDQo+Pg0KZW5kb2JqDQoNCjcgMCBvYmoNCjw8DQovVHlwZS9Gb250DQovU3VidHlwZSAvVHJ1ZVR5cGUNCi9CYXNlRm9udCAvQXJpYWwNCi9GaXJzdENoYXIgMzINCi9MYXN0Q2hhciAyNTUNCi9XaWR0aHMgWyAyNzcgMjc3IDM1NCA1NTYgNTU2IDg4OSA2NjYgMTkwIDMzMyAzMzMgMzg5IDU4MyAyNzcgMzMzIDI3NyAyNzcgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDI3NyAyNzcgNTgzIDU4MyA1ODMgNTU2IDEwMTUgNjY2IDY2NiA3MjIgNzIyIDY2NiA2MTAgNzc3IDcyMiAyNzcgNTAwIDY2NiA1NTYgODMzIDcyMiA3NzcgNjY2IDc3NyA3MjIgNjY2IDYxMCA3MjIgNjY2IDk0MyA2NjYgNjY2IDYxMCAyNzcgMjc3IDI3NyA0NjkgNTU2IDMzMyA1NTYgNTU2IDUwMCA1NTYgNTU2IDI3NyA1NTYgNTU2IDIyMiAyMjIgNTAwIDIyMiA4MzMgNTU2IDU1NiA1NTYgNTU2IDMzMyA1MDAgMjc3IDU1NiA1MDAgNzIyIDUwMCA1MDAgNTAwIDMzMyAyNTkgMzMzIDU4MyAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAyNzcgMzMzIDU1NiA1NTYgNTU2IDU1NiAyNTkgNTU2IDMzMyA3MzYgMzcwIDU1NiA1ODMgMzMzIDczNiA1NTIgMzk5IDU0OCAzMzMgMzMzIDMzMyA1NzYgNTM3IDMzMyAzMzMgMzMzIDM2NSA1NTYgODMzIDgzMyA4MzMgNjEwIDY2NiA2NjYgNjY2IDY2NiA2NjYgNjY2IDEwMDAgNzIyIDY2NiA2NjYgNjY2IDY2NiAyNzcgMjc3IDI3NyAyNzcgNzIyIDcyMiA3NzcgNzc3IDc3NyA3NzcgNzc3IDU4MyA3NzcgNzIyIDcyMiA3MjIgNzIyIDY2NiA2NjYgNjEwIDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDg4OSA1MDAgNTU2IDU1NiA1NTYgNTU2IDI3NyAyNzcgMjc3IDI3NyA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTQ4IDYxMCA1NTYgNTU2IDU1NiA1NTYgNTAwIDU1NiA1MDAgXQ0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCi9Gb250RGVzY3JpcHRvciAxNSAwIFINCj4+DQplbmRvYmoNCg0KMTUgMCBvYmoNCjw8DQovVHlwZSAvRm9udERlc2NyaXB0b3INCi9Gb250TmFtZSAvQXJpYWwNCi9GbGFncyAzMg0KL0ZvbnRCQm94IFstNjY0IC0yMTEgMjAwMCA5MzddDQovQXNjZW50IDkzNw0KL0Rlc2NlbnQgLTIxMQ0KL0NhcEhlaWdodCA3MTYNCi9JdGFsaWNBbmdsZSAwDQovU3RlbVYgODANCj4+DQplbmRvYmoNCg0KOCAwIG9iag0KPDwNCi9UeXBlL0ZvbnQNCi9TdWJ0eXBlIC9UcnVlVHlwZQ0KL0Jhc2VGb250IC9BcmlhbCxCb2xkDQovRmlyc3RDaGFyIDMyDQovTGFzdENoYXIgMjU1DQovV2lkdGhzIFsgMjc3IDMzMyA0NzQgNTU2IDU1NiA4ODkgNzIyIDIzNyAzMzMgMzMzIDM4OSA1ODMgMjc3IDMzMyAyNzcgMjc3IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDU1NiAzMzMgMzMzIDU4MyA1ODMgNTgzIDYxMCA5NzUgNzIyIDcyMiA3MjIgNzIyIDY2NiA2MTAgNzc3IDcyMiAyNzcgNTU2IDcyMiA2MTAgODMzIDcyMiA3NzcgNjY2IDc3NyA3MjIgNjY2IDYxMCA3MjIgNjY2IDk0MyA2NjYgNjY2IDYxMCAzMzMgMjc3IDMzMyA1ODMgNTU2IDMzMyA1NTYgNjEwIDU1NiA2MTAgNTU2IDMzMyA2MTAgNjEwIDI3NyAyNzcgNTU2IDI3NyA4ODkgNjEwIDYxMCA2MTAgNjEwIDM4OSA1NTYgMzMzIDYxMCA1NTYgNzc3IDU1NiA1NTYgNTAwIDM4OSAyNzkgMzg5IDU4MyAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAwIDAgMCAyNzcgMzMzIDU1NiA1NTYgNTU2IDU1NiAyNzkgNTU2IDMzMyA3MzYgMzcwIDU1NiA1ODMgMzMzIDczNiA1NTIgMzk5IDU0OCAzMzMgMzMzIDMzMyA1NzYgNTU2IDMzMyAzMzMgMzMzIDM2NSA1NTYgODMzIDgzMyA4MzMgNjEwIDcyMiA3MjIgNzIyIDcyMiA3MjIgNzIyIDEwMDAgNzIyIDY2NiA2NjYgNjY2IDY2NiAyNzcgMjc3IDI3NyAyNzcgNzIyIDcyMiA3NzcgNzc3IDc3NyA3NzcgNzc3IDU4MyA3NzcgNzIyIDcyMiA3MjIgNzIyIDY2NiA2NjYgNjEwIDU1NiA1NTYgNTU2IDU1NiA1NTYgNTU2IDg4OSA1NTYgNTU2IDU1NiA1NTYgNTU2IDI3NyAyNzcgMjc3IDI3NyA2MTAgNjEwIDYxMCA2MTAgNjEwIDYxMCA2MTAgNTQ4IDYxMCA2MTAgNjEwIDYxMCA2MTAgNTU2IDYxMCA1NTYgXQ0KL0VuY29kaW5nIC9XaW5BbnNpRW5jb2RpbmcNCi9Gb250RGVzY3JpcHRvciAxNiAwIFINCj4+DQplbmRvYmoNCg0KMTYgMCBvYmoNCjw8DQovVHlwZSAvRm9udERlc2NyaXB0b3INCi9Gb250TmFtZSAvQXJpYWwsQm9sZA0KL0ZsYWdzIDMyDQovRm9udEJCb3ggWy02MjcgLTIxMSAyMDAwIDkzN10NCi9Bc2NlbnQgOTM3DQovRGVzY2VudCAtMjExDQovQ2FwSGVpZ2h0IDcxNQ0KL0l0YWxpY0FuZ2xlIDANCi9TdGVtViA4MA0KPj4NCmVuZG9iag0KDQoxIDAgb2JqDQo8PA0KL1R5cGUgL0NhdGFsb2cNCi9QYWdlcyAyIDAgUg0KPj4NCmVuZG9iag0KDQoyIDAgb2JqDQo8PA0KL1R5cGUgL1BhZ2VzDQovS2lkcyBbIDQgMCBSIDExIDAgUiBdDQovQ291bnQgMg0KPj4NCmVuZG9iag0KDQozIDAgb2JqDQo8PA0KL1RpdGxlICgpDQovUHJvZHVjZXIgKERvY3VtZW50IC5OZXQgdi40LjAuMTAuMjgpDQovQ3JlYXRvciAoXDMxMW1pbGllIE1hcmNlYXUpDQo+Pg0KZW5kb2JqDQoNCnhyZWYNCjAgMTcNCjAwMDAwMDAwMDAgNjU1MzUgZg0KMDAwMDAwNTE1MyAwMDAwMCBuDQowMDAwMDA1MjEwIDAwMDAwIG4NCjAwMDAwMDUyODUgMDAwMDAgbg0KMDAwMDAwMDAxNyAwMDAwMCBuDQowMDAwMDAwOTY4IDAwMDAwIG4NCjAwMDAwMDE1ODEgMDAwMDAgbg0KMDAwMDAwMjc3MCAwMDAwMCBuDQowMDAwMDAzOTU3IDAwMDAwIG4NCjAwMDAwMDA5MTYgMDAwMDAgbg0KMDAwMDAwMDI2NyAwMDAwMCBuDQowMDAwMDAxMDIwIDAwMDAwIG4NCjAwMDAwMDE1MjggMDAwMDAgbg0KMDAwMDAwMTI2MiAwMDAwMCBuDQowMDAwMDAyNTg1IDAwMDAwIG4NCjAwMDAwMDM3NzQgMDAwMDAgbg0KMDAwMDAwNDk2NSAwMDAwMCBuDQp0cmFpbGVyDQo8PA0KL1NpemUgMTcNCi9Sb290IDEgMCBSDQovSW5mbyAzIDAgUg0KL0lEIFs8NEQ4RUMwQTNDOTM4MTk1MjU0MzNDM0M3MTFDMjcyQkM+PDREOEVDMEEzQzkzODE5NTI1NDMzQzNDNzExQzI3MkJDPl0NCj4+DQpzdGFydHhyZWYNCjUzOTINCiUlRU9G ",
"DMS_DocType": "application/pdf ",
"EIP_EmailMessage": "text.batchEmailMessage"
},
"HistoricType": "Invoice"

}


 * */