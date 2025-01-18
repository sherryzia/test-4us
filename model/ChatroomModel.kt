package com.example.chatappfirebase.model

import com.google.firebase.Timestamp

data class ChatroomModel(
    var chatroomId: String,
    var userIds: List<String?>,
    var lastMessageTimestamp: Timestamp,
    var lastMessageSenderId: String,
    var lastMessageSendToName: String,
    var lastMessage: String? = null,
    ) {
    constructor() : this("", emptyList(), Timestamp.now(), "", "", "")
}
