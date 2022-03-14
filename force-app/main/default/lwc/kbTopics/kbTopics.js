import { LightningElement } from 'lwc';

import getKnowledgeTopics from '@salesforce/apex/KnowledgeController.getKnowledgeTopicswithArticles';
//Custom Labels
import Knowledge_Resources from '@salesforce/label/c.Resources'
import All_Topics from '@salesforce/label/c.All_Topics'
import Results from '@salesforce/label/c.Results';
import Search_Bar from '@salesforce/label/c.Search_Bar';
import Search_bar_placeholder from '@salesforce/label/c.Search_topic_placeholder';
import Knowledge_Base_Topics from '@salesforce/label/c.Title_topics';

export default class KbTopics extends LightningElement {

    label = {
        Knowledge_Resources, All_Topics,
        Results, Search_Bar, Search_bar_placeholder,
        Knowledge_Base_Topics
    }

    isSearchApply = false;
    searchInput;

    topicList;
    isInit = false;
    refreshTextInput = true;
    showResultCount = false;
    get resultCount() {
        const result = this.topicList ? this.topicList.length : 0;
        return result + (result > 1 ? ' ' + this.label.Results + 's': ' ' + this.label.Results);
    }

    connectedCallback() {
        if (this.isInit) {
            return;
        }
        this.isInit = true;
        this.getKnowledgeTopicsJS();
    }

    getKnowledgeTopicsJS() {
        getKnowledgeTopics(
            {
                req: JSON.stringify(
                    {
                        topicName: this.searchInput
                    }
                )
            })
            .then(result => {
                
                this.refreshTextInput = true;
                let jsonRes = JSON.parse(result);
                console.log('Result is ',jsonRes);
                if (jsonRes.status) {
                    let topicList = jsonRes.topicWrpList;
                    this.topicList = topicList;
                }
                if (this.searchInput) this.showResultCount = true;
            })
            .catch(result => {
                console.log(result);
            });
    }

    handleValueChangeSearch(event) {
        this.searchInput = event.detail.value;
        this.isSearchApply = false;
        //this.showResultCount = false;
    }

    async handleSearchClick(event) {
        if (this.isSearchApply) {
            this.isSearchApply = false;
            this.searchInput = '';
            this.refreshTextInput = false;
            this.getKnowledgeTopicsJS();
            this.showResultCount = false;
        } else {
            this.isSearchApply = true;
            this.getKnowledgeTopicsJS();
        }

    }
}