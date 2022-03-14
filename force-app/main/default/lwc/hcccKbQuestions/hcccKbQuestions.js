import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Title_common_questions from '@salesforce/label/c.Title_common_questions';
import Common_Question_1 from '@salesforce/label/c.Common_Question_1';
import Common_Question_2 from '@salesforce/label/c.Common_Question_2';
import Common_Question_3 from '@salesforce/label/c.Common_Question_3';
import Common_Question_4 from '@salesforce/label/c.Common_Question_4';
import Question_1_Article from '@salesforce/label/c.Question_1_Article';
import Question_2_Article from '@salesforce/label/c.Question_2_Article';
import Question_3_Article from '@salesforce/label/c.Question_3_Article';
import Question_4_Article from '@salesforce/label/c.Question_4_Article';
import getArticleId from '@salesforce/apex/KnowledgeController.getArticleId';

export default class HcccKbQuestions extends NavigationMixin(LightningElement) {
    isLoading = false;

    label = {
        Title_common_questions,
        Common_Question_1, Common_Question_2, Common_Question_3, Common_Question_4,
        Question_1_Article, Question_2_Article, Question_3_Article, Question_4_Article
    }

    async handleQuestionClick(event) {
        this.isLoading = true;
        const articleNumber = event.target.title;
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


}