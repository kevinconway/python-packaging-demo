"""Setuptools configuration for pollster."""

from setuptools import setup
from setuptools import find_packages


with open('README.rst', 'r') as readmefile:

    README = readmefile.read()

setup(
    name='pollster',
    version='0.1.0',
    url='https://github.com/username/pollster',
    description='Polling and eagles.',
    author="Kevin Conway",
    author_email="kevinjacobconway@gmail.com",
    long_description=README,
    license='MIT',
    packages=find_packages(
        exclude=['tests', 'build', 'dist', 'docs', 'debian'],
    ),
    install_requires=[
        'django',
        'psycopg2',
    ],
    entry_points={
        'console_scripts': [
            'pollster-manage = pollster.cmd:manage',
        ],
    },
    package_data={
        "pollster": ["templates/admin/*"],
        "polls": [
            "static/polls/style.css",
            "static/polls/images/*",
            "templates/polls/*",
        ],
    },
)
