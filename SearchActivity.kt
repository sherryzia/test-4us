package com.example.chatappfirebase

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.inputmethod.InputMethodManager
import android.widget.ImageButton
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.chatappfirebase.adapter.SearchUserRecyclerAdapter
import com.example.chatappfirebase.databinding.ActivitySearchBinding
import com.example.chatappfirebase.model.UserModel
import com.example.chatappfirebase.utils.FirebaseUtils
import com.firebase.ui.firestore.FirestoreRecyclerOptions
import com.google.firebase.firestore.Query

class SearchActivity : AppCompatActivity() {
    private lateinit var binding: ActivitySearchBinding
    private lateinit var searchButton: ImageButton
    private lateinit var backButton: ImageButton
    private lateinit var recyclerView: RecyclerView
    private lateinit var adapter: SearchUserRecyclerAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySearchBinding.inflate(layoutInflater)
        setContentView(binding.root)

        searchButton = binding.searchUserBtn
        backButton = binding.backBtn
        recyclerView = binding.searchUserRecyclerView

        // Show keyboard when activity opens
        binding.searchUsernameInput.requestFocus()
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.showSoftInput(binding.searchUsernameInput, InputMethodManager.SHOW_IMPLICIT)

        backButton.setOnClickListener {
            onBackPressedDispatcher.onBackPressed()
        }

        searchButton.setOnClickListener {
            val searchTerm = binding.searchUsernameInput.text.toString().lowercase()
            if (searchTerm.length < 3 || searchTerm.isEmpty()) {
                binding.searchUsernameInput.error = "Please enter at least 3 characters"
            } else {
                setupSearchRecyclerView(searchTerm)
            }
        }
    }

    private fun setupSearchRecyclerView(searchTerm: String) {

        // query should fetch user regardless of there casing. it shouldnt care if its capital or small or camelcase etc.

        val query: Query = FirebaseUtils.collectionUserDetails
            .whereGreaterThanOrEqualTo("name", searchTerm)
            .whereLessThanOrEqualTo("name", "$searchTerm\uf8ff")


        val options = FirestoreRecyclerOptions.Builder<UserModel>()
            .setQuery(query, UserModel::class.java)
            .build()

        adapter = SearchUserRecyclerAdapter(options, this)
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter
        adapter.startListening()

        // Debugging: Check if the query returns any results
        query.get().addOnSuccessListener { documents ->
            if (documents.isEmpty) {
                Log.d("SearchActivity", "No results found.")
            } else {
                for (document in documents) {
                    Log.d("SearchActivity", "Found document: ${document.id} => ${document.data}")
                }
            }
        }.addOnFailureListener { exception ->
            Log.w("SearchActivity", "Error getting documents: ", exception)
        }
    }

    override fun onStart() {
        super.onStart()
        if (::adapter.isInitialized) {
            adapter.startListening()
        }
    }
 
    override fun onStop() {
        super.onStop()
        if (::adapter.isInitialized) {
            adapter.stopListening()
        }
    }
}
