package com.example.chatappfirebase.utils

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import com.example.chatappfirebase.R
import com.example.chatappfirebase.model.UserModel
import com.github.dhaval2404.imagepicker.ImagePicker
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.Timestamp
import com.google.firebase.messaging.FirebaseMessaging


class ProfileFragment : Fragment() {

    private lateinit var userName: EditText
    private lateinit var phoneNumber: EditText
    private lateinit var updateProfile: Button
    private lateinit var logoutText: TextView
    private var userModel: UserModel? = null
    private lateinit var progressBar: ProgressBar
    private lateinit var currentUserModel: UserModel
    private lateinit var profilePic: ImageView
    var imagePickLauncher: ActivityResultLauncher<Intent>? = null
    var selectedImageUri: Uri? = null

    var firebaseImageUrl =FirebaseUtils.getCurrentProfilePicStorageRef.downloadUrl.toString()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        imagePickLauncher = registerForActivityResult<Intent, ActivityResult>(
            ActivityResultContracts.StartActivityForResult()
        ) { result: ActivityResult ->
            if (result.resultCode == Activity.RESULT_OK) {
                val data = result.data
                if (data != null && data.data != null) {
                    selectedImageUri = data.data
                    AndroidUtils.setProfilePic(requireContext(), selectedImageUri, profilePic)
//                    AndroidUtil.setProfilePic(context, selectedImageUri, profilePic)
                }
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_profile, container, false)


        // Initialize views
        userName = view.findViewById(R.id.profile_username)
        phoneNumber = view.findViewById(R.id.profile_phone)
        updateProfile = view.findViewById(R.id.profle_update_btn)
        profilePic =view.findViewById(R.id.profile_image_view)
        logoutText = view.findViewById(R.id.logout_btn)
        progressBar = view.findViewById(R.id.profile_progress_bar)
        currentUserModel = UserModel()
        // Fetch user data
        getUserData()
        userName.hint = currentUserModel.name
        phoneNumber.hint = currentUserModel.phone



        progressBar.visibility = View.GONE
        // Setup the update button click listener
        updateProfile.setOnClickListener {
            handleProfileUpdate()
        }

        logoutText.setOnClickListener {
            FirebaseMessaging.getInstance().deleteToken().addOnCompleteListener(
                OnCompleteListener { task ->
                    if (!task.isSuccessful) {
                        Log.w("Logout", "Fetching FCM registration token failed", task.exception)
                        return@OnCompleteListener
                    }else{
                        Log.d("Logout", "Logout Triggered  ")
                        FirebaseUtils.logout(requireContext())
                    }
                })
        }
        profilePic.setOnClickListener {
            ImagePicker.with(this)
                .cropSquare()
                .compress(512)
                .maxResultSize(512, 512)
                .createIntent { intent ->
                    imagePickLauncher?.launch(intent)
                }
        }


        return view
    }

    private fun getUserData() {

        FirebaseUtils.getCurrentProfilePicStorageRef.getDownloadUrl()
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val uri: Uri = task.result
                    AndroidUtils.setProfilePic(context, uri, profilePic)
                }
            }
        FirebaseUtils.collectionUserDetails
            .whereEqualTo("userId", FirebaseUtils.currentUid)
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
                        userId = userDocument.getString("userId") ?: "",
                        fcmToken = userDocument.getString("fcmToken") ?: ""
                    )
                    userModel = otherUserModel
                    userName.setText(otherUserModel.name)
                    phoneNumber.setText(otherUserModel.phone)
                    currentUserModel = otherUserModel

                }
                Log.d(
                    "getUserData2",
                    "getUserData: ${userModel?.name}, ${userModel?.phone}, ${userModel?.userId}, ${userModel?.fcmToken}, ${userModel?.createdTimestamp} "
                )
            }

    }

    private fun handleProfileUpdate() {
        val name = userName.text.toString()
        val phone = phoneNumber.text.toString()

        if (name.isEmpty() || phone.isEmpty()) {
            AndroidUtils.showToast(requireContext(), "Please fill all the fields")
        } else {
            progressBar.visibility = View.VISIBLE
            userModel?.let {
                it.name = name
                it.phone = phone
                if(selectedImageUri!=null){
                    FirebaseUtils.getCurrentProfilePicStorageRef.putFile(selectedImageUri!!)
                }
                FirebaseUtils.collectionUserDetails.document(it.phone).set(it)
                    .addOnCompleteListener { task ->
                        if (task.isSuccessful) {
                            AndroidUtils.showToast(requireContext(), "Profile updated successfully")
                        } else {
                            AndroidUtils.showToast(requireContext(), "Profile update failed")
                        }
                        progressBar.visibility = View.GONE
                    }
            }
        }
    }
}
