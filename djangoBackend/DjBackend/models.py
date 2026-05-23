from django.db import models


# USER
class User(models.Model):

    nom = models.CharField(max_length=100)

    email = models.EmailField(unique=True)

    telephone = models.CharField(max_length=20)

    password = models.CharField(max_length=100)

    role = models.CharField(max_length=50)

    otp = models.CharField(
    max_length=10,
    blank=True,
    null=True
    )

    # 🔥 AJOUT
    is_online = models.BooleanField(
        default=False
    )

    # 🔥 AJOUT
    last_seen = models.DateTimeField(
        null=True,
        blank=True
    )

    def __str__(self):
        return self.nom


# OBJET
class Objet(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    titre = models.CharField(
        max_length=150
    )

    description = models.TextField()

    statut = models.CharField(
        max_length=50
    )

    date_objet = models.DateField()

    lieu = models.CharField(
        max_length=100
    )

    telephone = models.CharField(
        max_length=20
    )

    # ✅ AJOUTÉ
    categorie = models.CharField(
        max_length=50,
        default="autre"
    )

    # IMAGE
    image = models.ImageField(
        upload_to='objets/',
        null=True,
        blank=True
    )

    def __str__(self):
        return self.titre


# DOCUMENT
class Document(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    nom = models.CharField(
        max_length=100
    )

    prenom = models.CharField(
        max_length=100
    )

    date_naissance = models.DateField()

    nni = models.CharField(
        max_length=100
    )

    type_document = models.CharField(
        max_length=50
    )

    telephone = models.CharField(
        max_length=20
    )

    lieu_trouve = models.CharField(
        max_length=200
    )

    # 📸 PHOTO RECTO
    image = models.ImageField(
        upload_to='documents/',
        null=True,
        blank=True
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )
    # 🔥 STATUT DOCUMENT

    statut = models.CharField(

        max_length=50,

        default="trouvé"
    )

    def __str__(self):
        return f"{self.nom} {self.prenom}"


# CENTRE
class Centre(models.Model):

    nom = models.CharField(
        max_length=100
    )

    adresse = models.CharField(
        max_length=200
    )

    telephone = models.CharField(
        max_length=20
    )

    def __str__(self):
        return self.nom


# ZONE
class Zone(models.Model):

    nom = models.CharField(
        max_length=100
    )

    description = models.TextField()

    def __str__(self):
        return self.nom


# ADMIN LOG
class AdminLog(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    action = models.CharField(
        max_length=200
    )

    date_action = models.DateTimeField(
        auto_now_add=True
    )

    def __str__(self):
        return self.action


# FACTURE IA
class FactureIA(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    montant = models.FloatField()

    date_facture = models.DateField(
        auto_now_add=True
    )

    description = models.CharField(
        max_length=200
    )

    def __str__(self):
        return str(self.montant)


# NOTIFICATION
class Notification(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    message = models.TextField()

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    def __str__(self):
        return self.message


# FAVORI
class Favori(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE
    )

    objet = models.ForeignKey(
        Objet,
        on_delete=models.CASCADE
    )

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    class Meta:
        unique_together = ('user', 'objet')


# MESSAGE
class Message(models.Model):

    sender = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='sent_messages'
    )

    receiver = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='received_messages'
    )

    content = models.TextField()

    created_at = models.DateTimeField(
        auto_now_add=True
    )

    # 🔥 MESSAGE LU / NON LU
    is_read = models.BooleanField(
        default=False
    )

    def __str__(self):
        return self.content