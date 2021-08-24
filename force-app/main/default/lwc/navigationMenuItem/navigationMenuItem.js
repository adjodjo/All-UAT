import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import basePath from '@salesforce/community/basePath';
import ACTION_ARROW from '@salesforce/resourceUrl/action_arrow'


export default class NavigationMenuItem extends NavigationMixin(LightningElement) {

    @api item;
    @api index
    @track href = '#';

    pageReference;
    svgURL = `${ACTION_ARROW}#action-arrow`;

    connectedCallback() {
        // get the correct PageReference object for the menu item type
        if (this.item.navMenuItem.Type === 'SalesforceObject') {
            // aka "Salesforce Object" menu item
            this.pageReference = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: this.item.navMenuItem.Target
                },
                state: {
                    filterName: this.item.navMenuItem.DefaultListViewId
                }
            };
        } else if (this.item.navMenuItem.Type === 'InternalLink') {
            // aka "Site Page" menu item

            // WARNING: Normally you shouldn't use 'standard__webPage' for internal relative targets, but
            // we don't have a way of identifying the Page Reference type of an InternalLink URL
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: basePath + this.item.navMenuItem.Target
                }
            };
        } else if (this.item.navMenuItem.Type === 'ExternalLink') {
            // aka "External URL" menu item
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: this.item.navMenuItem.Target
                }
            };
        }

        // use the NavigationMixin from lightning/navigation to generate the URL for navigation.
        if (this.pageReference) {
            this[NavigationMixin.GenerateUrl](this.pageReference).then(
                (url) => {
                    this.href = url;
                }
            );
        }
    }

    handleNavigation() {
        this.dispatchEvent(new CustomEvent('navigation'));
    }

    handleClick(evt) {
        // use the NavigationMixin from lightning/navigation to perform the navigation.
        evt.stopPropagation();
        evt.preventDefault();
        this.handleNavigation();
        if (this.pageReference) {
            this[NavigationMixin.Navigate](this.pageReference);
        } else {
            console.log(
                `Navigation menu type "${this.item.navMenuItem.type
                }" not implemented for item ${JSON.stringify(this.item)}`
            );
        }
    }
    
    get cssClass() {
        if (this.item && this.item.grouping !== 'action_item') {
            return this.index === 0 ? 'nav-item slds-var-m-top_large' : 'nav-item';
        } else {
            return this.index === 0 ? 'action-button slds-var-m-top_large' : 'action-button ';
        }

    }

    get isActionButton() {
        return this.item && this.item.grouping === 'action_item';
    }

    get itemCss() {

        return this.item && this.item.active ? 'active' : '';
    }
}