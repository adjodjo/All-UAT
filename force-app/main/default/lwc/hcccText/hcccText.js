import { LightningElement, api } from 'lwc';

export default class HcccText extends LightningElement {
    @api hcccclass;
    @api size;
    @api color;

    get style() {
        let style = '';
        if (this.hcccclass) {
            style += this.hcccclass + ' '; 
        }
        if (this.color) {
            style += this.color + ' '; 
        }
        if (this.size) {
            style += this.size + ' '; 
        }
        return style;
    }
}