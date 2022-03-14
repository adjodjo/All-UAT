import { LightningElement, wire } from 'lwc';

import getArticle from '@salesforce/apex/KnowledgeController.getArticles';

import Related_Articles from '@salesforce/label/c.Related_articles'
import Knowledge_Resources from '@salesforce/label/c.Resources'
import All_Topics from '@salesforce/label/c.All_Topics'
import Help_CTA_title from '@salesforce/label/c.Help_CTA_title'
import Help_CTA_text from '@salesforce/label/c.Help_CTA_text'
import Edited from '@salesforce/label/c.Edited'

import { CurrentPageReference } from 'lightning/navigation';

export default class KbArticle extends LightningElement {

    currentPageReference = null; 
    urlStateParameters = null;
    recordId;
    urlLang = 'en_US';

    label ={
        Related_Articles  :Related_Articles,
        Knowledge_Resources : Knowledge_Resources,
        All_Topics : All_Topics,
        Help_CTA_text:Help_CTA_text,
        Help_CTA_title : Help_CTA_title,
        Edited : Edited
    }
    topicWrpObj = {};
    isInit = false;
    refreshTextInput = true;
    supportURL = '/vendorportal/s/support-request'; 
    connectedCallback(){
        if(this.isInit){
            return;
        }
        this.isInit = true;
        this.getArticleJS();
    }


    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
    setParametersBasedOnUrl() {
       this.recordId = this.urlStateParameters.id || null;
       this.urlLang = this.urlStateParameters.language || 'en_US';
    }

    getArticleJS(){
        debugger;
        getArticle(
            {  req : JSON.stringify( 
                                   { articleId: this.recordId,
                                     language :  this.urlLang
                                   //'ka05g000001UhTwAAK'
                                   }
                                )
            })
        .then(result =>{
            let jsonRes = JSON.parse(result);
            if(jsonRes.status){
                let topicObj = jsonRes.topicWrpObj;
                this.topicWrpObj = topicObj;
            }
        })
        .catch(result => {
            console.log(result);
        });
    }

    get showRelatedList() {
        console.log(this.topicWrpObj);
        return this.topicWrpObj && this.topicWrpObj.relatedArticleList && this.topicWrpObj.relatedArticleList.length > 0;
    }
}