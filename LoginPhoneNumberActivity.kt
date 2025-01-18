package com.example.chatappfirebase

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ProgressBar
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.transition.Visibility
import com.example.chatappfirebase.databinding.ActivityLoginPhoneNumberBinding
import com.google.firebase.firestore.FirebaseFirestore
import com.hbb20.CountryCodePicker

class LoginPhoneNumberActivity : AppCompatActivity() {

    lateinit var countryCodePicker: CountryCodePicker
    lateinit var phoneInput: EditText
    lateinit var sendOtpBtn: Button
    lateinit var progressBar: ProgressBar

    private lateinit var binding: ActivityLoginPhoneNumberBinding
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        enableEdgeToEdge()
        binding = ActivityLoginPhoneNumberBinding.inflate(layoutInflater)
        setContentView(binding.root)

       countryCodePicker = binding.loginCountrycode
        phoneInput = binding.loginMobileNumber
        sendOtpBtn = binding.sendOtpBtn
        progressBar = binding.loginProgressBar
        progressBar.visibility = View.GONE

        sendOtpBtn.setOnClickListener {
            // Set the mobile number to country code picker for validation
            countryCodePicker.registerCarrierNumberEditText(phoneInput)

            if(!countryCodePicker.isValidFullNumber){
                phoneInput.error = "Phone number not valid!"
                return@setOnClickListener
            }

            val intent = Intent(this, LoginOtpActivity::class.java)
            intent.putExtra("phone", countryCodePicker.fullNumberWithPlus)
            startActivity(intent)
        }



    }
}