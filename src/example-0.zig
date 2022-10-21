const std = @import("std");
const gtk = @import("gtk");

pub fn activate(app: *gtk.GtkApplication, user_data: gtk.gpointer) void {
    _ = user_data;

    const window: *gtk.GtkWidget = gtk.gtk_application_window_new(app);
    gtk.gtk_window_set_title(@ptrCast(*gtk.GtkWindow, window), "Window");
    gtk.gtk_window_set_default_size(@ptrCast(*gtk.GtkWindow, window), 200, 200);
    gtk.gtk_widget_show(window);
}

pub fn main() !void {
    const app = gtk.gtk_application_new("org.gtk.example", gtk.G_APPLICATION_FLAGS_NONE);
    defer gtk.g_object_unref(app);

    // using reimplementation
    _ = gtk.g_signal_connect(app, "activate", @ptrCast(gtk.GCallback, &activate), null);

    const status: c_int = gtk.g_application_run(@ptrCast(*gtk.GApplication, app), 0, null);
    if (status != 0)
        return error.Error;
}
