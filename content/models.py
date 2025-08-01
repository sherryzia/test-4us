from django.db import models
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _
import uuid

User = get_user_model()

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name_plural = 'Categories'
    
    def __str__(self):
        return self.name

class Content(models.Model):
    class ContentType(models.TextChoices):
        AUDIO = 'audio', _('Audio')
        AUDIOBOOK = 'audiobook', _('Audiobook')
        PODCAST = 'podcast', _('Podcast')
        AI_GENERATED = 'ai_generated', _('AI Generated')
    
    class AccessType(models.TextChoices):
        FREE = 'free', _('Free')
        PAID = 'paid', _('Paid')
        SUBSCRIPTION = 'subscription', _('Subscription Only')
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    description = models.TextField()
    creator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='content')
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    
    # Content files
    audio_file = models.FileField(upload_to='content/audio/', blank=True, null=True)
    cover_image = models.ImageField(upload_to='content/covers/', blank=True, null=True)
    
    # Content metadata
    content_type = models.CharField(max_length=20, choices=ContentType.choices)
    access_type = models.CharField(max_length=20, choices=AccessType.choices, default=AccessType.FREE)
    duration = models.PositiveIntegerField(help_text="Duration in seconds", null=True, blank=True)
    
    # Pricing
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    
    # Status
    is_published = models.BooleanField(default=False)
    is_featured = models.BooleanField(default=False)
    is_ai_generated = models.BooleanField(default=False)
    
    # Engagement
    views_count = models.PositiveIntegerField(default=0)
    likes_count = models.PositiveIntegerField(default=0)
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return self.title