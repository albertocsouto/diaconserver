{application, diaconserver,
 [{description, "diaconserver"},
  {vsn, "0.01"},
  {modules, [
    diaconserver,
    diaconserver_app,
    diaconserver_sup,
    diaconserver_web,
    diaconserver_deps
  ]},
  {registered, []},
  {mod, {diaconserver_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.
