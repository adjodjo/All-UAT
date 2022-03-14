import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getCommonTopics from '@salesforce/apex/KnowledgeController.getCommonTopics';
import getKnowledgeArticles from '@salesforce/apex/KnowledgeController.getKnowledgeArticles';

//Custom Labels
import Resources from '@salesforce/label/c.Resources';
import Results from '@salesforce/label/c.Results';
import Search_Bar from '@salesforce/label/c.Search_Bar';
import Search_bar_placeholder from '@salesforce/label/c.Search_bar_placeholder';
import Title_popular_articles from '@salesforce/label/c.Title_popular_articles';
import Title_topics from '@salesforce/label/c.Title_topics';
import Button_topics from '@salesforce/label/c.Button_topics';
import Related_articles from '@salesforce/label/c.Related_articles';
import Topic_1 from '@salesforce/label/c.Topic_1';
import Topic_2 from '@salesforce/label/c.Topic_2';
import Topic_3 from '@salesforce/label/c.Topic_3';


export default class KbLanding extends NavigationMixin(LightningElement) {

    // label = {
    //     'popularArticle' : 'Popular articles & resources',
    //     'browseKnowlegeTopics' : 'Browse Knowledge Base Topics',
    //     'commonQuestions' : 'Common questions'
    // }

    label = {
        Resources, Results, Search_Bar, Search_bar_placeholder,
        Title_popular_articles, Title_topics, Button_topics,
        Related_articles,
        Topic_1, Topic_2, Topic_3
    }
    topicList;
    articles = [];
    isInit = false;
    hideAll = false;
    isLoading = false;

    get resultCount() {
        const result = this.topicList ? this.topicList.length : 0;
        return result + (result > 1 ? ' ' + label.Results : ' ' + label.Results + 's');
    }

    connectedCallback() {
        if (this.isInit) {
            return;
        }
        this.isInit = true;
        this.getCommonTopics();
        this.getArticles();
    }

    getArticles() {
        this.isLoading = true;
        getKnowledgeArticles()
            .then(result => {
                if (result.success) {
                    console.log(result.topicNameMap);
                    this.articles = result.articles.map(element => {
                        element.url = `/vendorportal/s/knowledge-article?id=${element.KnowledgeArticleId}`;
                        element.topicName = result.topicNameMap[element.Id];
                        return element;
                    });
                } else {
                    console.error(result.error);
                }
            })
            .catch(result => {
                console.log(result);
            }).finally(() => {
                this.isLoading = false;
            });
    }

    async getCommonTopics() {
        this.isLoading = true;
        const topicIds = [this.label.Topic_1, this.label.Topic_2, this.label.Topic_3];
        try {
            const result = await getCommonTopics({ topicReq: JSON.stringify(topicIds) });
            let jsonRes = JSON.parse(result);
            if (jsonRes.status) {
                let topicList = jsonRes.topicWrpList;
                this.topicList = topicList.slice(0, 3);
            }
        } catch (error) {
            console.error(error);
        }
        finally{
            this.isLoading = false;
        }

    }

    handleToggleSearch(event) {
        const isSearchResults = event.detail;
        this.hideAll = isSearchResults;
    }
}