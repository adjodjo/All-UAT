import { LightningElement ,api} from 'lwc';

import initData from '@salesforce/apex/hccHelpAndContactController.initData';

import Help_and_Contacts from '@salesforce/label/c.Help_and_Contacts';
import Help_Title from '@salesforce/label/c.Help_Title';
import Help_Subtitle_1 from '@salesforce/label/c.Help_Subtitle_1';
import Help_Account_Manager from '@salesforce/label/c.Help_Account_Manager';
import Help_Subtitle_2 from '@salesforce/label/c.Help_Subtitle_2';
import Help_Office_1_Title from '@salesforce/label/c.Help_Office_1_Title';
import Help_Office_1_Address from '@salesforce/label/c.Help_Office_1_Address';
import Help_Office_1_Phone from '@salesforce/label/c.Help_Office_1_Phone';
import Help_Office_2_Title from '@salesforce/label/c.Help_Office_2_Title';
import Help_Office_3_Address from '@salesforce/label/c.Help_Office_3_Address';
import Help_Office_4_Phone from '@salesforce/label/c.Help_Office_4_Phone';
import Help_CTA_title from '@salesforce/label/c.Help_CTA_title';
import Help_CTA_text from '@salesforce/label/c.Help_CTA_text';
import Help_Associate_Director from '@salesforce/label/c.Help_Associate_Director'

import HCC_ICONS from '@salesforce/resourceUrl/hccIcons';

export default class helpAndContacts extends LightningElement {

    isShowSpinner = false;
    @api recordId;

    accountManagerName = '';
    accountManagerEmail = '';
    accountManagerPhone = '';
    accountManagerEmailMailto = '';
    assistantManagerEmailMailto = '';
    accountManagerImageURL;
    pathPrefix = '';
    supportURL='';

    assistantManagerName = '';
    assistantManagerEmail = '';
    assistantManagerPhone = '';
    assistantManagerImageURL;

    label = {
        'Help_Title' : Help_Title,
        'Help_and_Contacts' : Help_and_Contacts,
        'Help_Subtitle_1' : Help_Subtitle_1,
        'Help_Account_Manager' : Help_Account_Manager,
        'Help_Subtitle_2' : Help_Subtitle_2,
        'Help_Office_1_Title' : Help_Office_1_Title,
        'Help_Office_1_Address' : Help_Office_1_Address,
        'Help_Office_1_Phone' : Help_Office_1_Phone,
        'Help_Office_2_Title' : Help_Office_2_Title,
        'Help_Office_3_Address' : Help_Office_3_Address,
        'Help_Office_4_Phone' : Help_Office_4_Phone,
        'Help_CTA_title' : Help_CTA_title,
        'Help_CTA_text' : Help_CTA_text,
        'Help_Associate_Director' : Help_Associate_Director
    }

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

    initDataJS(){
        debugger;
        initData(
            {  req : JSON.stringify( 
                                   { recordId: this.recordId, 
                                   }
                                )
            })
        .then(result =>{
            let jsonRes = JSON.parse(result);
            if(jsonRes.status){
                if(jsonRes.accountOwnerUser){
                    this.accountManagerName = jsonRes.accountOwnerUser.FirstName + ' ' + jsonRes.accountOwnerUser.LastName;
                    this.accountManagerEmail = jsonRes.accountOwnerUser.Email;
                    this.accountManagerEmailMailto = 'mailto:'+ this.accountManagerEmail;
                    this.accountManagerPhone = jsonRes.accountOwnerUser.Phone;
                    this.pathPrefix = ''+jsonRes.pathPrefix;
                    this.supportURL = this.pathPrefix+'/support-request'; 
                    this.accountManagerImageURL = jsonRes.accountOwnerUser.SmallPhotoUrl;

                    this.assistantManagerEmail = jsonRes.assistantUser.Email;
                     this.assistantManagerEmailMailto = 'mailto:'+ this.assistantManagerEmail;
                    this.assistantManagerName = jsonRes.assistantUser.FirstName + ' ' + jsonRes.assistantUser.LastName;
                    this.assistantManagerPhone = jsonRes.assistantUser.Phone;
                    this.assistantManagerImageURL = jsonRes.assistantUser.SmallPhotoUrl;
                }         
            }
        })
        .catch(result => {
            console.log(result);
        });
    }

    handleEmailClick(event){
        event.currentTarget.style.color = '#E60000';
    }
}