package com.example.chatappfirebase.utils

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.ImageView
import android.widget.Toast
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.example.chatappfirebase.R
import com.example.chatappfirebase.model.UserModel


class AndroidUtils {

    companion object {

        fun passUserModelAsIntent(intent: Intent, model: UserModel) {
            intent.putExtra("username", model.name)
            intent.putExtra("phone", model.phone)
            intent.putExtra("userId", model.userId)
            intent.putExtra("fcmToken", model.fcmToken)
        }

        fun getUserModelFromIntent(intent: Intent): UserModel {
            val userModel = UserModel()
            userModel.name = intent.getStringExtra("username")!!
            userModel.phone = intent.getStringExtra("phone")!!
            userModel.userId = intent.getStringExtra("userId")!!
            userModel.fcmToken = intent.getStringExtra("fcmToken")!!
            return userModel
        }

        fun showToast(context: Context, message: String) {
            Toast.makeText(context, message, Toast.LENGTH_LONG).show()
        }

        fun setProfilePic(context: Context?, imageUri: Uri?, imageView: ImageView?) {
            if (context != null) {
                if (imageView != null) {
                    if (imageUri != null) {
                        Glide.with(context).load(imageUri)
                            .apply(RequestOptions.circleCropTransform()).into(imageView)
                    } else {
                        imageView.setImageResource(R.drawable.person_icon) // Default image
                    }
                }
            }
        }

    }
}