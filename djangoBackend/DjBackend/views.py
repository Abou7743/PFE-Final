from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.parsers import MultiPartParser, FormParser

from django.contrib.auth.hashers import make_password, check_password
from django.contrib.auth.models import User as AuthUser
from rest_framework.authtoken.models import Token

import random

from django.core.mail import send_mail

from django.conf import settings

from django.utils import timezone

import pytesseract
pytesseract.pytesseract.tesseract_cmd = (
    r'C:\Program Files\Tesseract-OCR\tesseract.exe'
)

from PIL import Image

import re

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

from rest_framework.decorators import (
    api_view,
    permission_classes
)

from rest_framework.parsers import (
    MultiPartParser,
    FormParser
)

#from .models import User, Objet, Document, Centre, Zone, AdminLog, FactureIA
#from .models import User, Objet, Document, Centre, Zone, AdminLog, FactureIA, Notification
from .models import User, Objet, Document, Centre, Zone, AdminLog, FactureIA, Notification, Favori, Message
from .serializers import (
    UserSerializer,
    ObjetSerializer,
    DocumentSerializer,
    CentreSerializer,
    ZoneSerializer,
    AdminLogSerializer,
    FactureIASerializer,
    NotificationSerializer,
    FavoriSerializer,
    MessageSerializer
)


# ==============================
# 🔹 VIEWSETS (CORRIGÉ)
# ==============================

# 👤 USERS
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]  # 🔥 CORRECTION


# 📦 OBJETS
#class ObjetViewSet(viewsets.ModelViewSet):
    #queryset = Objet.objects.all()
    #serializer_class = ObjetSerializer
    #parser_classes = (MultiPartParser, FormParser)
    #permission_classes = [AllowAny]

class ObjetViewSet(viewsets.ModelViewSet):
    queryset = Objet.objects.all()
    serializer_class = ObjetSerializer
    parser_classes = (MultiPartParser, FormParser)
    permission_classes = [AllowAny]

    # 🔔 Notification quand on publie
    def perform_create(self, serializer):

        objet = serializer.save()

        Notification.objects.create(
            user=objet.user,
            message="Votre objet a été publié ✅"
        )

    # 🔔 Notification quand retrouvé
    def perform_update(self, serializer):

        objet = serializer.save()

        if objet.statut == "trouvé":

            Notification.objects.create(
                user=objet.user,
                message="Votre objet a été marqué retrouvé 🎉"
            )


# 📄 DOCUMENTS
# 📄 DOCUMENTS
class DocumentViewSet(
    viewsets.ModelViewSet
):

    queryset = Document.objects.all()

    serializer_class = DocumentSerializer

    parser_classes = (
        MultiPartParser,
        FormParser
    )

    permission_classes = [
        AllowAny
    ]

    def perform_create(
        self,
        serializer
    ):

        document = serializer.save()

        # 🔥 Ajouter automatiquement
        # dans HomeScreen (Objet)
        Objet.objects.create(

    user=document.user,

    titre=document.type_document,

    description=
        f"{document.nom} {document.prenom}",

    statut="trouvé",

    date_objet=
        timezone.now().date(),

    lieu=document.lieu_trouve,

    telephone=document.telephone,

    categorie="document",

    image=document.image
)
        
# 🏢 CENTRES
class CentreViewSet(viewsets.ModelViewSet):
    queryset = Centre.objects.all()
    serializer_class = CentreSerializer
    permission_classes = [AllowAny]  # 🔥 CORRECTION


# 🌍 ZONES
class ZoneViewSet(viewsets.ModelViewSet):
    queryset = Zone.objects.all()
    serializer_class = ZoneSerializer
    permission_classes = [AllowAny]  # 🔥 CORRECTION


# 🧾 LOGS
class AdminLogViewSet(viewsets.ModelViewSet):
    queryset = AdminLog.objects.all()
    serializer_class = AdminLogSerializer
    permission_classes = [AllowAny]  # 🔥 CORRECTION


# 🤖 FACTURE IA
class FactureIAViewSet(viewsets.ModelViewSet):
    queryset = FactureIA.objects.all()
    serializer_class = FactureIASerializer
    permission_classes = [AllowAny]


# ==============================
# 🔐 AUTH
# ==============================

@api_view(['POST'])
def register_user(request):
    try:
        user = User.objects.create(
            nom=request.data.get('nom'),
            email=request.data.get('email'),
            telephone=request.data.get('telephone'),
            password=make_password(request.data.get('password')),
            role="user"
        )
        return Response({"message": "User created"}, status=201)
    except Exception as e:
        return Response({"error": str(e)}, status=400)


