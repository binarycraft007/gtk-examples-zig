const std = @import("std");
const gtk = @import("gtk");

pub fn print_hello(widget: *gtk.GtkWidget, data: gtk.gpointer) callconv(.C) void {
    _ = widget;
    _ = data;

    gtk.g_print("Hello World\n");
}

pub fn activate(app: *gtk.GtkApplication, user_data: gtk.gpointer) void {
    _ = user_data;

    const window: *gtk.GtkWidget = gtk.gtk_application_window_new(app);
    gtk.gtk_window_set_title(@ptrCast(*gtk.GtkWindow, window), "Window");
    gtk.gtk_window_set_default_size(@ptrCast(*gtk.GtkWindow, window), 200, 200);

    const box: *gtk.GtkWidget = gtk.gtk_box_new(gtk.GTK_ORIENTATION_VERTICAL, 0);
    gtk.gtk_widget_set_halign(box, gtk.GTK_ALIGN_CENTER);
    gtk.gtk_widget_set_valign(box, gtk.GTK_ALIGN_CENTER);

    gtk.gtk_window_set_child(@ptrCast(*gtk.GtkWindow, window), box);

    const button: *gtk.GtkWidget = gtk.gtk_button_new_with_label("Hello World");
    // using reimplementations
    _ = gtk.g_signal_connect(button, "clicked", @ptrCast(gtk.GCallback, &print_hello), null);
    _ = gtk.g_signal_connect_swapped(
        button,
        "clicked",
        @ptrCast(gtk.GCallback, &gtk.gtk_window_destroy),
        window,
    );

    gtk.gtk_box_append(@ptrCast(*gtk.GtkBox, box), button);

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
