({
    init: function (cmp, event, helper) {
        console.log('start init', cmp, event, helper);

        var actions = helper.getRowActions.bind(this, cmp);

        helper.init(cmp, helper);
    },

    handleMatchRowAction: function (cmp, event, helper) {
        console.log('handleOnRowAction');
        var action = event.getParam('action');
        var row = event.getParam('row');

        console.log('cmp');
        console.log(cmp);
        console.log('event');
        console.log(event);
        console.log('helper');
        console.log(helper);
        console.log('action');
        console.log(action);
        console.log('row');
        console.log(row);

        switch (action.name) {
            case 'review':
                helper.reviewMatch(cmp, helper, row);
                break;
        }
    },

    handleSearchRowAction: function (cmp, event, helper) {
        console.log('handleOnRowAction');
        var action = event.getParam('action');
        var row = event.getParam('row');

        console.log('cmp');
        console.log(cmp);
        console.log('event');
        console.log(event);
        console.log('helper');
        console.log(helper);
        console.log('action');
        console.log(action);
        console.log('row');
        console.log(row);

        switch (action.name) {
            case 'select':
                helper.setAccountOnCurrentMatch(cmp, helper, row);
                break;
        }
    },
    searchUpdate: function (cmp, event, helper) {
        console.log('searchUpdate');
        helper.accountSearch(cmp, event, helper);
    },
    handleClearClick: function (cmp, event, helper) {
        helper.clearMatch(cmp, helper);
    },
    handleSaveClick: function (cmp, event, helper) {
        helper.saveMatch(cmp, helper);
    },
    handleApproveClick: function (cmp, event, helper) {
        console.log('handleApproveClick');


        helper.setStoreValue(cmp, helper, 'showConfirmModal', true);
        helper.setStoreValue(
            cmp,
            helper,
            'confirmModalHeader',
            'Link Accounts?'
        );
        helper.setStoreValue(
            cmp,
            helper,
            'confirmModalBody',
            'Link the Connect account with the account found in Salesforce?'
        );
        helper.setStoreValue(cmp, helper, 'confirmModalConfirmText', 'Yes');
        helper.setStoreValue(cmp, helper, 'confirmModalCancelText', 'No');
        helper.setStoreValue(
            cmp,
            helper,
            'confirmModalConfirmAction',
            'confirmAndMatchAccounts'
        );
    },
    handleNoMatchClick: function (cmp, event, helper) {
        // helper.saveMatch(cmp, helper);

        helper.setStoreValue(cmp, helper, 'showConfirmModal', true);
        helper.setStoreValue(
            cmp,
            helper,
            'confirmModalHeader',
            'Create New Account?'
        );
        helper.setStoreValue(
            cmp,
            helper,
            'confirmModalBody',
            'No match was found and you would like to create a new account based on the available information?'
        );
        helper.setStoreValue(cmp, helper, 'confirmModalConfirmText', 'Yes');
        helper.setStoreValue(cmp, helper, 'confirmModalCancelText', 'No');
        helper.setStoreValue(
            cmp,
            helper,
            'confirmModalConfirmAction',
            'confirmAndCreateAccount'
        );
    },
    handleConfirmModalCancelClick: function (cmp, event, helper) {
        console.log('handleConfirmModalCancelClick');
        helper.setStoreValue(cmp, helper, 'showConfirmModal', false);
    },
    handleConfirmModalApproveClick: function (cmp, event, helper) {
        console.log('handleConfirmModalApproveClick');
        // helper.saveMatch(cmp, helper);

        helper.setStoreValue(cmp, helper, 'showConfirmModal', false);

        // force:createRecord
        // https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/ref_force_createRecord.htm

        //TODO: Handle this

        var store = helper.getStore(cmp);
        var actionName = store.confirmModalConfirmAction;


        if (actionName) {

            switch (actionName) {
                case 'confirmAndMatchAccounts': {
                    helper.confirmAndMatchAccounts(cmp, helper);
                    break;
                }
                case 'confirmAndCreateAccount': {
                    helper.confirmAndCreateAccount(cmp, helper);
                    break;
                }

            }

        }
    },
    loadMoreMatches: function (cmp, event, helper) {
        //Display a spinner to signal that data is being loaded
        event.getSource().set('v.isLoading', true);
        //Display "Loading" when more data is being loaded
        cmp.set('v.loadMoreStatus', 'Loading');
        // helper.getMatches(cmp, cmp.get('v.rowsToLoad'))
        //     .then($A.getCallback(function (data) {
        //         if (cmp.get('v.data').length >= cmp.get('v.totalNumberOfRows')) {
        //             cmp.set('v.enableInfiniteLoading', false);
        //             cmp.set('v.loadMoreStatus', 'No more data to load');
        //         } else {
        //             var currentData = cmp.get('v.data');
        //             //Appends new data to the end of the table
        //             var newData = currentData.concat(data);
        //             cmp.set('v.data', newData);
        //             cmp.set('v.loadMoreStatus', '');
        //         }
        //         event.getSource().set("v.isLoading", false);
        //     }));

        function callback() {
            event.getSource().set('v.isLoading', false);
        }

        var store = helper.getStore(cmp);

        if (store.moreMatchesToLoad) {
            helper.getMatches(cmp, helper, callback);
        }
    },
    viewMatch: function (cmp, event, helper) {
        console.log('viewMatch');

        var store = helper.getStore(cmp);

        var match = store.reviewMatch;
        window.open('/' + match.Id);
    },
    viewCompareAccount: function (cmp, event, helper) {
        console.log('viewCompareAccount');

        var store = helper.getStore(cmp);

        var account = store.compareAccount;
        window.open('/' + account.Id);
    },
    handleStoreEvent: function (cmp, event, helper) {
        console.log('handleStoreEvent');


    }
});