@api_view(['POST'])
def login_user(request):

    try:

        email = request.data.get('email')

        password = request.data.get('password')

        user = User.objects.filter(
            email=email
        ).first()

        if not user:

            return Response(
                {
                    "error":
                        "Utilisateur introuvable"
                },
                status=400
            )

        if not check_password(
            password,
            user.password
        ):

            return Response(
                {
                    "error":
                        "Mot de passe incorrect"
                },
                status=400
            )

        # 🔥 UTILISATEUR EN LIGNE
        user.is_online = True
        user.save()

        # 🔥 récupérer ou créer user Django auth
        auth_user, created = AuthUser.objects.get_or_create(
            username=user.email
        )

        # 🔥 IMPORTANT : seulement si nouveau
        if created:

            auth_user.set_password(password)

            auth_user.save()

        # 🔑 TOKEN
        token, _ = Token.objects.get_or_create(
            user=auth_user
        )

        return Response({

            "token": token.key,

            "id": user.id,

            "nom": user.nom,

            "email": user.email,

            "telephone": user.telephone,

            "role": user.role,

            # 🔥 AJOUT
            "is_online": user.is_online
        })

    except Exception as e:

        return Response(
            {
                "error": str(e)
            },
            status=500
        )
# ==============================
# 🔧 USER ACTIONS
# ==============================

@api_view(['POST'])
def update_user(request):
    try:
        user = User.objects.get(id=request.data.get('id'))

        user.nom = request.data.get('nom')
        user.email = request.data.get('email')
        user.telephone = request.data.get('telephone')

        user.save()

        return Response({"message": "Profile updated"})

    except:
        return Response({"error": "User not found"}, status=404)


@api_view(['POST'])
def change_password(request):
    try:
        user = User.objects.get(id=request.data.get('id'))

        if not check_password(request.data.get('old_password'), user.password):
            return Response({"error": "Ancien mot de passe incorrect"}, status=400)

        user.password = make_password(request.data.get('new_password'))
        user.save()

        return Response({"message": "Mot de passe changé"})

    except:
        return Response({"error": "Erreur"}, status=404)


# ==============================
# 🤖 IA
# ==============================

@api_view(['GET'])
def match_objets_documents(request):
    documents = Document.objects.all()
    objets = Objet.objects.all()

    results = []

    for doc in documents:
        for obj in objets:
            texte_doc = f"{doc.nom} {doc.prenom} {doc.type_document} {doc.lieu_perte}"
            texte_obj = f"{obj.titre} {obj.description} {obj.lieu}"

            vectorizer = TfidfVectorizer().fit_transform([texte_doc, texte_obj])
            similarity = cosine_similarity(vectorizer[0:1], vectorizer[1:2])[0][0]

            if similarity > 0.3:
                results.append({
                    "document": doc.nom,
                    "objet": obj.titre,
                    "score": round(similarity * 100, 2)
                })

    return Response(results)


# ==============================
# 🧾 LOG
# ==============================

@api_view(['POST'])
def add_log(request):
    AdminLog.objects.create(
        user_id=request.data.get('user'),
        action=request.data.get('action')
    )
    return Response({"message": "log added"})


