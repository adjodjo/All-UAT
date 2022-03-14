import { LightningElement, api } from 'lwc';

export default class HcccListItem extends LightningElement {

    @api title;
    @api bodyTitle;
    @api bodyText;
    @api url;


    connectedCallback(){
        
    }

}