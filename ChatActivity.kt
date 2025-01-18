package com.example.chatappfirebase

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.EditText
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.chatappfirebase.adapter.ChatRecyclerAdapter
import com.example.chatappfirebase.databinding.ActivityChatBinding
import com.example.chatappfirebase.model.ChatMessageModel
import com.example.chatappfirebase.model.ChatroomModel
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.AccessToken
import com.example.chatappfirebase.utils.AndroidUtils
import com.example.chatappfirebase.utils.FirebaseUtils
import com.example.chatappfirebase.utils.FirebaseUtils.Companion.currentUid
import com.example.chatappfirebase.utils.FirebaseUtils.Companion.currentUserDetails
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.android.material.snackbar.Snackbar
import com.google.android.material.textfield.TextInputLayout
import com.google.firebase.Timestamp
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import com.tencent.mmkv.MMKV
import com.zegocloud.uikit.plugin.invitation.ZegoInvitationType
import com.zegocloud.uikit.prebuilt.call.ZegoUIKitPrebuiltCallConfig
import com.zegocloud.uikit.prebuilt.call.ZegoUIKitPrebuiltCallService
import com.zegocloud.uikit.prebuilt.call.core.invite.ZegoCallInvitationData
import com.zegocloud.uikit.prebuilt.call.event.CallEndListener
import com.zegocloud.uikit.prebuilt.call.event.ErrorEventsListener
import com.zegocloud.uikit.prebuilt.call.event.SignalPluginConnectListener
import com.zegocloud.uikit.prebuilt.call.invite.ZegoUIKitPrebuiltCallInvitationConfig
import com.zegocloud.uikit.prebuilt.call.invite.internal.ZegoUIKitPrebuiltCallConfigProvider
import com.zegocloud.uikit.prebuilt.call.invite.widget.ZegoSendCallInvitationButton
import com.zegocloud.uikit.service.defines.ZegoUIKitUser
import com.zegocloud.uikit.service.express.IExpressEngineEventHandler
import im.zego.zegoexpress.constants.ZegoRoomStateChangedReason
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.IOException

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response;
import timber.log.Timber

class ChatActivity : AppCompatActivity() {
    private lateinit var binding: ActivityChatBinding
    private lateinit var textMessage: String
    private lateinit var otherUsername: TextView
    private lateinit var messageButton: ImageButton
    private lateinit var recyclerView: RecyclerView
    private lateinit var backButton: ImageButton
    private lateinit var chatroomId: String
    private lateinit var messageInput: EditText
    private lateinit var imageView: ImageView
    private var chatroomModel: ChatroomModel? = null
    private lateinit var otherUserModel: UserModel
    private lateinit var adapter: ChatRecyclerAdapter
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityChatBinding.inflate(layoutInflater)
        setContentView(binding.root)

        otherUsername = binding.otherUsername
        messageButton = binding.messageSendBtn
        backButton = binding.backBtn
        recyclerView = binding.chatRecyclerView
        messageInput = binding.chatMessageInput
        imageView = findViewById(R.id.profile_pic_image_view)

        // Retrieve the username and user model
        val uName1 = intent.getStringExtra("username")
        val uName = uName1?.split(" ")?.joinToString(" ") { it.capitalize() }




        otherUsername.text = uName

        otherUserModel = AndroidUtils.getUserModelFromIntent(intent)

        chatroomId = FirebaseUtils.getChatroomId(currentUid!!, otherUserModel.userId)


        val userID: String = currentUid!!
        val userName: String = uName!!
        val appID: Long = 248606129
        val appSign: String = "bef934276d4d67c1e79e484d83b96ba772a73356937622c20bacaae70bbfb3d2"

        initCallInviteService(appID, appSign, userID, userName)

        initVoiceButton()

        initVideoButton()


