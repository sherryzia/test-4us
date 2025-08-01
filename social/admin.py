# social/admin.py - Complete fixed admin
from django.contrib import admin
from .models import Post, PostLike, Comment, CommentLike, Follow, Block, Chat, Message

@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ('title_preview', 'author', 'post_type', 'likes_count', 'comments_count', 'is_published', 'created_at')
    list_filter = ('post_type', 'is_published', 'is_featured', 'created_at')
    search_fields = ('title', 'content', 'author__username', 'author__first_name', 'author__last_name')
    readonly_fields = ('id', 'likes_count', 'comments_count', 'shares_count', 'created_at', 'updated_at')
    
    fieldsets = (
        ('Content', {
            'fields': ('author', 'title', 'content', 'post_type')
        }),
        ('Media', {
            'fields': ('image', 'audio_file', 'link_url'),
            'classes': ('collapse',)
        }),
        ('Engagement', {
            'fields': ('likes_count', 'comments_count', 'shares_count'),
            'classes': ('collapse',)
        }),
        ('Status', {
            'fields': ('is_published', 'is_featured')
        }),
        ('Metadata', {
            'fields': ('id', 'created_at', 'updated_at'),
            'classes': ('collapse',)
        })
    )
    
    def title_preview(self, obj):
        return obj.title[:50] + '...' if len(obj.title) > 50 else obj.title
    title_preview.short_description = 'Title'

@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('content_preview', 'author', 'post_title_preview', 'parent', 'likes_count', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('content', 'author__username', 'post__title')
    readonly_fields = ('id', 'likes_count', 'created_at', 'updated_at')
    
    def content_preview(self, obj):
        return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content
    content_preview.short_description = 'Content'
    
    def post_title_preview(self, obj):
        return obj.post.title[:30] + '...' if len(obj.post.title) > 30 else obj.post.title
    post_title_preview.short_description = 'Post'

@admin.register(Follow)
class FollowAdmin(admin.ModelAdmin):
    list_display = ('follower', 'following', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('follower__username', 'following__username', 'follower__first_name', 'following__first_name')
    readonly_fields = ('created_at',)

@admin.register(Block)
class BlockAdmin(admin.ModelAdmin):
    list_display = ('blocker', 'blocked', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('blocker__username', 'blocked__username', 'blocker__first_name', 'blocked__first_name')
    readonly_fields = ('created_at',)

@admin.register(Chat)
class ChatAdmin(admin.ModelAdmin):
    list_display = ('id_preview', 'participant1', 'participant2', 'message_count', 'created_at', 'updated_at')
    list_filter = ('created_at', 'updated_at')
    search_fields = ('participant1__username', 'participant2__username')
    readonly_fields = ('id', 'created_at', 'updated_at')
    
    def id_preview(self, obj):
        return str(obj.id)[:8] + '...'
    id_preview.short_description = 'Chat ID'
    
    def message_count(self, obj):
        return obj.messages.count()
    message_count.short_description = 'Messages'

@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ('content_preview', 'sender', 'chat_preview', 'is_read', 'created_at')
    list_filter = ('is_read', 'created_at')
    search_fields = ('content', 'sender__username')
    readonly_fields = ('id', 'created_at')
    
    def content_preview(self, obj):
        return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content
    content_preview.short_description = 'Content'
    
    def chat_preview(self, obj):
        return f"{obj.chat.participant1.username} & {obj.chat.participant2.username}"
    chat_preview.short_description = 'Chat'

# Register the Like models for debugging purposes
@admin.register(PostLike)
class PostLikeAdmin(admin.ModelAdmin):
    list_display = ('user', 'post_title_preview', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('user__username', 'post__title')
    readonly_fields = ('created_at',)
    
    def post_title_preview(self, obj):
        return obj.post.title[:30] + '...' if len(obj.post.title) > 30 else obj.post.title
    post_title_preview.short_description = 'Post'

@admin.register(CommentLike)
class CommentLikeAdmin(admin.ModelAdmin):
    list_display = ('user', 'comment_preview', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('user__username', 'comment__content')
    readonly_fields = ('created_at',)
    
    def comment_preview(self, obj):
        return obj.comment.content[:30] + '...' if len(obj.comment.content) > 30 else obj.comment.content
    comment_preview.short_description = 'Comment'