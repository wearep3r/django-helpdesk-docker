from django.contrib import admin
#from django.urls import path, include
from django.conf.urls import url,include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    url('admin/', admin.site.urls),
    url(r'', include('helpdesk.urls', namespace='helpdesk')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
