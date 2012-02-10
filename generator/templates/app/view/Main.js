Ext.define("%NAMESPACE_NAME%.view.Main", {
    extend: "Ext.TabPanel",
    xtype: "mainview",

    config: {
        tabBarPosition: "bottom",
        items: [
            {
                xtype: "container",
                iconCls: "compass1",
                title: "Item 1"
            },
            {
                xtype: "container",
                iconCls: "settings7",
                title: "Item 2"
            },
            {
                xtype: "container",
                iconCls: "info_plain2",
                title: "Item 3"
            }
        ]
    }

});
