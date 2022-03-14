import { LightningElement, api } from 'lwc';

export default class HcccCard extends LightningElement {

    @api title;
    @api url;

    connectedCallback(){}

}