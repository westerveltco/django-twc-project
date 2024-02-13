from __future__ import annotations

from pathlib import Path

from django.contrib.auth.decorators import login_required
from django.contrib.staticfiles import finders
from django.http import FileResponse
from django.http import HttpRequest
from django.http import HttpResponse
from django.http import HttpResponseNotFound
from django.shortcuts import redirect
from django.shortcuts import render
from django.utils import timezone
from django.views.decorators.cache import cache_control
from django.views.decorators.http import require_GET
from sentry_sdk import last_event_id


def custom_error_404(
    request: HttpRequest, exception: Exception | None = None, *args, **kwargs
) -> HttpResponse:
    return render(request, "404.html", context={}, status=404)


def custom_error_500(request: HttpRequest, *args, **kwargs) -> HttpResponse:
    return render(
        request, "500.html", context={"sentry_event_id": last_event_id()}, status=500
    )


@require_GET
@cache_control(max_age=60 * 60 * 24, immutable=True, public=True)  # one day
def robots_txt(request: HttpRequest) -> HttpResponse:
    return render(request, "robots.txt", content_type="text/plain")


@require_GET
@cache_control(max_age=60 * 60 * 24, immutable=True, public=True)  # one day
def security_txt(request: HttpRequest) -> HttpResponse:
    return render(
        request,
        ".well-known/security.txt",
        context={
            "year": timezone.now().year + 1,
        },
        content_type="text/plain",
    )


@require_GET
@cache_control(max_age=60 * 60 * 24, immutable=True, public=True)  # one day
def favicon(request: HttpRequest) -> HttpResponse | FileResponse:
    name = request.path.lstrip("/")
    path = finders.find(name)
    if path:
        file = Path(path).open("rb")
        response = FileResponse(file)
    else:
        if name == "favicon.ico":
            response = HttpResponseNotFound()
        else:
            response = redirect("favicon.ico")
    return response


@require_GET
@login_required
def index(request: HttpRequest) -> HttpResponse:
    return render(request, "index.html", context={})
