package com.example.chatappfirebase.utils

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.util.Log
import com.example.chatappfirebase.ChatActivity
import com.example.chatappfirebase.LoginPhoneNumberActivity
import com.example.chatappfirebase.model.UserModel
import com.google.firebase.Timestamp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.CollectionReference
import com.google.firebase.firestore.DocumentReference
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageReference
import java.text.SimpleDateFormat


class FirebaseUtils {
    companion object {

        // Changed to a function to prevent null initialization issues
        val currentUid: String?
            get() = FirebaseAuth.getInstance().uid



        fun currentUserDetails(onResult: (DocumentReference?) -> Unit) {
            collectionUserDetails
                .whereEqualTo("userId", currentUid!!)
                .limit(1)
                .get()
                .addOnSuccessListener { querySnapshot ->
                    if (!querySnapshot.isEmpty) {
                        // Fetch the first document that matches the query
                        val userDocument = querySnapshot.documents[0]

                        // Extract phone from the document
                        val uid = userDocument.getString("phone").toString()
                        Log.d("fetchUserDetails", "phone $uid")

                        // Pass the DocumentReference back to the caller
                        val userRef = FirebaseFirestore.getInstance().collection("users").document(uid)
                        onResult(userRef)
                    } else {
                        Log.e("fetchUserDetails", "User document not found for current UID.")
                        onResult(null)
                    }
                }
                .addOnFailureListener { exception ->
                    Log.e("fetchUserDetails", "Failed to fetch user details", exception)
                    onResult(null)
                }
        }


//        fun LastMessageUpdater(lastMessage: String?,chatroomId: String?,onResult: (DocumentReference?) -> Unit) {
//            collectionUserDetails
//                .whereEqualTo("userId", currentUid!!)
//                .limit(1)
//                .get()
//                .addOnSuccessListener { querySnapshot ->
//                    if (!querySnapshot.isEmpty) {
//
//                        val userRef = FirebaseFirestore.getInstance().collection("chatrooms").document(chatroomId!!).update("lastMessage",lastMessage)
//                        onResult(userRef)
//                    } else {
//                        Log.e("fetchUserDetails", "User document not found for current UID.")
//                        onResult(null)
//                    }
//                }
//                .addOnFailureListener { exception ->
//                    Log.e("fetchUserDetails", "Failed to fetch user details", exception)
//                    onResult(null)
//                }
//        }




        val collectionUserDetails = FirebaseFirestore.getInstance().collection("users")

        val getCurrentProfilePicStorageRef: StorageReference
            get() = FirebaseStorage.getInstance().reference.child("profile_pic")
                .child(currentUid ?: "default")

        fun getOtherProfilePicStorageRef(otherUserId: String?): StorageReference {
            return FirebaseStorage.getInstance().reference.child("profile_pic")
                .child(otherUserId ?: "default")
        }

        fun allUserCollectionReference(): CollectionReference {
            return FirebaseFirestore.getInstance().collection("users")
        }

        fun logout(context: Context) {
            FirebaseAuth.getInstance().signOut()
            val intent = Intent(context, LoginPhoneNumberActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            context.startActivity(intent)
        }

        fun getChatroomReference(chatroomId: String?): DocumentReference {
            return FirebaseFirestore.getInstance().collection("chatrooms").document(chatroomId!!)
        }

        fun getOtherUserFromChatroom(userIds: List<String?>): DocumentReference {
            return if (userIds[0] == currentUid) {
                allUserCollectionReference().document(userIds[1] ?: "")
            } else {
                allUserCollectionReference().document(userIds[0] ?: "")
            }
        }

        @SuppressLint("SimpleDateFormat")
        fun timestampToString(timestamp: Timestamp): String {
            return SimpleDateFormat("HH:mm").format(timestamp.toDate())
        }

        fun allChatroomCollectionReference(): CollectionReference {
            return FirebaseFirestore.getInstance().collection("chatrooms")
        }

        fun getChatroomMessageReference(chatroomId: String?): CollectionReference {
            return getChatroomReference(chatroomId).collection("chats")
        }

        fun getChatroomId(userId1: String, userId2: String): String {
            return if (userId1.hashCode() < userId2.hashCode()) {
                userId1 + "_" + userId2
            } else {
                userId2 + "_" + userId1
            }
        }

        fun isLoggedIn(): Boolean {
            return currentUid != null
        }
    }
}
