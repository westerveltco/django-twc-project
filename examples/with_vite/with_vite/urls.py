from __future__ import annotations

from django.conf import settings
from django.contrib import admin
from django.urls import include
from django.urls import path
from django_twc_toolbox import views as toolbox_views
from health_check.views import MainView

from with_vite import __version__
from with_vite.core import views as core_views

admin_header = f"with_vite-example_owner v{__version__}"
admin.site.enable_nav_sidebar = False
admin.site.site_header = admin_header
admin.site.site_title = admin_header

urlpatterns = [
    path(".well-known/security.txt", toolbox_views.security_txt),
    path("robots.txt", toolbox_views.robots_txt),
    path("", include("django_twc_ui.favicons.urls")),
    path("404/", toolbox_views.custom_error_404, name="404"),
    path("500/", toolbox_views.custom_error_500, name="500"),
    path("accounts/", include("allauth.urls")),
    path("admin/", admin.site.urls),
    path("health/", MainView.as_view()),
    path("", core_views.index, name="index"),
]

handler404 = "django_twc_toolbox.views.custom_error_404"  # noqa: F811
handler500 = "django_twc_toolbox.views.custom_error_500"  # noqa: F811


if settings.DEBUG:
    from django.conf.urls.static import static
    from django.contrib.staticfiles.urls import staticfiles_urlpatterns

    urlpatterns += staticfiles_urlpatterns()
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns = [
        path("__debug__/", include("debug_toolbar.urls")),
        path("__reload__/", include("django_browser_reload.urls")),
    ] + urlpatterns
