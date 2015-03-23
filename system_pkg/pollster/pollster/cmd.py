"""Commands for managing pollster."""
import os
import sys


def manage():
    """Run django manage.py."""
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "pollster.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
