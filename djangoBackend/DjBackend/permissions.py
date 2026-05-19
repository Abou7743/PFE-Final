from rest_framework.permissions import BasePermission
from .models import User  # 🔥 on utilise TON modèle

class IsAdminUserCustom(BasePermission):
    def has_permission(self, request, view):
        try:
            user = User.objects.filter(email=request.user.username).first()
            return user and user.role == "admin"
        except:
            return False