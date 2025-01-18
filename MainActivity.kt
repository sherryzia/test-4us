package com.example.chatappfirebase

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.ImageButton
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.example.chatappfirebase.databinding.ActivityMainBinding
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.AccessToken
import com.example.chatappfirebase.utils.AndroidUtils
import com.example.chatappfirebase.utils.FirebaseUtils
import com.example.chatappfirebase.utils.FirebaseUtils.Companion.currentUid
import com.example.chatappfirebase.utils.ProfileFragment
import com.example.easychat.ChatFragment
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.firebase.Timestamp
import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var searchButton: ImageButton
    private lateinit var bottomNavigationView: BottomNavigationView
    private val manager = supportFragmentManager
    private val chatFragment = ChatFragment()
    private val profileFragment = ProfileFragment()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        getFcmToken()
        bottomNavigationView = binding.bottomNavigation
        searchButton = binding.mainSearchBtn

        searchButton.setOnClickListener {
            val intent = Intent(this, SearchActivity::class.java)
            startActivity(intent)
        }

        // Set up bottom navigation
        bottomNavigationView.setOnNavigationItemSelectedListener { menuItem ->
            when (menuItem.itemId) {
                R.id.menu_chat -> {
                    // Switch to ChatFragment
                    manager.beginTransaction().apply {
                        replace(R.id.main_frame_layout, chatFragment)
                        commit()
                    }
                    true
                }

                R.id.menu_profile -> {
                    // Switch to ProfileFragment
                    manager.beginTransaction().apply {
                        replace(R.id.main_frame_layout, profileFragment)
                        commit()
                    }
                    true
                }

                else -> false
            }
        }

        // Set default selection
        if (savedInstanceState == null) {
            bottomNavigationView.selectedItemId = R.id.menu_chat
        }
    }

    fun getFcmToken() {
//        initAuth2Reciever()
        var uid = ""

        FirebaseUtils.collectionUserDetails
            .whereEqualTo("userId", currentUid)
            .limit(1)
            .get()
            .addOnSuccessListener { querySnapshot ->
                if (!querySnapshot.isEmpty) {
                    // Fetch the first document that matches the query
                    val userDocument = querySnapshot.documents[0]

                    uid = userDocument.getString("phone").toString()
                }
                Log.d("fetchUserDetails", "phone $uid ")

                FirebaseMessaging.getInstance().getToken().addOnSuccessListener {
                    if (it != null) {
                        val token = it
                        Log.d("TOKENX", "getFcmToken: $token ")

                        Log.d("phonex", " No. $uid")

                        FirebaseUtils.collectionUserDetails.document(uid).update("fcmToken", token)
                    }
                }
            }
            .addOnFailureListener { exception ->
                Log.e("fetchUserDetails", "Failed to fetch user details", exception)
            }


    }

    private fun initAuth2Reciever() {
        val accessToken = AccessToken()
        lifecycleScope.launch(Dispatchers.IO)
        {
            var oauthtoken = accessToken.accessToken
            Log.d("xyz", "initAuth2Reciever: $oauthtoken ")

        }
    }
}
