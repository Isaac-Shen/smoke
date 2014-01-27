# cython: profile=False

from smoke.model.dt cimport prop as mdl_dt_prp

from itertools import chain, imap


cdef class SendTable(object):
    def __init__(self, name, send_props, needs_flattening):
        self.name = name
        self.send_props = send_props
        self.needs_flattening = needs_flattening

    property baseclass:
        def __get__(SendTable self):
            gen = (sp.dt for sp in self.send_props if sp.name is 'baseclass')
            return next(gen, None)

    property all_exclusions:
        def __get__(SendTable self):
            gen = (sp for sp in self.send_props if sp.flags & mdl_dt_prp.EXCLUDE)
            return imap(lambda sp: (sp.dt, sp.name), gen)

    property all_non_exclusions:
        def __get__(SendTable self):
            return (sp for sp in self.send_props if sp.flags ^ mdl_dt_prp.EXCLUDE)

    property all_relations:
        def __get__(SendTable self):
            non_exclusions = self.all_non_exclusions
            return (sp for sp in non_exclusions if sp.type is mdl_dt_prp.DATATABLE)
