# social/urls.py - Fixed version with correct parameter types
from django.urls import path
from . import views

urlpatterns = [
    # Feed
    path('feed/', views.get_feed, name='get_feed'),
    
    # Search
    path('search/users/', views.search_users, name='search_users'),
    
    # Posts - Fixed to use uuid instead of int
    path('posts/create/', views.create_post, name='create_post'),
    path('posts/<uuid:post_id>/like/', views.toggle_like_post, name='toggle_like_post'),
    path('posts/<uuid:post_id>/comments/', views.get_post_comments, name='get_post_comments'),
    path('posts/<uuid:post_id>/comments/create/', views.create_comment, name='create_comment'),
    
    # Users - These use int because User model uses auto-incrementing id
    path('users/<int:user_id>/follow/', views.toggle_follow_user, name='toggle_follow_user'),
    path('users/<int:user_id>/block/', views.toggle_block_user, name='toggle_block_user'),
    
    # Profile 
    path('profile/', views.get_user_profile, name='get_user_profile'),
    path('profile/<str:username>/', views.get_user_profile, name='get_user_profile_by_username'),
    path('profile/<str:username>/posts/', views.get_user_posts, name='get_user_posts'),
    path('profile/update/', views.update_profile, name='update_profile'),
    
    # Chat - Fixed to use uuid instead of int
    path('chats/', views.get_chats, name='get_chats'),
    path('chats/create/<int:user_id>/', views.create_chat, name='create_chat'),
    path('chats/<uuid:chat_id>/messages/', views.get_chat_messages, name='get_chat_messages'),
    path('chats/<uuid:chat_id>/send/', views.send_message, name='send_message'),
]