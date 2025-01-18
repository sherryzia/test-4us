package com.example.chatappfirebase

import android.content.Intent
import android.os.Bundle
import android.os.CountDownTimer
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import com.example.chatappfirebase.databinding.ActivityLoginOtpBinding
import com.example.chatappfirebase.utils.AndroidUtils.Companion.showToast
import com.example.chatappfirebase.utils.FirebaseUtils
import com.google.firebase.FirebaseException
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.PhoneAuthCredential
import com.google.firebase.auth.PhoneAuthOptions
import com.google.firebase.auth.PhoneAuthProvider
import java.util.concurrent.TimeUnit

class LoginOtpActivity : AppCompatActivity() {

    private lateinit var phoneNumber: String
    private lateinit var binding: ActivityLoginOtpBinding
    private lateinit var verificationCode: String
    private lateinit var forceResendingToken: PhoneAuthProvider.ForceResendingToken
    val timeoutSecs=60L
    private val mAuth = FirebaseAuth.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize view binding
        binding = ActivityLoginOtpBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Set up views from the binding
        val otpInput = binding.loginOtp
        val nextBtn = binding.loginNextBtn
        val progressBar = binding.loginProgressBar
        val resendOtpTextView = binding.resendOtpTextview

        // Hide progress bar initially
        progressBar.visibility = View.GONE

        enableEdgeToEdge()

        // Retrieve phone number from intent
        phoneNumber = intent.extras?.getString("phone").toString()
        showToast(this, phoneNumber)

        // Send OTP initially
        sendOtp(phoneNumber, isResend = false)

        // Handle "Next" button click
        nextBtn.setOnClickListener {
            val otp = otpInput.text.toString()
            if (otp.isNotEmpty()) {
                val credential = PhoneAuthProvider.getCredential(verificationCode, otp)
                signIn(credential)
            } else {
                showToast(this, "Please enter OTP")
            }
        }

        // Handle resend OTP
        resendOtpTextView.setOnClickListener {
            sendOtp(phoneNumber,true)
        }
    }

    private fun sendOtp(phoneNumber: String, isResend: Boolean) {
        startResendTimer()
        setInProgress(true)

        val optionsBuilder = PhoneAuthOptions.newBuilder(mAuth)
            .setPhoneNumber(phoneNumber)
            .setTimeout(timeoutSecs, TimeUnit.SECONDS)
            .setActivity(this)
            .setCallbacks(object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
                override fun onVerificationCompleted(credential: PhoneAuthCredential) {
                    signIn(credential)
                }

                override fun onVerificationFailed(e: FirebaseException) {
                    showToast(
                        this@LoginOtpActivity,
                        "OTP couldn't be sent. Please try again later..: ${e.message}"
                    )
                    setInProgress(false)
                    val intent = Intent(this@LoginOtpActivity, LoginPhoneNumberActivity::class.java)
                    startActivity(intent)
                }

                override fun onCodeSent(
                    verificationId: String,
                    token: PhoneAuthProvider.ForceResendingToken
                ) {
                    super.onCodeSent(verificationId, token)
                    verificationCode = verificationId
                    forceResendingToken = token
                    showToast(this@LoginOtpActivity, "OTP Sent")
                    setInProgress(false)
                }
            })

        if (isResend) {
            optionsBuilder.setForceResendingToken(forceResendingToken)
        }

        PhoneAuthProvider.verifyPhoneNumber(optionsBuilder.build())
    }

    private fun startResendTimer() {
        // Set the total countdown duration (e.g., 60 seconds)
        val totalTime = 60000L // 60 seconds in milliseconds
        val interval = 1000L // 1-second intervals

        // Create a CountDownTimer
        object : CountDownTimer(totalTime, interval) {
            override fun onTick(millisUntilFinished: Long) {
                // Update the UI to show remaining time in seconds
                binding.resendOtpTextview.text = "Resend in ${millisUntilFinished / 1000}s"
                binding.resendOtpTextview.isEnabled = false // Disable resend button
            }

            override fun onFinish() {
                // Enable the resend button and reset text when timer finishes
                binding.resendOtpTextview.text = "Resend OTP"
                binding.resendOtpTextview.isEnabled = true
            }
        }.start() // Start the countdown
    }

    private fun setInProgress(inProgress: Boolean) {
        binding.loginProgressBar.visibility = if (inProgress) View.VISIBLE else View.GONE
        binding.loginNextBtn.visibility = if (inProgress) View.GONE else View.VISIBLE
    }

    private fun signIn(credential: PhoneAuthCredential) {
        mAuth.signInWithCredential(credential).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                // If sign-in is successful, check if the user data already exists in Firestore
                FirebaseUtils.collectionUserDetails
                    .whereEqualTo("phone", phoneNumber) // Assuming 'phone' is the field for phone numbers in the "users" collection
                    .get()
                    .addOnSuccessListener { documents ->
                        if (!documents.isEmpty) {
                            // User data exists, navigate to MainActivity
                            showToast(this, "Welcome back!")
                            startActivity(Intent(this, MainActivity::class.java))
                        } else {
                            // User data does not exist, navigate to LoginUsernameActivity
                            showToast(this, "Please complete your profile")
                            val intent = Intent(this, LoginUsernameActivity::class.java)
                            intent.putExtra("phone", phoneNumber)
                            startActivity(intent)
                        }
                    }
                    .addOnFailureListener { exception ->
                        showToast(this, "Failed to check user data: ${exception.message}")
                    }
            } else {
                showToast(this, "Sign-in failed: ${task.exception?.message}")
            }
        }
    }

}
