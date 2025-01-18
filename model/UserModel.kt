package com.example.chatappfirebase.model

import com.google.firebase.Timestamp

data class UserModel (
    var name: String,
    var phone: String,
    var createdTimestamp: Timestamp,
    var userId: String,
    var fcmToken: String
){
    constructor() : this("", "", Timestamp.now(), "","")
}
