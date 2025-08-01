# social/serializers.py - Complete fixed version
from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.utils import timezone
from .models import Post, PostLike, Comment, CommentLike, Follow, Block, Chat, Message
from datetime import timedelta

User = get_user_model()

class UserProfileSerializer(serializers.ModelSerializer):
    is_following = serializers.SerializerMethodField()
    is_blocked = serializers.SerializerMethodField()
    avatar_url = serializers.SerializerMethodField()
    posts_count = serializers.SerializerMethodField()
    followers_count = serializers.SerializerMethodField()
    following_count = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = [
            'id', 'username', 'first_name', 'last_name', 'email', 
            'bio', 'website', 'avatar', 'avatar_url', 'role',
            'posts_count', 'followers_count', 'following_count',
            'is_following', 'is_blocked', 'created_at'
        ]
        read_only_fields = ['id', 'username', 'email', 'created_at']
    
    def get_is_following(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated and request.user != obj:
            return Follow.objects.filter(follower=request.user, following=obj).exists()
        return False
    
    def get_is_blocked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated and request.user != obj:
            return Block.objects.filter(blocker=request.user, blocked=obj).exists()
        return False
    
    def get_avatar_url(self, obj):
        if obj.avatar:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.avatar.url)
        return f"https://ui-avatars.com/api/?name={obj.first_name}+{obj.last_name}&background=6366f1&color=fff&size=100"
    
    def get_posts_count(self, obj):
        # Use cached count if available, otherwise count
        return getattr(obj, 'posts_count', obj.posts.count())
    
    def get_followers_count(self, obj):
        # Use cached count if available, otherwise count
        return getattr(obj, 'followers_count', obj.followers.count())
    
    def get_following_count(self, obj):
        # Use cached count if available, otherwise count
        return getattr(obj, 'following_count', obj.following.count())

class PostCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['title', 'content', 'post_type', 'image', 'audio_file', 'link_url']
    
    def validate(self, data):
        post_type = data.get('post_type')
        
        if post_type == 'image' and not data.get('image'):
            raise serializers.ValidationError("Image is required for image posts")
        
        if post_type == 'link' and not data.get('link_url'):
            raise serializers.ValidationError("Link URL is required for link posts")
        
        if post_type == 'audio' and not data.get('audio_file'):
            raise serializers.ValidationError("Audio file is required for audio posts")
        
        return data

class PostSerializer(serializers.ModelSerializer):
    author = UserProfileSerializer(read_only=True)
    is_liked = serializers.SerializerMethodField()
    image_url = serializers.SerializerMethodField()
    audio_url = serializers.SerializerMethodField()
    time_ago = serializers.SerializerMethodField()
    
    class Meta:
        model = Post
        fields = [
            'id', 'author', 'title', 'content', 'post_type',
            'image', 'image_url', 'audio_file', 'audio_url', 'link_url', 
            'likes_count', 'comments_count', 'shares_count', 'is_liked',
            'is_published', 'is_featured', 'created_at', 'time_ago'
        ]
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return PostLike.objects.filter(user=request.user, post=obj).exists()
        return False
    
    def get_image_url(self, obj):
        if obj.image:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.image.url)
        return None
    
    def get_audio_url(self, obj):
        if obj.audio_file:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.audio_file.url)
        return None
    
    def get_time_ago(self, obj):
        now = timezone.now()
        diff = now - obj.created_at
        
        if diff < timedelta(minutes=1):
            return "Just now"
        elif diff < timedelta(hours=1):
            return f"{diff.seconds // 60}m ago"
        elif diff < timedelta(days=1):
            return f"{diff.seconds // 3600}h ago"
        elif diff < timedelta(days=7):
            return f"{diff.days}d ago"
        else:
            return obj.created_at.strftime("%b %d, %Y")

class CommentSerializer(serializers.ModelSerializer):
    author = UserProfileSerializer(read_only=True)
    is_liked = serializers.SerializerMethodField()
    replies = serializers.SerializerMethodField()
    time_ago = serializers.SerializerMethodField()
    
    class Meta:
        model = Comment
        fields = [
            'id', 'author', 'content', 'likes_count', 'is_liked',
            'replies', 'created_at', 'time_ago'
        ]
    
    def get_is_liked(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return CommentLike.objects.filter(user=request.user, comment=obj).exists()
        return False
    
    def get_replies(self, obj):
        if obj.replies.exists():
            return CommentSerializer(obj.replies.all(), many=True, context=self.context).data
        return []
    
    def get_time_ago(self, obj):
        now = timezone.now()
        diff = now - obj.created_at
        
        if diff < timedelta(minutes=1):
            return "Just now"
        elif diff < timedelta(hours=1):
            return f"{diff.seconds // 60}m ago"
        elif diff < timedelta(days=1):
            return f"{diff.seconds // 3600}h ago"
        else:
            return f"{diff.days}d ago"

class FollowSerializer(serializers.ModelSerializer):
    follower = UserProfileSerializer(read_only=True)
    following = UserProfileSerializer(read_only=True)
    
    class Meta:
        model = Follow
        fields = ['follower', 'following', 'created_at']

class ChatSerializer(serializers.ModelSerializer):
    other_participant = serializers.SerializerMethodField()
    last_message = serializers.SerializerMethodField()
    unread_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Chat
        fields = [
            'id', 'other_participant', 'last_message', 
            'unread_count', 'created_at', 'updated_at'
        ]
    
    def get_other_participant(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            other_user = obj.participant2 if obj.participant1 == request.user else obj.participant1
            return UserProfileSerializer(other_user, context=self.context).data
        return None
    
    def get_last_message(self, obj):
        last_message = obj.messages.last()
        if last_message:
            return MessageSerializer(last_message, context=self.context).data
        return None
    
    def get_unread_count(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.messages.filter(is_read=False).exclude(sender=request.user).count()
        return 0

class MessageSerializer(serializers.ModelSerializer):
    sender = UserProfileSerializer(read_only=True)
    is_own = serializers.SerializerMethodField()
    time_ago = serializers.SerializerMethodField()
    
    class Meta:
        model = Message
        fields = [
            'id', 'sender', 'content', 'is_read', 'is_own',
            'created_at', 'time_ago'
        ]
    
    def get_is_own(self, obj):
        request = self.context.get('request')
        if request and request.user.is_authenticated:
            return obj.sender == request.user
        return False
    
    def get_time_ago(self, obj):
        now = timezone.now()
        diff = now - obj.created_at
        
        if diff < timedelta(minutes=1):
            return "Just now"
        elif diff < timedelta(hours=1):
            return f"{diff.seconds // 60}m ago"
        elif diff < timedelta(days=1):
            return f"{diff.seconds // 3600}h ago"
        else:
            return obj.created_at.strftime("%b %d, %Y %H:%M")