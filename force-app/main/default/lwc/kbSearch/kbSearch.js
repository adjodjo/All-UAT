import { LightningElement, track ,wire } from 'lwc';

import getKnowledgeTopicList from '@salesforce/apex/KnowledgeController.getArticlesList';
import lang from '@salesforce/i18n/lang';
import Knowledge_Search_Text from '@salesforce/label/c.Search_Bar';
import Knowledge_BASE from '@salesforce/label/c.Resources';
import Knowledge_Results from '@salesforce/label/c.Results';
import Knowledge_Search_Resources_Placeholder from '@salesforce/label/c.Search_bar_placeholder';
import { CurrentPageReference } from 'lightning/navigation';
export default class KbSearch extends LightningElement {
    currentPageReference = null; 
    urlStateParameters = null;
    language = lang;
    urlLang = 'en_US';
    label = {
        Knowledge_Search_Text : Knowledge_Search_Text,
        Knowledge_BASE : Knowledge_BASE,
        Knowledge_Results : Knowledge_Results,
        Knowledge_Search_Resources_Placeholder : Knowledge_Search_Resources_Placeholder,
    }

    @track page = 1;
    perpage = 25;
    @track pages = [];
    set_size = 25;

    showSearchButton = true;
    isSearchApply = false;
    searchInput;
    totalTopics;
    topicList;
    isInit = false;
    refreshTextInput = true;
    connectedCallback(){
        if(this.isInit){
            return;
        }
        this.isInit = true;
        //this.getKnowledgeTopicListJS();
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
    setParametersBasedOnUrl() {
       this.urlLang = this.urlStateParameters.language || 'en_US';
       if (this.language && this.language != 'en-US') {
            this.urlLang = this.language;
        }
    }
    getKnowledgeTopicListJS(){
        debugger;        
        getKnowledgeTopicList(
            {  req : JSON.stringify( 
                                   { 
                                       searchTerm: this.searchInput,
                                        language : this.urlLang
                                   }
                                )
            })
        .then(result =>{
            this.refreshTextInput = true;
            let jsonRes = JSON.parse(result);
            if(jsonRes.status){
                let topicList = jsonRes.topicWrpList;
                this.topicList = topicList;
                this.totalTopics = this.topicList.length;
                if(this.totalTopics < 1){
                    this.totalTopics = -1;
                }
                this.pages = [];                
                this.setPages(this.topicList);
            }
        })
        .catch(result => {
            console.log(result);
        });
    }

    handleValueChangeSearch(event){
        this.searchInput = event.detail.value;
        console.log(this.searchInput);
        this.showSearchButton = true;
        //this.isSearchApply = false;
    }

    handleSearchClick(event){
        this.handleSearch();

        // Event to hide the knowledge landing page data
        const toggleSearchEvent = new CustomEvent('togglesearch', { detail: true});
        // Dispatches the event.
        this.dispatchEvent(toggleSearchEvent);
    }

    handleClearClick(event) {
        this.handleSearch();

        // Event to hide the knowledge landing page data
        const toggleSearchEvent = new CustomEvent('togglesearch', { detail: false});
        // Dispatches the event.
        this.dispatchEvent(toggleSearchEvent);
    }

    handleSearch() {
        
        if(!this.showSearchButton){
            this.showSearchButton = false;
            this.isSearchApply = false;
            this.searchInput = '';
            this.refreshTextInput = false;
            this.topicList = [];
            this.totalTopics = undefined;
            let thisObj = this;
            setTimeout(function(){
                thisObj.refreshTextInput = true;
            },300);
        }else{
            if(this.searchInput === null || this.searchInput === undefined || this.searchInput === ''){
                this.showSearchButton = false;
                this.isSearchApply = true;
                this.topicList = [];
                this.totalTopics = -1;
            }else{
                this.showSearchButton = false;
                this.isSearchApply = true;
                this.getKnowledgeTopicListJS()    
            }
        }
    }

    pageData = ()=>{
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page*perpage) - perpage;
        let endIndex = (page*perpage);
        return this.topicList.slice(startIndex,endIndex);
    }


    setPages = (data) => {
        //console.log('-----setPages---');
        let numberOfPages = Math.ceil(data.length / this.perpage);
        for (let index = 1; index <= numberOfPages; index++) {
            this.pages.push(index);
        }
    }  
    
    get hasPrev(){
        return this.page > 1;
    }
    
    get hasNext(){
        return this.page < this.pages.length
    }

    onNext = ()=>{
        ++this.page;
    }

    onPrev = ()=>{
        --this.page;
    }
    onPrevLink = ()=>{
        --this.page;
    }
    onPageClick = (e)=>{
        this.page = parseInt(e.target.dataset.id,10);
    }

    get currentPageData(){
        return this.pageData();
    }

    get pagesList(){
        let mid = Math.floor(this.set_size/2) + 1 ;
        if(this.page > mid){
            return this.pages.slice(this.page-mid, this.page+mid-1);
        } 
        return this.pages.slice(0,this.set_size);
    }

    renderedCallback(){
        this.renderButtons(); 
            //this.renderAnchors();
    }
    renderButtons = ()=>{
        this.template.querySelectorAll('button').forEach((but)=>{
            but.style.color = this.page===parseInt(but.dataset.id,10)?'red':'black';
        });
    }

    get resultText() {
        let result = undefined;
        if (this.totalTopics && this.totalTopics == 1) {
            result = this.totalTopics + ' ' + this.label.Knowledge_Results;
        }else if (this.totalTopics && this.totalTopics > 1) {
            result = this.totalTopics + ' ' + this.label.Knowledge_Results + 's';
        }else if (this.totalTopics &&  this.totalTopics <= 0){
            result = '0 ' + this.label.Knowledge_Results + 's';
        }
        return result;
    }

}