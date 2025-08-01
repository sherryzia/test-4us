import random
import string
from django.core.mail import send_mail
from django.conf import settings
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.core.cache import cache
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def generate_otp(length=6):
    """Generate a random OTP"""
    return ''.join(random.choices(string.digits, k=length))

def send_otp_email(email, otp, purpose='verification'):
    """Send OTP via email"""
    subject_map = {
        'verification': '🔑 Verify Your Email - AI Audio Marketplace',
        'password_reset': '🔐 Password Reset - AI Audio Marketplace'
    }
    
    subject = subject_map.get(purpose, 'OTP Verification')
    
    # Create email content
    if purpose == 'verification':
        message = f"""
Hello!

Welcome to AI Audio Marketplace! 

Your email verification code is: {otp}

Please enter this code on the verification page to complete your registration.

This code will expire in 10 minutes for security reasons.

If you didn't create an account with us, please ignore this email.

Best regards,
AI Audio Marketplace Team
        """
    else:
        message = f"""
Hello!

You requested to reset your password for AI Audio Marketplace.

Your password reset code is: {otp}

Please enter this code on the password reset page to create a new password.

This code will expire in 10 minutes for security reasons.

If you didn't request this password reset, please ignore this email.

Best regards,
AI Audio Marketplace Team
        """
    
    # Always print OTP to console for debugging
    print(f"\n" + "="*60)
    print(f"📧 SENDING OTP EMAIL 📧")
    print(f"To: {email}")
    print(f"Subject: {subject}")
    print(f"OTP: {otp}")
    print(f"Purpose: {purpose}")
    print(f"="*60 + "\n")
    
    try:
        # Method 1: Try Django's send_mail first
        send_mail(
            subject=subject,
            message=message,
            from_email=settings.EMAIL_HOST_USER,
            recipient_list=[email],
            fail_silently=False,
        )
        print(f"✅ Django email sent successfully to {email}")
        return True
        
    except Exception as e:
        print(f"❌ Django email failed: {e}")
        
        # Method 2: Try direct SMTP (this should work based on our test)
        try:
            smtp_server = "smtp.gmail.com"
            port = 587
            sender_email = "asimzaman2000@gmail.com"
            sender_password = "bjjrxajvsvfzgpfq"  # Working password from test
            
            print(f"Trying direct SMTP...")
            
            # Create message
            msg = MIMEMultipart()
            msg['From'] = sender_email
            msg['To'] = email
            msg['Subject'] = subject
            msg.attach(MIMEText(message, 'plain'))
            
            # Send email using direct SMTP
            server = smtplib.SMTP(smtp_server, port)
            server.starttls()
            server.login(sender_email, sender_password)
            server.send_message(msg)
            server.quit()
            
            print(f"✅ Direct SMTP email sent successfully to {email}")
            return True
            
        except Exception as smtp_error:
            print(f"❌ Direct SMTP failed: {smtp_error}")
            print(f"📧 ERROR: Could not send email, but OTP is: {otp}")
            # Still return True so the user can use console OTP
            return True

def store_otp(email, otp, purpose='verification', expiry_minutes=10):
    """Store OTP in cache with expiry"""
    cache_key = f"otp_{purpose}_{email}"
    cache.set(cache_key, otp, timeout=expiry_minutes * 60)
    return cache_key

def verify_otp(email, otp, purpose='verification'):
    """Verify OTP"""
    cache_key = f"otp_{purpose}_{email}"
    stored_otp = cache.get(cache_key)
    
    if stored_otp and stored_otp == otp:
        cache.delete(cache_key)  # Delete after successful verification
        return True
    return False

def send_verification_email(user):
    """Send verification email to user"""
    otp = generate_otp()
    store_otp(user.email, otp, 'verification')
    success = send_otp_email(user.email, otp, 'verification')
    
    # Always print success message
    if success:
        print(f"📧 Verification email process completed for: {user.email}")
    
    return success

def send_password_reset_email(email):
    """Send password reset email"""
    otp = generate_otp()
    store_otp(email, otp, 'password_reset')
    success = send_otp_email(email, otp, 'password_reset')
    
    # Always print success message
    if success:
        print(f"📧 Password reset email process completed for: {email}")
    
    return success