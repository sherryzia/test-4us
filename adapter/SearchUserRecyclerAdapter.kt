package com.example.chatappfirebase.adapter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.chatappfirebase.ChatActivity
import com.example.chatappfirebase.R
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.AndroidUtils
import com.example.chatappfirebase.utils.FirebaseUtils
import com.firebase.ui.firestore.FirestoreRecyclerAdapter
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import kotlinx.coroutines.delay

class SearchUserRecyclerAdapter(
    options: FirestoreRecyclerOptions<UserModel>,
    private val context: Context
) : FirestoreRecyclerAdapter<UserModel, SearchUserRecyclerAdapter.UserModelViewHolder>(options) {

    override fun onBindViewHolder(holder: UserModelViewHolder, position: Int, model: UserModel) {
        holder.usernameText.text = model.name
        holder.phoneText.text = model.phone

        // Add "(Me)" to the username if it's the current user
        if (model.userId == FirebaseUtils.currentUid) {
            val uName = model.name.split(" ").joinToString(" ") { it.capitalize() }
            holder.usernameText.text = "$uName (Me)"
        }
        FirebaseUtils.getOtherProfilePicStorageRef(model.userId).getDownloadUrl()
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val uri: Uri = task.result
                    AndroidUtils.setProfilePic(context, uri, holder.profilePic)
                }
            }

        // Load profile picture if available
//        FirebaseUtils.getOtherProfilePicStorageRef(model.userId).downloadUrl
//            .addOnCompleteListener { task ->
//                if (task.isSuccessful) {
//                    val uri: Uri? = task.result
//                    if (uri != null) {
//                        AndroidUtils.setProfilePic(context, uri, holder.profilePic)
//                    }
//                }
//            }

        holder.itemView.setOnClickListener {
            // Navigate to ChatActivity
            val intent = Intent(context, ChatActivity::class.java).apply {
                AndroidUtils.passUserModelAsIntent(this, model)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

            context.startActivity(intent)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UserModelViewHolder {
        val view =
            LayoutInflater.from(context).inflate(R.layout.search_user_recycler_row, parent, false)
        return UserModelViewHolder(view)
    }

    inner class UserModelViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val usernameText: TextView = itemView.findViewById(R.id.user_name_text)
        val phoneText: TextView = itemView.findViewById(R.id.phone_text)
        val profilePic: ImageView = itemView.findViewById(R.id.profile_pic_image_view)
    }
}
