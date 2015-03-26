=========================
Python Packaging Examples
=========================

Code Layout
===========

Each example contains exactly the same source code. The sample project is the
result of following the Django 1.7 tutorial. There is a Django project called
`pollster` and a Django application called `polls`. Each contains templates
and static file assets. The project is configured to connect to a postgresql
database.

Environment Layout
==================

Each example contains a Vagrantfile which will create five LXC containers.
Two containers represent the development environment and development database.
The other three represent two production environments and a production
database.

The names of the vagrant machines are as follows:

-   dev

    The development environment

-   dev-db

    The development database node.

-   prod(1|2)

    The production environments.

-   prod-db

    The production database node.

Each development environment contains /etc/hosts entries for prod1 and prod2.
All environments contain a /etc/hosts entry for pypi which is linked to the
dependency server

The dependency server, the Vagrantfile for which is in the '/deps' directory,
hosts the private PYPI and apt repositories.

Walking Through The Examples
============================

Custom Packaging
----------------

The custom packaging example is intended as a sandbox for using non-packaging
techniques for deploying code. An example scenario would go as follows:

.. code-block:: shell

    vagrant ssh dev
    cd /opt/pollster
    sudo pip install --index-url http://pypi/simple django psycopg2
    python manage.py collectstatic --noinput
    python manage.py migrate
    sudo service pollster start
    // Check that the service starts and the page loads with images.

    cd /opt
    scp -r pollster prod1:/opt/
    ssh prod1
    sudo pip install --index-url http://pypi/simple django psycopg2
    cd /opt/pollster
    python manage.py collectstatic --nopinput
    python manage.py migrate
    sudo service pollster start
    // Check that the service starts and the page loads with images.


Source Distribution
-------------------

The source distribution example contains a sample setup.py and MANIFEST.in
file for generating a Python source distribution. It also bundles and exposes
a console script for interacting with the Django manage.py commands.

.. code-block:: shell

    vagrant ssh dev
    cd ~/code/pollster
    python setup.py sdist
    scp dist/pollster-0.1.0.tar.tz pypi:/srv/pypi

    ssh prod1
    sudo pip install --index-url http://pypi/simple pollster
    pollster-manage collectstatic --noinput
    pollster-manage migrate
    sudo service pollster start
    // Check that the service starts and the page loads with images.

System Packaing
---------------

The system packaging example contains a requirements.txt for dependency
version pinning, a 'debian' subdirectory, and rpmvenv configuration for
generating system package.

Debian packages are generated with
`dh_virtualenv <https://github.com/spotify/dh-virtualenv>`_ and RPM packages
are generated with `rpmvenv <https://github.com/kevinconway/rpmvenv>`_.

.. code-block:: shell

    # Generate a .deb
    cd ~/code/pollster
    dpkg-buildpackage -us -uc
    cd ..
    scp pollster_0.1.1_amd64.deb pypi:/srv/deb
    ssh pypi reindex
    ssh prod1
    sudo apt-get update
    sudo apt-get install pollster
    // Check that the service starts and the page loads with images.

.. code-block:: shell

    # Generate a .rpm
    cd ~/code/pollster
    rpmvenv .rpmvenv.json

Private Package Repositories
============================

The following guides were used in setting up the private PYPI and apt
repositories:

-   http://www.plankandwhittle.com/a-debianor-ubuntu-mirror-to-call-your-own/

-   https://jamie.curle.io/blog/setting-up-a-custom-pypi-server/
