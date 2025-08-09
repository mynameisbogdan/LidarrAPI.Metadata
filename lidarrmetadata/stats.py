"""
Utilities for sending stats
"""

from lidarrmetadata.config import get_config

CONFIG = get_config()

class TelegrafStatsClient(object):
    def __init__(self, host='localhost', port=8092):
        from telegraf.client import TelegrafClient

        self._client = TelegrafClient(host=host, port=port)

    def metric(self, key, value, tags=None):
        tags = tags or {}
        tags['application_path'] = CONFIG.ROOT_PATH
        self._client.metric(key, value, tags=tags)
