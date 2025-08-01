# social/views.py - Complete fixed version with proper error handling
from rest_framework import generics, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth import get_user_model
from django.db.models import Q
from django.shortcuts import get_object_or_404
from .models import Post, PostLike, Comment, CommentLike, Follow, Block, Chat, Message
from .serializers import (
    PostSerializer, CommentSerializer, PostCreateSerializer,
    UserProfileSerializer, FollowSerializer, ChatSerializer, MessageSerializer
)

User = get_user_model()

# Feed Views
@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_feed(request):
    """Get posts from followed users"""
    try:
        user = request.user
        
        # Get users that current user follows
        following_users = Follow.objects.filter(follower=user).values_list('following', flat=True)
        
        # Get users that current user has blocked
        blocked_users = Block.objects.filter(blocker=user).values_list('blocked', flat=True)
        
        # Get posts from following users, excluding blocked users
        posts = Post.objects.filter(
            author__in=following_users
        ).exclude(
            author__in=blocked_users
        ).select_related('author').prefetch_related('likes', 'comments')
        
        # If user doesn't follow anyone, show recent public posts
        if not posts.exists():
            posts = Post.objects.exclude(
                author__in=blocked_users
            ).exclude(
                author=user  # Don't show own posts in general feed
            ).select_related('author').prefetch_related('likes', 'comments')[:20]
        
        serializer = PostSerializer(posts, many=True, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Feed error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Search Views
@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def search_users(request):
    """Search for users by name or username"""
    try:
        query = request.GET.get('q', '').strip()
        
        if len(query) < 2:
            return Response({'error': 'Query must be at least 2 characters'}, 
                          status=status.HTTP_400_BAD_REQUEST)
        
        # Get users that current user has blocked
        blocked_users = Block.objects.filter(blocker=request.user).values_list('blocked', flat=True)
        
        # Search users by username, first_name, or last_name
        users = User.objects.filter(
            Q(username__icontains=query) |
            Q(first_name__icontains=query) |
            Q(last_name__icontains=query)
        ).exclude(
            id=request.user.id  # Exclude current user
        ).exclude(
            id__in=blocked_users  # Exclude blocked users
        ).order_by('username')[:20]  # Limit to 20 results
        
        serializer = UserProfileSerializer(users, many=True, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Search error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Post Views
@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_post(request):
    """Create a new post"""
    try:
        serializer = PostCreateSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            post = serializer.save(author=request.user)
            
            # Update user's posts count (if the field exists)
            if hasattr(request.user, 'posts_count'):
                request.user.posts_count += 1
                request.user.save()
            
            return Response(PostSerializer(post, context={'request': request}).data, 
                          status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    except Exception as e:
        print(f"❌ Create post error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def toggle_like_post(request, post_id):
    """Like or unlike a post"""
    try:
        post = get_object_or_404(Post, id=post_id)
        like, created = PostLike.objects.get_or_create(user=request.user, post=post)
        
        if not created:
            like.delete()
            post.likes_count = max(0, post.likes_count - 1)  # Ensure it doesn't go negative
            action = 'unliked'
            is_liked = False
        else:
            post.likes_count += 1
            action = 'liked'
            is_liked = True
        
        post.save()
        
        return Response({
            'action': action,
            'likes_count': post.likes_count,
            'is_liked': is_liked
        })
        
    except Exception as e:
        print(f"❌ Toggle like error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Comment Views
@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_post_comments(request, post_id):
    """Get comments for a post"""
    try:
        post = get_object_or_404(Post, id=post_id)
        comments = Comment.objects.filter(post=post, parent=None).select_related('author').order_by('-created_at')
        serializer = CommentSerializer(comments, many=True, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Get comments error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_comment(request, post_id):
    """Create a comment on a post"""
    try:
        post = get_object_or_404(Post, id=post_id)
        
        # Extract content from request data
        content = request.data.get('content', '').strip()
        if not content:
            return Response({'error': 'Content is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Create comment
        comment = Comment.objects.create(
            author=request.user,
            post=post,
            content=content
        )
        
        # Update post's comment count
        post.comments_count += 1
        post.save()
        
        return Response(CommentSerializer(comment, context={'request': request}).data, 
                      status=status.HTTP_201_CREATED)
        
    except Exception as e:
        print(f"❌ Create comment error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Follow/Unfollow Views
@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def toggle_follow_user(request, user_id):
    """Follow or unfollow a user"""
    try:
        target_user = get_object_or_404(User, id=user_id)
        
        if target_user == request.user:
            return Response({'error': 'Cannot follow yourself'}, status=status.HTTP_400_BAD_REQUEST)
        
        follow, created = Follow.objects.get_or_create(
            follower=request.user, 
            following=target_user
        )
        
        if not created:
            follow.delete()
            # Update counts if fields exist
            if hasattr(target_user, 'followers_count'):
                target_user.followers_count = max(0, target_user.followers_count - 1)
                target_user.save()
            if hasattr(request.user, 'following_count'):
                request.user.following_count = max(0, request.user.following_count - 1)
                request.user.save()
            action = 'unfollowed'
            is_following = False
        else:
            # Update counts if fields exist
            if hasattr(target_user, 'followers_count'):
                target_user.followers_count += 1
                target_user.save()
            if hasattr(request.user, 'following_count'):
                request.user.following_count += 1
                request.user.save()
            action = 'followed'
            is_following = True
        
        # Get current followers count
        followers_count = getattr(target_user, 'followers_count', target_user.followers.count())
        
        return Response({
            'action': action,
            'is_following': is_following,
            'followers_count': followers_count
        })
        
    except Exception as e:
        print(f"❌ Toggle follow error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def toggle_block_user(request, user_id):
    """Block or unblock a user"""
    try:
        target_user = get_object_or_404(User, id=user_id)
        
        if target_user == request.user:
            return Response({'error': 'Cannot block yourself'}, status=status.HTTP_400_BAD_REQUEST)
        
        block, created = Block.objects.get_or_create(
            blocker=request.user, 
            blocked=target_user
        )
        
        if not created:
            block.delete()
            action = 'unblocked'
            is_blocked = False
        else:
            # Also unfollow if blocking
            Follow.objects.filter(
                Q(follower=request.user, following=target_user) |
                Q(follower=target_user, following=request.user)
            ).delete()
            action = 'blocked'
            is_blocked = True
        
        return Response({
            'action': action,
            'is_blocked': is_blocked
        })
        
    except Exception as e:
        print(f"❌ Toggle block error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# User Profile Views
@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_user_profile(request, username=None):
    """Get user profile (own or another user's)"""
    try:
        if username:
            user = get_object_or_404(User, username=username)
        else:
            user = request.user
        
        # Check if user is blocked
        is_blocked = Block.objects.filter(
            blocker=user, blocked=request.user
        ).exists() if user != request.user else False
        
        if is_blocked:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        
        serializer = UserProfileSerializer(user, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Get profile error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_user_posts(request, username):
    """Get posts by a specific user"""
    try:
        user = get_object_or_404(User, username=username)
        
        # Check if user is blocked
        is_blocked = Block.objects.filter(
            blocker=user, blocked=request.user
        ).exists()
        
        if is_blocked:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)
        
        posts = Post.objects.filter(author=user).select_related('author').order_by('-created_at')
        serializer = PostSerializer(posts, many=True, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Get user posts error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['PUT', 'PATCH', 'POST'])
@permission_classes([permissions.IsAuthenticated])
def update_profile(request):
    """Update user profile with comprehensive method support"""
    try:
        user = request.user
        
        print(f"\n🔍 PROFILE UPDATE DEBUG 🔍")
        print(f"User: {user.username}")
        print(f"Method: {request.method}")
        print(f"Request data: {request.data}")
        print(f"Request files: {request.FILES}")
        
        # Update basic fields
        if 'first_name' in request.data:
            user.first_name = request.data['first_name']
            print(f"Updated first_name: {user.first_name}")
            
        if 'last_name' in request.data:
            user.last_name = request.data['last_name']
            print(f"Updated last_name: {user.last_name}")
            
        if 'bio' in request.data:
            user.bio = request.data['bio']
            print(f"Updated bio: {user.bio}")
            
        if 'website' in request.data:
            user.website = request.data['website']
            print(f"Updated website: {user.website}")
        
        # Handle avatar upload
        if 'avatar' in request.FILES:
            user.avatar = request.FILES['avatar']
            print(f"Updated avatar: {user.avatar}")
        
        user.save()
        print(f"✅ User saved successfully")
        
        # Return updated user data
        serializer = UserProfileSerializer(user, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Profile update error: {str(e)}")
        import traceback
        traceback.print_exc()
        return Response(
            {'error': f'Profile update failed: {str(e)}'}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

# Chat Views
@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_chats(request):
    """Get user's chats"""
    try:
        chats = Chat.objects.filter(
            Q(participant1=request.user) | Q(participant2=request.user)
        ).select_related('participant1', 'participant2').order_by('-updated_at')
        
        serializer = ChatSerializer(chats, many=True, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Get chats error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_chat(request, user_id):
    """Create or get existing chat with a user"""
    try:
        target_user = get_object_or_404(User, id=user_id)
        
        if target_user == request.user:
            return Response({'error': 'Cannot chat with yourself'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Check if chat already exists
        chat = Chat.objects.filter(
            Q(participant1=request.user, participant2=target_user) |
            Q(participant1=target_user, participant2=request.user)
        ).first()
        
        if not chat:
            chat = Chat.objects.create(
                participant1=request.user,
                participant2=target_user
            )
        
        serializer = ChatSerializer(chat, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Create chat error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_chat_messages(request, chat_id):
    """Get messages for a chat"""
    try:
        chat = get_object_or_404(Chat, id=chat_id)
        
        # Check if user is participant
        if request.user not in [chat.participant1, chat.participant2]:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
        
        messages = Message.objects.filter(chat=chat).select_related('sender').order_by('created_at')
        serializer = MessageSerializer(messages, many=True, context={'request': request})
        return Response(serializer.data)
        
    except Exception as e:
        print(f"❌ Get messages error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def send_message(request, chat_id):
    """Send a message in a chat"""
    try:
        chat = get_object_or_404(Chat, id=chat_id)
        
        # Check if user is participant
        if request.user not in [chat.participant1, chat.participant2]:
            return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
        
        content = request.data.get('content', '').strip()
        if not content:
            return Response({'error': 'Content is required'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Create message
        message = Message.objects.create(
            chat=chat,
            sender=request.user,
            content=content
        )
        
        # Update chat timestamp
        chat.save()
        
        return Response(MessageSerializer(message, context={'request': request}).data,
                      status=status.HTTP_201_CREATED)
        
    except Exception as e:
        print(f"❌ Send message error: {str(e)}")
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)