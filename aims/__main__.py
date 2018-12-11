#!/usr/bin/env python
# -*- coding: utf-8 -*-
# =============================================================================
"""
Ansible Inventory Management System

File name: app/__main__.py
Author: Dwight Spencer
Date created: Dec 11 10:54:12 2018
Date last modified: Tue Dec 11 10:55:35 CST 2018
Python Version: 2.7 or 3.1

"""

# =============================================================================
# Future proof
# =============================================================================

from __future__ import (print_function, unicode_literals)

# =============================================================================
# Metadata
# =============================================================================

__author__ = "Dwight A. Spencer"
__version__ = "1.0.0"
__copyright__ = ', '.join(['Copyright ©2014-2026', __author__])
__description__ = 'ansible inventory management api'
__credits__ = ['Dwight A. Spencer']
__license__ = 'BSD'
__license_url__ = 'https://github.com/denzuko/aims/blob/master/LICENSE'
__usage_url__ = 'https://github.com/denzuko/aims/blob/master/USAGE.md'
__email__ = 'support@dwightaspencer.com'
__maintainer__ = __author__
__status__ = "Production"
__author_url__ = "https://dwightaspencer.com"

# =============================================================================
# Imports
# =============================================================================

from os import environ, exit
from redis import StrictRedis
from redis.exceptions import ConnectionError as RedisConnectError
from eve import Eve
from eve.exceptions import ConfigException as EveConfigError
from eve_swagger import swagger

# =============================================================================
# Methods
# =============================================================================
class ApiInstance(object):
    """
    AIMS api instance factory
    """

    def __init__(self):
        try:
            self.redis = StrictRedis.from_url(environ.get('REDIS_URI', 'redis://redis:6379/0'))
        except RedisConnectError as error:
            print(error)
            os.exit(False)

        self.app = Eve(redis=self.redis)
        self.app.register_blueprint(swagger)
        try:
            self.api_config()
            self.api_define()
        except EveConfigError as error:
            print(error)
            os.exit(False)

    def api_define(self):
        """ Defines swagger infoObject with module metadata """

        # required. See http://swagger.io/specification/#infoObject for details.
        self.app.config['SWAGGER_INFO'] = {
            'title': __description__.capitalize(),
            'version': __version__,
            'description': __description__,
            'termsOfService': __usage_url__,
            'contact': {'name': __author__, 'url': __author_url__},
            'license': {'name': __license__, 'url': __license_url__}
        }

    def api_config(self):
        """ 
        Sets api version for /:version, cors and makes api json only
        """

        self.app.config['API_VERSION'] = __version__.split(".")[0]
        self.app.config['X_DOMAINS'] = environ.get('CORS_DOMAINS', '*')
        self.app.config['RENDERERS'] = ['eve.render.JSONRenderer']
        self.app.config['VERSIONING'] = True
        self.app.config['OPLOG'] = True
        self.app.config['OPLOG_ENDPOINT'] = '/oplog'
        self.app.config['SCHEMA_ENDPOINT'] = '/schema'
        self.app.config['SOFT_DELETE'] = True
        self.app.config['OPTIMIZE_PAGINATION_FOR_SPEED'] = True

    def boot(self):
        """ 
        Stands up the api server
        """
        self.app.run(
            host=str('0.0.0.0'),
            port=int(environ.get('PORT', 8080)),
            MONGO_URI=str(environ.get('MONGO_URI', 'mongodb://user:user@mongo:27017/apidemo'))
        )

def main():
    """
    Startup method - Stands up an instanace of our api with 12factor configs and defines routing
    """
    aims_instance = ApiInstance()
    aims_instance.boot()

if __name__ == '__main__':
    main()
