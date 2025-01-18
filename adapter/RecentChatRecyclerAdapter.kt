package com.example.chatappfirebase.adapter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.chatappfirebase.ChatActivity
import com.example.chatappfirebase.R
import com.example.chatappfirebase.model.ChatroomModel
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.AndroidUtils
import com.example.chatappfirebase.utils.FirebaseUtils
import com.firebase.ui.firestore.FirestoreRecyclerAdapter
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.firebase.Timestamp


class RecentChatRecyclerAdapter(
    options: FirestoreRecyclerOptions<ChatroomModel?>?,
    context: Context
) :
    FirestoreRecyclerAdapter<ChatroomModel, RecentChatRecyclerAdapter.ChatroomModelViewHolder>(
        options!!
    ) {
    var context: Context = context

    override fun onBindViewHolder(
        holder: ChatroomModelViewHolder,
        position: Int,
        model: ChatroomModel
    ) {
        // Fetch other user from chatroom
        FirebaseUtils.getOtherUserFromChatroom(model.userIds)
            .get()
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val documentSnapshot = task.result
                    if (documentSnapshot != null) {
                        val otherUserId = documentSnapshot.id

                        // Fetch user details from Firebase 'users' collection
                        FirebaseUtils.collectionUserDetails
                            .whereEqualTo("userId", otherUserId)
                            .limit(1)
                            .get()
                            .addOnSuccessListener { querySnapshot ->
                                if (!querySnapshot.isEmpty) {
                                    // Fetch the first document that matches the query
                                    val userDocument = querySnapshot.documents[0]

                                    // Create a UserModel instance with fetched data
                                    val otherUserModel = UserModel(
                                        name = userDocument.getString("name") ?: "",
                                        phone = userDocument.getString("phone") ?: "",
                                        createdTimestamp = userDocument.getTimestamp("createdTimestamp")
                                            ?: Timestamp.now(),
                                        userId = otherUserId,
                                        fcmToken = userDocument.getString("fcmToken") ?: ""
                                    )
                                    FirebaseUtils.getOtherProfilePicStorageRef(otherUserId).getDownloadUrl()
                                        .addOnCompleteListener { task ->
                                            if (task.isSuccessful) {
                                                val uri: Uri = task.result
                                                AndroidUtils.setProfilePic(context, uri, holder.profilePic)
                                            }
                                        }
                                    // Set username and last message for the chat
                                    holder.usernameText.text = otherUserModel.name
                                    val lastMessageSentByMe =
                                        model.lastMessageSenderId == FirebaseUtils.currentUid
                                    holder.lastMessageText.text = if (lastMessageSentByMe) {
                                        "You: ${model.lastMessage}"
                                    } else {
                                        model.lastMessage
                                    }
                                    holder.lastMessageTime.text =
                                        FirebaseUtils.timestampToString(model.lastMessageTimestamp)

                                    // Set click listener to start ChatActivity
                                    holder.itemView.setOnClickListener {
                                        Log.d(
                                            "QueryResult",
                                            "${otherUserModel.name} , ${otherUserModel.phone} , ${otherUserModel.userId} , ${otherUserModel.fcmToken} , ${otherUserModel.createdTimestamp}"
                                        )
                                        val intent = Intent(context, ChatActivity::class.java).apply {
                                            // Pass user model to the intent
                                            AndroidUtils.passUserModelAsIntent(this, otherUserModel)
                                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                        }
                                        context.startActivity(intent)
                                    }
                                } else {
                                    Log.e(
                                        "fetchUserDetails",
                                        "User document with userId $otherUserId does not exist"
                                    )
                                }
                            }
                            .addOnFailureListener { exception ->
                                Log.e("fetchUserDetails", "Failed to fetch user details", exception)
                            }

                    }
                } else {
                    Log.e(
                        "onBindViewHolder",
                        "Failed to fetch other user from chatroom",
                        task.exception
                    )
                }
            }
    }


    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): ChatroomModelViewHolder {
        val view: View =
            LayoutInflater.from(context).inflate(R.layout.recent_chat_recycler_row, parent, false)
        return ChatroomModelViewHolder(view)
    }

    inner class ChatroomModelViewHolder(itemView: View) :
        RecyclerView.ViewHolder(itemView) {
        var usernameText: TextView = itemView.findViewById(R.id.user_name_text)
        var lastMessageText: TextView = itemView.findViewById(R.id.last_message_text)
        var lastMessageTime: TextView = itemView.findViewById(R.id.last_message_time_text)
        var profilePic: ImageView = itemView.findViewById(R.id.profile_pic_image_view)
    }
}