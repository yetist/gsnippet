==================
Migrating to GDBus
==================

.. contents::

Conceptual differences
======================

The central concepts of D-Bus are modelled in a very similar way in dbus-glib and GDBus. Both have a objects representing connections, proxies and method invocations. But there are some important differences:

dbus-glib uses libdbus, GDBus doesn't. Instead, it relies on GIO streams as transport layer, and has its own implementation for the the D-Bus connection setup and authentication. Apart from using streams as transport, avoiding libdbus also lets GDBus avoid some thorny multithreading issues.

dbus-glib uses the GObject type system for method arguments and return values, including a homegrown container specialization mechanism. GDBus relies uses the GVariant type system which is explicitly designed to match D-Bus types.

The typical way to export an object in dbus-glib involves generating glue code from XML introspection data using dbus-binding-tool. GDBus does not (yet?) use code generation; you are expected to embed the introspection data in your application code.


API comparison
================

Table 7. dbus-glib APIs and their GDBus counterparts


Dbus-glib                                | GDBus
DBusGConnection                          | GDBusConnection
DBusGProxy                               | GDBusProxy
DBusGMethodInvocation                    | GDBusMethodInvocation

dbus_g_bus_get()                         | g_bus_get_sync(), also see g_bus_get()
dbus_g_proxy_new_for_name()              | g_dbus_proxy_new_sync() and g_dbus_proxy_new_for_bus_sync(), also see g_dbus_proxy_new()
dbus_g_proxy_add_signal()                | not needed, use the generic "g-signal"
dbus_g_proxy_connect_signal()            | use g_signal_connect() with "g-signal"
dbus_g_connection_register_g_object()    | g_dbus_connection_register_object()
dbus_g_connection_unregister_g_object()  | g_dbus_connection_unregister_object()
dbus_g_object_type_install_info()        | introspection data is installed while registering an object, see g_dbus_connection_register_object()
dbus_g_proxy_begin_call()                | g_dbus_proxy_call()
dbus_g_proxy_end_call()                  | g_dbus_proxy_call_finish()
dbus_g_proxy_call()                      | g_dbus_proxy_call_sync()
dbus_g_error_domain_register()           | g_dbus_error_register_error_domain()
dbus_g_error_has_name()                  | no direct equivalent, see g_dbus_error_get_remote_error()
dbus_g_method_return()                   | g_dbus_method_invocation_return_value()
dbus_g_method_return_error()             | g_dbus_method_invocation_return_error() and variants
dbus_g_method_get_sender()               | g_dbus_method_invocation_get_sender()



Owning bus names
==================
Creating proxies for well-known names
=======================================
Client-side GObject bindings
=============================
Exporting objects
===================
Conceptual differences
=======================

