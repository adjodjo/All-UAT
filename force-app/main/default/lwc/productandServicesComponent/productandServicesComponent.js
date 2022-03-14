import { LightningElement,track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import lang from '@salesforce/i18n/lang';
import getArticleId from '@salesforce/apex/KnowledgeController.getArticleId';
import Products_Title from '@salesforce/label/c.Products_Title';
import Products_C_Options_Title from '@salesforce/label/c.Products_C_Options_Title';
import Products_Contact_Us_Button from '@salesforce/label/c.Products_Contact_Us_Button';
import Products_C_Option_6_P1 from '@salesforce/label/c.Products_C_Option_6_P1';
import Products_C_Option_6 from '@salesforce/label/c.Products_C_Option_6';
import Products_C_Option_5_P1 from '@salesforce/label/c.Products_C_Option_5_P1';
import Products_C_Option_5 from '@salesforce/label/c.Products_C_Option_5';
import Products_C_Option_4_P1 from '@salesforce/label/c.Products_C_Option_4_P1';
import Products_C_Option_4 from '@salesforce/label/c.Products_C_Option_4';
import Products_C_Option_3_P1 from '@salesforce/label/c.Products_C_Option_3_P1';
import Products_C_Option_3 from '@salesforce/label/c.Products_C_Option_3';
import Products_C_Option_2_P1 from '@salesforce/label/c.Products_C_Option_2_P1';
import Products_C_Option_2 from '@salesforce/label/c.Products_C_Option_2';
import Products_C_Option_1_P1 from '@salesforce/label/c.Products_C_Option_1_P1';
import Products_C_Option_1 from '@salesforce/label/c.Products_C_Option_1';
import Products_B_Options_Title from '@salesforce/label/c.Products_B_Options_Title';
import Products_B_Option_1_P1 from '@salesforce/label/c.Products_B_Option_1_P1';
import Products_B_Option_1 from '@salesforce/label/c.Products_B_Option_1';
import Products_B_Option_2_P1 from '@salesforce/label/c.Products_B_Option_2_P1';
import Products_B_Option_2 from '@salesforce/label/c.Products_B_Option_2';
import Products_B_Option_3_P1 from '@salesforce/label/c.Products_B_Option_3_P1';
import Products_B_Option_3 from '@salesforce/label/c.Products_B_Option_3';
import Products_B_Option_4_P1 from '@salesforce/label/c.Products_B_Option_4_P1';
import Products_B_Option_4 from '@salesforce/label/c.Products_B_Option_4';
import Products_B_Option_5_P1 from '@salesforce/label/c.Products_B_Option_5_P1';
import Products_B_Option_5 from '@salesforce/label/c.Products_B_Option_5';
import Products_B_Option_6_P1 from '@salesforce/label/c.Products_B_Option_6_P1';
import Products_B_Option_6 from '@salesforce/label/c.Products_B_Option_6';

import Products_C_Option_1_Url from '@salesforce/label/c.Products_C_Option_1_Url';
import Products_C_Option_2_Url from '@salesforce/label/c.Products_C_Option_2_Url';
import Products_C_Option_3_Url from '@salesforce/label/c.Products_C_Option_3_Url';
import Products_C_Option_4_Url from '@salesforce/label/c.Products_C_Option_4_Url';
import Products_C_Option_5_Url from '@salesforce/label/c.Products_C_Option_5_Url';
import Products_C_Option_6_Url from '@salesforce/label/c.Products_C_Option_6_Url';
import Products_B_Option_1_Url from '@salesforce/label/c.Products_B_Option_1_Url';
import Products_B_Option_2_Url from '@salesforce/label/c.Products_B_Option_2_Url';
import Products_B_Option_3_Url from '@salesforce/label/c.Products_B_Option_3_Url';
import Products_B_Option_4_Url from '@salesforce/label/c.Products_B_Option_4_Url';
import Products_B_Option_5_Url from '@salesforce/label/c.Products_B_Option_5_Url';
import Products_B_Option_6_Url from '@salesforce/label/c.Products_B_Option_6_Url';

import Products_Tile_Title from '@salesforce/label/c.Products_Tile_Title';
import Products_Tile_P1 from '@salesforce/label/c.Products_Tile_P1';
import Products_Learn_More from '@salesforce/label/c.Products_Learn_More';
import Special_offers from '@salesforce/label/c.Special_offers';
import Special_offers_Content from '@salesforce/label/c.Special_offers_Content';
import Special_Offers_Title from '@salesforce/label/c.Special_Offers_Title';
import SpecialOffersImg from '@salesforce/resourceUrl/SpecialOffersImg';
import SpecialOffersImgFr from '@salesforce/resourceUrl/SpecialOffersImgFr';
import Equipment_Financing_Programs from '@salesforce/label/c.Equipment_Financing_Programs';
import Program_Summary from '@salesforce/label/c.Program_Summary';
import Programs_Learn_More from '@salesforce/label/c.Programs_Learn_More';
import getUserData from '@salesforce/apex/hcccVendorPortalController.getUserData';
import fetchSalesProgram from '@salesforce/apex/productandServicesController.fetchSalesProgram';
import FORM_FACTOR from '@salesforce/client/formFactor';
export default class ProductandServicesComponent extends NavigationMixin(LightningElement) {
    @api showLeftLink;
    @api leftLinkText;
    @api leftLinkType;
    @api leftLinkUrl;
    @api showRightLink;
    @api rightLinkText;
    @api rightLinkType;
    @api rightLinkUrl;
    @api iconName = 'zoom';
    @track dataId;
    @track deviceDetected;
    isDesktop;
    isMobile;
    contactSalesTitle = Products_Tile_Title;
    contactSalesPara = Products_Tile_P1;
    productsOptionB1 = Products_B_Option_1;
    productsOptionPB1 = Products_B_Option_1_P1;
    productsOptionB2 = Products_B_Option_2;
    productsOptionPB2 = Products_B_Option_2_P1;
    productsOptionB3 = Products_B_Option_3;
    productsOptionPB3 = Products_B_Option_3_P1;
    productsOptionB4 = Products_B_Option_4;
    productsOptionPB4 = Products_B_Option_4_P1;
    productsOptionB5 = Products_B_Option_5;
    productsOptionPB5 = Products_B_Option_5_P1;
    productsOptionB6 = Products_B_Option_6;
    productsOptionPB6 = Products_B_Option_6_P1;
    productsTitle = Products_Title;
    productsContactUs = Products_Contact_Us_Button;
    productsOptionTitle = Products_C_Options_Title;
    productsOption1 = Products_C_Option_1;
    productsOptionP1 = Products_C_Option_1_P1;
    productsOption2 = Products_C_Option_2;
    productsOptionP2 = Products_C_Option_2_P1;
    productsOption3 = Products_C_Option_3;
    productsOptionP3 = Products_C_Option_3_P1;
    productsOption4 = Products_C_Option_4;
    productsOptionP4 = Products_C_Option_4_P1;
    productsOption5 = Products_C_Option_5;
    productsOptionP5 = Products_C_Option_5_P1;
    productsOption6 = Products_C_Option_6;
    productsOptionP6 = Products_C_Option_6_P1;
    productsBOptionsTitle = Products_B_Options_Title;
    productsSpecialOffers = Special_offers;
    learnMore = Products_Learn_More;
    specialOffersContent = Special_offers_Content;
    specialOffersTitle = Special_Offers_Title;
    specialOffersImg = lang !== 'fr' ? SpecialOffersImg : SpecialOffersImgFr;
    EquipmentFinancingPrograms = Equipment_Financing_Programs;
    programSummary = Program_Summary;
    Programs_Learn_More = Programs_Learn_More;
    @track Account_Id;
    @track error;
    @track program_Description;
    @track program_Summary;
    @track program_Description_FR;
    @track program_Summary_FR;
    @track renderTable = false;
    @track salesPrograms;
    productOptions = [];
    productOptionsPB = [];
    optionsToDisplay1 = {option:this.productsOption1, content:this.productsOptionP1, url:this.setOptionUrl(Products_C_Option_1_Url)};
    optionsToDisplay2 = {option:this.productsOption2, content:this.productsOptionP2, url:this.setOptionUrl(Products_C_Option_2_Url)};
    optionsToDisplay3 = {option:this.productsOption3, content:this.productsOptionP3, url:this.setOptionUrl(Products_C_Option_3_Url)};
    optionsToDisplay4 = {option:this.productsOption4, content:this.productsOptionP4, url:this.setOptionUrl(Products_C_Option_4_Url)};
    optionsToDisplay5 = {option:this.productsOption5, content:this.productsOptionP5, url:this.setOptionUrl(Products_C_Option_5_Url)};
    optionsToDisplay6   = {option:this.productsOption6, content:this.productsOptionP6, url:this.setOptionUrl(Products_C_Option_6_Url)};

    optionToDisplayPB1 = {option:this.productsOptionB1, content:this.productsOptionPB1, url:this.setOptionUrl(Products_B_Option_1_Url)};
    optionToDisplayPB2 = {option:this.productsOptionB2, content:this.productsOptionPB2, url:this.setOptionUrl(Products_B_Option_2_Url)};
    optionToDisplayPB3 = {option:this.productsOptionB3, content:this.productsOptionPB3, url:this.setOptionUrl(Products_B_Option_3_Url)};
    optionToDisplayPB4 = {option:this.productsOptionB4, content:this.productsOptionPB4, url:this.setOptionUrl(Products_B_Option_4_Url)};
    optionToDisplayPB5 = {option:this.productsOptionB5, content:this.productsOptionPB5, url:this.setOptionUrl(Products_B_Option_5_Url)};
    optionToDisplayPB6 = {option:this.productsOptionB6, content:this.productsOptionPB6, url:this.setOptionUrl(Products_B_Option_6_Url)};

    fillOptions() {
        (this.optionsToDisplay1.option != 'NA') ? this.productOptions.push(this.optionsToDisplay1) : null;
        (this.optionsToDisplay2.option != 'NA') ? this.productOptions.push(this.optionsToDisplay2) : null;
        (this.optionsToDisplay3.option != 'NA') ? this.productOptions.push(this.optionsToDisplay3) : null;
        (this.optionsToDisplay4.option != 'NA') ? this.productOptions.push(this.optionsToDisplay4) : null;
        (this.optionsToDisplay5.option != 'NA') ? this.productOptions.push(this.optionsToDisplay5) : null;
        (this.optionsToDisplay6.option != 'NA') ? this.productOptions.push(this.optionsToDisplay6) : null;
        
        (this.optionToDisplayPB1.option != 'NA') ? this.productOptionsPB.push(this.optionToDisplayPB1) : null;
        (this.optionToDisplayPB2.option != 'NA') ? this.productOptionsPB.push(this.optionToDisplayPB2) : null;
        (this.optionToDisplayPB3.option != 'NA') ? this.productOptionsPB.push(this.optionToDisplayPB3) : null;
        (this.optionToDisplayPB4.option != 'NA') ? this.productOptionsPB.push(this.optionToDisplayPB4) : null;
        (this.optionToDisplayPB5.option != 'NA') ? this.productOptionsPB.push(this.optionToDisplayPB5) : null;
        (this.optionToDisplayPB6.option != 'NA') ? this.productOptionsPB.push(this.optionToDisplayPB6) : null;
        
    }

    get isFr() {
        return lang == 'fr';
    }

    connectedCallback(){
        debugger;
        this.fillOptions();
        this.handleGetUserData();
        this.deviceDetected = FORM_FACTOR;
        if(this.deviceDetected == 'Small' ||this.deviceDetected == 'Medium'){
            this.isMobile = true;
        }
        else {
            this.isDesktop = true;
        }
        
        console.log('this.deviceDetected'+this.deviceDetected);
    }

    setOptionUrl(url) {
        return url != 'NA' ? url : null;
    }

    handleGetUserData() {
        getUserData().then(result => {
            if (result) {
                console.log('result'+JSON.stringify(result));
                if(result.Contact.AccountId != null){
                    this.Account_Id = result.Contact.AccountId;
                    this.fetchAccountSalesProgram();
                }
            }
        }).catch(error => {
            console.error(error);
        });
    } 

    fetchAccountSalesProgram(){
        fetchSalesProgram({Account_Id: this.Account_Id})
            .then((result) => {
                console.log('fetchSalesProgram result', JSON.stringify(result));
                if(result != null){
                    this.renderTable = true;
                    this.salesPrograms = result;
                    
                }
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
            });
    }

    async handleProgramButton(event) {
        this.isLoading = true;
        const articleNumber = event.currentTarget.title;
        console.log(articleNumber);
        const result = await getArticleId({ articleNumber });
        if (result.success) {
            //console.log(result);
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

    handleClick(){
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: window.location.origin + '/vendorportal/s/contact-sales'
            }
        }).then(generatedUrl => {
            window.open(generatedUrl, "_self");
        });    
    }

    clickZoom(){
       // window.open(this.specialOffersImg);  
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: window.location.origin + '/'+this.specialOffersImg
            }
        }).then(generatedImgUrl => {
            window.open(generatedImgUrl);
        });       
    }
    
}