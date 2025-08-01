# audio_marketplace/urls.py - Simple version WITHOUT ai_pipeline
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse

def api_homepage(request):
    """Simple API homepage"""
    return JsonResponse({
        'message': 'Welcome to Nymia AI Audio Marketplace API',
        'version': '1.0.0',
        'endpoints': {
            'admin': '/admin/',
            'auth': '/api/auth/',
            'social': '/api/social/',
        },
        'status': 'running'
    })

urlpatterns = [
    path('', api_homepage, name='homepage'),
    path('admin/', admin.site.urls),
    path('api/auth/', include('users.urls')),
    path('api/social/', include('social.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)