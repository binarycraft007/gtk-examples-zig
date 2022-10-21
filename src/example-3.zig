const std = @import("std");
const gtk = @import("gtk");

pub fn print_hello(widget: *gtk.GtkWidget, data: gtk.gpointer) callconv(.C) void {
    _ = widget;
    _ = data;

    gtk.g_print("Hello World\n");
}

pub fn quit_cb(window: *gtk.GtkWindow) callconv(.C) void {
    gtk.gtk_window_close(window);
}

pub fn activate(app: *gtk.GtkApplication, user_data: gtk.gpointer) void {
    _ = user_data;

    const builder: ?*gtk.GtkBuilder = gtk.gtk_builder_new();
    _ = gtk.gtk_builder_add_from_file(builder, "src/builder.ui", null);
    defer gtk.g_object_unref(builder);

    var window: *gtk.GObject = gtk.gtk_builder_get_object(builder, "window");
    gtk.gtk_window_set_application(@ptrCast(*gtk.GtkWindow, window), app);

    var button: *gtk.GObject = gtk.gtk_builder_get_object(builder, "button1");
    // using reimplementation
    _ = gtk.g_signal_connect(button, "clicked", @ptrCast(gtk.GCallback, &print_hello), null);

    button = gtk.gtk_builder_get_object(builder, "button2");
    // using reimplementation
    _ = gtk.g_signal_connect(button, "clicked", @ptrCast(gtk.GCallback, &print_hello), null);

    button = gtk.gtk_builder_get_object(builder, "quit");
    // using reimplementation
    _ = gtk.g_signal_connect_swapped(button, "clicked", @ptrCast(gtk.GCallback, &quit_cb), window);

    gtk.gtk_widget_show(@ptrCast(*gtk.GtkWidget, window));
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
