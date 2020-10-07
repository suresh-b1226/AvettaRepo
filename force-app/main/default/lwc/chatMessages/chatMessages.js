/**
 * Created by JasonMcGrew on 8/12/2020.
 */

import BaseChatMessage from 'lightningsnapin/baseChatMessage';
import { track, wire } from 'lwc';
import getAllChatBotLinks from "@salesforce/apex/chatMessagesController.getAllChatBotLinks";

const DEFAULT_MESSAGE_PREFIX = 'ANY_TEXT';
const YOUTUBE_MESSAGE_PREFIX = 'YOUTUBE';
const IMAGE_MESSAGE_PREFIX   = 'IMAGE';


const SUPPORTED_MESSAGE_PREFIX = [DEFAULT_MESSAGE_PREFIX, YOUTUBE_MESSAGE_PREFIX, IMAGE_MESSAGE_PREFIX];

/**
 * Displays a chat message using the inherited api messageContent and is styled based on the inherited api userType and messageContent api objects passed in from BaseChatMessage.
 */
export default class ChatMessages extends BaseChatMessage  {
    messageType = DEFAULT_MESSAGE_PREFIX;
    @track content = '';
    @track chatbotlinks;

    @wire(getAllChatBotLinks)
    wiredChatbotlinks({ error, data }) {
        if (data) {
            this.chatbotlinks = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    }

    constructor() {
        super();
    }
    renderedCallback() {

/*        if (!this.isAgent) {
            return;
        }*/
        const messageTypePrefixPosition = SUPPORTED_MESSAGE_PREFIX.indexOf(this.messageContent.value.split(':')[0]);

        if (messageTypePrefixPosition > -1) {
            this.messageType = SUPPORTED_MESSAGE_PREFIX[messageTypePrefixPosition];
        }

        const contentValue = (this.messageContent.value.split(this.messageType + ':').length === 1) ? this.messageContent.value : this.messageContent.value.split(this.messageType + ':')[1];

        if (this.isYoutube) {
            this.content = 'https://www.youtube.com/embed/' + contentValue;
        } else if (this.isImage) {
            this.content = this.extractOriginalString(contentValue);
        } else {
            const contenttemp = contentValue
                .replace( // innerText or textContent
                    /(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?((?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2}))|((\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)(\.(\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)){3}))(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$ |\/.,*:;=]|%[a-f\d]{2})*)?/g,
                    function(imgUrl) {
                        if(this.chatbotlinks !== undefined) {
                            let foundelement = this.chatbotlinks.find(ele => ele.link == imgUrl);
                            if(foundelement !== undefined) {
                                return `<a target="_blank" href="${imgUrl}">${foundelement.title}</a>`;
                            }
                            else if(imgUrl.includes('https://') || imgUrl.includes('http://')) {
                                return `<a target="_blank" href="${imgUrl}">Click This Link</a>`;
                            }
                        }
                        return imgUrl;
                    }.bind(this)
                );
            this.content = contenttemp.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '\\"');
        }
    }

    extractOriginalString(generatedString) {
        const matched = generatedString.match(/<a href.+>(.*?)<\/a>/);
        if (matched.length > 1) {
            return matched[1];
        }
        return generatedString;
    }

    get isAgent() {
        return this.userType === 'agent';
    }

    get isAnyText() {
        return this.messageType === DEFAULT_MESSAGE_PREFIX;
    }

    get isYoutube() {
        return this.messageType === YOUTUBE_MESSAGE_PREFIX;
    }

    get isImage() {
        return this.messageType === IMAGE_MESSAGE_PREFIX;
    }

    get isLoaded() {
        if (this.chatbotlinks != undefined) {
            return true;
        }
        return false;
    }
}