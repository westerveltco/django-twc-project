from __future__ import annotations


def sentry_traces_sampler(sampling_context):
    """
    Returns an int representing the probability of a trace being sampled.

    Disregards any health check requests.
    """
    if _should_disgard(sampling_context):
        return 0

    return 0.5


def sentry_profiles_sampler(sampling_context):
    """
    Returns an int representing the probability of a profile being sampled.

    Disregards any health check requests.
    """
    if _should_disgard(sampling_context):
        return 0

    return 0.5


def _should_disgard(sampling_context) -> bool:
    DISGARDED_METHODS = ["GET", "HEAD"]
    DISGARDED_PATHS = ["/up/"]

    return (
        sampling_context.get("wsgi_environ", None)
        and sampling_context["wsgi_environ"]["REQUEST_METHOD"] in DISGARDED_METHODS
        and sampling_context["wsgi_environ"]["PATH_INFO"] in DISGARDED_PATHS
    )