        FirebaseUtils.getOtherProfilePicStorageRef(otherUserModel.userId).getDownloadUrl()
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val uri: Uri = task.result
                    AndroidUtils.setProfilePic(this, uri, imageView)
                }
            }

        backButton.setOnClickListener {
            onBackPressedDispatcher.onBackPressed()
        }

        messageButton.setOnClickListener {
            textMessage = binding.chatMessageInput.text.toString().trim()

            if (textMessage.isEmpty()) {
                return@setOnClickListener
            } else {
                sendMessageToUser(textMessage)
            }
        }
        getOrCreateChatroomModel()
        setupChatRecyclerView()
    }

    private fun setupChatRecyclerView() {
        val query: Query = FirebaseUtils.getChatroomMessageReference(chatroomId)
            .orderBy("timestamp", Query.Direction.DESCENDING)

        val options = FirestoreRecyclerOptions.Builder<ChatMessageModel>()
            .setQuery(query, ChatMessageModel::class.java)
            .build()

        adapter = ChatRecyclerAdapter(options, this)

        val manager = LinearLayoutManager(this)
        manager.reverseLayout = true
        recyclerView.layoutManager = manager
        recyclerView.adapter = adapter

        adapter.startListening()
        adapter.registerAdapterDataObserver(object : RecyclerView.AdapterDataObserver() {
            override fun onItemRangeInserted(positionStart: Int, itemCount: Int) {
                super.onItemRangeInserted(positionStart, itemCount)
                recyclerView.smoothScrollToPosition(0)
            }
        })

        // Set up swipe-to-delete functionality
        val itemTouchHelper = ItemTouchHelper(object : ItemTouchHelper.SimpleCallback(0, ItemTouchHelper.LEFT) {
            override fun onMove(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder, target: RecyclerView.ViewHolder): Boolean {
                return false
            }
            override fun onChildDraw(
                c: Canvas,
                recyclerView: RecyclerView,
                viewHolder: RecyclerView.ViewHolder,
                dX: Float,
                dY: Float,
                actionState: Int,
                isCurrentlyActive: Boolean
            ) {
                if (actionState == ItemTouchHelper.ACTION_STATE_SWIPE) {
                    val itemView = viewHolder.itemView
                    val icon = ContextCompat.getDrawable(
                        recyclerView.context,
                        R.drawable.baseline_delete_24
                    )  // your delete icon
                    val iconMargin = (itemView.height - icon!!.intrinsicHeight) / 2

                    // Draw the background
                    val background = ColorDrawable(Color.RED)
                    background.setBounds(
                        itemView.right + dX.toInt(),  // extend background only as far as swiped distance
                        itemView.top,
                        itemView.right,
                        itemView.bottom
                    )
                    background.draw(c)

                    // Calculate icon position
                    val iconTop = itemView.top + iconMargin
                    val iconBottom = iconTop + icon.intrinsicHeight
                    val iconLeft = itemView.right - iconMargin - icon.intrinsicWidth
                    val iconRight = itemView.right - iconMargin

                    // Draw the icon
                    icon.setBounds(iconLeft, iconTop, iconRight, iconBottom)
                    icon.draw(c)
                }

                super.onChildDraw(
                    c,
                    recyclerView,
                    viewHolder,
                    dX,
                    dY,
                    actionState,
                    isCurrentlyActive
                )
            }
            override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {
                val position = viewHolder.adapterPosition
                val message = adapter.getItem(position)

                if (message.senderId == FirebaseUtils.currentUid) {
                    // Delete the message from Firebase
                    adapter.deleteItem(position)

                    // Show Snackbar with undo option
                    Snackbar.make(recyclerView, "Message deleted", Snackbar.LENGTH_LONG)
                        .setAction("Undo") {
                            FirebaseUtils.getChatroomMessageReference(chatroomId).add(message)
                        }
                        .addCallback(object : Snackbar.Callback() {
                            override fun onDismissed(transientBottomBar: Snackbar?, event: Int) {
                                if (event != Snackbar.Callback.DISMISS_EVENT_ACTION) {
                                    FirebaseUtils.getChatroomMessageReference(chatroomId)
                                        .orderBy("timestamp", Query.Direction.DESCENDING)
                                        .limit(1)
                                        .get()
                                        .addOnSuccessListener { querySnapshot ->
                                            if (!querySnapshot.isEmpty) {
                                                val newLastMessage = querySnapshot.documents[0].getString("message")
                                                updateLastMessageInChatroom(newLastMessage, chatroomId)
                                            } else {
                                                updateLastMessageInChatroom(null, chatroomId)
                                            }
                                        }
                                        .addOnFailureListener { exception ->
                                            Log.e("ChatRoom", "Error getting last message: ", exception)
                                        }
                                }
                            }
                        })
                        .show()
                } else {
                    Snackbar.make(recyclerView, "You cannot delete this message", Snackbar.LENGTH_SHORT).show()
                    adapter.notifyItemChanged(position)
                }
            }

            private fun updateLastMessageInChatroom(lastMessage: String?, chatroomId: String?) {
                FirebaseFirestore.getInstance().collection("chatrooms")
                    .whereEqualTo("chatroomId", chatroomId!!)
                    .limit(1)
                    .get()
                    .addOnSuccessListener { querySnapshot ->
                        if (!querySnapshot.isEmpty) {
                            val chatroomDocument = querySnapshot.documents[0]
                            chatroomDocument.reference.update("lastMessage", lastMessage)
                        }
                    }
                    .addOnFailureListener { exception ->
                        Log.e("ChatRoom", "Failed to update last message: ", exception)
                    }
            }
        })
        itemTouchHelper.attachToRecyclerView(recyclerView)
    }



    private fun sendMessageToUser(textMessage: String) {

        chatroomModel?.lastMessageTimestamp = Timestamp.now()
        chatroomModel?.lastMessageSenderId = currentUid!!
        chatroomModel?.lastMessage = textMessage
        chatroomModel?.lastMessageSendToName = otherUserModel.name
        FirebaseUtils.getChatroomReference(chatroomId).set(chatroomModel!!)

        var chatMessageModel: ChatMessageModel =
            ChatMessageModel(textMessage, currentUid!!, Timestamp.now())
        FirebaseUtils.getChatroomMessageReference(chatroomId).add(chatMessageModel)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    messageInput.setText("")
                    sendNotification(textMessage)
                    AndroidUtils.showToast(this, "Message sent successfully!")
                } else {
                    AndroidUtils.showToast(
                        this,
                        "Failed to send message: ${task.exception?.message}"
                    )
                }
            }
    }

    private fun getOrCreateChatroomModel() {
        FirebaseUtils.getChatroomReference(chatroomId).get().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val document = task.result
                if (document != null && document.exists()) {
                    chatroomModel = document.toObject(ChatroomModel::class.java)
                } else {
                    // First-time chat, create a new chatroom model
                    chatroomModel = ChatroomModel(
                        chatroomId,
                        listOf(currentUid, otherUserModel.userId),
                        Timestamp.now(),
                        "",
                        "",
                        ""
                    )
                    FirebaseUtils.getChatroomReference(chatroomId).set(chatroomModel!!)
                        .addOnSuccessListener {
                            AndroidUtils.showToast(this, "Chatroom created successfully!")
                        }
                        .addOnFailureListener { e ->
                            AndroidUtils.showToast(this, "Failed to create chatroom: ${e.message}")
                        }
                }
            } else {
                AndroidUtils.showToast(this, "Failed to get chatroom: ${task.exception?.message}")
            }
        }
    }

    fun sendNotification(message: String?) {
        Log.d("otherUserID", "sendNotification: ${otherUserModel.fcmToken}")
        currentUserDetails { userRef ->
            userRef?.get()?.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val currentUser = task.result.toObject(UserModel::class.java)
                    Log.d("sendcheck", "sendNotification: ${currentUser?.name}, ${currentUser?.userId}, ${currentUser?.fcmToken} ")
                    currentUser?.let {
                        try {
                            // Construct the JSON payload for the FCM API
                            val jsonObject = JSONObject()
                            val messageObject = JSONObject()
                            val notificationObject = JSONObject()
                            val dataObject = JSONObject()

                            // Populate notification content
                            notificationObject.put("title", currentUser.name)
                            notificationObject.put("body", message)

                            // Populate data content
                            dataObject.put("userId", currentUser.userId)

                            // Add notification and data objects to the message object
                            messageObject.put("notification", notificationObject)
                            messageObject.put("data", dataObject)
                            messageObject.put("token", otherUserModel.fcmToken)

                            // Add message object to the root JSON
                            jsonObject.put("message", messageObject)

                            // Send the request to FCM
                            callApi(jsonObject)
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                } else {
                    Log.e("sendNotification", "Failed to fetch current user details.")
                }
            }?.addOnFailureListener { exception ->
                Log.e("sendNotification", "Error retrieving user data", exception)
            }
        }
    }

    fun callApi(jsonObject: JSONObject) {
        val JSON: MediaType = "application/json; charset=utf-8".toMediaTypeOrNull() ?: return
        val client = OkHttpClient()
        val url = "https://fcm.googleapis.com/v1/projects/chatappfirebase-3ebb8/messages:send"
        val body: RequestBody = jsonObject.toString().toRequestBody(JSON)

        // Launch a coroutine to handle asynchronous token retrieval
        lifecycleScope.launch(Dispatchers.IO) {
            val accessToken = AccessToken()
            val oauthtoken = accessToken.accessToken

            Log.d("xyz", "Retrieved OAuth token: $oauthtoken")

            // Create the request with the token in the header
            val request: Request = Request.Builder()
                .url(url)
                .post(body)
                .addHeader("Authorization", "Bearer $oauthtoken")
                .addHeader("Content-Type", "application/json")
                .build()

            client.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    e.printStackTrace()
                }

                override fun onResponse(call: Call, response: Response) {
                    if (response.isSuccessful) {
                        Log.d("FCM", "Notification sent successfully: ${response.body?.string()}")
                    } else {
                        Log.e("FCM", "Error sending notification: ${response.body?.string()}")
                    }
                }
            })
        }
    }

    private fun initVideoButton() {
        val newVideoCall = findViewById<ZegoSendCallInvitationButton>(R.id.new_video_call)
        newVideoCall.setIsVideoCall(true)

        //for notification sound
        newVideoCall.resourceID = "zego_data"


        newVideoCall.setOnClickListener { view ->
            val targetUserID = otherUserModel.userId
            val split = targetUserID.split(",")
            val users = ArrayList<ZegoUIKitUser>()
            for (userID in split) {
                println("userID=$userID")
                val userName = "User_${userID}"
                users.add(ZegoUIKitUser(userID, userName))
            }
            newVideoCall.setInvitees(users)
        }

    }

    private fun initVoiceButton() {
        val newVoiceCall = findViewById<ZegoSendCallInvitationButton>(R.id.new_voice_call)
        newVoiceCall.setIsVideoCall(false)

        newVoiceCall.resourceID = "zego_data"

        val targetUserID = otherUserModel.userId
        val split = targetUserID.split(",")
        val users = ArrayList<ZegoUIKitUser>()
        for (userID in split) {
            println("userID=$userID")
            val userName = "User_${userID}"
            users.add(ZegoUIKitUser(userID, userName))
        }
        newVoiceCall.setInvitees(users)
    }

    private fun initCallInviteService(
        appID: Long,
        appSign: String,
        userID: String,
        userName: String
    ) {
        val callInvitationConfig = ZegoUIKitPrebuiltCallInvitationConfig().apply {
            provider =
                ZegoUIKitPrebuiltCallConfigProvider { invitationData -> getConfig(invitationData) }
        }

        ZegoUIKitPrebuiltCallService.events.errorEventsListener =
            ErrorEventsListener { errorCode, message -> Timber.d("onError() called with: errorCode = [$errorCode], message = [$message]") }

        ZegoUIKitPrebuiltCallService.events.invitationEvents.pluginConnectListener =
            SignalPluginConnectListener { state, event, extendedData -> Timber.d("onSignalPluginConnectionStateChanged() called with: state = [$state], event = [$event], extendedData = [$extendedData]") }

        ZegoUIKitPrebuiltCallService.init(
            application,
            appID,
            appSign,
            userID,
            userName,
            callInvitationConfig
        )

        ZegoUIKitPrebuiltCallService.events.callEvents.callEndListener =
            CallEndListener { callEndReason, jsonObject -> Timber.d("onCallEnd() called with: callEndReason = [$callEndReason], jsonObject = [$jsonObject]") }

        ZegoUIKitPrebuiltCallService.events.callEvents.setExpressEngineEventHandler(object :
            IExpressEngineEventHandler() {
            override fun onRoomStateChanged(
                roomID: String,
                reason: ZegoRoomStateChangedReason,
                errorCode: Int,
                extendedData: JSONObject
            ) {
                Timber.d("onRoomStateChanged() called with: roomID = [$roomID], reason = [$reason], errorCode = [$errorCode], extendedData = [$extendedData]")
            }
        })
    }

//    override fun onBackPressed() {
//        super.onBackPressed()
//        val builder = AlertDialog.Builder(this@ChatActivity)
//        builder.setTitle("Sign Out")
//        builder.setMessage("Are you sure to Sign Out?After Sign out you can't receive offline calls")
//        builder.setNegativeButton("cancel") { dialog, _ -> dialog.dismiss() }
//        builder.setPositiveButton("Ok") { dialog, _ ->
//            dialog.dismiss()
//            signOut()
//            finish()
//        }
//        builder.create().show()
//    }

    private fun getConfig(invitationData: ZegoCallInvitationData): ZegoUIKitPrebuiltCallConfig {
        val isVideoCall = invitationData.type == ZegoInvitationType.VIDEO_CALL.value
        val isGroupCall = invitationData.invitees.size > 1
        return when {
            isVideoCall && isGroupCall -> ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            !isVideoCall && isGroupCall -> ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            !isVideoCall -> ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
            else -> ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        ZegoUIKitPrebuiltCallService.endCall()
    }


}
