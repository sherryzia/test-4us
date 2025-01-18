//package com.example.chatappfirebase
//
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.content.Context
//import android.net.Uri
//import android.os.Bundle
//import android.util.Log
//import android.widget.EditText
//import android.widget.ImageButton
//import android.widget.ImageView
//import android.widget.TextView
//import androidx.appcompat.app.AppCompatActivity
//import androidx.core.app.NotificationCompat
//import androidx.core.app.NotificationManagerCompat
//import androidx.recyclerview.widget.LinearLayoutManager
//import androidx.recyclerview.widget.RecyclerView
//import com.example.chatappfirebase.adapter.ChatRecyclerAdapter
//import com.example.chatappfirebase.databinding.ActivityChatBinding
//import com.example.chatappfirebase.model.ChatMessageModel
//import com.example.chatappfirebase.model.ChatroomModel
//import com.example.chatappfirebase.model.UserModel
//import com.example.chatappfirebase.utils.AndroidUtils
//import com.example.chatappfirebase.utils.FirebaseUtils
//import com.example.chatappfirebase.utils.FirebaseUtils.Companion.currentUid
//import com.example.chatappfirebase.utils.FirebaseUtils.Companion.currentUserDetails
//import com.firebase.ui.firestore.FirestoreRecyclerOptions
//import com.google.firebase.Timestamp
//import com.google.firebase.firestore.Query
//import org.json.JSONObject
//import java.io.IOException
//
//import okhttp3.Call;
//import okhttp3.Callback;
//import okhttp3.MediaType;
//import okhttp3.MediaType.Companion.toMediaTypeOrNull
//import okhttp3.OkHttpClient;
//import okhttp3.Request;
//import okhttp3.RequestBody;
//import okhttp3.RequestBody.Companion.toRequestBody
//import okhttp3.Response;
//
//class ChatActivity : AppCompatActivity() {
//    private lateinit var binding: ActivityChatBinding
//    private lateinit var textMessage: String
//    private lateinit var otherUsername: TextView
//    private lateinit var messageButton: ImageButton
//    private lateinit var recyclerView: RecyclerView
//    private lateinit var backButton: ImageButton
//    private lateinit var chatroomId: String
//    private lateinit var messageInput: EditText
//    private lateinit var imageView: ImageView
//    private var chatroomModel: ChatroomModel? = null
//    private lateinit var otherUserModel: UserModel
//    private lateinit var adapter: ChatRecyclerAdapter
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        binding = ActivityChatBinding.inflate(layoutInflater)
//        setContentView(binding.root)
//
//        otherUsername = binding.otherUsername
//        messageButton = binding.messageSendBtn
//        backButton = binding.backBtn
//        recyclerView = binding.chatRecyclerView
//        messageInput = binding.chatMessageInput
//        imageView = findViewById(R.id.profile_pic_image_view)
//
//        // Retrieve the username and user model
//        val uName1 = intent.getStringExtra("username")
//        val uName = uName1?.split(" ")?.joinToString(" ") { it.capitalize() }
//
//
//
//
//        otherUsername.text = uName
//
//        otherUserModel = AndroidUtils.getUserModelFromIntent(intent)
//
//        chatroomId = FirebaseUtils.getChatroomId(currentUid!!, otherUserModel.userId)
//
//
//        FirebaseUtils.getOtherProfilePicStorageRef(otherUserModel.userId).getDownloadUrl()
//            .addOnCompleteListener { task ->
//                if (task.isSuccessful) {
//                    val uri: Uri = task.result
//                    AndroidUtils.setProfilePic(this, uri, imageView)
//                }
//            }
//
//        backButton.setOnClickListener {
//            onBackPressedDispatcher.onBackPressed()
//        }
//
//        messageButton.setOnClickListener {
//            textMessage = binding.chatMessageInput.text.toString().trim()
//
//            if (textMessage.isEmpty()) {
//                return@setOnClickListener
//            } else {
//                sendMessageToUser(textMessage)
//            }
//        }
//        getOrCreateChatroomModel()
//        setupChatRecyclerView()
//    }
//
//    private fun setupChatRecyclerView() {
//        val query: Query = FirebaseUtils.getChatroomMessageReference(chatroomId)
//            .orderBy("timestamp", Query.Direction.DESCENDING)
//
//        val options = FirestoreRecyclerOptions.Builder<ChatMessageModel>()
//            .setQuery(query, ChatMessageModel::class.java)
//            .build()
//
//        adapter = ChatRecyclerAdapter(options, this)
//
//        val manager = LinearLayoutManager(this)
//        manager.reverseLayout = true
//        recyclerView.layoutManager = manager
//
//        recyclerView.adapter = adapter
//        adapter.startListening()
//        adapter.registerAdapterDataObserver(object : RecyclerView.AdapterDataObserver() {
//            override fun onItemRangeInserted(positionStart: Int, itemCount: Int) {
//                super.onItemRangeInserted(positionStart, itemCount)
//                recyclerView.smoothScrollToPosition(0)
//            }
//        })
//        // Debugging: Check if the query returns any results
//        query.get().addOnSuccessListener { documents ->
//            if (documents.isEmpty) {
//                Log.d("SearchActivity", "No results found.")
//            } else {
//                for (document in documents) {
//                    Log.d("SearchActivity", "Found document: ${document.id} => ${document.data}")
//                }
//            }
//        }.addOnFailureListener { exception ->
//            Log.w("SearchActivity", "Error getting documents: ", exception)
//        }
//
//    }
//
//    private fun sendMessageToUser(textMessage: String) {
//
//        chatroomModel?.lastMessageTimestamp = Timestamp.now()
//        chatroomModel?.lastMessageSenderId = currentUid!!
//        chatroomModel?.lastMessage = textMessage
//        chatroomModel?.lastMessageSendToName = otherUserModel.name
//        FirebaseUtils.getChatroomReference(chatroomId).set(chatroomModel!!)
//
//        var chatMessageModel: ChatMessageModel =
//            ChatMessageModel(textMessage, currentUid!!, Timestamp.now())
//        FirebaseUtils.getChatroomMessageReference(chatroomId).add(chatMessageModel)
//            .addOnCompleteListener { task ->
//                if (task.isSuccessful) {
//                    messageInput.setText("")
//                    sendNotification(textMessage)
//                    AndroidUtils.showToast(this, "Message sent successfully!")
//                } else {
//                    AndroidUtils.showToast(
//                        this,
//                        "Failed to send message: ${task.exception?.message}"
//                    )
//                }
//            }
//    }
//
//    private fun getOrCreateChatroomModel() {
//        FirebaseUtils.getChatroomReference(chatroomId).get().addOnCompleteListener { task ->
//            if (task.isSuccessful) {
//                val document = task.result
//                if (document != null && document.exists()) {
//                    chatroomModel = document.toObject(ChatroomModel::class.java)
//                } else {
//                    // First-time chat, create a new chatroom model
//                    chatroomModel = ChatroomModel(
//                        chatroomId,
//                        listOf(currentUid, otherUserModel.userId),
//                        Timestamp.now(),
//                        "",
//                        "",
//                        ""
//                    )
//                    FirebaseUtils.getChatroomReference(chatroomId).set(chatroomModel!!)
//                        .addOnSuccessListener {
//                            AndroidUtils.showToast(this, "Chatroom created successfully!")
//                        }
//                        .addOnFailureListener { e ->
//                            AndroidUtils.showToast(this, "Failed to create chatroom: ${e.message}")
//                        }
//                }
//            } else {
//                AndroidUtils.showToast(this, "Failed to get chatroom: ${task.exception?.message}")
//            }
//        }
//    }
//
//    fun sendNotification(message: String?) {
//        Log.d("otherUserID", "sendNotification: ${otherUserModel.fcmToken}")
//        currentUserDetails { userRef ->
//            userRef?.get()?.addOnCompleteListener { task ->
//                if (task.isSuccessful) {
//                    val currentUser = task.result.toObject(UserModel::class.java)
//                    Log.d("sendcheck", "sendNotification: ${currentUser?.name}, ${currentUser?.userId}, ${currentUser?.fcmToken} ")
//                    currentUser?.let {
//                        createNotification(message, currentUser.name)
//
//                        try {
//                            // Construct the JSON payload for the FCM API
//                            val jsonObject = JSONObject()
//                            val messageObject = JSONObject()
//                            val notificationObject = JSONObject()
//                            val dataObject = JSONObject()
//
//                            // Populate notification content
//                            notificationObject.put("title", currentUser.name)
//                            notificationObject.put("body", message)
//
//                            // Populate data content
//                            dataObject.put("userId", currentUser.userId)
//
//                            // Add notification and data objects to the message object
//                            messageObject.put("notification", notificationObject)
//                            messageObject.put("data", dataObject)
//                            messageObject.put("token", otherUserModel.fcmToken)
//
//                            // Add message object to the root JSON
//                            jsonObject.put("message", messageObject)
//
//                            // Send the request to FCM
//                            callApi(jsonObject)
//                        } catch (e: Exception) {
//                            e.printStackTrace()
//                        }
//                    }
//                } else {
//                    Log.e("sendNotification", "Failed to fetch current user details.")
//                }
//            }?.addOnFailureListener { exception ->
//                Log.e("sendNotification", "Error retrieving user data", exception)
//            }
//        }
//    }
//
//    private fun createNotification(message: String?, username: String) {
//        val channelId = "chat_notifications"
//        val notificationId = 1
//
//        // Create the NotificationChannel (required for Android O and above)
//        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//            val channelName = "Chat Notifications"
//            val channelDescription = "Notifications for new chat messages"
//            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH).apply {
//                description = channelDescription
//            }
//            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            notificationManager.createNotificationChannel(channel)
//        }
//
//        // Build the notification
//        val builder = NotificationCompat.Builder(this, channelId)
//            .setSmallIcon(R.drawable.person_icon) // Replace with your notification icon
//            .setContentTitle(username)
//            .setContentText(message)
//            .setPriority(NotificationCompat.PRIORITY_HIGH)
//            .setAutoCancel(true)
//
//        // Show the notification
//        with(NotificationManagerCompat.from(this)) {
//            notify(notificationId, builder.build())
//        }
//    }
//
//
//    fun callApi(jsonObject: JSONObject) {
//        val JSON: MediaType = "application/json; charset=utf-8".toMediaTypeOrNull() ?: return
//        val client = OkHttpClient()
//        val url = "https://fcm.googleapis.com/v1/projects/chatappfirebase-3ebb8/messages:send"
//        val body: RequestBody = jsonObject.toString().toRequestBody(JSON)
//
//        val request: Request = Request.Builder()
//            .url(url)
//            .post(body)
//            .addHeader(
//                "Authorization",
//                "Bearer ya29.a0AeDClZBsdDhjv-qj-U2TkOGhgpisdBNq_YJ94E8MUuryFC6HN9eLXIQLUsb1J25hFc47psY4z3a9ffRZ97_Q-TGx0AfSuhOxsrDRJwBhRcpo-tR2UZZpB1m2nN-dCNOPpegvyTOBKSSXTcdlOc1YwAqobEWGn75Hu6ncIraEaCgYKAZISARMSFQHGX2Mixq8VXxDHWDkOktkYQ6tzew0175" // Replace with your Firebase project’s server key
//            )
//            .addHeader("Content-Type", "application/json")
//            .build()
//
//        client.newCall(request).enqueue(object : Callback {
//            override fun onFailure(call: Call, e: IOException) {
//                e.printStackTrace()
//            }
//
//            override fun onResponse(call: Call, response: Response) {
//                if (response.isSuccessful) {
//                    Log.d("FCM", "Notification sent successfully: ${response.body?.string()}")
//                } else {
//                    Log.e("FCM", "Error sending notification: ${response.body?.string()}")
//                }
//            }
//        })
//    }
//
//
//}
