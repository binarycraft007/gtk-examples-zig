const std = @import("std");
const gtk = @import("gtk");

pub fn print_hello(widget: *gtk.GtkWidget, data: gtk.gpointer) callconv(.C) void {
    _ = widget;
    _ = data;

    gtk.g_print("Hello World\n");
}

pub fn activate(app: *gtk.GtkApplication, user_data: gtk.gpointer) void {
    _ = user_data;

    var window = gtk.gtk_application_window_new(app);
    gtk.gtk_window_set_title(@ptrCast(*gtk.GtkWindow, window), "Window");

    const grid = gtk.gtk_grid_new();

    gtk.gtk_window_set_child(@ptrCast(*gtk.GtkWindow, window), grid);

    var button = gtk.gtk_button_new_with_label("Button 1");
    _ = gtk.g_signal_connect(button, "clicked", @ptrCast(gtk.GCallback, &print_hello), null);
    gtk.gtk_grid_attach(@ptrCast(*gtk.GtkGrid, grid), button, 0, 0, 1, 1);

    button = gtk.gtk_button_new_with_label("Button 2");
    _ = gtk.g_signal_connect(button, "clicked", @ptrCast(gtk.GCallback, &print_hello), null);
    gtk.gtk_grid_attach(@ptrCast(*gtk.GtkGrid, grid), button, 1, 0, 1, 1);

    button = gtk.gtk_button_new_with_label("Quit");
    _ = gtk.g_signal_connect_swapped(
        button,
        "clicked",
        @ptrCast(gtk.GCallback, &gtk.gtk_window_destroy),
        window,
    );

    gtk.gtk_grid_attach(@ptrCast(*gtk.GtkGrid, grid), button, 0, 1, 2, 1);

    gtk.gtk_widget_show(window);
}

pub fn main() !void {
    const app = gtk.gtk_application_new("org.gtk.example", gtk.G_APPLICATION_FLAGS_NONE);
    defer gtk.g_object_unref(app);

    _ = gtk.g_signal_connect(app, "activate", @ptrCast(gtk.GCallback, &activate), null);

    const status = gtk.g_application_run(@ptrCast(*gtk.GApplication, app), 0, null);
    if (status != 0)
        return error.Error;
}
