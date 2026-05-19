from django.contrib import admin

# Register your models here.

from .models import User

admin.site.register(User)

from .models import Objet

admin.site.register(Objet)

from .models import Document

admin.site.register(Document)

from .models import Centre, Zone, AdminLog, FactureIA

admin.site.register(Centre)
admin.site.register(Zone)
admin.site.register(AdminLog)
admin.site.register(FactureIA)