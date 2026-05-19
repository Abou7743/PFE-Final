from rest_framework.routers import DefaultRouter
from .views import (
    UserViewSet,
    ObjetViewSet,
    DocumentViewSet,
    CentreViewSet,
    ZoneViewSet,
    AdminLogViewSet,
    FactureIAViewSet,
    match_objets_documents,
    my_notifications,
    add_favori,
    my_favoris,
    send_message,
    get_messages,
    my_conversations,
    notifications_count,
    messages_count,
    logout_user,
    user_status,
    search_document,
    ocr_document,
    update_document_status,
    delete_notification,
    send_otp,
    verify_otp,
    reset_password,
)

from django.urls import path

# Router
router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'objets', ObjetViewSet)
router.register(r'documents', DocumentViewSet)
router.register(r'centres', CentreViewSet)
router.register(r'zones', ZoneViewSet)
router.register(r'adminlogs', AdminLogViewSet)
router.register(r'factures', FactureIAViewSet)
#router.register(r'documents', DocumentViewSet)

# urlpatterns principal
urlpatterns = router.urls

# Ajouter IA route
from .views import update_user, change_password  # ✅ CORRECT 
from .views import change_password
from .views import update_user
from .views import login_user
from .views import register_user
from .views import add_log
from .views import my_objets   # 🔥 AJOUT ICI
from .models import Notification
from django.contrib import admin
from django.urls import path, include

from django.conf import settings
from django.conf.urls.static import static

urlpatterns += [
    path('match/', match_objets_documents),
    path('register/', register_user),
    path('login/', login_user),
    path('change-password/', change_password),
    path('update-profile/', update_user),
    path('add-log/', add_log),
    path('api/my-objets/<int:user_id>/', my_objets),
    path('notifications/<int:user_id>/', my_notifications),
    path('favoris/', add_favori),
    path('favoris/<int:user_id>/', my_favoris),
    path('mes-favoris/<int:user_id>/', my_favoris),
    path('send-message/', send_message),
    path('messages/<int:sender>/<int:receiver>/', get_messages),
    path('conversations/<int:user_id>/', my_conversations),
    path('notifications-count/<int:user_id>/', notifications_count),
    path('messages-count/<int:user_id>/', messages_count),
    path('logout/', logout_user),
    path('user-status/<int:user_id>/', user_status),
    path('search-document/', search_document),
    path('ocr-document/', ocr_document),
    path('update-document-status/<int:document_id>/', update_document_status),
    path('delete-notification/<int:notification_id>/', delete_notification),
    path('reset-password/', reset_password),
    path('send-otp/', send_otp),
    path('verify-otp/', verify_otp),
    path('reset-password/', reset_password),
]

# 🔥 AJOUT IMPORTANT
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)