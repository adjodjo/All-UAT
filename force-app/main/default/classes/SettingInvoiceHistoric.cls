global with sharing class SettingInvoiceHistoric {
    
    public String SF_AccountId;
    public String SF_HistoryBuyoutId;
    public String IL_ContractNumber;
    public String x_CustId;
    public String IL_Langue;
    public String x_ActiveDirectoryName;
    public String EIP_InvoiceNumber;
    public String EIP_InvoiceDate;
    public String EIP_HistoricType;
    public List<String> EIP_InvoiceAmountFee;
    public String EIP_Comment;
    public String DMS_DocType;
    public String DMS_DocLink;
    public Decimal EIP_InvoiceAmount;
    public Decimal EIP_BuyoutAmount;
    public Decimal EIP_TotalFee;
    public Decimal EIP_InvoicePST;
    public Decimal EIP_InvoiceGST;
    public Decimal EIP_InvoiceHST ;
    public Decimal EIP_ReceivedAmount;
    public Decimal EIP_InvoiceDifference;
    Public Boolean EIP_TransfertThirdParty;
    

    public SettingInvoiceHistoric(String SF_AccountId,String SF_HistoryBuyoutId,String IL_ContractNumber,String x_CustId,String IL_Langue,String x_ActiveDirectoryName,
                                  String EIP_InvoiceNumber,String EIP_InvoiceDate,String EIP_HistoricType,String EIP_Comment,String DMS_DocType,String DMS_DocLink, 
                                  List<String> EIP_InvoiceAmountFee, Decimal EIP_InvoiceAmount, Decimal EIP_BuyoutAmount, Decimal EIP_TotalFee, Decimal EIP_InvoicePST, 
                                  Decimal EIP_InvoiceGST, Decimal EIP_InvoiceHST, Decimal EIP_ReceivedAmount, Decimal EIP_InvoiceDifference, Boolean EIP_TransfertThirdParty ){
                                      
                                      this.SF_AccountId = SF_AccountId;
                                      this.SF_HistoryBuyoutId = SF_HistoryBuyoutId;
                                      this.IL_ContractNumber = IL_ContractNumber;
                                      this.x_CustId = x_CustId;
                                      this.IL_Langue = IL_Langue;
                                      this.x_ActiveDirectoryName = x_ActiveDirectoryName;
                                      this.EIP_InvoiceNumber = EIP_InvoiceNumber;
                                      this.EIP_InvoiceDate = EIP_InvoiceDate;
                                      this.EIP_HistoricType = EIP_HistoricType;
                                      this.EIP_Comment = EIP_Comment;
                                      this.DMS_DocType = DMS_DocType;
                                      this.DMS_DocLink = DMS_DocLink;
                                      this.EIP_InvoiceAmountFee = EIP_InvoiceAmountFee;
                                      this.EIP_InvoiceAmount = EIP_InvoiceAmount;
                                      this.EIP_BuyoutAmount = EIP_BuyoutAmount;
                                      this.EIP_TotalFee = EIP_TotalFee;
                                      this.EIP_InvoicePST = EIP_InvoicePST;
                                      this.EIP_InvoiceGST = EIP_InvoiceGST;
                                      this.EIP_InvoiceHST = EIP_InvoiceHST;
                                      this.EIP_ReceivedAmount = EIP_ReceivedAmount;
                                      this.EIP_InvoiceDifference = EIP_InvoiceDifference;
                                      this.EIP_TransfertThirdParty = EIP_TransfertThirdParty;
    }

}