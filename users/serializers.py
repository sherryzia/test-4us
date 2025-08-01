from rest_framework import serializers
from django.contrib.auth import get_user_model, authenticate
from django.contrib.auth.password_validation import validate_password
from rest_framework_simplejwt.tokens import RefreshToken
from .utils import send_verification_email, verify_otp, send_password_reset_email

User = get_user_model()

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirm = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'password_confirm', 'role', 'first_name', 'last_name')
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("Passwords don't match")
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(**validated_data)
        
        # Send verification email
        send_verification_email(user)
        
        return user

class EmailVerificationSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)
    
    def validate(self, attrs):
        email = attrs.get('email')
        otp = attrs.get('otp')
        
        if not verify_otp(email, otp, 'verification'):
            raise serializers.ValidationError('Invalid or expired OTP')
        
        return attrs

class ResendOTPSerializer(serializers.Serializer):
    email = serializers.EmailField()

class PasswordResetRequestSerializer(serializers.Serializer):
    email = serializers.EmailField()
    
    def validate_email(self, value):
        try:
            User.objects.get(email=value)
        except User.DoesNotExist:
            raise serializers.ValidationError("No user found with this email address")
        return value

class PasswordResetConfirmSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6)
    new_password = serializers.CharField(write_only=True, validators=[validate_password])
    new_password_confirm = serializers.CharField(write_only=True)
    
    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password_confirm']:
            raise serializers.ValidationError("Passwords don't match")
        
        email = attrs.get('email')
        otp = attrs.get('otp')
        
        if not verify_otp(email, otp, 'password_reset'):
            raise serializers.ValidationError('Invalid or expired OTP')
        
        return attrs

class GoogleAuthSerializer(serializers.Serializer):
    access_token = serializers.CharField()

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 'role', 
                 'avatar', 'bio', 'website', 'is_verified', 'email_verified', 
                 'creator_approved', 'creator_earnings', 'created_at')
        read_only_fields = ('id', 'is_verified', 'creator_approved', 'creator_earnings', 'created_at')

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
    
    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')
        
        print(f"\n🔍 LOGIN SERIALIZER DEBUG 🔍")
        print(f"Username: {username}")
        print(f"Password: {'*' * len(password) if password else 'None'}")
        
        if username and password:
            # Try to find user by username or email
            user = None
            try:
                # First try by username
                user = User.objects.get(username=username)
                print(f"Found user by username: {user.username}")
            except User.DoesNotExist:
                try:
                    # Then try by email
                    user = User.objects.get(email=username)
                    print(f"Found user by email: {user.email}")
                except User.DoesNotExist:
                    print(f"❌ No user found with username/email: {username}")
                    raise serializers.ValidationError('Invalid credentials')
            
            # Check if user exists and password is correct
            if user and user.check_password(password):
                print(f"✅ Password check passed for user: {user.username}")
                if not user.is_active:
                    print(f"❌ User account is disabled: {user.username}")
                    raise serializers.ValidationError('User account is disabled')
                attrs['user'] = user
            else:
                print(f"❌ Password check failed for user: {username}")
                raise serializers.ValidationError('Invalid credentials')
        else:
            raise serializers.ValidationError('Must include username and password')
        
        print(f"✅ Serializer validation passed")
        return attrs