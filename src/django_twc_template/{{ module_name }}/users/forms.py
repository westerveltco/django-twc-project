from __future__ import annotations

from django.contrib.auth import forms

from .models import User


class UserCreationForm(forms.UserCreationForm):
    class Meta:
        model = User
        fields = (
            "email",
            "username",
        )


class UserChangeForm(forms.UserChangeForm):
    class Meta:
        model = User
        fields = (
            "email",
            "username",
        )
