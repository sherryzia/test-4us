package com.example.chatappfirebase

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.AndroidUtils
import com.example.chatappfirebase.utils.FirebaseUtils
import com.google.firebase.Timestamp
import com.google.firebase.firestore.FirebaseFirestore

@SuppressLint("CustomSplashScreen")
class SplashActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        // Log intent extras to verify userId is received
        Log.d("SplashActivity", "Intent extras: ${intent.extras}")

        // Check if the activity was started from a notification
        val userId = intent.getStringExtra("userId")
        if (userId != null) {
            Log.d("SplashActivity", "Received userId: $userId")
            getUserDetails(userId)
        } else {
            navigateToMainOrLogin()
        }
    }

    private fun getUserDetails(userId: String) {
        FirebaseUtils.collectionUserDetails
            .whereEqualTo("userId", userId)
            .limit(1)
            .get()
            .addOnSuccessListener { querySnapshot ->
                if (!querySnapshot.isEmpty) {
                    // Fetch the first document that matches the query
                    val userDocument = querySnapshot.documents[0]

                    // Extract phone from the document
                    val uid = userDocument.getString("phone").toString()
                    Log.d("fetchUserDetails", "phone $uid ")

                    // Get user details using the phone number
                    FirebaseUtils.collectionUserDetails.document(uid).get()
                        .addOnSuccessListener { document ->
                            if (document.exists()) {
                                // Create UserModel with fetched data
                                val otherUserModel = UserModel(
                                    name = document.getString("name") ?: "",
                                    phone = document.getString("phone") ?: "",
                                    createdTimestamp = document.getTimestamp("createdTimestamp") ?: Timestamp.now(),
                                    userId = userId,
                                    fcmToken = document.getString("fcmToken") ?: ""
                                )

                                // Open ChatActivity and pass user data
                                val chatIntent = Intent(this, ChatActivity::class.java).apply {
                                    AndroidUtils.passUserModelAsIntent(this, otherUserModel)
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                                }
                                startActivity(chatIntent)
                                finish()
                            } else {
                                Log.e("SplashActivity", "User document with ID $userId does not exist.")
                                navigateToMainOrLogin()
                            }
                        }
                        .addOnFailureListener { exception ->
                            Log.e("SplashActivity", "Failed to fetch user details", exception)
                            navigateToMainOrLogin()
                        }
                } else {
                    Log.e("SplashActivity", "No user found for ID $userId.")
                    navigateToMainOrLogin()
                }
            }
            .addOnFailureListener { exception ->
                Log.e("fetchUserDetails", "Failed to fetch user details", exception)
                navigateToMainOrLogin()
            }
    }

    private fun navigateToMainOrLogin() {
        val intent = if (FirebaseUtils.isLoggedIn() && FirebaseUtils.currentUid!!.isNotEmpty()) {
            Intent(this, MainActivity::class.java)
        } else {
            Intent(this, LoginPhoneNumberActivity::class.java)
        }
        startActivity(intent)
        finish()
    }
}
