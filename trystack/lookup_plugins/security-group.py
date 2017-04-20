import ansible.utils as utils
import ansible.errors as errors
from ansible.plugins.lookup import LookupBase

class LookupModule(LookupBase):

    def __init__(self, basedir=None, **kwargs):
        self.basedir = basedir

    def run(self, terms, variable=None, **kwargs):
        if len(terms) != 1 and not instance(terms[0], dict):
            raise errors.AnsibleError('Openstack definition should be a dictionary~')

        openstack = terms[0]
        ret = []

        for cloud in openstack:
            if 'security' in cloud:
                for group in cloud['security']:
                    if 'name' in group:
                        ret.append({'cloud':cloud['cloud'], 'group':group['name']})

        return ret
