({
    init: function (cmp, helper) {
        console.log('helper.init', cmp, helper);

        var store = {

            page: 0,
            pageSize: 10,
            accountTypesMap: [],

            matchData: [],
            matchColumns: [
                {
                    label: 'Connect Name',
                    fieldName: 'Name',
                    type: 'text'
                },
                {
                    label: 'SF Name',
                    fieldName: 'sfAccountName',
                    type: 'text'
                },
                {
                    label: 'Reason',
                    fieldName: 'Match_Type__c',
                    type: 'text'
                },
                {
                    label: '',
                    type: 'button',
                    fieldName: 'Id',
                    typeAttributes: {
                        label: 'Review',
                        name: 'review'
                    }
                }
            ],

            reviewMatch: null,
            compareAccount: null,
            searchText: null,
            searchColumns: [
                {
                    label: 'Name',
                    fieldName: 'Name',
                    type: 'text'
                },
                {
                    label: 'Connect Id',
                    fieldName: 'Organizer_ID__c',
                    type: 'text'
                },
                {
                    label: 'Email Domain',
                    fieldName: 'emailDomain',
                    type: 'text'
                },
                {
                    label: 'Status',
                    fieldName: 'Active__c',
                    type: 'text'
                },
                {
                    label: 'Type',
                    fieldName: 'sfAccountType',
                    type: 'text'
                },
                {
                    label: '',
                    type: 'button',
                    fieldName: 'Id',
                    typeAttributes: {
                        label: 'Select',
                        name: 'select'
                    }
                }
            ],
            searchResults: null,

            initialRows: 10,
            rowsToLoad: 10,
            totalNumberOfRows: 32,
            moreMatchesToLoad: true,
            loadMoreStatus: '',
            enableInfiniteLoading: true,

            showConfirmModal: false,
            confirmModalHeader: 'Confirm',
            confirmModalBody: 'Are you Sure?',
            confirmModalConfirmText: 'Yes',
            confirmModalCancelText: 'Yes',

            confirmModalConfirmAction: ''
        };

        helper.setStore(cmp, store);

        helper.getCount(cmp, helper);
        helper.getAccountTypesMap(cmp, helper);
        helper.getMatches(cmp, helper);
    },
    setStoreValue: function (cmp, helper, propertyName, value) {
        console.log('setStoreValue: ', arguments);
        var store = helper.getStore(cmp);

        store[propertyName] = value;

        helper.setStore(cmp, store);
    },
    setStore: function (cmp, store) {
        cmp.set('v.store', store);
    },
    getStore: function (cmp) {
        var store = cmp.get('v.store');

        return store;
    },

    getCount: function (cmp, helper) {
        var log = console.log;

        log('getCount', cmp, helper);

        function callback(results) {
            console.log('getCount callback');

            helper.setStoreValue(cmp, helper, 'totalNumberOfRows', results);
        }

        console.log('getCount call serverCall');
        helper.serverCall(
            'c.getContractorMatchesCount',
            callback,
            null,
            cmp,
            helper
        );
    },
    getAccountTypesMap: function (cmp, helper) {
        var log = console.log;

        log('getAccountTypesMap', cmp, helper);

        function callback(results) {
            console.log('getAccountTypesMap callback');

            helper.setStoreValue(cmp, helper, 'accountTypesMap', results);
        }

        console.log('getAccountTypesMap call serverCall');
        helper.serverCall('c.getAccountTypesMap', callback, null, cmp, helper);
    },
    getMatches: function (cmp, helper, callerCallback) {
        var log = console.log;

        log('getMatches', cmp, helper);

        var store = helper.getStore(cmp);

        if (store.matchData.length >= store.totalNumberOfRows) {
            helper.setStoreValue(cmp, helper, 'enableInfiniteLoading', false);
            helper.setStoreValue(cmp, helper, 'moreMatchesToLoad', false);
            helper.setStoreValue(
                cmp,
                helper,
                'loadMoreStatus',
                'No more matches to load'
            );

            if (callerCallback) {
                callerCallback();
            }
        } else {
            var params = {
                page: store.page,
                pageSize: store.pageSize,
                orderBy: 'name'
            };

            var dto = {dto: JSON.stringify(params)};
            log(dto);

            function callback(results, cmp, helper) {
                console.log('getMatches callback');
                var store = helper.getStore(cmp);

                var formatMatchesedResults = helper.formatMatches(results, cmp, helper);

                console.log(formatMatchesedResults);

                var currentMatches = store.matchData;

                var dataResults = currentMatches.concat(formatMatchesedResults);

                helper.setStoreValue(cmp, helper, 'matchData', dataResults);
                helper.setStoreValue(cmp, helper, 'loadMoreStatus', '');
                helper.setStoreValue(cmp, helper, 'page', store.page + 1);

                if (callerCallback) {
                    callerCallback();
                }
            }

            helper.setStoreValue(cmp, helper, 'page', params.page++);

            console.log('getMatches call serverCall');
            helper.serverCall('c.getContractorMatches', callback, dto, cmp, helper);
        }
    },
    getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        if (row['matchFound']) {
            actions.push({
                label: 'Review Match',
                iconName: 'action:approval',
                name: 'approve'
            });
        }

        actions.push({
            label: 'Search',
            iconName: 'utility:search',
            name: 'search'
        });
        // simulate a trip to the server
        setTimeout(
            $A.getCallback(function () {
                doneCallback(actions);
            }),
            200
        );
    },
    reviewMatch: function (cmp, helper, match) {
        console.log('ReviewMatch');
        console.log(helper.pojo(match));

        helper.accountFetch(cmp, helper, match);

        helper.setStoreValue(cmp, helper, 'reviewMatch', match);
    },
    setAccountOnCurrentMatch: function (cmp, helper, account) {
        console.log('ReviewMatch');
        console.log(helper.pojo(account));

        var store = helper.getStore(cmp);

        var match = store.reviewMatch;

        match.Account__c = account.Id;

        helper.accountFetch(cmp, helper, match);

        helper.setStoreValue(cmp, helper, 'reviewMatch', match);
    },
    accountSearch: function (cmp, event, helper) {
        console.log('accountSearch');

        var params = {
            searchText: helper.getStore(cmp).searchText
            // searchType: cmp.get('v.searchType')
        };

        function callback(results, cmp, helper) {
            helper.formatSearch(results, cmp, helper);

            helper.setStoreValue(cmp, helper, 'searchResults', results);
        }

        console.log('accountSearch call serverCall');
        helper.serverCall('c.accountSearch', callback, params, cmp, helper);
    },
    clearMatch: function (cmp, helper) {
        console.log('saveMatch');

        var store = helper.getStore(cmp);

        var match = store.reviewMatch;
        var account = store.compareAccount;

        var params = {
            matchId: match.Id
        };

        function callback(results) {
            helper.setStoreValue(cmp, helper, 'searchResults', results);
            helper.init(cmp, helper);
        }

        console.log('clearAccountMatch call serverCall');
        helper.serverCall('c.clearAccountMatch', callback, params, cmp, helper);
    },
    saveMatch: function (cmp, helper) {
        console.log('saveMatch');

        var store = helper.getStore(cmp);

        var match = store.reviewMatch;
        var account = store.compareAccount;

        var params = {
            matchId: match.Id,
            accountId: account.Id
        };

        function callback(results) {
            helper.setStoreValue(cmp, helper, 'searchResults', results);
            helper.init(cmp, helper);
        }

        console.log('saveAccountMatch call serverCall');
        helper.serverCall('c.saveAccountMatch', callback, params, cmp, helper);
    },
    confirmAndCreateAccount: function (cmp, helper) {
        console.log('confirmAndCreateAccount');


        var store = helper.getStore(cmp);

        var match = store.reviewMatch;

        var params = {
            matchId: match.Id
        };

        function callback(results) {
            helper.init(cmp, helper);
        }

        console.log('createAccountFromMatch call serverCall');
        helper.serverCall('c.createAccountFromMatch', callback, params, cmp, helper);

    },
    confirmAndMatchAccounts: function (cmp, helper) {
        console.log('confirmAndMatchAccounts');

        var store = helper.getStore(cmp);

        var match = store.reviewMatch;
        var account = store.compareAccount;

        var params = {
            matchId: match.Id,
            accountId: account.Id
        };

        function callback(results) {
            helper.init(cmp, helper);
        }

        console.log('approveMatch call serverCall');
        helper.serverCall('c.approveMatch', callback, params, cmp, helper);
    },
    accountFetch: function (cmp, helper, match) {
        console.log('acountFetch');

        var store = helper.getStore(cmp);

        var account = store.compareAccount;

        if (!match) {
            var match = store.reviewMatch;
        }

        var params = {
            searchId: match.Account__c
        };

        function callback(results, cmp, helper) {
            results = helper.populateAccountType(results, cmp, helper);

            helper.setStoreValue(cmp, helper, 'compareAccount', results);
        }

        if (match.Account__c) {
            console.log('accountFetch call serverCall');
            helper.serverCall('c.accountFetch', callback, params, cmp, helper);
        } else {
            console.log('accountFetch set empty account');
            helper.setStoreValue(cmp, helper, 'compareAccount', null);
        }
    },
    formatMatches: function (entries, cmp, helper) {
        for (var i = 0; i < entries.length; i++) {
            if (entries[i].accountRecordTypeId__c) {
                var types = helper.getStore(cmp).accountTypesMap;

                entries[i].accountType = types[entries[i].accountRecordTypeId__c];
            }

            if (entries[i].Account__r) {
                entries[i].matchFound = true;

                if (entries[i].Account__r.Name) {
                    entries[i].sfAccountName = entries[i].Account__r.Name;
                }
            } else {
                entries[i].matchFound = false;
            }
        }

        return entries;
    },
    populateAccountType: function (account, cmp, helper) {
        if (account.RecordTypeId) {
            var store = helper.getStore(cmp);
            var types = store.accountTypesMap;

            account.sfAccountType = types[account.RecordTypeId];
        }

        return account;
    },
    formatSearch: function (entries, cmp, helper) {
        for (var i = 0; i < entries.length; i++) {
            entries[i] = helper.populateAccountType(entries[i], cmp, helper);

            if (entries[i].Primary_Contact_Email__c) {
                entries[i].emailDomain = entries[i].Primary_Contact_Email__c.split(
                    '@'
                )[1];
            }
        }

        return entries;
    },
    serverCall: function (method, callback, params, cmp, helper) {
        console.log('serverCall', method, callback, params, cmp, helper);
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get(method);

        if (params) {
            console.log(params);
            action.setParams(params);
        }

        // Create a callback that is executed after
        // the server-side action returns
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                // Alert the user with the value returned
                // from the server
                var results = response.getReturnValue();

                console.log('results: ', results);

                if (callback) {
                    callback(results, cmp, helper);
                }

                // You would typically fire a event here to trigger
                // client-side notification that the server-side
                // action is complete
            } else if (state === 'INCOMPLETE') {
                // do something
            } else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log('Error message: ' + errors[0].message);
                    }
                } else {
                    console.log('Unknown error');
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events,
        // which could trigger other events and
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    pojo: function (obj) {
        return JSON.parse(JSON.stringify(obj));
    }
});