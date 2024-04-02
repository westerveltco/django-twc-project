from __future__ import annotations

from django.conf import settings
from django.contrib import admin
from django.urls import include
from django.urls import path
from health_check.views import MainView

from default import __version__
from default.core import views as core_views

admin_header = f"default-example_owner v{__version__}"
admin.site.enable_nav_sidebar = False
admin.site.site_header = admin_header
admin.site.site_title = admin_header

urlpatterns = [
    path(".well-known/security.txt", core_views.security_txt),
    path("android-chrome-192x192.png", core_views.favicon),
    path("android-chrome-512x512.png", core_views.favicon),
    path("apple-touch-icon.png", core_views.favicon),
    path("browserconfig.xml", core_views.favicon),
    path("favicon-16x16.png", core_views.favicon),
    path("favicon-32x32.png", core_views.favicon),
    path("favicon.ico", core_views.favicon),
    path("mstile-150x150.png", core_views.favicon),
    path("robots.txt", core_views.robots_txt),
    path("safari-pinned-tab.svg", core_views.favicon),
    path("site.webmanifest", core_views.favicon),
    path("404/", core_views.custom_error_404, name="404"),
    path("500/", core_views.custom_error_500, name="500"),
    path("accounts/", include("allauth.urls")),
    path("admin/", admin.site.urls),
    path("health/", MainView.as_view()),
    path("", core_views.index, name="index"),
]

handler404 = "default.core.views.custom_error_404"  # noqa: F811
handler500 = "default.core.views.custom_error_500"  # noqa: F811


if settings.DEBUG:
    from django.conf.urls.static import static
    from django.contrib.staticfiles.urls import staticfiles_urlpatterns

    urlpatterns += staticfiles_urlpatterns()
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns = [
        path("__debug__/", include("debug_toolbar.urls")),
        path("__reload__/", include("django_browser_reload.urls")),
    ] + urlpatterns
