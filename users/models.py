# users/models.py - Clean version (Follow/Block models moved to social app)
from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    class UserRole(models.TextChoices):
        ADMIN = 'admin', 'Admin'
        CREATOR = 'creator', 'Creator'
        LISTENER = 'listener', 'Listener'
    
    role = models.CharField(
        max_length=20, 
        choices=UserRole.choices, 
        default=UserRole.LISTENER
    )
    avatar = models.ImageField(upload_to='avatars/', blank=True, null=True)
    bio = models.TextField(max_length=500, blank=True)
    website = models.URLField(blank=True)
    is_verified = models.BooleanField(default=False)
    email_verified = models.BooleanField(default=False)
    creator_approved = models.BooleanField(default=False)
    creator_earnings = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    
    # Social features - NEW FIELDS
    followers_count = models.PositiveIntegerField(default=0)
    following_count = models.PositiveIntegerField(default=0)
    posts_count = models.PositiveIntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.username} ({self.get_role_display()})"