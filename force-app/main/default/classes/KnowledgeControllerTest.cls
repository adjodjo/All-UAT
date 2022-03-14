@isTest
class KnowledgeControllerTest {


    @TestSetup
    static void makeData(){
        Knowledge__kav ka = new Knowledge__kav();
        ka.Title = 'Test Article';
        ka.UrlName = 'testArr';
        ka.Summary = 'Test Article';
        ka.Language = 'en_US';
        insert ka;
        

        String knowledgeArticleId = [SELECT KnowledgeArticleId FROM Knowledge__kav].KnowledgeArticleId; 
        KbManagement.PublishingService.publishArticle(knowledgeArticleId, true);

        Topic topicObj = new Topic();
        topicObj.Name = 'Test Topic';
        topicObj.Description = 'Test Topic';
        insert topicObj;

        String topicId = topicObj.id;
        TopicAssignment topicAssignmentObj = new TopicAssignment();
        topicAssignmentObj.TopicId = topicId;
        topicAssignmentObj.EntityId = ka.Id;
        insert topicAssignmentObj;

    }


    @isTest
    static void KnowledgeControllerTestMethod() {
        Map<String,String> req = new Map<String, String>();
        req.put('topicName', '');
        KnowledgeController.getKnowledgeTopics(JSON.serializePretty(req));
    }

    @isTest
    static void KnowledgeControllerTestMethod1() {

        List<Topic> childTopicList = 
            [
                SELECT 
                    Id,
                    Name, 
                    Description
                FROM Topic
            ];
            String knowledgeArticleId = [SELECT id,KnowledgeArticleId FROM Knowledge__kav].KnowledgeArticleId; 

        Map<String,String> req = new Map<String, String>();
        req.put('articleId', knowledgeArticleId);
        req.put('language', 'en_US');
        KnowledgeController.getArticles(JSON.serializePretty(req));
        KnowledgeController.getTopicWithArticles(childTopicList[0].Id);
        KnowledgeController.getTopicWithArticles('');
        KnowledgeController.getCommonTopics(JSON.serialize(new List<String>{childTopicList[0].Id}));
    }
    
    @isTest
    static void KnowledgeControllerTestMethod2() {
        Map<String,String> req = new Map<String, String>();
        req.put('topicName', '');
        req.put('searchTerm','Test');
        req.put('language','en_US');
        KnowledgeController.getKnowledgeTopicList(JSON.serializePretty(req));
        KnowledgeController.getKnowledgeTopicswithArticles(JSON.serializePretty(req));
        KnowledgeController.getKnowledgeArticles();
        KnowledgeController.getArticleId('11111');        
        KnowledgeController.getArticlesList(JSON.serialize(req));
        req.put('language','fr');
        KnowledgeController.getArticlesList(JSON.serialize(req));
    }

}