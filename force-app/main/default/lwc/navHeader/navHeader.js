import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import COMPANY_LOGO from '@salesforce/resourceUrl/Company_Logo';
import basePath from '@salesforce/community/basePath';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from "lightning/uiRecordApi";
import FIRST_NAME from "@salesforce/schema/User.FirstName";
import LAST_NAME from "@salesforce/schema/User.LastName";
import LOGOUT_LABEL from "@salesforce/label/c.Logout";
import MENU_ARROW_DOWN from '@salesforce/resourceUrl/menu_down_arrow';
import TOOL_TIPS_SVG from '@salesforce/resourceUrl/tooltipSvg';
import SEARCH_SVG from '@salesforce/resourceUrl/searchSvg';
import ALERT_SVG from '@salesforce/resourceUrl/alertSvg';
import setupNavigationItems from '@salesforce/apex/NavigationMenuItemsController.setupNavigationItems';
import getClientLogoUrl from '@salesforce/apex/NavigationMenuItemsController.getClientLogoUrl';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import portalMessageChannel from '@salesforce/messageChannel/portalMessageChannel__c';
import lang from '@salesforce/i18n/lang';
import NAVIGATION_NAME from '@salesforce/label/c.Portal_Navigation_Name';

export default class NavHeader extends NavigationMixin(LightningElement) {
    //public attributes
    @api menuItems;
    @api menuName;

    //tracked attributes
    @track pageRef;
    @track action_menu_items = [];
    @track request_items = [];
    @track company_info_items = [];
    @track customer_info_items = [];
    @track menuToggle = 'menuToggle';
    @track menuOpen = false;

    logo;
    logoAlt;
    logoFrench;
    logoAltFrench;

    publishedState = 'Live';
    menu_arrow_down_svg = `${MENU_ARROW_DOWN}#ic-baseline-keyboard-arrow-right`;
    tool_tip_svg = `${TOOL_TIPS_SVG}#question`;
    search_svg = `${SEARCH_SVG}#search`;
    alert_svg = `${ALERT_SVG}#alerts`;
    logoutLabel = LOGOUT_LABEL;
    href = basePath;
    home;

    @wire(MessageContext)
    messageContext;

    Logo_Url__c
    Logo_Url_French__c

    @wire(getRecord, { recordId: USER_ID, fields: [FIRST_NAME, LAST_NAME] })
    user;


    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    connectedCallback() {
        this.handleGetClientLogoUrl();
        this.subscribeToMessageChannel();
    }

    handleMessage(message) {
        this.menuItems = message;
        if (this.menuItems) {

            this.handleSetupNavigationItems();
        }
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                portalMessageChannel,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleGetClientLogoUrl() {
        getClientLogoUrl().then(result => {
            if (result) {
                result = JSON.parse(result);
                this.logo = result.Contact.Account.Logo_Url__c;
                this.logoAlt = result.Contact.Account.Logo_Alt_Text__c;
                this.logoFrench = result.Contact.Account.Logo_Url_French__c;
                this.logoAltFrench = result.Contact.Account.Logo_Alt_Text_French__c;
            } else {
                this.logo = COMPANY_LOGO;
                this.logoAlt = 'Company Logo';
                this.logoFrench = COMPANY_LOGO;
                this.logoAltFrench = 'Logo d\'entreprise';

            }
        }).catch(error => {
            console.error(error);
        });
    }


    handleSetupNavigationItems() {
        setupNavigationItems({
            menuName: NAVIGATION_NAME,
            publishedState: this.publishedState,
            x_menuItems: JSON.stringify(this.menuItems)
        }).then(result => {
            if (result && result.indexOf('Error') == -1) {

                this.request_items = [];
                this.action_menu_items = [];
                this.company_info_items = [];
                this.customer_info_items = [];
                let navigationItems = JSON.parse(result);
                navigationItems.sort((a, b) => (a.id > b.id) ? 1 : -1);

                for (let i = 0; i < navigationItems.length; i++) {
                    if (navigationItems[i].grouping === 'action_item') {
                        navigationItems[i].label = navigationItems[i].label.toUpperCase();
                        this.action_menu_items.push(navigationItems[i]);
                    }
                    else if (navigationItems[i].grouping === 'request_item') {
                        this.request_items.push(navigationItems[i]);
                    }
                    else if (navigationItems[i].grouping === 'customer_info_item') {
                        this.customer_info_items.push(navigationItems[i]);
                    }
                    else if (navigationItems[i].grouping === 'company_info_item') {
                        this.company_info_items.push(navigationItems[i]);
                    } else {
                        this.home = navigationItems[i];
                    }
                }

            } else {
                throw result;
            }
        }).catch(error => {
            console.error(error);
        });
    }

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.pageRef = currentPageReference;
        this.menuToggle = 'menuToggle';
        const app = currentPageReference && currentPageReference.state && currentPageReference.state.app;
        if (app === 'commeditor') {
            this.publishedState = 'Draft';
        } else {
            this.publishedState = 'Live';
        }
        if (lang) {
            this.displayLanguage = lang.indexOf('-') > -1 ? lang.replace('-', '_') : lang;
            this.language = this.displayLanguage == 'fr' ? 'English' : 'Français';
        }
        if (this.template.querySelector(".checkbox-hamburger")) {
            this.template.querySelector(".checkbox-hamburger").checked = false;
            this.handleChange();
        }
    }

    handleLanguageChange() {
        this.displayLanguage = this.displayLanguage == 'fr' ? 'en_US' : 'fr';
        this.handleChangeUserLangauge();
    }

    //causes page refresh with language prefences
    handleChangeUserLangauge() {
        let path = location.origin + location.pathname;
        path += '?language=' + this.displayLanguage;
        location.href = path;
    }

    //changes the width of the menu toggle based on langauges
    handleChange() {
        this.menuOpen = this.template.querySelector(".checkbox-hamburger") && this.template.querySelector(".checkbox-hamburger").checked === true;
        if (this.menuOpen && this.template.querySelector(".checkbox-hamburger")) {
            this.template.querySelector(".checkbox-hamburger").classList.add('shiftCheckboxLeft');
        } else {
            this.template.querySelector(".checkbox-hamburger").classList.remove('shiftCheckboxLeft');
        }
    }

    get isFr()
    {
        return this.displayLanguage === 'fr';
    }

    //handles navigating to home page
    handleHomeClick() {
        let pageref = {
            attributes:
            {
                name: "Home"
            },
            type: "comm__namedPage"
        }
        this[NavigationMixin.Navigate](pageref);
    }


    get homeActive() {
        return this.home && this.home.active ? 'active' : '';
    }

    get userFullName() {
        return this.user && this.user.data && this.user.data.fields ? this.user.data.fields.FirstName.value + this.user.data.fields.LastName.value : '';
    }

    get logoutUrl() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        return sitePrefix + "/secur/logout.jsp";
    }

}