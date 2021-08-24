({
    handleValueChange: function (component, event, helper) {
        let menuItems = JSON.parse(JSON.stringify(component.get("v.menuItems")));
        component.find('messageChannel').publish(menuItems);
    }
})