from .models import Objet
from .serializers import ObjetSerializer
@api_view(['GET'])
def my_objets(request, user_id):
    objets = Objet.objects.filter(user_id=user_id)
    serializer = ObjetSerializer(objets, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def my_notifications(request, user_id):

    notifications = Notification.objects.filter(
        user_id=user_id
    ).order_by('-created_at')

    serializer = NotificationSerializer(
        notifications,
        many=True
    )

    return Response(serializer.data)

def destroy(self, request, *args, **kwargs):

    objet = self.get_object()

    # 🔥 utilisateur connecté
    user_id = request.data.get("user")

    # 🔥 admin peut supprimer tout
    if str(objet.user.id) == str(user_id):
        return super().destroy(request, *args, **kwargs)

    return Response(
        {"error": "Non autorisé"},
        status=403
    )

@api_view(['POST'])
def add_favori(request):

    user_id = request.data.get("user")
    objet_id = request.data.get("objet")

    try:

        favori = Favori.objects.get(
            user_id=user_id,
            objet_id=objet_id
        )

        # 💔 supprimer favori
        favori.delete()

        return Response({
            "message": "Retiré des favoris 💔"
        })

    except Favori.DoesNotExist:

        # ❤️ ajouter favori
        Favori.objects.create(
            user_id=user_id,
            objet_id=objet_id
        )

        return Response({
            "message": "Ajouté aux favoris ❤️"
        })

@api_view(['GET'])
def my_favoris(request, user_id):

    favoris = Favori.objects.filter(
        user_id=user_id
    )

    data = []

    for fav in favoris:

        objet = fav.objet

        data.append({

            "id": objet.id,
            "titre": objet.titre,
            "description": objet.description,
            "lieu": objet.lieu,
            "categorie": objet.categorie,
            "statut": objet.statut,
            "telephone": objet.telephone,

            "image": (
                request.build_absolute_uri(
                    objet.image.url
                )
                if objet.image
                else None
            ),
        })

    return Response(data)

@api_view(['POST'])
def send_message(request):

    Message.objects.create(
        sender_id=request.data.get('sender'),
        receiver_id=request.data.get('receiver'),
        content=request.data.get('content')
    )

    return Response({
        "message": "Message envoyé ✅"
    })


@api_view(['GET'])
def get_messages(request, sender, receiver):

    messages = Message.objects.filter(
        sender_id__in=[sender, receiver],
        receiver_id__in=[sender, receiver]
    ).order_by('created_at')

    messages.update(is_read=True)

    # 🔥 MARQUER COMME LU
    messages.filter(
        receiver_id=sender
    ).update(is_read=True)

    serializer = MessageSerializer(
        messages,
        many=True
    )

    return Response(serializer.data)

@api_view(['GET'])
def my_conversations(request, user_id):

    messages = Message.objects.filter(
        sender_id=user_id
    ) | Message.objects.filter(
        receiver_id=user_id
    )

    conversations = {}

    for msg in messages.order_by('-created_at'):

        other_user = (
            msg.receiver
            if msg.sender.id == user_id
            else msg.sender
        )

        if other_user.id not in conversations:

            conversations[other_user.id] = {
                "user_id": other_user.id,
                "nom": other_user.nom,
                "last_message": msg.content,
            }

    return Response(list(conversations.values()))


@api_view(['GET'])
def notifications_count(request, user_id):

    count = Notification.objects.filter(
        user_id=user_id
    ).count()

    return Response({
        "count": count
    })


@api_view(['GET'])
def messages_count(request, user_id):

    count = Message.objects.filter(
        receiver_id=user_id,
        is_read=False
    ).count()

    return Response({
        "count": count
    })

@api_view(['POST'])
def logout_user(request):

    user_id = request.data.get('user_id')

    user = User.objects.get(
        id=user_id
    )

    user.is_online = False
    user.save()

    return Response({
        "message":
            "Déconnecté ✅"
    })

@api_view(['GET'])
def user_status(request, user_id):

    user = User.objects.get(
        id=user_id
    )

    return Response({

        "is_online":
            user.is_online
    })

@api_view(['POST'])
def search_document(request):

    nom = request.data.get(
        'nom',
        ''
    )

    prenom = request.data.get(
        'prenom',
        ''
    )

    nni = request.data.get(
        'nni',
        ''
    )

    date_naissance = request.data.get(
        'date_naissance',
        ''
    )

    documents = Document.objects.all()

    # 🔥 FILTRES INTELLIGENTS

    if nom != '':

        documents = documents.filter(
            nom__icontains=nom
        )

    if prenom != '':

        documents = documents.filter(
            prenom__icontains=prenom
        )

    if nni != '':

        documents = documents.filter(
            nni__icontains=nni
        )

    if date_naissance != '':

        documents = documents.filter(
            date_naissance=date_naissance
        )

    serializer = DocumentSerializer(
        documents,
        many=True,
        context={
            'request': request
        }
    )

    return Response(
        serializer.data
    )

@api_view(['POST'])
@permission_classes([AllowAny])

def ocr_document(request):

    try:

        image = request.FILES.get('image')

        if not image:

            return Response({

                "error":
                    "Image obligatoire"

            }, status=400)

        img = Image.open(image)

        # noir/blanc
        img = img.convert('L')

        # contraste fort
        img = img.point(
            lambda x: 0 if x < 140 else 255,
            '1'
        )

        # agrandir image
        width, height = img.size

        img = img.resize(
            (width * 2, height * 2)
        )

        text = pytesseract.image_to_string(

            img,

            lang='fra+eng',

            config='--oem 3 --psm 6'
        )

        # =========================
        # 🔥 NETTOYAGE OCR
        # =========================

        # supprimer caractères bizarres
        text = re.sub(

            r'[^A-Za-z0-9À-ÿ\n ]',

            ' ',

            text
        )

        # supprimer espaces multiples
        text = re.sub(

            r'\s+',

            ' ',

            text
        )

        # texte propre
        text = text.strip()

        # MAJUSCULE
        text = text.upper()


        print(text)

        # 🔥 EXTRACTION NNI

        nni_match = re.search(
            r'\d{5,}',
            text
        )

        nni = (
            nni_match.group(0)
            if nni_match
            else ""
        )

        # 🔥 MATCHING DOCUMENT

        matched_document = None

        # 🔥 MATCHING PAR NNI

        if nni != "":

            matched_document = (

                Document.objects.filter(
                    nni__icontains=nni
                ).first()
            )

        # 🔥 SI NNI NON TROUVÉ
        # chercher par nom/prénom

        if not matched_document:

            documents = Document.objects.all()

            for doc in documents:

                full_name = (
                    f"{doc.nom} {doc.prenom}"
                ).lower()

                if (

                    doc.nom.lower()
                    in text.lower()

                    or

                    doc.prenom.lower()
                    in text.lower()

                    or

                    full_name
                    in text.lower()
                ):

                    matched_document = doc

                    break

        # 🔥 SI DOCUMENT TROUVÉ

        if matched_document:

            Notification.objects.create(

                user=matched_document.user,

                message=
                    "Quelqu’un recherche votre document 🪪"
            )

            return Response({

                "success": True,

                "ocr_text": text,

                "nni": nni,

                "matched": True,

                "document": {

                    "id":
                        matched_document.id,

                    "user":
                        matched_document.user.id,

                    "nom":
                        matched_document.nom,

                    "prenom":
                        matched_document.prenom,

                    "telephone":
                        matched_document.telephone,

                    "lieu_trouve":
                        matched_document.lieu_trouve,

                    "type_document":
                        matched_document.type_document,
                }
            })

        # ❌ AUCUN MATCH

        return Response({

            "success": True,

            "ocr_text": text,

            "nni": nni,

            "matched": False,

            "message":
                "Aucun document retrouvé. Vérifiez l’image ou les informations."
        })

    except Exception as e:

        return Response({

            "error": str(e)

        }, status=500)

@api_view(['POST'])
@permission_classes([AllowAny])

def update_document_status(
    request,
    document_id
):

    try:

        document = Document.objects.get(
            id=document_id
        )

        # ✅ changer statut
        document.statut = "retourné"

        document.save()

        # 🔔 notification

        Notification.objects.create(

            user=document.user,

            message=
                "Votre document a été retourné ✅"
        )

        return Response({

            "success": True,

            "message":
                "Document retourné"
        })

    except Document.DoesNotExist:

        return Response({

            "success": False,

            "message":
                "Document introuvable"
        }, status=404)

@api_view(['DELETE'])
@permission_classes([AllowAny])

def delete_notification(
    request,
    notification_id
):

    try:

        notification = Notification.objects.get(
                id=notification_id
            )

        notification.delete()

        return Response({

            "success": True,

            "message":
                "Notification supprimée"
        })

    except Notification.DoesNotExist:

        return Response({

            "success": False,

            "message":
                "Notification introuvable"
        }, status=404)


# 🔥 ENVOYER OTP

@api_view(['POST'])
def send_otp(request):

    method = request.data.get('method')

    email = request.data.get('email')

    telephone = request.data.get('telephone')

    try:

        # 📧 EMAIL

        if method == "email":

            user = User.objects.get(
                email=email
            )

        # 📱 TELEPHONE

        else:

            user = User.objects.get(
                telephone=telephone
            )

        # 🔥 GENERATE OTP

        otp = str(
            random.randint(
                100000,
                999999
            )
        )

        user.otp = otp

        user.save()

        # 📧 EMAIL OTP

        if method == "email":

            send_mail(

                'Code OTP',

                f'Votre code OTP est : {otp}',

                settings.EMAIL_HOST_USER,

                [email],

                fail_silently=False,
            )

        return Response({

            "success": True,

            "message":
                "OTP envoyé ✅"
        })

    except User.DoesNotExist:

        return Response({

            "success": False,

            "message":
                "Utilisateur introuvable ❌"
        })


# 🔥 VERIFY OTP
# 🔥 VERIFY OTP

@api_view(['POST'])
def verify_otp(request):

    otp = request.data.get('otp')

    try:

        user = User.objects.get(
            otp=otp
        )

        return Response({

            "success": True,

            "message":
                "OTP valide ✅"
        })

    except User.DoesNotExist:

        return Response({

            "success": False,

            "message":
                "OTP invalide ❌"
        })
# 🔥 RESET PASSWORD

@api_view(['POST'])
def reset_password(request):

    otp = request.data.get('otp')

    password = request.data.get('password')

    try:

        user = User.objects.get(
            otp=otp
        )

        user.password = make_password(password)

        user.otp = ""

        user.save()

        return Response({

            "success": True,

            "message":
                "Mot de passe changé ✅"
        })

    except User.DoesNotExist:

        return Response({

            "success": False,

            "message":
                "OTP invalide ❌"
        })