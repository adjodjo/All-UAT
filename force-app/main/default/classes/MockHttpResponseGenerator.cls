public class MockHttpResponseGenerator implements HttpCalloutMock 
{
    public HTTPResponse respond(HTTPRequest req) 
    {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('Test Body');
        res.setStatusCode(200);
        System.assertEquals('POST', req.getMethod());
      
        return res;
    }
}