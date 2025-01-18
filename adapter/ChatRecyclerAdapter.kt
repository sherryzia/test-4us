package com.example.chatappfirebase.adapter

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.chatappfirebase.R
import com.example.chatappfirebase.model.ChatMessageModel
import com.example.chatappfirebase.utils.FirebaseUtils
import com.firebase.ui.firestore.FirestoreRecyclerAdapter
import com.firebase.ui.firestore.FirestoreRecyclerOptions


class ChatRecyclerAdapter(
     options: FirestoreRecyclerOptions<ChatMessageModel?>?,
    var context: Context
) :
    FirestoreRecyclerAdapter<ChatMessageModel, ChatRecyclerAdapter.ChatModelViewHolder>(options!!) {
    override fun onBindViewHolder(
         holder: ChatModelViewHolder,
        position: Int,
         model: ChatMessageModel
    ) {
        Log.i("haushd", "asjd")
        if (model.senderId == FirebaseUtils.currentUid) {
            holder.leftChatLayout.visibility = View.GONE
            holder.rightChatLayout.visibility = View.VISIBLE
            holder.rightChatTextview.text = model.message
        } else {
            holder.rightChatLayout.visibility = View.GONE
            holder.leftChatLayout.visibility = View.VISIBLE
            holder.leftChatTextview.text = model.message
        }
    }


    override fun onCreateViewHolder(
         parent: ViewGroup,
        viewType: Int
    ): ChatModelViewHolder {
        val view: View =
            LayoutInflater.from(context).inflate(R.layout.chat_message_recycler_row, parent, false)
        return ChatModelViewHolder(view)
    }
    fun deleteItem(position: Int) {
        snapshots.getSnapshot(position).reference.delete()
    }

    inner class ChatModelViewHolder( itemView: View) : RecyclerView.ViewHolder(itemView) {
        var leftChatLayout: LinearLayout =
            itemView.findViewById<LinearLayout>(R.id.left_chat_layout)
        var rightChatLayout: LinearLayout =
            itemView.findViewById<LinearLayout>(R.id.right_chat_layout)
        var leftChatTextview: TextView = itemView.findViewById<TextView>(R.id.left_chat_textview)
        var rightChatTextview: TextView = itemView.findViewById<TextView>(R.id.right_chat_textview)
    }
}
