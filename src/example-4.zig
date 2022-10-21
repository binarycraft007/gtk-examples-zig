const std = @import("std");
const gtk = @import("gtk");

var surface: ?*gtk.cairo_surface_t = null;

var start_x: f64 = 0;
var start_y: f64 = 0;

pub fn clear_surface() void {
    const cr: ?*gtk.cairo_t = gtk.cairo_create(surface);

    gtk.cairo_set_source_rgb(cr, 1, 1, 1);
    gtk.cairo_paint(cr);

    gtk.cairo_destroy(cr);
}

pub fn resize_cb(
    widget: *gtk.GtkWidget,
    width: c_int,
    height: c_int,
    data: gtk.gpointer,
) callconv(.C) void {
    _ = width;
    _ = height;
    _ = data;

    if (surface != null) {
        gtk.cairo_surface_destroy(surface);
        surface = null;
    }

    if (gtk.gtk_native_get_surface(gtk.gtk_widget_get_native(widget)) != null) {
        surface = gtk.gdk_surface_create_similar_surface(
            gtk.gtk_native_get_surface(gtk.gtk_widget_get_native(widget)),
            gtk.CAIRO_CONTENT_COLOR,
            gtk.gtk_widget_get_width(widget),
            gtk.gtk_widget_get_height(widget),
        );

        clear_surface();
    }
}

pub fn draw_cb(
    drawing_area: *gtk.GtkDrawingArea,
    cr: *gtk.cairo_t,
    width: c_int,
    height: c_int,
    data: gtk.gpointer,
) callconv(.C) void {
    _ = drawing_area;
    _ = width;
    _ = height;
    _ = data;

    gtk.cairo_set_source_surface(cr, surface, 0, 0);
    gtk.cairo_paint(cr);
}

pub fn draw_brush(widget: *gtk.GtkWidget, x: f64, y: f64) void {
    const cr: ?*gtk.cairo_t = gtk.cairo_create(surface);

    gtk.cairo_rectangle(cr, x - 3, y - 3, 6, 6);
    gtk.cairo_fill(cr);

    gtk.cairo_destroy(cr);

    gtk.gtk_widget_queue_draw(widget);
}

pub fn drag_begin(
    gesture: *gtk.GtkGestureDrag,
    x: f64,
    y: f64,
    area: *gtk.GtkWidget,
) callconv(.C) void {
    _ = gesture;

    start_x = x;
    start_y = y;

    draw_brush(area, x, y);
}

pub fn drag_update(
    gesture: *gtk.GtkGestureDrag,
    x: f64,
    y: f64,
    area: *gtk.GtkWidget,
) callconv(.C) void {
    _ = gesture;

    draw_brush(area, start_x + x, start_y + y);
}

pub fn drag_end(
    gesture: *gtk.GtkGestureDrag,
    x: f64,
    y: f64,
    area: *gtk.GtkWidget,
) callconv(.C) void {
    _ = gesture;

    draw_brush(area, start_x + x, start_y + y);
}

pub fn pressed(
    gesture: *gtk.GtkGestureDrag,
    n_press: i16,
    x: f64,
    y: f64,
    area: *gtk.GtkWidget,
) callconv(.C) void {
    _ = gesture;
    _ = n_press;
    _ = x;
    _ = y;

    clear_surface();
    gtk.gtk_widget_queue_draw(area);
}

pub fn close_window() callconv(.C) void {
    if (surface != null)
        gtk.cairo_surface_destroy(surface);
}

pub fn activate(app: *gtk.GtkApplication, user_data: gtk.gpointer) void {
    _ = user_data;

    var window: *gtk.GtkWidget = gtk.gtk_application_window_new(app);
    gtk.gtk_window_set_title(@ptrCast(*gtk.GtkWindow, window), "Drawing Area");

    _ = gtk.g_signal_connect(window, "destroy", @ptrCast(gtk.GCallback, &close_window), null);

    var frame: *gtk.GtkWidget = gtk.gtk_frame_new(null);
    gtk.gtk_window_set_child(@ptrCast(*gtk.GtkWindow, window), frame);

    var drawing_area: *gtk.GtkWidget = gtk.gtk_drawing_area_new();
    gtk.gtk_widget_set_size_request(drawing_area, 100, 100);

    gtk.gtk_frame_set_child(@ptrCast(*gtk.GtkFrame, frame), drawing_area);

    gtk.gtk_drawing_area_set_draw_func(
        @ptrCast(*gtk.GtkDrawingArea, drawing_area),
        @ptrCast(gtk.GtkDrawingAreaDrawFunc, &draw_cb),
        null,
        null,
    );

    // using reimplementation
    _ = gtk.g_signal_connect_after(drawing_area, "resize", @ptrCast(gtk.GCallback, &resize_cb), null);

    var drag: ?*gtk.GtkGesture = gtk.gtk_gesture_drag_new();
    gtk.gtk_gesture_single_set_button(@ptrCast(*gtk.GtkGestureSingle, drag), gtk.GDK_BUTTON_PRIMARY);
    gtk.gtk_widget_add_controller(drawing_area, @ptrCast(*gtk.GtkEventController, drag));
    // using reimplementation
    _ = gtk.g_signal_connect(drag, "drag-begin", @ptrCast(gtk.GCallback, &drag_begin), drawing_area);
    _ = gtk.g_signal_connect(drag, "drag-update", @ptrCast(gtk.GCallback, &drag_update), drawing_area);
    _ = gtk.g_signal_connect(drag, "drag-end", @ptrCast(gtk.GCallback, &drag_end), drawing_area);

    var press: ?*gtk.GtkGesture = gtk.gtk_gesture_click_new();
    gtk.gtk_gesture_single_set_button(@ptrCast(*gtk.GtkGestureSingle, press), gtk.GDK_BUTTON_SECONDARY);
    gtk.gtk_widget_add_controller(drawing_area, @ptrCast(*gtk.GtkEventController, press));

    // using reimplementation
    _ = gtk.g_signal_connect(press, "pressed", @ptrCast(gtk.GCallback, &pressed), drawing_area);

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
