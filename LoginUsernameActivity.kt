package com.example.chatappfirebase

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import com.example.chatappfirebase.databinding.ActivityLoginUsernameBinding
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.FirebaseUtils.Companion.collectionUserDetails
import com.google.firebase.Timestamp
import com.google.firebase.auth.FirebaseAuth

class LoginUsernameActivity : AppCompatActivity() {

    private lateinit var binding: ActivityLoginUsernameBinding
    private lateinit var userModel: UserModel

    private var phoneNumber: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityLoginUsernameBinding.inflate(layoutInflater)
        setContentView(binding.root)

        phoneNumber = intent.extras?.getString("phone")

        binding.loginProgressBar.visibility = View.GONE
        enableEdgeToEdge()

        getUserName()

        binding.loginLetMeInBtn.setOnClickListener {
            setUserName()
        }
    }

    private fun getUserName() {
        setInProgress(true)

        collectionUserDetails.document(phoneNumber ?: "")
            .get()
            .addOnSuccessListener { document ->
                if (document.exists()) {
                    userModel = document.toObject(UserModel::class.java)!!
                    binding.loginUsername.setText(userModel.name)
                }
                setInProgress(false)
            }
            .addOnFailureListener {
                setInProgress(false)
                Toast.makeText(this, "Failed to retrieve user data", Toast.LENGTH_SHORT).show()
            }
    }

    private fun setUserName() {
        val username = binding.loginUsername.text.toString()

        if (username.isEmpty() || username.length < 3) {
            binding.loginUsername.error = "Username cannot be empty or less than 3 characters"
            return
        }
        setInProgress(true)

        if (::userModel.isInitialized) {
            userModel.name = username
        } else {
            // If userModel is not initialized, create a new instance
            val uId: String? = FirebaseAuth.getInstance().uid
            userModel = UserModel(
                name = username.lowercase(),
                phone = phoneNumber ?: "",
                createdTimestamp = Timestamp.now(),
                userId = uId ?: "",
                fcmToken = ""
            )
        }
//Unresolved reference: document
        //Unresolved reference: document
        collectionUserDetails.document(phoneNumber ?: "")
            .set(userModel)
            .addOnSuccessListener {
                setInProgress(false)
                val intent = Intent(this, MainActivity::class.java)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                startActivity(intent)
                finish()
            }
            .addOnFailureListener {
                setInProgress(false)
                Toast.makeText(this, "Something went wrong", Toast.LENGTH_SHORT).show()
            }
    }

    private fun setInProgress(inProgress: Boolean) {
        binding.loginProgressBar.visibility = if (inProgress) View.VISIBLE else View.GONE
        binding.loginLetMeInBtn.visibility = if (inProgress) View.GONE else View.VISIBLE
    }
}
