Ext.Loader.setPath('%NAMESPACE_NAME%', 'app');

Ext.application({
    name: '%NAMESPACE_NAME%',
    tabletStartupScreen: 'resources/images/tabletStartupScreen.png',
    phoneStartupScreen: 'resources/images/phoneStartupScreen.png',
    icon: 'resources/images/icon.png',
    glossOnIcon: false,

    requires: [
        'Ext.Anim',
        'Ext.DateExtras'
    ],

    controllers: [
        
    ],

    models: [
        
    ],

    stores: [
        
    ],

    views: [
        'Main'
    ],

    launch: function () {

        Ext.Viewport.add({
            xtype: 'mainview'
        });

    }

});