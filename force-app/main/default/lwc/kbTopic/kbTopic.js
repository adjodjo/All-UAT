import { LightningElement, wire, track } from "lwc";
import getTopicWithArticles from '@salesforce/apex/KnowledgeController.getTopicWithArticles';

import Knowledge_Resources from '@salesforce/label/c.Resources'
import All_Topics from '@salesforce/label/c.All_Topics'

import { CurrentPageReference } from 'lightning/navigation';

export default class KbTopic extends LightningElement {

    label = {
        Knowledge_Resources, All_Topics
    }

    recordId;
    @track articles = [];
    @track topic;
    currentPageReference = null;
    urlStateParameters = null;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            this.setParametersBasedOnUrl();
        }
    }

    setParametersBasedOnUrl() {
        this.recordId = this.urlStateParameters.id || null;
    }

    @wire(getTopicWithArticles, { topicId: '$recordId' })
    getTopicData({ data, error }) {
        try {
            if (data) {
                const result = JSON.parse(data);
                console.log(result)
                if (result.success) {
                    this.articles = result.articles.map(element => {
                        element.url = `/vendorportal/s/knowledge-article?id=${element.KnowledgeArticleId}`;
                        return element;
                    });
                    this.topic = result.topic;
                    console.log(this.articles);
                } else {
                    console.log('Error happened: ', result.error);
                }
            } else if (error) {
                console.log('error ' + error);
            }
        } catch (error) {
            console.log('error ' + error);
        }

    };
}