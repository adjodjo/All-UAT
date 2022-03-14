import { LightningElement, api, wire } from 'lwc';
import initData from '@salesforce/apex/HomeDashboardController.initData';
import lang from '@salesforce/i18n/lang';

import homeDashboardBackground from '@salesforce/resourceUrl/Portal_homebanner';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

import getArticleId from '@salesforce/apex/KnowledgeController.getArticleId';

import ArticleFeatureImg from '@salesforce/resourceUrl/ArticleFeatureImg';
import KB_Feature_Title from '@salesforce/label/c.KB_Feature_Title';
import KB_Feature_Summary from '@salesforce/label/c.KB_Feature_Summary';
import KB_Feature_Article_Number from '@salesforce/label/c.KB_Feature_Article_Number';
import Help_Account_Manager from '@salesforce/label/c.Help_Account_Manager';
import HomeDashboard_Hello from '@salesforce/label/c.HomeDashboard_Hello';
import HomeDashboard_Monthly_Volume_Quote from '@salesforce/label/c.HomeDashboard_Monthly_Volume_Quote';
import HomeDashboard_No_Of_Accepted_Quotes from '@salesforce/label/c.HomeDashboard_No_Of_Accepted_Quotes';
import HomeDashboard_No_Of_Quote_Expiring from '@salesforce/label/c.HomeDashboard_No_Of_Quote_Expiring';
import HomeDashboard_Total_Quoted_Commission from '@salesforce/label/c.HomeDashboard_Total_Quoted_Commission';
import HomeDasboard_username_exclamation from '@salesforce/label/c.HomeDasboard_username_exclamation';

import HCC_ICONS from '@salesforce/resourceUrl/hccIcons';

export default class HomeDashboard extends NavigationMixin(LightningElement) {

    isShowSpinner = false;
    @api recordId;
    urlLang;
    language = lang;

    userFirstName = '';
    accountManagerName = '';
    accountManagerEmail = '';
    accountManagerPhone = '';
    accountManagerImageURL;
    pathPrefix = '';
    kPIInfo;

    accountManagerEmailMailto = 'mailto';
    
    homeDashboardBackgroundImg = homeDashboardBackground;

    label = {
        'HomeDashboard_Monthly_Volume_Quote' : HomeDashboard_Monthly_Volume_Quote,
        'HomeDashboard_No_Of_Accepted_Quotes' : HomeDashboard_No_Of_Accepted_Quotes,
        'HomeDashboard_No_Of_Quote_Expiring' : HomeDashboard_No_Of_Quote_Expiring,
        'HomeDashboard_Total_Quoted_Commission' : HomeDashboard_Total_Quoted_Commission,
        'KB_Feature_Title' : KB_Feature_Title,
        'KB_Feature_Summary' : KB_Feature_Summary,
        'KB_Feature_Article_Number' : KB_Feature_Article_Number,
        'Help_Account_Manager': Help_Account_Manager,
        'HomeDashboard_Hello' : HomeDashboard_Hello,
        'HomeDasboard_username_exclamation' : HomeDasboard_username_exclamation
    }

    ArticleFeatureImg = ArticleFeatureImg;

    phoneIcon = HCC_ICONS +'/Phone_icon.svg';
    mailIcon = HCC_ICONS +'/mail_icon.svg';

    isInit = false;
    connectedCallback(){
        if(this.isInit){
            return;
        }
        this.isInit = true;
        this.initDataJS();
    }

    // Declare the currentPageReference variable in order to track it
    currentPageReference;
    urlStateParameters = null;

    // Injects the page reference that describes the current page
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.urlLang = this.urlStateParameters.language;
        if (!this.language) {
            this.language = this.urlLang;
        }
    }

    initDataJS(){
        debugger;
        initData(
            {  req : JSON.stringify( 
                                   { recordId: this.recordId,
                                    isFetchQuoteData : true 
                                   }
                                )
            })
        .then(result =>{
            let jsonRes = JSON.parse(result);
            if(jsonRes.status){
                if(jsonRes.accountOwnerUser){
                    this.accountManagerName = jsonRes.accountOwnerUser.FirstName + ' ' + jsonRes.accountOwnerUser.LastName;
                    this.accountManagerEmail = jsonRes.accountOwnerUser.Email;
                    this.accountManagerPhone = jsonRes.accountOwnerUser.Phone;
                    this.accountManagerEmailMailto = 'mailto:'+ this.accountManagerEmail;
                    this.pathPrefix = ''+jsonRes.pathPrefix;
                    this.accountManagerImageURL = jsonRes.accountOwnerUser.MediumPhotoUrl;
                    let kPIInfo = JSON.parse(jsonRes.KPICalculations);
                    kPIInfo.totalQuoteVolume = this.kFormatter(kPIInfo.totalQuoteVolume);
                    kPIInfo.quotePotentialCommissions = this.kFormatter(kPIInfo.quotePotentialCommissions);
                    kPIInfo.totalAcceptedQuotes = kPIInfo.totalAcceptedQuotes;
                    kPIInfo.quotesExpiringin30Days = kPIInfo.quotesExpiringin30Days;
                    this.kPIInfo = kPIInfo;
                   //this.userFirstName = jsonRes.firstName;
                    this.userFirstName = this.label.HomeDasboard_username_exclamation.replace('{0}', jsonRes.firstName);
                }         
            }
        })
        .catch(result => {
            console.log(result);
        });
    }

    async handleFeatureClick(event) {
        this.isLoading = true;
        const articleNumber = event.currentTarget.title;
        const result = await getArticleId({ articleNumber });
        if (result.success) {
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: window.location.origin + `/vendorportal/s/knowledge-article?id=${result.articles[0].KnowledgeArticleId}`
                }
            }).then(generatedUrl => {
                window.open(generatedUrl, "_self");
            });
        } else {
            console.error(result.error);
        }
        this.isLoading = false;
    }

    kFormatter(num) {
        if (num) {
            if(Math.abs(num) > 999){
                num = Math.sign(num)*((Math.abs(num)/1000));
                num = Number(num).toLocaleString('fr', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                num = this.language == 'fr' ? num + 'K $' : '$ ' + num + 'K';
            }else{
                num = Number(num).toLocaleString('fr', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                num = this.language == 'fr' ? num + ' $' : '$ ' + num;
            }
        } else if (num == 0) {
            num = this.language == 'fr' ? num + ' $' : '$ ' + num;
        }
        return num
    }

    handleCurrencyFormatting(amount) {
        if (amount) {
            amount = Number(amount).toLocaleString('fr', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            amount = this.language == 'fr' ? amount + ' $' : '$ ' + amount;
        } else if (amount == 0) {
            amount = this.language == 'fr' ? amount + ' $' : '$ ' + amount;
        }
        return amount;
    }
}