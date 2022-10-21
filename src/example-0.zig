const std = @import("std");
const gtk = @import("gtk");

// g_signal_connect isn't being converted from C to Zig correctly, so using the following
// reimplementation: https://github.com/Swoogan/ziggtk/blob/master/src/gtk.zig
// zig bug report: https://github.com/ziglang/zig/issues/5596
pub fn _g_signal_connect(
    instance: gtk.gpointer,
    detailed_signal: [*c]const gtk.gchar,
    c_handler: gtk.GCallback,
    data: gtk.gpointer,
) gtk.gulong {
    var zero: u32 = 0;
    const flags: *gtk.GConnectFlags = @ptrCast(*gtk.GConnectFlags, &zero);
    return gtk.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, flags.*);
}

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
