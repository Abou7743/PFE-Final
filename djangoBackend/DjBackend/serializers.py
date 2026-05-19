from rest_framework import serializers
#from .models import User, Objet, Document, Centre, Zone, AdminLog, FactureIA
from rest_framework import serializers

from .models import (
    User,
    Objet,
    Document,
    Centre,
    Zone,
    AdminLog,
    FactureIA,
    Notification,
    Favori,
    Message
)

# 🔹 USER
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'nom', 'email', 'telephone', 'role']
        #fields = '__all__'


# 🔹 OBJET (AVEC IMAGE)
class ObjetSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = Objet
        fields = '__all__'

    def get_image_url(self, obj):
        request = self.context.get('request')
        if obj.image:
            return request.build_absolute_uri(obj.image.url)
        return None


# 🔹 DOCUMENT
class DocumentSerializer(
    serializers.ModelSerializer
):

    image_url = serializers.SerializerMethodField()

    class Meta:

        model = Document

        fields = '__all__'

    def get_image_url(
        self,
        obj
    ):

        request = self.context.get('request')

        if obj.image:

            return request.build_absolute_uri(
                obj.image.url
            )

        return None


# 🔹 CENTRE
class CentreSerializer(serializers.ModelSerializer):
    class Meta:
        model = Centre
        fields = '__all__'


# 🔹 ZONE
class ZoneSerializer(serializers.ModelSerializer):
    class Meta:
        model = Zone
        fields = '__all__'


# 🔹 LOG
class AdminLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = AdminLog
        fields = '__all__'


# 🔹 FACTURE IA
class FactureIASerializer(serializers.ModelSerializer):
    class Meta:
        model = FactureIA
        fields = '__all__'

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'

class FavoriSerializer(serializers.ModelSerializer):

    class Meta:
        model = Favori
        fields = '__all__'

class MessageSerializer(serializers.ModelSerializer):

    class Meta:
        model = Message
        fields = '__all__'