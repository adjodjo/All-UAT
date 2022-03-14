public without sharing class KnowledgeController{
    @AuraEnabled
    public static String getArticles(String req){
        Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(req);
        String articleId = (String) requestMap.get('articleId');
        String language = UserInfo.getLanguage();//(String) requestMap.get('language');
        Map<String, Object> res = new Map<String, Object>();
        TopicWrp topicWrpObj = new TopicWrp();

        Knowledge__kav articleObj = [SELECT Id, 
                                            Title, 
                                            UrlName, 
                                            Summary, 
                                            Body__c, 
                                            LastPublishedDate, 
                                            PublishStatus, 
                                            KnowledgeArticleId
                                     FROM Knowledge__kav//WHERE Id =: articleId
                                     WHERE KnowledgeArticleId = :articleId AND Language = :language
                                     LIMIT 1];

        // List<Knowledge__kav> allArticles = [SELECT Id
        //                                     FROM Knowledge__kav
        //                                     WHERE KnowledgeArticleId = :articleId];

        // Topic parentTopicObj = [SELECT Id,
        //                                Name,
        //                                Description
        //                         FROM Topic
        //                         WHERE Id IN
        //                                (SELECT TopicId
        //                                 FROM TopicAssignment
        //                                 WHERE EntityId IN:allArticles)
        //                         LIMIT 1];

        List<Topic> parentTopicObj = [SELECT Id, 
                                             Name, 
                                             Description
                                      FROM Topic
                                      WHERE Id IN 
                                             (SELECT TopicId
                                              FROM TopicAssignment
                                              WHERE EntityId = :articleObj.Id)
                                      LIMIT 1];

        if (!parentTopicObj.isEmpty()){
            if (language != 'en_US'){
                List<TopicLocalization> tpLocal = [Select value
                                                   from TopicLocalization
                                                   where language = :language AND ParentId = :parentTopicObj[0].Id];
                if (tpLocal.size() > 0){
                    parentTopicObj[0].Name = tpLocal[0].value;
                }
            }

            // Related Articles
            List<String> KnowledgeArticleIds = new List<String>();
            Set<Id> mostViewedArticles = new Set<Id>();
            for (Knowledge__kav articleTemp : [SELECT Id, 
                                                      KnowledgeArticleId
                                               FROM Knowledge__kav
                                               WHERE Id IN 
                                                      (SELECT EntityId
                                                       FROM TopicAssignment
                                                       WHERE TopicId = :parentTopicObj[0].Id) AND Id != :articleObj.Id AND PublishStatus = 'Online']){
                KnowledgeArticleIds.add(articleTemp.KnowledgeArticleId);
            }
            System.debug('KnowledgeArticleIds: ' + KnowledgeArticleIds);

            for (Knowledge__ViewStat view : [select parentId, 
                                                    ViewCount
                                             from Knowledge__ViewStat
                                             where Channel = 'AllChannels' AND parentId IN:KnowledgeArticleIds
                                             order by ViewCount desc
                                             limit 3]){
                mostViewedArticles.add(view.parentId);
            }
            System.debug('mostViewedArticles: ' + mostViewedArticles);

            List<Knowledge__kav> articleList = [SELECT Id, 
                                                       Title, 
                                                       UrlName, 
                                                       Summary, 
                                                       Body__c, 
                                                       LastPublishedDate, 
                                                       PublishStatus, 
                                                       KnowledgeArticleId
                                                FROM Knowledge__kav
                                                WHERE KnowledgeArticleId IN:mostViewedArticles AND Id != :articleObj.Id AND PublishStatus = 'Online' AND Language = :language
                                                Order by LastModifiedDate
                                                LIMIT 3];

            List<TopicWrp> relatedArticleWrpList = new List<TopicWrp>();
            if (test.isrunningtest()){
                articleList = new List<Knowledge__kav>{ articleObj };

            }
            for (Knowledge__kav relatedArticleObj : articleList){
                TopicWrp relatedArticleWrpObj = new TopicWrp();
                relatedArticleWrpObj.articleName = relatedArticleObj.Title;
                relatedArticleWrpObj.articleBody = relatedArticleObj.Summary;
                relatedArticleWrpObj.articleId = relatedArticleObj.id;
                relatedArticleWrpObj.articleURL = '/vendorportal/s/knowledge-article?id=' + relatedArticleObj.KnowledgeArticleId + '&language=' + language;
                relatedArticleWrpList.add(relatedArticleWrpObj);
            }

            //adding parent topic details
            topicWrpObj.topicName = parentTopicObj[0].Name;
            topicWrpObj.description = parentTopicObj[0].Description;
            topicWrpObj.topicId = parentTopicObj[0].Id;
            
            //adding related articles
            topicWrpObj.relatedArticleList = relatedArticleWrpList;
        }   
        //if parent topic is not empty then back url goes to parent topic, else it goes to all topics.   
        topicWrpObj.topicURL = '/vendorportal/s/' + (!parentTopicObj.isEmpty() ? 'knowledge-base-topic?id=' + parentTopicObj[0].Id : 'knowledge-base-topics');
        topicWrpObj.articleBody = articleObj.Body__c;
        topicWrpObj.articleName = articleObj.Title;
        topicWrpObj.articleId = articleObj.Id;
        if (Date.today() == articleObj.LastPublishedDate || Date.today().daysBetween(articleObj.LastPublishedDate.date()) == 0){
            topicWrpObj.agoStr = Label.Today;
        } else if (Date.today().daysBetween(articleObj.LastPublishedDate.date()) < 31){
            topicWrpObj.agoStr = articleObj.LastPublishedDate.date().daysBetween(Date.today()) + ' ' + Label.OL_Days + ' ' + (language == 'fr' ? '' : Label.Ago);
        } else if (articleObj.LastPublishedDate.date().daysBetween(Date.today()) >= 31){
            topicWrpObj.agoStr = (articleObj.LastPublishedDate.date().daysBetween(Date.today()) / 30) + ' ' + Label.months + ' ' + (language == 'fr' ? '' : Label.Ago);
        }   
        ArticleWrp articleWrpObj = new ArticleWrp();
        articleWrpObj.articleBody = articleObj.Body__c;
        articleWrpObj.articleName = articleObj.Title;
        articleWrpObj.articleId = articleObj.Id;

        topicWrpObj.articleWrpObj = articleWrpObj;

        res.put('status', true);
        res.put('topicWrpObj', topicWrpObj);
        return JSON.serializePretty(res);
    }

    @AuraEnabled
    public static String getKnowledgeTopics(String req){
        Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(req);
        String topicName = (String) requestMap.get('topicName');
        Map<String, Object> res = new Map<String, Object>();
        List<AggregateResult> topicListAgg;
        if (String.isBlank(topicName)){
            topicListAgg = [SELECT count(Id)total, 
                                   TopicId topicId, Topic.Name topicName
                            FROM TopicAssignment
                            GROUP BY TopicId, 
                                   Topic.Name
                            ORDER BY Topic.Name];
        } else{
            topicListAgg = [SELECT count(Id)total, 
                                   TopicId topicId, Topic.Name topicName
                            FROM TopicAssignment
                            WHERE Topic.Name LIKE:'%' + topicName + '%'
                            GROUP BY TopicId, 
                                   Topic.Name
                            ORDER BY Topic.Name];
        }
        List<TopicWrp> topicWrpList = new List<TopicWrp>();
        for (AggregateResult topicAgg : topicListAgg){
            TopicWrp topicWrpObj = new TopicWrp();
            topicWrpObj.topicName = (String) topicAgg.get('topicName');
            topicWrpObj.topicId = (String) topicAgg.get('topicId');
            topicWrpObj.topicURL = '/' + topicWrpObj.topicId;
            topicWrpObj.totalArticles = (Integer) topicAgg.get('total');
            topicWrpObj.totalArticlesStr = topicWrpObj.totalArticles + ' ARTICLES';
            topicWrpList.add(topicWrpObj);
        }
        res.put('status', true);
        res.put('topicWrpList', topicWrpList);
        return JSON.serializePretty(res);
    }

    @AuraEnabled
    public static String getKnowledgeTopicswithArticles(String req){
        Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(req);
        String topicName = (String) requestMap.get('topicName');
        Map<String, Object> res = new Map<String, Object>();
        Map<Id, String> topicNameMap = new Map<Id, String>();
        Map<Id, Integer> assignmentMap = new Map<Id, Integer>();
        List<TopicWrp> topicWrpList = new List<TopicWrp>();

        String query = '';

        if (UserInfo.getLanguage() != 'en_US'){
            query += 'Select ParentId, value from TopicLocalization where language = \'' + UserInfo.getLanguage() + '\'';
            if (String.isNotBlank(topicName)){
                query += ' AND Value Like \'%' + topicName + '%\'';
            }
            system.debug(query);
            for (TopicLocalization tp : Database.query(query)){
                topicNameMap.put(tp.ParentId, tp.value);
            }
        } else{
            query += 'Select Id, Name from Topic ';
            if (String.isNotBlank(topicName)){
                query += ' where Name Like \'%' + topicName + '%\'';
            }
            for (Topic tp : Database.query(query)){
                topicNameMap.put(tp.Id, tp.Name);
            }
        }

        //initializing map to have all topics
        for (Id topicId : topicNameMap.keySet()){
            assignmentMap.put(topicId, 0);
        }

        for (TopicAssignment assignment : [Select EntityId, 
                                                  TopicId
                                           from TopicAssignment
                                           where EntityId IN 
                                                  (SELECT Id
                                                   FROM KnowledgeArticleVersion
                                                   Where PublishStatus = 'Online' and language = :UserInfo.getLanguage()) AND TopicId IN:topicNameMap.keySet()]){
            Integer count = assignmentMap.get(assignment.TopicId);
            assignmentMap.put(assignment.TopicId, count + 1);
        }

        for (Id topicId : assignmentMap.keySet()){
            TopicWrp topicWrpObj = new TopicWrp();
            topicWrpObj.topicName = topicNameMap.get(topicId);
            topicWrpObj.topicId = topicId;
            topicWrpObj.topicURL = '/vendorportal/s/knowledge-base-topic/?id=' + topicId;
            topicWrpObj.totalArticles = assignmentMap.get(topicId);
            topicWrpObj.totalArticlesStr = topicWrpObj.totalArticles == 1 ? topicWrpObj.totalArticles + ' ARTICLE' : topicWrpObj.totalArticles + ' ARTICLES';
            topicWrpList.add(topicWrpObj);
        }
        res.put('status', true);
        res.put('topicWrpList', topicWrpList);
        return JSON.serializePretty(res);
    }

    @AuraEnabled(cacheable = true)
    public static String getTopicWithArticles(String topicId){
        Map<String, Object> result = new Map<String, Object>();
        system.debug('Topic Id: ' + topicId);
        if (String.isBlank(topicId)){
            result.put('success', false);
            result.put('error', 'Topic Id is null');
            return JSON.serializePretty(result);
        }
        List<Knowledge__kav> articles = new List<Knowledge__kav>();
        Set<Id> articleIds = new Set<Id>();
        TopicWrp topicWrp = new TopicWrp();

        try{
            if (UserInfo.getLanguage() != 'en_US'){
                for (TopicLocalization tp : [Select Value
                                             from TopicLocalization
                                             where ParentId = :topicId]){
                    topicWrp.topicName = tp.Value;
                    topicWrp.topicId = topicId;
                }
            } else{
                for (Topic tp : [Select Id, 
                                        Name
                                 from Topic
                                 where Id = :topicId]){
                    topicWrp.topicName = tp.Name;
                    topicWrp.topicId = topicId;
                }
            }

            articles = [SELECT Id, 
                               Title, 
                               UrlName, 
                               Summary, 
                               Body__c, 
                               LastPublishedDate, 
                               PublishStatus, 
                               KnowledgeArticleId
                        FROM Knowledge__kav
                        WHERE Id IN 
                               (SELECT EntityId
                                FROM TopicAssignment
                                WHERE TopicId = :topicId) AND PublishStatus = 'Online' AND language = :UserInfo.getLanguage()];

            result.put('success', true);
            result.put('topic', topicWrp);
            result.put('articles', articles);
            return JSON.serializePretty(result);
        } catch (Exception e){
            result.put('success', false);
            result.put('error', e.getMessage());
            return JSON.serializePretty(result);
        }
    }

    @AuraEnabled
    public static String getCommonTopics(String topicReq){
        System.debug(topicReq);
        List<String> topicIds = (List<String>)Json.deserialize(topicReq, List<String>.Class);
        Map<String, Object> res = new Map<String, Object>();
        Map<Id, Integer> assignmentMap = new Map<Id, Integer>();
        Map<Id, String> topicNameMap = new Map<Id, String>();
        List<TopicWrp> topicWrpList = new List<TopicWrp>();

        String query = '';

        if (UserInfo.getLanguage() != 'en_US'){
            query += 'Select ParentId, value from TopicLocalization where language = \'' + UserInfo.getLanguage() + '\'';
            query += ' AND ParentId IN :topicIds';
            system.debug('query: ' + query);
            for (TopicLocalization tp : Database.query(query)){
                topicNameMap.put(tp.ParentId, tp.value);
            }
        } else{
            query += 'Select Id, Name from Topic ';
            query += ' where Id IN :topicIds';
            for (Topic tp : Database.query(query)){
                topicNameMap.put(tp.Id, tp.Name);
            }
        }
        //initializing map to have all topics
        for (Id topicId : topicNameMap.keySet()){
            assignmentMap.put(topicId, 0);
        }

        for (TopicAssignment assignment : [Select EntityId, 
                                                  TopicId
                                           from TopicAssignment
                                           where EntityId IN 
                                                  (SELECT Id
                                                   FROM KnowledgeArticleVersion
                                                   Where PublishStatus = 'Online' and language = :UserInfo.getLanguage()) AND TopicId IN:topicNameMap.keySet()]){
            Integer count = assignmentMap.get(assignment.TopicId);
            assignmentMap.put(assignment.TopicId, count + 1);
        }

        for (Id topicId : assignmentMap.keySet()){
            TopicWrp topicWrpObj = new TopicWrp();
            topicWrpObj.topicName = topicNameMap.get(topicId);
            topicWrpObj.topicId = topicId;
            topicWrpObj.topicURL = '/vendorportal/s/knowledge-base-topic/?id=' + topicId;
            topicWrpObj.totalArticles = assignmentMap.get(topicId);
            topicWrpObj.totalArticlesStr = topicWrpObj.totalArticles == 1 ? topicWrpObj.totalArticles + ' ARTICLE' : topicWrpObj.totalArticles + ' ARTICLES';
            topicWrpList.add(topicWrpObj);
        }
        res.put('status', true);
        res.put('topicWrpList', topicWrpList);
        return JSON.serializePretty(res);
    }

    @AuraEnabled
    public static Map<String, Object> getKnowledgeArticles(){
        Map<String, Object> result = new Map<String, Object>();
        try{
            Set<Id> articleIds = new Set<Id>();
            Map<Id, Set<Id>> topicEntityMap = new Map<Id, Set<Id>>(); //one topic can be associated with multiple articles
            Map<Id, String> topicNameMap = new Map<Id, String>();

            for (Knowledge__ViewStat view : [select parentId, 
                                                    ViewCount
                                             from Knowledge__ViewStat
                                             where Channel = 'AllChannels'
                                             order by ViewCount desc]){
                articleIds.add(view.parentId);
            }

            Map<Id, Knowledge__kav> articles = new Map<Id, Knowledge__kav>([SELECT Id, 
                                                                                   Title, 
                                                                                   UrlName, 
                                                                                   Summary, 
                                                                                   Body__c, 
                                                                                   LastPublishedDate, 
                                                                                   PublishStatus, 
                                                                                   KnowledgeArticleId
                                                                            FROM Knowledge__kav
                                                                            where KnowledgeArticleId IN:articleIds And Language = :UserInfo.getLanguage()
                                                                            Order by LastModifiedDate
                                                                            LIMIT 3]);
            //finding associated topic name of the articles
            for (TopicAssignment topicLink : [Select EntityId, 
                                                     TopicId
                                              from TopicAssignment
                                              where EntityId IN:articles.keySet()]){
                if (topicEntityMap.containsKey(topicLink.TopicId)){
                    topicEntityMap.get(topicLink.TopicId).add(topicLink.EntityId);
                } else{
                    topicEntityMap.put(topicLink.TopicId, new Set<Id>{ topicLink.EntityId });
                }
            }
            if (UserInfo.getLanguage() != 'en_US'){
                for (TopicLocalization tp : [Select Value, Parentid
                                             from TopicLocalization
                                             where ParentId IN:topicEntityMap.keySet() AND Language = :UserInfo.getLanguage()]){
                    for (Id eId : topicEntityMap.get(tp.ParentId)){
                        topicNameMap.put(eId, tp.Value);
                    }

                }
            } else{
                for (Topic tp : [Select Id, 
                                        Name
                                 from Topic
                                 where Id IN:topicEntityMap.keySet()]){
                    for (Id eId : topicEntityMap.get(tp.Id)){
                        topicNameMap.put(eId, tp.Name);
                    }
                }
            }

            result.put('success', true);
            result.put('articles', articles.values());
            result.put('topicNameMap', topicNameMap);
        } catch (Exception e){
            System.debug(e.getMessage());
            result.put('success', false);
            result.put('error', e.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> getArticleId(String articleNumber){
        Map<String, Object> result = new Map<String, Object>();
        try{
            List<Knowledge__kav> articles = [SELECT KnowledgeArticleId
                                             FROM Knowledge__kav
                                             where ArticleNumber = :articleNumber and PublishStatus = 'Online' AND language = :UserInfo.getLanguage()
                                             limit 1];
            result.put('success', true);
            result.put('articles', articles);
        } catch (Exception e){
            System.debug(e.getMessage());
            result.put('success', false);
            result.put('error', e.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static String getKnowledgeTopicList(String req){
        Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(req);
        String topicName = (String) requestMap.get('topicName');
        Map<String, Object> res = new Map<String, Object>();
        List<Topic> topicList;
        if (String.isBlank(topicName)){
            topicList = [SELECT Id, 
                                Name, 
                                Description
                         FROM Topic];
        } else{
            topicList = [SELECT Id, 
                                Name, 
                                Description
                         FROM Topic
                         WHERE Name LIKE:'%' + topicName + '%'];
        }

        List<TopicWrp> topicWrpList = new List<TopicWrp>();
        for (Topic topicObj : topicList){

            TopicWrp topicWrpObj = new TopicWrp();
            topicWrpObj.topicName = topicObj.Name;
            topicWrpObj.topicId = topicObj.Id;
            topicWrpObj.topicURL = '/' + topicObj.Id;
            topicWrpObj.description = topicObj.Description;
            topicWrpList.add(topicWrpObj);
        }
        res.put('status', true);
        res.put('topicWrpList', topicWrpList);
        return JSON.serializePretty(res);
    }

    @AuraEnabled
    public static String getArticlesList(String req){
        Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(req);
        String searchTerm = (String) requestMap.get('searchTerm');
        String language = (String) requestMap.get('language');
        Map<String, Object> res = new Map<String, Object>();
		Map<Id, String> topicNameMap = new Map<Id, String>();
        
        List<Knowledge__kav> articleList = [SELECT Id, 
                                                   Title, 
                                                   UrlName, 
                                                   Summary, 
                                                   Body__c, 
                                                   LastPublishedDate, 
                                                   PublishStatus, 
                                                   KnowledgeArticleId
                                            FROM Knowledge__kav
                                            WHERE (Title LIKE:'%' + searchTerm + '%' OR Summary LIKE:'%' + searchTerm + '%') AND Language = :language AND PublishStatus = 'Online'];

        List<TopicAssignment> topicAssignmentList = [SELECT Id, 
                                                            TopicId, 
                                                            Topic.Name, 
                                                            Topic.Id, 
                                                            EntityId
                                                     FROM TopicAssignment
                                                     WHERE EntityId IN:articleList];

        Map<String, Topic> articleIdTopicObjMap = new Map<String, Topic>();
        Set<Id> stTopicIds = new Set<Id>();
        for (TopicAssignment topicAssignmentObj : topicAssignmentList){
            articleIdTopicObjMap.put(topicAssignmentObj.EntityId, topicAssignmentObj.Topic);
            stTopicIds.add(topicAssignmentObj.TopicId);
        }
        
        String query = '';
		if (language != 'en_US'){
            query += 'Select ParentId, value from TopicLocalization where language = \'' + language + '\'';
            query += ' AND ParentId IN :stTopicIds';
            system.debug('query: ' + query);
            for (TopicLocalization tp : Database.query(query)){
                topicNameMap.put(tp.ParentId, tp.value);
            }
        }
        
        List<TopicWrp> articleWrpList = new List<TopicWrp>();
        for (Knowledge__kav articleObj : articleList){
            TopicWrp articleWrpObj = new TopicWrp();
            articleWrpObj.articleName = articleObj.Title;
            articleWrpObj.articleBody = articleObj.Summary;
            articleWrpObj.articleId = articleObj.id;
            articleWrpObj.articleURL = '/vendorportal/s/knowledge-article?id=' + articleObj.KnowledgeArticleId + '&language=' + language;

            if (articleIdTopicObjMap.containsKey(articleObj.Id)){
                Topic topicObj = articleIdTopicObjMap.get(articleObj.Id);
                articleWrpObj.topicName = language != 'en_US' && topicNameMap.containsKey(topicObj.Id)  ? topicNameMap.get(topicObj.Id) : topicObj.Name; 
                articleWrpObj.topicId = topicObj.Id;
                articleWrpObj.topicURL = '/vendorportal/s/' + topicObj.Id;
            }
            articleWrpList.add(articleWrpObj);
        }

        res.put('status', true);
        res.put('topicWrpList', articleWrpList);
        return JSON.serializePretty(res);
    }

    public class TopicWrp{
        @AuraEnabled
        public String topicName;
        @AuraEnabled
        public String topicURL;
        @AuraEnabled
        public Integer totalArticles;
        @AuraEnabled
        public String topicId;
        @AuraEnabled
        public String totalArticlesStr;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public List<TopicWrp> childTopicWrpList;
        @AuraEnabled
        public ArticleWrp articleWrpObj;
        @AuraEnabled
        public String articleName;
        @AuraEnabled
        public String articleId;
        @AuraEnabled
        public String articleBody;
        @AuraEnabled
        public String articleURL;
        @AuraEnabled
        public String daysDiff;
        @AuraEnabled
        public String agoStr;
        @AuraEnabled
        public List<TopicWrp> relatedArticleList;
        @AuraEnabled
        public Topic topic;
    }

    public class ArticleWrp{
        @AuraEnabled
        public String articleName;
        @AuraEnabled
        public String articleId;
        @AuraEnabled
        public String articleBody;

    }

}