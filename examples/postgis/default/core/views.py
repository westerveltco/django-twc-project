from __future__ import annotations

from django.contrib.auth.decorators import login_required
from django.http import HttpRequest
from django.http import HttpResponse
from django.shortcuts import render
from django.views.decorators.http import require_GET


@require_GET
@login_required
def index(request: HttpRequest) -> HttpResponse:
    return render(request, "index.html", context={})
